#!/bin/bash
dmidecode -t system | grep -q amazon && CLOUD='aws'
if [ "$CLOUD" = "aws" ] ;then
	AZ="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)"	
fi
test -n "$CLOUD" && location="{ $CLOUD $AZ } "
colmin="$(echo -n "$location 00:11:22" | wc -c)"

export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTIGNORE=ls:w:pwd:history:man:rm:shutdown:reboot:halt
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='[%y-%m-%d %H:%M:%S] '
export PS1='$(if [[ $? == 0 ]]; then echo "\[\e[1;32m\]"; else echo "\[\e[1;31m\]"; fi)$location$(printf "%*s" $(($(tput cols)-$colmin)) "" | sed "s/ /-/g") \t\n\[\e[0;37m\][\[\e[0;36m\]\u@\h\[\e[0;38m\] \w]\$ '
export EDITOR=vim

#whoami="$(whoami)@$(echo $SSH_CONNECTION | awk '{print $1}')"
#export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "CMDRUN $whoami [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'

alias sc=systemctl
source /usr/share/bash-completion/completions/systemctl
alias jc=journalctl
source /usr/share/bash-completion/completions/journalctl
