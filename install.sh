#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[dotfiles]${NC} $1"; }
warn()  { echo -e "${YELLOW}[dotfiles]${NC} $1"; }

# Create a symlink, backing up existing file if needed
link() {
  local src="$DOTFILES/$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -sf "$src" "$dst"
  info "Linked $dst → $src"
}

info "Setting up dotfiles..."

# ── Symlinks ──────────────────────────────────────────────────────
link zshrc                      "$HOME/.zshrc"
link gitconfig                  "$HOME/.gitconfig"
link alacritty/alacritty.toml   "$HOME/.config/alacritty/alacritty.toml"
link zellij/config.kdl          "$HOME/.config/zellij/config.kdl"

# ── Zellij binary ─────────────────────────────────────────────────
if ! command -v zellij &>/dev/null && [ ! -f "$HOME/bin/zellij" ]; then
  info "Installing Zellij..."
  mkdir -p "$HOME/bin"
  ZELLIJ_VERSION="v0.43.1"
  curl -L "https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/zellij-aarch64-apple-darwin.tar.gz" \
    | tar -xz -C /tmp
  mv /tmp/zellij "$HOME/bin/zellij"
  chmod +x "$HOME/bin/zellij"
fi

# ── glow binary ───────────────────────────────────────────────────
if ! command -v glow &>/dev/null && [ ! -f "$HOME/bin/glow" ]; then
  info "Installing glow..."
  mkdir -p "$HOME/bin"
  curl -L "https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Darwin_arm64.tar.gz" \
    | tar -xz -C /tmp "glow_2.1.1_Darwin_arm64/glow"
  mv /tmp/glow_2.1.1_Darwin_arm64/glow "$HOME/bin/glow"
  chmod +x "$HOME/bin/glow"
fi

info "Done! Open a new terminal or run: source ~/.zshrc"
