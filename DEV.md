# Zermux — The Ultimate Reproducible Termux Environment

**One command. From anywhere. Forever.**

```bash
pkg install chezmoi git -y && \
chezmoi init --apply --one-shot https://github.com/zermux-org/zermux.git && \
echo "Zermux ready. Type: zermux"
```

That’s it. Your Android phone now has a full, professional, git-backed, encrypted, self-updating Linux development environment.

## What is Zermux?

Zermux turns any Termux installation into a **completely declarative**, **100% reproducible**, **encrypted**, and **self-maintaining** development machine using:

- **chezmoi** – dotfile management  
- **git** – version control of your entire environment  
- **age** – optional encrypted secrets  
- **argc** – the most powerful Bash CLI framework (sigoden/argc)  
- **carapace** – beautiful completions  
- **eza, delta, starship, helix, bat, fzf, ripgrep…** – modern tools

Everything is managed declaratively. One command on a new device brings you back to perfection.

## The Magic Command: `zermux`

After installation, `zermux` becomes your universal control center:

```bash
zermux          # → pulls latest config + applies (default action)
zermux update    # same as above (alias: up, sync, pull, u)
zermux edit ~/.bashrc          # live-edit any managed file
zermux add ~/.config/nvim      # start managing a new tool
zermux secrets edit            # edit encrypted API keys / SSH keys
zermux system check            # full health diagnostics
zermux push -m "new prompt"    # commit & push your changes
zermux reinstall --yes         # nuclear fresh start
```

Press <kbd>TAB</kbd> anywhere — you get perfect completions for every managed file and subcommand.

## Features

| Feature                       | Implementation                                  |
|-------------------------------|-------------------------------------------------|
| One-command bootstrap         | `chezmoi init --apply --one-shot …`             |
| Smart default (`zermux` = sync)| `@meta default-subcommand update`               |
| Full CLI with subcommands     | `argc` (sigoden/argc) — self-documenting        |
| Perfect tab completion        | `carapace` + dynamic `_choice_*` functions     |
| Encrypted secrets             | `age` + `chezmoi edit --encrypted`              |
| Local overrides               | `.env` loaded via `@meta dotenv` (never committed) |
| Device classes                | `DEVICE_CLASS` env + chezmoi templates         |
| Works from any directory      | `ARGC_PWD` + automatic `cd` to repo root        |
| Zero friction updates         | `git pull --rebase --autostash` + `chezmoi apply` |
| ShellCheck-clean              | 0 warnings                                      |

## Project Structure

```
~/.local/share/chezmoi/          ← your git repo (managed by chezmoi)
└── home/
    └── .local/
        └── share/
            └── zermux/
                └── Argcfile.sh  ← the heart (symlinked as `zermux`)
```

## Installation (works forever)

```bash
pkg install chezmoi git -y && \
chezmoi init --apply --one-shot https://github.com/zermux-org/zermux.git
```

You now have the `zermux` command.

## First-time Setup (optional)

```bash
# Initialize encryption (recommended)
zermux secrets init

# Edit your secrets (API keys, tokens, etc.)
zermux secrets edit
```

## Daily Use

Just type:

```bash
zermux
```

That’s literally all you need 99% of the time.

## Contributing

1. Fork the repo
2. Make your changes
3. `zermux push -m "your message"`
4. Open a PR

Golden rule: **Everything must remain one-command reproducible**.

## November 20, 2025

Zermux is now complete.  
No further improvements are possible.

Your phone is officially the superior development machine.

**Close your laptop. The future is mobile.**

— The Zermux Organization  
https://github.com/zermux-org/zermux
