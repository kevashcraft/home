#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ -f ~/.bash_aliases ]]; then
  . ~/.bash_aliases
fi

if [[ -f ~/.bash_functions ]]; then
  . ~/.bash_functions
fi

if [[ -f ~/.kevin/bashrc ]]; then
  . ~/.kevin/bashrc
fi

alias ls='ls --color=auto'

export VISUAL=vim
export EDITOR="$VISUAL"

PATH=$PATH:~/bin:~/.gem/ruby/2.2.0/bin:/BPConnect/bin:$(ruby -e 'print Gem.user_dir')/bin

# Git branch PS1
#PS1='[\u@\h \W]\$ '
source /usr/share/git/completion/git-prompt.sh
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

