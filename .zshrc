# =============================================================================
# Zsh Configuration
# =============================================================================

# --- VS Code Shell Integration (Preserved) ---
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  if [[ -n "$VSCODE_SHELL_INTEGRATION" ]]; then
    return
  fi
  SHELL_INTEGRATION_PATH="$(code --locate-shell-integration-path zsh 2>/dev/null)"
  if [[ -f "$SHELL_INTEGRATION_PATH" ]]; then
    source "$SHELL_INTEGRATION_PATH"
  fi
fi

# --- Environment Variables ---
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR="nano"
export VISUAL="nano"
export PAGER="less"

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY          # Append to history file
setopt INC_APPEND_HISTORY      # Add commands as they are typed, don't wait for exit
setopt HIST_IGNORE_DUPS        # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS       # Do not display a line previously found
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry
setopt HIST_VERIFY             # Don't execute immediately upon history expansion
setopt SHARE_HISTORY           # Share history between all sessions

# --- Options ---
setopt AUTO_CD                 # Auto changes to a directory without typing cd
setopt AUTO_PUSHD              # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS       # Do not store duplicates in the stack
setopt PUSHD_SILENT            # Do not print the directory stack on pushd or popd
setopt EXTENDED_GLOB           # Use extended globbing syntax
setopt NO_BEEP                 # No beep
setopt CORRECT                 # Autocorrect commands

# --- Completion ---
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Enable caching for faster completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"

# Initialize completion (dumb check to speed up startup)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# --- Keybindings ---
bindkey -e # Emacs mode
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[1;5D' backward-word      # Ctrl+Left
bindkey '^[[H' beginning-of-line     # Home
bindkey '^[[F' end-of-line           # End
bindkey '^[[3~' delete-char          # Delete

# --- Tools Integration ---

# Starship Prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Zoxide (better cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# FZF (Fuzzy Finder)
if command -v fzf >/dev/null 2>&1; then
  # Debian/Ubuntu paths
  [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
fi

# --- Aliases ---
# General
alias l="ls -lah"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias -g G='| grep'
alias -g L='| less'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Replacements with modern tools if available
if command -v eza >/dev/null 2>&1; then
  alias ls="eza"
  alias ll="eza -lah --git"
  alias la="eza -la"
  alias tree="eza --tree"
fi

if command -v batcat >/dev/null 2>&1; then
  alias cat="batcat"
elif command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi

if command -v rg >/dev/null 2>&1; then
  alias grep="rg"
fi

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias glog="git log --oneline --graph --decorate --all"

# Tmux
alias t="tmux"
alias ta="tmux attach -t"
alias tn="tmux new -s"
alias tl="tmux list-sessions"

# --- Plugins (System) ---
# Autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
fi

# Syntax Highlighting (Must be last)
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
