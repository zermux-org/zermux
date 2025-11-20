#!/usr/bin/env bash
# =============================================================================
# Zermux Full Installer – 100% reproducible Termux environment (2025)
# =============================================================================

set -eEo pipefail
trap 'echo -e "\033[91m✘ Installation failed at line $LINENO\033[0m" >&2; exit 1' ERR

export ZERMUX_PATH="$HOME/.local/share/zermux"
export ZERMUX_LOG="/tmp/zermux-install-$(date +%s).log"

RESET='\033[0m' BOLD='\033[1m' CYAN='\033[96m' GREEN='\033[92m' YELLOW='\033[93m' PURPLE='\033[95m'
log() { echo -e "${CYAN}[Zermux]${RESET} $*"; }
step() { echo -e "${PURPLE}➤${RESET} ${BOLD}$*${RESET}"; }
success() { echo -e "${GREEN}✔ $*${RESET}"; }

# Replaced symlink() with copy_config()
copy_config() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  # -a preserves attributes, --no-clobber avoids overwriting if identical (optional)
  cp -a "$src" "$dest"
  success "Copied $(basename "$dest")"
}

step "Installing core packages (idempotent)..."
pkg install -y zellij starship bat vivid carapace eza fd ripgrep zoxide fzf git-delta neovim openssh proot-distro

step "Creating XDG directories..."
mkdir -p ~/.config ~/.cache ~/.local/{bin,share,state} "$PREFIX/tmp"
chmod 700 "$PREFIX/tmp"

step "Copying configuration files (single source of truth)..."
copy_config "$ZERMUX_PATH/default/bashrc"               ~/.bashrc
copy_config "$ZERMUX_PATH/default/inputrc"               ~/.inputrc
copy_config "$ZERMUX_PATH/config/starship.toml"          ~/.config/starship.toml
copy_config "$ZERMUX_PATH/config/zellij"                 ~/.config/zellij                # directory
copy_config "$ZERMUX_PATH/config/bat"                    ~/.config/bat                   # directory
copy_config "$ZERMUX_PATH/config/carapace"               ~/.config/carapace              # directory
copy_config "$ZERMUX_PATH/config/termux/termux.properties" ~/.termux/termux.properties
copy_config "$ZERMUX_PATH/config/termux/colors.properties"  ~/.termux/colors.properties

mkdir -p ~/.termux/boot
copy_config "$ZERMUX_PATH/boot.sh"                       ~/.termux/boot/00-zermux.sh

step "Applying Termux settings..."
termux-reload-settings || true

step "Zermux $(cat "$ZERMUX_PATH/version" 2>/dev/null || echo "main") installed successfully!"

cat <<EOF

Restart Termux completely → you will land in a beautiful Zellij workspace

Your config is now fully copied (not symlinked).
To update in the future:
  cd $ZERMUX_PATH && git pull
  then re-run this installer (or just copy the changed files manually)

Enjoy the most aesthetic Termux setup in 2025 
EOF

#exec bash