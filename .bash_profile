#
# ~/.bash_profile
#

eval $(keychain --eval --agents ssh -Q --quiet)

setleds +num

[[ -f ~/.bashrc ]] && . ~/.bashrc
