export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.fzf/bin:$PATH"

# ── Homebrew ───────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── Zsh completion ────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

# ── History ───────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ── Plugins ───────────────────────────────────────────────────────
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── fzf ───────────────────────────────────────────────────────────
source ~/.fzf/shell/key-bindings.zsh
source ~/.fzf/shell/completion.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# ── Aliases ───────────────────────────────────────────────────────
alias ll='ls -lAh'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias zhelp='glow ~/dotfiles/ZELLIJ.md'
alias zquit='zellij kill-session $ZELLIJ_SESSION_NAME'

# Push dotfiles changes to GitHub
dsync() {
  local msg="${1:-update dotfiles}"
  git -C ~/dotfiles add -A && git -C ~/dotfiles commit -m "$msg" && git -C ~/dotfiles push -u origin main
}

# Zellij smart attach — directory-based sessions
zmux() {
  local session
  session=$(basename "$PWD" | tr ' .' '-' | tr '[:upper:]' '[:lower:]')
  local active
  active=$(~/bin/zellij list-sessions 2>/dev/null | sed 's/\x1b\[[0-9;]*[mK]//g' | grep "^$session" | grep -v "EXITED")
  if [ -n "$active" ]; then
    ~/bin/zellij attach "$session"
  else
    ~/bin/zellij kill-session "$session" >/dev/null 2>&1
    ~/bin/zellij delete-session "$session" >/dev/null 2>&1
    ~/bin/zellij --session "$session"
  fi
}

# ── Starship prompt ───────────────────────────────────────────────
eval "$(starship init zsh)"

# bun completions
[ -s "/Users/deep/.bun/_bun" ] && source "/Users/deep/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# --
tunnel_asgard() {
    ssh -L 6379:localhost:6379 \
        -L 5432:localhost:5432 \
        asgardhq
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=/Users/deep/.opencode/bin:$PATH

# claude-mem alias disabled 2026-05-03: plugin was uninstalled but its daemon kept rewriting AGENTS.md
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"


# Exness / MT5 live BTC quote helpers
export EXNESS_TICKS_CSV="$HOME/Library/Application Support/net.metaquotes.wine.metatrader5/drive_c/Program Files/MetaTrader 5/MQL5/Files/exness_ticks.csv"

exwatch() {
  local interval="${1:-1}"
  local key=""
  while true; do
    clear
    date
    stat -f "file modified: %Sm" "$EXNESS_TICKS_CSV" 2>/dev/null || true
    cat "$EXNESS_TICKS_CSV" 2>/dev/null || echo "missing: $EXNESS_TICKS_CSV"
    echo
    echo "press q to stop; refresh ${interval}s"
    key=""
    read -t "$interval" -k 1 key
    [[ "$key" == "q" ]] && break
  done
}

exbench() {
  cargo run --manifest-path "$HOME/Dev/asgard/stride-perp-agg-rs/Cargo.toml" -p stride-market-bench -- \
    --reference exness \
    --exness-csv "$EXNESS_TICKS_CSV" \
    "$@"
}
