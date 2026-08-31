#!/usr/bin/env bash

set -euo pipefail

readonly CRYPT_NAME="cryptlvm"
readonly KEYFILE="/etc/cryptsetup-keys.d/cryptlvm.key"
readonly REPO_URL="https://github.com/msvetkin/user-configuration.git"
readonly MKINITCPIO_HOOKS="base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck"

hostname_arg=""
username_arg=""
luks_device_arg=""
dry_run=0

function display_usage() {
	cat <<EOF
usage: $0 --hostname=<hostname> --username=<username> [--luks-device=<device>] [--dry-run]

  --hostname     hostname to write to /etc/hostname
  --username     account to create
  --luks-device  LUKS partition (default: autodetected via blkid)
  --dry-run      print every command instead of running it
EOF
	exit 1
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--hostname=*)
			hostname_arg="${1#*=}"
			;;
		--username=*)
			username_arg="${1#*=}"
			;;
		--luks-device=*)
			luks_device_arg="${1#*=}"
			;;
		--dry-run)
			dry_run=1
			;;
		*)
			echo "error: invalid argument format."
			display_usage
			;;
	esac
	shift
done

if [ -z "${hostname_arg}" ] || [ -z "${username_arg}" ]; then
	echo "error: missing mandatory argument(s)."
	display_usage
fi

readonly repo_dir="/home/${username_arg}/code/github/user-configuration"

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

function write_file() {
	local path="$1"
	local mode="$2"
	local content="$3"

	if [ "${dry_run}" -eq 1 ]; then
		printf "install -m %s /dev/null %s\ncat > %s <<'EOF'\n%s\nEOF\n" \
			"${mode}" "${path}" "${path}" "${content}"
		return 0
	fi

	install -m "${mode}" /dev/null "${path}"
	printf '%s\n' "${content}" > "${path}"
}

function as_user() {
	run runuser -u "${username_arg}" -- "$@"
}

function set_grub_option() {
	local line="$1"
	local key="${line%%=*}"

	run_sh "sed -i -e '/^#\\?${key}=/d' /etc/default/grub"
	run_sh "printf '%s\\n' $(quote "${line}") >> /etc/default/grub"
}

luks_device="${luks_device_arg}"
if [ -z "${luks_device}" ]; then
	luks_device="$(blkid -t TYPE=crypto_LUKS -o device 2>/dev/null | head -n1 || true)"
fi

luks_uuid=""
if [ -n "${luks_device}" ]; then
	luks_uuid="$(blkid -s UUID -o value "${luks_device}" 2>/dev/null || true)"
fi

if [ -z "${luks_device}" ] || [ -z "${luks_uuid}" ]; then
	if [ "${dry_run}" -eq 0 ]; then
		echo "error: no LUKS partition found. pass --luks-device=<device>."
		exit 1
	fi
	luks_device="${luks_device:-/dev/nvme0n1p3}"
	luks_uuid="<luks-uuid>"
fi

echo "hostname    = ${hostname_arg}"
echo "username    = ${username_arg}"
echo "luks device = ${luks_device} (${luks_uuid})"
echo

run ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
run hwclock --systohc
run_sh "sed -i -e 's/^#en_US\\.UTF-8/en_US.UTF-8/' -e 's/^#ru_RU\\.UTF-8/ru_RU.UTF-8/' /etc/locale.gen"
run locale-gen
run_sh "echo 'LANG=en_US.UTF-8' > /etc/locale.conf"
run_sh "echo '${hostname_arg}' > /etc/hostname"
run passwd

run pacman -S --noconfirm grub efibootmgr

# GRUB prompts for the passphrase to read /boot, then the initramfs reuses this
# keyfile so the same passphrase is not asked twice.
run mkdir -p /etc/cryptsetup-keys.d
run_sh "dd bs=512 count=4 if=/dev/random iflag=fullblock | install -m 0600 /dev/stdin ${KEYFILE}"
run cryptsetup -v luksAddKey "${luks_device}" "${KEYFILE}"

run_sh "sed -i -e 's|^HOOKS=.*|HOOKS=(${MKINITCPIO_HOOKS})|' /etc/mkinitcpio.conf"
run_sh "sed -i -e 's|^FILES=.*|FILES=(${KEYFILE})|' /etc/mkinitcpio.conf"

set_grub_option "GRUB_ENABLE_CRYPTODISK=y"
set_grub_option "GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${luks_uuid}:${CRYPT_NAME} cryptkey=rootfs:${KEYFILE}\""

run grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck
run mkinitcpio -P
run grub-mkconfig -o /boot/grub/grub.cfg

run pacman -S --noconfirm openresolv netctl wpa_supplicant dhcpcd dhclient dialog openssh net-tools

run useradd -m -G wheel,uucp "${username_arg}"
run passwd "${username_arg}"
run pacman -S --noconfirm sudo
run_sh "sed -i -e 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers"

run pacman -S --noconfirm xorg-xinit lightdm lightdm-gtk-greeter i3lock wezterm
run systemctl enable lightdm.service

run pacman -S --noconfirm nix git
run gpasswd -a "${username_arg}" nix-users
run systemctl enable nix-daemon.service
run_sh "grep -q '^experimental-features' /etc/nix/nix.conf || echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf"

# base-devel is what makepkg needs to build the AUR packages in setup-arch-user.sh.
run pacman -S --noconfirm --needed base-devel

run_sh "sed -i -e 's/^#Color/Color/' /etc/pacman.conf"
# makepkg.conf is sourced by bash, so nproc resolves on the machine doing the build.
run sed -i -e 's|^#\?MAKEFLAGS=.*|MAKEFLAGS="-j$(nproc)"|' /etc/makepkg.conf

run pacman -S --noconfirm pavucontrol pulseaudio pulseaudio-alsa

run pacman -S --noconfirm telegram-desktop discord

run mkdir -p /usr/share/xsessions
write_file /usr/share/xsessions/i3.desktop 0644 "[Desktop Entry]
Name=i3
Comment=improved dynamic tiling window manager
Exec=/home/${username_arg}/.nix-profile/bin/i3-session-target
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;"

as_user mkdir -p "/home/${username_arg}/code/github"
as_user git clone "${REPO_URL}" "${repo_dir}"

cat <<EOF

done. reboot, log in as ${username_arg}, then run:

  ${repo_dir}/setup-arch-user.sh
EOF
