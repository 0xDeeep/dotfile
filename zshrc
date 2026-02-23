export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.fzf/bin:$PATH"

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
  git -C ~/dotfiles add -A && git -C ~/dotfiles commit -m "$msg" && git -C ~/dotfiles push
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
