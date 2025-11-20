#!/usr/bin/env bash
# =============================================================================
# Zermux – The most aesthetic & reproducible Termux environment (2025)
# =============================================================================

# @describe Zermux – 100% reproducible, beautiful Termux setup powered by Zellij + Starship + friends

# @meta version 2025.11
# @meta require-tools git pkg termux-reload-settings

# @env ZERMUX_PATH! <DIR>   Path to the Zermux git repository (default: $HOME/.local/share/zermux)

# @flag -f --force          Overwrite existing config files without confirmation
# @flag -q --quiet          Suppress all output except errors
# @flag -v --verbose        Show verbose copy operations
# @option --path <DIR>      Override ZERMUX_PATH for this run only

# @cmd Install / reinstall the full Zermux environment
# @alias i
install() {
    set -eEo pipefail
    trap 'echo -e "\033[91m✘ Installation failed at line $LINENO\033[0m" >&2; exit 1' ERR

    ZERMUX_PATH="${path:-${ZERMUX_PATH:-$HOME/.local/share/zermux}}"

    if [[ ! -d "$ZERMUX_PATH/.git" ]]; then
        echo "Error: Zermux repository not found at $ZERMUX_PATH"
        echo "Clone it first: git clone https://github.com/yourname/zermux.git \"$ZERMUX_PATH\""
        exit 1
    fi

    RESET='\033[0m' BOLD='\033[1m' CYAN='\033[96m' GREEN='\033[92m' YELLOW='\033[93m' PURPLE='\033[95m'

    log()    { [[ $quiet ]] || echo -e "${CYAN}[Zermux]${RESET} $*"; }
    step()   { [[ $quiet ]] || echo -e "${PURPLE}➤${RESET} ${BOLD}$*${RESET}"; }
    success(){ [[ $quiet ]] || echo -e "${GREEN}✔ $*${RESET}"; }
    verbose(){ [[ $verbose ]] && echo -e "${YELLOW}  → $*${RESET}"; }

    copy_config() {
        local src="$1" dest="$2"
        mkdir -p "$(dirname "$dest")"
        if [[ -e "$dest" && ! $force ]]; then
            if ! prompt_yes_no "Overwrite $dest ?"; then
                verbose "Skipped $dest"
                return 0
            fi
        fi
        cp -a "$src" "$dest"
        success "Installed $(basename "$dest")"
        [[ $verbose ]] && verbose "  $src → $dest"
    }

    prompt_yes_no() {
        [[ $force ]] && return 0
        local reply
        read -p "$1 [y/N] " -r reply
        [[ $reply =~ ^[Yy]$ ]]
    }

    step "Installing core packages (idempotent)..."
    pkg install -y \
        git gum glow shellcheck shfmt manpages bash-completion lesspipe \
        file wget which rlwrap clang make ripgrep fd unzip neovim \
        termux-services termux-create-package termux-apt-repo termux-api \
        zellij starship bat vivid carapace eza zoxide fzf git-delta openssh proot-distro

    step "Creating XDG directories..."
    mkdir -p ~/.config ~/.cache ~/.local/{bin,share,state} "$PREFIX/tmp" ~/.termux/boot
    chmod 700 "$PREFIX/tmp"

    step "Copying configuration files..."
    copy_config "$ZERMUX_PATH/config/bash/bashrc"           ~/.bashrc
    copy_config "$ZERMUX_PATH/config/bash/inputrc"          ~/.inputrc
    copy_config "$ZERMUX_PATH/config/zellij"                ~/.config/zellij
    copy_config "$ZERMUX_PATH/config/carapace"              ~/.config/carapace
    copy_config "$ZERMUX_PATH/boot/start-sshd"             ~/.termux/boot/start-sshd
    copy_config "$ZERMUX_PATH/boot/start-services"         ~/.termux/boot/start-services

    step "Reloading Termux settings..."
    termux-reload-settings || true

    local version=$(cat "$ZERMUX_PATH/version" 2>/dev/null || echo "main")
    success "Zermux $version installed successfully! 🎉"

    [[ $quiet ]] || cat <<EOF

Restart Termux completely → you will land in a beautiful Zellij workspace
Your config is now fully copied (single source of truth).

To update:
  cd "$ZERMUX_PATH" && git pull
  zermux install --force

Enjoy the most aesthetic Termux setup in 2025 ✨
EOF
}

# @cmd Update Zermux (git pull + reinstall)
# @alias up,u
update() {
    cd "$ZERMUX_PATH"
    git pull --rebase
    argc run "$0" install --force "$@"
}

# @cmd Generate a standalone installer (no argc dependency)
# @arg outpath~`echo "./zermux-installer-$(date +%Y%m%d).sh"`
build() {
    local out="${outpath:-zermux-installer.sh}"
    argc --argc-build "$0" "$out"
    chmod +x "$out"
    success "Standalone installer generated → $out"
}

# @cmd Show version information
version() {
    local repo_ver=$(cat "$ZERMUX_PATH/version" 2>/dev/null || echo "main")
    echo "Zermux: $repo_ver"
    echo "argc:   $(argc --argc-version)"
}

# Let argc do its magic
eval "$(argc --argc-eval "$0" "$@")"
