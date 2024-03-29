# PATH
export JAVA_HOME=/usr
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/mnt/c/Users/Pablo/OneDrive/Documents/git
ZDOTDIR=~/dotfiles

# Aliases definition
source $ZDOTDIR/.aliases

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  #source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Move prompt to bottom
cls

# Print alias completion
local cmd_alias=""

alias_for() {
  [[ $1 =~ '[[:punct:]]' ]] && return
  local search=${1}
  local found="$( alias $search )"
  if [[ -n $found ]]; then
    found=${found//\\//}
    found=${found%\'}
    found=${found#"$search="}
    found=${found#"'"}
    echo "${found} ${2}" | xargs
  else
    echo ""
  fi
}

expand_command_line() {
  first=$(echo "$1" | awk '{print $1;}')
  rest=$(echo ${${1}/"${first}"/})

  if [[ -n "${first//-//}" ]]; then
    cmd_alias="$(alias_for "${first}" "${rest:1}")"
    if [[ -n $cmd_alias ]] && [[ "${cmd_alias:0:1}" != "." ]]; then
      echo "\e[1;34m❯ ${cmd_alias}\e[0m"
    fi
  fi
}

pre_validation() {
  [[ $# -eq 0 ]] && return
  expand_command_line "$@"
}

autoload -U add-zsh-hook
add-zsh-hook preexec pre_validation

# Enable command auto-correction
ENABLE_CORRECTION="true"

# Update automatically
# DISABLE_UPDATE_PROMPT=true

# P10k prompt
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

# Load zsh plugins with Antibody
source $ZDOTDIR/.zsh_plugins.sh

# Loading fzf
[ -f $ZDOTDIR/.fzf.zsh ] && source $ZDOTDIR/.fzf.zsh

# Expand alias on enter
#expand_alias_on_accept(){
#  local word=${${(Az)LBUFFER}[-1]}
#  zle _expand_alias
#  zle expand-word
#  zle accept-line
#}

#zle -N expand_alias_on_accept
#bindkey "^M" expand_alias_on_accept

# Vs code integration
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  POWERLEVEL9K_TERM_SHELL_INTEGRATION=true
fi

#Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Optimizing auto-completion
autoload -Uz compinit
for dump in $ZDOTDIR/.zcompdump(N.mh+24); do
  compinit
done


