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

# ── Homebrew ──────────────────────────────────────────────────────
if [ ! -f "/opt/homebrew/bin/brew" ]; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── Symlinks ──────────────────────────────────────────────────────
link zshrc                      "$HOME/.zshrc"
link gitconfig                  "$HOME/.gitconfig"
link alacritty/alacritty.toml   "$HOME/.config/alacritty/alacritty.toml"
link zellij/config.kdl          "$HOME/.config/zellij/config.kdl"

mkdir -p "$HOME/bin"

# ── Zellij ────────────────────────────────────────────────────────
if [ ! -f "$HOME/bin/zellij" ]; then
  info "Installing Zellij..."
  ZELLIJ_VERSION="v0.43.1"
  curl -L "https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/zellij-aarch64-apple-darwin.tar.gz" \
    | tar -xz -C /tmp
  mv /tmp/zellij "$HOME/bin/zellij"
  chmod +x "$HOME/bin/zellij"
fi

# ── glow ──────────────────────────────────────────────────────────
if [ ! -f "$HOME/bin/glow" ]; then
  info "Installing glow..."
  curl -L "https://github.com/charmbracelet/glow/releases/download/v2.1.1/glow_2.1.1_Darwin_arm64.tar.gz" \
    | tar -xz -C /tmp "glow_2.1.1_Darwin_arm64/glow"
  mv /tmp/glow_2.1.1_Darwin_arm64/glow "$HOME/bin/glow"
  chmod +x "$HOME/bin/glow"
fi

# ── starship ──────────────────────────────────────────────────────
if [ ! -f "$HOME/bin/starship" ]; then
  info "Installing starship..."
  curl -L "https://github.com/starship/starship/releases/download/v1.24.2/starship-aarch64-apple-darwin.tar.gz" \
    | tar -xz -C /tmp
  mv /tmp/starship "$HOME/bin/starship"
  chmod +x "$HOME/bin/starship"
fi

# ── fzf ───────────────────────────────────────────────────────────
if [ ! -d "$HOME/.fzf" ]; then
  info "Installing fzf..."
  git clone --depth 1 --branch v0.68.0 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --bin --no-bash --no-fish --no-zsh --no-update-rc
fi

# ── zsh plugins ───────────────────────────────────────────────────
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi

if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
fi

# ── bat ───────────────────────────────────────────────────────────
if [ ! -f "$HOME/bin/bat" ]; then
  info "Installing bat..."
  curl -L "https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-aarch64-apple-darwin.tar.gz" \
    | tar -xz -C /tmp
  mv /tmp/bat-v0.26.1-aarch64-apple-darwin/bat "$HOME/bin/bat"
  chmod +x "$HOME/bin/bat"
fi

# ── ripgrep ───────────────────────────────────────────────────────
if [ ! -f "$HOME/bin/rg" ]; then
  info "Installing ripgrep..."
  curl -L "https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-aarch64-apple-darwin.tar.gz" \
    | tar -xz -C /tmp
  mv /tmp/ripgrep-15.1.0-aarch64-apple-darwin/rg "$HOME/bin/rg"
  chmod +x "$HOME/bin/rg"
fi

# ── jq ────────────────────────────────────────────────────────────
if [ ! -f "$HOME/bin/jq" ]; then
  info "Installing jq..."
  curl -L "https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-macos-arm64" -o "$HOME/bin/jq"
  chmod +x "$HOME/bin/jq"
fi

# ── brew tools ────────────────────────────────────────────────────
brew install btop

info "Done! Open a new terminal or run: source ~/.zshrc"
