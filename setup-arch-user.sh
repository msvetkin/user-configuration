#!/usr/bin/env bash

set -euo pipefail

readonly AUR_HELPER_URL="https://aur.archlinux.org/yay-bin.git"
readonly AUR_PACKAGES=(google-chrome)

profile_arg="desktop"
dry_run=0

function display_usage() {
	cat <<EOF
usage: $0 [--profile=<profile>] [--dry-run]

  --profile  home-manager profile, laptop or desktop (default: ${profile_arg})
  --dry-run  print every command instead of running it
EOF
	exit 1
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--profile=*)
			profile_arg="${1#*=}"
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

if [ "${profile_arg}" != "laptop" ] && [ "${profile_arg}" != "desktop" ]; then
	echo "error: profile must be laptop or desktop."
	exit 1
fi

# makepkg refuses to build as root, and home-manager writes into this account's profile.
if [ "$(id -u)" -eq 0 ]; then
	echo "error: run as your own user, not root."
	exit 1
fi

readonly repo_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
readonly zsh_path="${HOME}/.nix-profile/bin/zsh"

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

echo "profile = ${profile_arg}"
echo "repo    = ${repo_dir}"
echo

if [ "${dry_run}" -eq 1 ] || ! command -v yay >/dev/null; then
	if [ "${dry_run}" -eq 1 ]; then
		build_dir="/tmp/tmp.XXXXXXXXXX"
	else
		build_dir="$(mktemp -d)"
	fi

	run git clone "${AUR_HELPER_URL}" "${build_dir}/yay-bin"
	run_sh "cd ${build_dir}/yay-bin && makepkg -si --noconfirm"
	run rm -rf "${build_dir}"
fi

run yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

run_sh "out=\"\$(nix build --no-link --print-out-paths \\
	'${repo_dir}#homeConfigurations.${profile_arg}.activationPackage')\"
\"\${out}/activate\""

run_sh "grep -qx '${zsh_path}' /etc/shells || echo '${zsh_path}' | sudo tee -a /etc/shells >/dev/null"
run sudo chsh -s "${zsh_path}" "$(id -un)"

cat <<EOF

done. log out and back in to pick up the new shell and session.
EOF
