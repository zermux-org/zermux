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

run() {
  log "→ $*"
  "$@" >>"$ZERMUX_LOG" 2>&1
}

step "Installing core packages (idempotent)..."
pkg install -y zellij starship bat vivid carapace eza fd ripgrep zoxide fzf git-delta neovim openssh proot-distro

step "Creating XDG directories..."
mkdir -p ~/.config ~/.cache ~/.local/{bin,share,state} "$PREFIX/tmp"
chmod 700 "$PREFIX/tmp"

step "Symlinking configuration (single source of truth)..."
symlink() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  rm -f "$dest"
  ln -sf "$src" "$dest"
  success "Linked $(basename "$dest")"
}

symlink "$ZERMUX_PATH/default/bashrc" ~/.bashrc
symlink "$ZERMUX_PATH/default/inputrc" ~/.inputrc
symlink "$ZERMUX_PATH/config/starship.toml" ~/.config/starship.toml
symlink "$ZERMUX_PATH/config/zellij" ~/.config/zellij
symlink "$ZERMUX_PATH/config/bat" ~/.config/bat
symlink "$ZERMUX_PATH/config/carapace" ~/.config/carapace
symlink "$ZERMUX_PATH/config/termux/termux.properties" ~/.termux/termux.properties
symlink "$ZERMUX_PATH/config/termux/colors.properties" ~/.termux/colors.properties

mkdir -p ~/.termux/boot
symlink "$ZERMUX_PATH/boot.sh" ~/.termux/boot/00-zermux.sh

step "Applying Termux settings..."
termux-reload-settings || true

step "Zermux $(cat "$ZERMUX_PATH/version" 2>/dev/null || echo "main") installed successfully!"

cat <<EOF

Restart Termux completely → you will land in a beautiful Zellij workspace
Everything is Git-backed → update with: cd $ZERMUX_PATH && git pull

Enjoy the most aesthetic Termux setup in 2025 
EOF

exec bash
