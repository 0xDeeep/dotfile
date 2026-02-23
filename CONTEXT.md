# Dotfiles — Context & State

> This document is for agents picking up this work.
> Read this fully before making any changes. Do not assume. Do not overwrite without understanding state.

---

## Machine

- **Model:** MacBook Pro (Apple Silicon — arm64)
- **OS:** macOS 26.1 (Darwin 25.1.0)
- **Shell:** zsh 5.9
- **User:** deep (`/Users/deep`)

---

## Goal

Set up a modern, productive terminal environment on a new MacBook and track all configs in a dotfiles GitHub repo for easy sync and new machine setup.

---

## What Has Been Done

### 1. Alacritty ✅
- **File:** `~/.config/alacritty/alacritty.toml` → symlink → `~/dotfiles/alacritty/alacritty.toml`
- Shift+Enter sends `\u001b\r` for newline in Claude Code input
- Config includes: window padding, opacity, Menlo font, Tomorrow Night colors, blinking cursor, mouse bindings, keyboard shortcuts

### 2. Xcode Command Line Tools ✅
- git 2.50.1 at `/usr/bin/git`
- clang 17.0.0

### 3. Homebrew ✅
- **Version:** 5.0.15
- **Path:** `/opt/homebrew` (Apple Silicon)
- Initialized in zshrc via `eval "$(/opt/homebrew/bin/brew shellenv)"`
- Use brew for tools that don't have prebuilt binaries (e.g. btop)
- Prefer `~/bin` manual installs for single-binary tools where a direct download exists

### 4. Zellij ✅
- **Version:** 0.43.1
- **Binary:** `~/bin/zellij` (manually downloaded)
- **Config:** `~/.config/zellij/config.kdl` → symlink → `~/dotfiles/zellij/config.kdl`
- **Theme:** catppuccin-mocha
- **Layout:** compact (no pane frames)
- **Mouse:** enabled
- **Copy:** pbcopy (macOS clipboard)
- **Custom keybinding:** `Ctrl+o → ?` opens `~/dotfiles/ZELLIJ.md` in a floating pane via `less`
- **NOT using tmux** — user chose Zellij as modern alternative
- **Auto-launch:** DISABLED — user opens Zellij manually via `zmux`

### 5. glow ✅
- **Version:** 2.1.1
- **Binary:** `~/bin/glow` (manually downloaded)
- Renders markdown in terminal
- `zhelp` alias opens `~/dotfiles/ZELLIJ.md`

### 6. zsh Plugins ✅
Installed manually via git clone:
- `~/.zsh/zsh-autosuggestions/` — inline suggestions
- `~/.zsh/zsh-syntax-highlighting/` — command color highlighting
- `~/.fzf/` — fuzzy finder (v0.68.0), binaries at `~/.fzf/bin/`
- `~/bin/starship` — shell prompt (v1.24.2)

### 7. zshrc ✅
- **File:** `~/.zshrc` → symlink → `~/dotfiles/zshrc`
- Contains: PATH, completions, history, plugin sources, aliases, `zmux`, `zquit`, `zhelp`, fzf bindings, starship, bun

### 8. Dotfiles Repo ✅ (local only)
- **Location:** `~/dotfiles/`
- **Git:** initialized, files staged, NOT yet pushed to GitHub
- **Approach:** symlinks — real files in `~/dotfiles/`, symlinks at original locations
- **GitHub:** `git@github.com:0xDeeep/dotfile.git` (PUBLIC repo)
- ⚠️ **OPSEC — Repo is PUBLIC. Hard rules:**
  - Never add: secrets, tokens, passwords, API keys, private keys, env files
  - Never add: anything from `~/.ssh/` — config exposes infrastructure, keys are credentials
  - Safe to add: tool configs, aliases, keybindings, themes, shell rc files
  - The gitconfig SSH signing key is a public key — safe

---

## Symlink Map

| Symlink (original location) | Real file in repo |
|-----------------------------|-------------------|
| `~/.zshrc` | `~/dotfiles/zshrc` |
| `~/.gitconfig` | `~/dotfiles/gitconfig` |
| `~/.config/alacritty/alacritty.toml` | `~/dotfiles/alacritty/alacritty.toml` |
| `~/.config/zellij/config.kdl` | `~/dotfiles/zellij/config.kdl` |

---

## Key Aliases & Functions

```zsh
zmux()   # Directory-based Zellij sessions
         # cd ~/myproject && zmux → creates/attaches "myproject" session
         # Detached → reattaches | Dead/exited → cleans up, creates fresh

zquit    # Kill current Zellij session from inside
zhelp    # Open ~/dotfiles/ZELLIJ.md with glow
dsync    # Push dotfiles to GitHub: git add -A + commit + push from ~/dotfiles/
         # Usage: dsync "add neovim config"  (default message: "update dotfiles")
         # Benefit: one command to sync any config change — no manual cd/add/commit/push

# Git shortcuts: gs / ga / gc / gp / gl
# Navigation:    ll / la / .. / ...
```

---

## How to Add More Dotfiles

```bash
# 1. Move real file into repo
mv ~/.config/someapp/config.toml ~/dotfiles/someapp/config.toml

# 2. Create symlink back
ln -sf ~/dotfiles/someapp/config.toml ~/.config/someapp/config.toml

# 3. Add to install.sh
link someapp/config.toml "$HOME/.config/someapp/config.toml"

# 4. Push
dsync "add someapp config"
```

---

## File Inventory

```
~/dotfiles/
├── CONTEXT.md              ← this file
├── ZELLIJ.md               ← full Zellij keybindings reference (zhelp / Ctrl+o → ?)
├── install.sh              ← run once on new machine
├── zshrc                   ← ~/.zshrc
├── gitconfig               ← ~/.gitconfig
├── alacritty/
│   └── alacritty.toml      ← ~/.config/alacritty/alacritty.toml
└── zellij/
    └── config.kdl          ← ~/.config/zellij/config.kdl

~/bin/                      ← user binaries (in PATH)
├── zellij                  ← v0.43.1
├── glow                    ← v2.1.1
├── starship                ← v1.24.2
├── bat                     ← v0.26.1
├── rg                      ← ripgrep v15.1.0
└── jq                      ← v1.8.1

/opt/homebrew/              ← Homebrew v5.0.15
└── btop                    ← v1.4.6

~/.zsh/
├── zsh-autosuggestions/
└── zsh-syntax-highlighting/

~/.fzf/                     ← fzf v0.68.0
```

---

## Key Decisions

| Decision | Reason |
|----------|--------|
| Zellij over tmux | Works out of the box, modern, no heavy config needed |
| Homebrew NOT installed | All tools installed via manual binary downloads |
| Symlinks dotfiles approach | Industry standard (nickjj, holman, craftzdog) |
| Public GitHub repo | Intentionally public — never add secrets, tokens, or private keys |
| `zmux` directory-based sessions | Each project folder gets its own Zellij session |
| glow for markdown | Best terminal markdown renderer, single binary |
| Compact Zellij layout | No pane frame headers, cleaner UI |
| Starship prompt | Clean, fast, no oh-my-zsh dependency |

---


*Last updated: 2026-02-23 | Session: MacBook terminal setup*
