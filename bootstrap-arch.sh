#!/usr/bin/env bash

set -euo pipefail

readonly CRYPT_NAME="cryptlvm"
readonly VG_NAME="main"
readonly PACSTRAP_PACKAGES=(
	base
	base-devel
	linux
	linux-firmware
	intel-ucode
	lvm2
	cryptsetup
	git
	vim
)

disk_arg=""
swap_arg=""
root_arg="250G"
dry_run=0
assume_yes=0

function display_usage() {
	cat <<EOF
usage: $0 --disk=<device> [--swap=<size>] [--root=<size>] [--dry-run] [--yes]

  --disk     whole disk to erase, e.g. /dev/nvme0n1
  --swap     swap volume size (default: installed RAM, rounded up, to allow hibernation)
  --root     root volume size (default: ${root_arg}); /home takes the remainder
  --dry-run  print every command instead of running it
  --yes      skip the erase confirmation
EOF
	exit 1
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--disk=*)
			disk_arg="${1#*=}"
			;;
		--swap=*)
			swap_arg="${1#*=}"
			;;
		--root=*)
			root_arg="${1#*=}"
			;;
		--dry-run)
			dry_run=1
			;;
		--yes)
			assume_yes=1
			;;
		*)
			echo "error: invalid argument format."
			display_usage
			;;
	esac
	shift
done

if [ -z "${disk_arg}" ]; then
	echo "error: missing mandatory argument(s)."
	display_usage
fi

function quote() {
	if [[ "$1" =~ ^[A-Za-z0-9_@%+=:,./-]+$ ]]; then
		printf '%s' "$1"
	else
		printf "'%s'" "${1//\'/\'\\\'\'}"
	fi
}

function run() {
	local line=""
	local arg

	if [ "${dry_run}" -eq 1 ]; then
		for arg in "$@"; do
			line+="$(quote "${arg}") "
		done
		printf '%s\n' "${line% }"
		return 0
	fi
	"$@"
}

function run_sh() {
	if [ "${dry_run}" -eq 1 ]; then
		printf '%s\n' "$1"
		return 0
	fi
	eval "$1"
}

function partition() {
	if [[ "${disk_arg}" =~ [0-9]$ ]]; then
		printf '%sp%s' "${disk_arg}" "$1"
	else
		printf '%s%s' "${disk_arg}" "$1"
	fi
}

if [ -z "${swap_arg}" ]; then
	swap_arg="$(awk '/MemTotal/ { printf "%dG", int($2 / 1024 / 1024) + 1 }' /proc/meminfo)"
fi

readonly boot_part="$(partition 1)"
readonly efi_part="$(partition 2)"
readonly luks_part="$(partition 3)"

if [ "${dry_run}" -eq 0 ]; then
	if [ "$(id -u)" -ne 0 ]; then
		echo "error: must run as root."
		exit 1
	fi

	if [ ! -d /sys/firmware/efi ]; then
		echo "error: not booted in UEFI mode."
		exit 1
	fi

	if [ ! -b "${disk_arg}" ]; then
		echo "error: ${disk_arg} is not a block device."
		exit 1
	fi

	for tool in sgdisk cryptsetup pvcreate pacstrap genfstab; do
		if ! command -v "${tool}" >/dev/null; then
			echo "error: ${tool} not found."
			exit 1
		fi
	done
fi

echo "disk    = ${disk_arg}"
echo "swap    = ${swap_arg}"
echo "root    = ${root_arg}"
echo "layout  = ${boot_part} bios_boot | ${efi_part} esp | ${luks_part} luks1 -> ${CRYPT_NAME} -> ${VG_NAME}"
echo

if [ "${dry_run}" -eq 0 ] && [ "${assume_yes}" -eq 0 ]; then
	lsblk -o NAME,SIZE,TYPE,MODEL,SERIAL "${disk_arg}"
	echo
	read -r -p "this erases ${disk_arg}. type ERASE to continue: " reply
	if [ "${reply}" != "ERASE" ]; then
		echo "aborted."
		exit 1
	fi
fi

run timedatectl set-ntp true

run sgdisk --zap-all "${disk_arg}"
run sgdisk --new=1:0:+1M --typecode=1:ef02 --change-name=1:"BIOS boot partition" "${disk_arg}"
run sgdisk --new=2:0:+550M --typecode=2:ef00 --change-name=2:"EFI system partition" "${disk_arg}"
run sgdisk --new=3:0:0 --typecode=3:8309 --change-name=3:"Linux LUKS" "${disk_arg}"
run partprobe "${disk_arg}"

# GRUB reads /boot from inside this container, and its LUKS2 support cannot do argon2.
run cryptsetup -v --type luks1 luksFormat "${luks_part}"
run cryptsetup open "${luks_part}" "${CRYPT_NAME}"

run pvcreate "/dev/mapper/${CRYPT_NAME}"
run vgcreate "${VG_NAME}" "/dev/mapper/${CRYPT_NAME}"
run lvcreate -L "${swap_arg}" -n swap "${VG_NAME}"
run lvcreate -L "${root_arg}" -n root "${VG_NAME}"
run lvcreate -l 100%FREE -n home "${VG_NAME}"
# e2scrub takes its snapshot from free extents in the volume group.
run lvreduce -f -L -256M "${VG_NAME}/home"

run mkfs.fat -F32 "${efi_part}"
run mkfs.ext4 "/dev/${VG_NAME}/root"
run mkfs.ext4 "/dev/${VG_NAME}/home"
run mkswap "/dev/${VG_NAME}/swap"

run mount "/dev/${VG_NAME}/root" /mnt
run mount --mkdir "/dev/${VG_NAME}/home" /mnt/home
run mount --mkdir "${efi_part}" /mnt/efi
run swapon "/dev/${VG_NAME}/swap"

run pacstrap -K /mnt "${PACSTRAP_PACKAGES[@]}"
run_sh "genfstab -U /mnt >> /mnt/etc/fstab"

run install -m 0755 "$(dirname "$(readlink -f "$0")")/setup-arch-root.sh" /mnt/root/setup-arch-root.sh

cat <<EOF

done. now run:

  arch-chroot /mnt /root/setup-arch-root.sh --hostname=<hostname> --username=<username>
EOF
