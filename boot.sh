#!/usr/bin/env bash
# =============================================================================
# Zermux Boot Installer – Zero-boilerplate Termux Environment (2025)
# Usage: curl -fsSL https://raw.githubusercontent.com/yourname/zermux/main/zermux-boot.sh | bash
# =============================================================================

#set -euo pipefail

export ZERMUX_ONLINE_INSTALL=true

# Colors
readonly RESET='\033[0m' BOLD='\033[1m' CYAN='\033[96m' GREEN='\033[92m' YELLOW='\033[93m' RED='\033[91m'
log()    { echo -e "${CYAN}[Zermux]${RESET} $*"; }
success(){ echo -e "${GREEN}✔${RESET} $*"; }
warn()   { echo -e "${YELLOW}⚠${RESET} $*"; }
error()  { echo -e "${RED}✘ ERROR: $*${RESET}" >&2; exit 1; }

# Gradient ASCII Logo (Tokyo Night Storm)
print_logo() {
    local colors=(117 111 105 99 141 135 169 204)
    local logo=(
        "   ███████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗   "
        "   ╚══███╔╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝   "
        "     ███╔╝ █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝    "
        "    ███╔╝  ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗    "
        "   ███████╗███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗   "
        "   ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   "
    )
    clear
    for i in "${!logo[@]}"; do
        printf '\e[38;5;%dm%s\e[0m\n' "${colors[i]}" "${logo[i]}"
    done
    echo
}

#print_logo

log "Starting Zermux installation – $(date '+%Y-%m-%d %H:%M')"

log "Updating Termux packages..."
termux-change-repo && yes | pkg upgrade -y

print_logo

log "Installing zermux-core..."
#pkg install -y git gum glow shellcheck shfmt manpages bash-completion lesspipe file wget which rlwrap clang make ripgrep fd unzip neovim termux-services termux-create-package termux-apt-repo termux-api git zellij openssh neovim bash starship manpages bash-completion lesspipe rlwrap file wget which unzip
ZERMUX_REPO="${ZERMUX_REPO:-zermux-org/zermux}"
ZERMUX_REF="${ZERMUX_REF:-main}"
ZERMUX_PATH="$HOME/.local/share/zermux"

log "Cloning Zermux from https://github.com/${ZERMUX_REPO}.git"
rm -rf "$ZERMUX_PATH"
git clone --depth 1 "https://github.com/${ZERMUX_REPO}.git" "$ZERMUX_PATH"

if [[ "$ZERMUX_REF" != "main" ]]; then
    log "Checking out ref: $ZERMUX_REF"
    (cd "$ZERMUX_PATH" && git fetch origin "$ZERMUX_REF" && git checkout "$ZERMUX_REF")
fi

success "Repository ready → $ZERMUX_PATH"
log "Launching full installer..."
exec bash "$ZERMUX_PATH/install.sh"
