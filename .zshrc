# ---------------------- #
# PATH CONFIGURATION     #
# ---------------------- #
export PATH="$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin:$PATH"

# ---------------------- #
# OH-MY-ZSH SETUP        #
# ---------------------- #
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  git
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ---------------------- #
# ZSH OPTIONS            #
# ---------------------- #
setopt autocd               # Change dirs by name
setopt interactivecomments  # Allow comments in interactive shell
setopt magicequalsubst      # Expand arguments of the form name=value
setopt nonomatch            # Suppress error if glob doesn't match
setopt notify               # Job status notifications
setopt numericglobsort      # Sort globs numerically
setopt promptsubst          # Enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/}  # Remove / from word characters
PROMPT_EOL_MARK=""          # Hide EOL character in prompt

# ---------------------- #
# COMPLETION             #
# ---------------------- #
autoload -Uz compinit
compinit -d "${ZSH_CACHE_DIR:-$HOME/.cache}/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ---------------------- #
# HISTORY SETTINGS       #
# ---------------------- #
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_verify

alias history="history 0"

# ---------------------- #
# KEYBINDINGS            #
# ---------------------- #
bindkey -e
bindkey ' ' magic-space
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo
bindkey -r '^[[Z'
bindkey '^[[Z' forward-char

# ---------------------- #
# PROMPT SETUP           #
# ---------------------- #
if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
  debian_chroot=$(< /etc/debian_chroot)
fi

case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

if [[ -n "$color_prompt" ]]; then
  PROMPT='%F{blue}╭─%f${debian_chroot:+(%F{magenta}${debian_chroot}%f) }%F{cyan}%n@%m %F{green}%~%f %F{blue}──⟫%f\n%F{blue}╰─%f%B%F{%(#.red.blue)}%#%f%b '
  RPROMPT='%F{red}${(?.⛔)}%f%F{yellow}${(1j.⚙.)}%f'
else
  PROMPT='╭─${debian_chroot:+($debian_chroot) }%n@%m %~ ──⟫\n╰─%# '
fi

# ---------------------- #
# ZSH SYNTAX HIGHLIGHT   #
# ---------------------- #
SYNTAX_HIGHLIGHT="$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [[ -f $SYNTAX_HIGHLIGHT ]]; then
  source "$SYNTAX_HIGHLIGHT"
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
  ZSH_HIGHLIGHT_STYLES[path]='underline'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
  ZSH_HIGHLIGHT_STYLES[arg0]='fg=green'
fi

# ---------------------- #
# AUTOSUGGESTIONS        #
# ---------------------- #
AUTOSUGGEST="$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [[ -f $AUTOSUGGEST ]]; then
  source "$AUTOSUGGEST"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# ---------------------- #
# SHELL ENV SETTINGS     #
# ---------------------- #
case "$TERM" in
  xterm*|rxvt*)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
    ;;
esac

new_line_before_prompt=yes
precmd() {
  [[ -n $TERM_TITLE ]] && print -Pnr -- "$TERM_TITLE"
  if [[ "$new_line_before_prompt" == yes ]]; then
    if [[ -z "$_NEW_LINE_BEFORE_PROMPT" ]]; then
      _NEW_LINE_BEFORE_PROMPT=1
    else
      print ""
    fi
  fi
}

# ---------------------- #
# COLOR + ALIASES        #
# ---------------------- #
if command -v dircolors >/dev/null; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='diff --color=auto'
  alias ip='ip --color=auto'
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# File management aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Pager color enhancement
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# ---------------------- #
# CLEANUP                #
# ---------------------- #
unset color_prompt force_color_prompt
