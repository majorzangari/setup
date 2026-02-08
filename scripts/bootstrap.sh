#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR/.."

echo "$REPO_DIR"

echo "Updating and installing packages"
sudo pacman -Syu --needed - < "$REPO_DIR/packages.txt"


DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
	echo "Cloning dotfile repository"
	git clone --recurse-submodules https://github.com/majorzangari/dotfiles.git "$DOTFILES_DIR"
else
	echo "Dotfiles repository already exists, pulling latest"
	cd "$DOTFILES_DIR" && git pull --recurse-submodules
fi

echo "Stowing dotfiles"
cd "$DOTFILES_DIR"

for pkg in bash alacritty; do
	stow -v "$pkg"
done

AUR_BUILD="$HOME/.aur-build"
mkdir -p "$AUR_BUILD"
if ! command -v paru &>/dev/null; then
	echo "Installing paru"
	cd "$AUR_BUILD"
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si --noconfirm
else
	echo "paru already installed"
fi

AUR_FILE="$REPO_DIR/aur.txt"
if [ -f "$AUR_FILE" ]; then
	echo "Installing AUR packages"
	while read -r pkg; do
		[ -z "$pkg" ] && continue
		paru -S --noconfirm "$pkg"
	done < "$AUR_FILE"
fi

echo "Setup complete"
echo "You should probably run \"sudo usermod -aG docker <youruser>" though"
