# Do nothing if the shell is non-interactive.
[ -z "$PS1" ] && return

# TODO: add time, add exit status and running time of last command
PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h:\[\e[33m\]\w\[\e[0m\]\n[\!]\$ '

# Only add to $PATH the first time this file is sourced.
if [ -z "$ETC_PATH" ] && [ ${ETC_PATH-_} ]; then
    ETC_PATH=$PATH
    PATH=$HOME/bin:$HOME/local/bin
    PATH=$PATH:/opt/local/bin:/opt/local/sbin
    PATH=$PATH:/usr/local/bin:/usr/local/sbin:/bin
    PATH=$PATH:$ETC_PATH
    export PATH
fi

shopt -s no_empty_cmd_completion
shopt -s checkwinsize  # Update windows size after each command.
shopt -s cmdhist       # Store multiline commands as a single entry.
shopt -s cdspell       # Allow minor mispellings.
shopt -s histappend    # Append history from all running bash processes.
shopt -s histreedit    # Reedit a history substitution line upon failure.
shopt -s histverify    # Edit a recalled history line before executing.
set -o ignoreeof       # Prevent accidental exiting of shell via C-d.

umask 0022

# Prevent C-s from accidentally freezing the terminal.
[ -t 0 ] && stty ixany

PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

HISTCONTROL=ignoreboth:erasedups
HISTIGNORE=' *:&:?:??:pwd:-:.. *:jobs:history:clear:exit'
HISTIGNORE=$HISTIGNORE':ll[a.c]:llc[a.]:*password=*:*PASSWORD=*'
HISTSIZE=20000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT='[%F %T] '

FIGNORE=~:.a:.class:.la:.mo:.o:.obj:.pyc:.pyo:.so:.swo:.swp

# Not always exported.
export LINES COLUMNS

export EDITOR=vim
export VISUAL=$EDITOR

export PAGER=less
export LESS='-~iFMQRWX'
export LESSHISTFILE=/dev/null

ANSI_RESET=$(tput sgr0)
ANSI_BOLD=$(tput bold)
ANSI_BLINK=$(tput blink)
ANSI_REVERSE=$(tput rev)
ANSI_UNDERLINE=$(tput smul)
for c in 'BLACK 0' 'RED 1' 'GREEN 2' 'BLUE 4' 'MAGENTA 5' 'CYAN 6' 'WHITE 7';
do
    set -- $c
    eval ANSI_$1=$(tput setaf $2) ANSI_BG_$1=$(tput setab $2)
done

# Less colors for man pages.
export LESS_TERMCAP_mb=${ANSI_BOLD}${ANSI_RED}
export LESS_TERMCAP_md=${ANSI_BOLD}${ANSI_RED}
export LESS_TERMCAP_me=$ANSI_RESET
export LESS_TERMCAP_so=${ANSI_YELLOW}${ANSI_BG_BLUE}
export LESS_TERMCAP_se=$ANSI_RESET
export LESS_TERMCAP_ue=$ANSI_RESET
export LESS_TERMCAP_us=${ANSI_BOLD}${ANSI_GREEN}

export GREP_OPTIONS='--color=auto --devices=skip'
export GREP_COLOR='33;44'

ls --version >/dev/null 2>&1
if [ $? ]; then
    # BSD
    LS_OPTIONS='-GT'
    export LSCOLORS=gxfxcxdxbxegedabagacad
else
    # GNU
    LS_OPTIONS='--color=auto --time-style="+%b %d %T %Y"'
    LSCOLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;'
    LSCOLORS=$LSCOLORS'43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
    export LSCOLORS
fi

case $OSTYPE in
    darwin*)
        # XCode 4 no longer supports PPC.
        export ARCHFLAGS='-arch i386 -arch x86_64'

        # Prevent tar from copying resource forks.
        export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
        export COPYFILE_DISABLE=1
esac

export PERL_CPANM_OPT='-q'

[ -f ~/.bash_aliases ] && source ~/.bash_aliases

[ -f ~/local/perlbrew/etc/bashrc ] && source ~/local/perlbrew/etc/bashrc
