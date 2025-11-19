# Zermux Developer Guide (November 19, 2025)

Welcome to the official developer guide for **Zermux** — the zero-boilerplate, Git-backed, Zellij-powered Termux environment.

## 1. Setup Instructions (Fresh Device → Ready in < 2 minutes)

### 1.1 Install Termux (F-Droid or GitHub only)
```bash
# Recommended: F-Droid (auto-updates, no Google Play Services)
https://f-droid.org/packages/com.termux/

# Or direct APK from GitHub releases (v0.118.1+ required)
https://github.com/termux/termux-app/releases
```

### 1.2 One-Command Installation
```bash
curl -fsSL https://raw.githubusercontent.com/yourname/zermux/main/zermux-boot.sh | bash
```
Optional overrides:
```bash
ZERMUX_REPO=cooluser/zermux-fork ZERMUX_REF=experimental \
curl -fsSL https://raw.githubusercontent.com/yourname/zermux/main/zermux-boot.sh | bash
```

### 1.3 First Launch
- Close all Termux sessions completely  
- Re-open Termux → you automatically land inside a **Zellij** workspace  
- Enjoy Tokyo Night Storm theme, Starship prompt, bat pager, carapace completion

### 1.4 Updating Zermux (Forever)
```bash
cd ~/.local/share/zermux && git pull
# Then restart Termux or run: source ~/.bashrc
```

## 2. Project Structure Overview (Omarchy-style)

```
zermux/
├── boot.sh          ← curl | bash entrypoint
├── install.sh              ← idempotent full installer
├── motd.sh                 ← ~/.termux/motd.sh
├── version                 ← current release (e.g., 2025.11)
├── logo.txt                ← gradient ASCII logo
├── AGENTS.md               ← PRD for AI assistants (you’re reading it)
├── default/
│   ├── bashrc              ← single source of truth for shell
│   └── inputrc             ← readline config
├── config/
│   ├── starship.toml
│   ├── vivid/themes/
│   ├── zellij/
│   │   ├── config.kdl
│   │   └── layouts/dev.kdl
│   ├── bat/config
│   ├── carapace/
│   └── termux/
│       ├── termux.properties
│       └── colors.properties
└── themes/
    ├── tokyo-night/        ← full theme override (termux, starship, zellij, bat)
    └── catppuccin-mocha/
```

Everything the user sees is symlinked from this repo → **single source of truth**.

## 3. Development Workflow

### 3.1 Clone & Work Locally
```bash
git clone https://github.com/yourname/zermux.git ~/.local/share/zermux
cd ~/.local/share/zermux
```

### 3.2 Make Changes
- Edit files directly in the repo  
- Test instantly (no reinstall needed):
```bash
source ~/.bashrc                  # reload shell config
termux-reload-settings            # reload Termux UI theme
zellij kill-session -y && zellij  # restart Zellij with new layout
```

### 3.3 Add a New Theme
```bash
mkdir -p themes/new-theme
cp -r themes/tokyo-night/* themes/new-theme/
# Edit files → done
# Switch temporarily:
ln -sf $PWD/themes/new-theme/termux.properties ~/.termux/termux.properties
termux-reload-settings
```

### 3.4 Bump Version
```bash
echo "2025.11.19" > version
git commit -am "Release 2025.11.19"
git push
```

### 3.5 Coding Standards (Mandatory)
- All scripts: `set -euo pipefail` + full colorized logging  
- Tabs for indentation in Bash (per Termux guidelines)  
- Line length ≤ 80 characters  
- No executable bit on config files  
- Use `ln -sf` everywhere (idempotent)  
- Prefer `local` variables in functions  
- Never hardcode `$PREFIX` or `$HOME`

## 4. Testing Approach

### 4.1 Manual Smoke Test (run after every change)
```bash
# 1. Fresh Termux (use Termux:Boot or new device)
# 2. Run the one-liner
# 3. Verify:
[ ] Gradient logo appears
[ ] Zellij starts automatically
[ ] Starship prompt works
[ ] `ls` has vivid colors
[ ] `cat file` uses bat
[ ] Tab completion is carapace
[ ] `man ls` uses bat
[ ] Tokyo Night theme in Termux UI
```

### 4.2 Automated Test (future)
```bash
./scripts/test-install.sh   # creates proot-distro, runs installer, asserts symlinks
```

### 4.3 Compatibility Matrix
Tested & guaranteed on:
- Termux v0.118.1+ (F-Droid)
- Android 9–15
- aarch64, arm, x86_64

## 5. Common Troubleshooting Steps

| Symptom                          | Fix                                                                 |
|----------------------------------|---------------------------------------------------------------------|
| No Zellij on startup             | `ls ~/.termux/boot/` → ensure `00-zermux.sh` symlink exists         |
| Wrong colors / theme             | Run `termux-reload-settings` or restart app                         |
| bat/carapace/starship missing   | `pkg install bat carapace starship` then restart                    |
| "Permission denied" on $PREFIX/tmp | `chmod 700 $PREFIX/tmp`                                           |
| Old config lingering             | `rm -rf ~/.config/{zellij,starship,bat,carapace}` then restart     |
| Want to uninstall completely     | `rm -rf ~/.local/share/zermux ~/.config/zermux ~/.termux/boot/00-zermux.sh` |
| Installer stuck on pkg install   | Check internet → try different mirror: `termux-change-repo`         |

You now have everything needed to maintain, extend, and ship the most beautiful Termux environment in 2025.

Happy hacking!  
— The Zermux Team (November 19, 2025)