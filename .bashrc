# Do nothing if the shell is non-interactive.
[[ -z $PS1 ]] && return

# Prevent $PATH from growing every time this file is sourced.
SYSTEM_PATH=${SYSTEM_PATH:-$PATH}
PATH=$HOME/bin:$HOME/local/bin
PATH=$PATH:/opt/local/bin:/opt/local/sbin
PATH=$PATH:/usr/local/bin:/usr/local/sbin:/bin
PATH=$PATH:$SYSTEM_PATH
export PATH

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
[[ -t 0 ]] && stty ixany

PROMPT_COMMAND='history -a; history -c; history -r;'

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
export LESS='-~iFMQRX'
export LESSHISTFILE=/dev/null

init_ansi_colors () {
    ANSI_RESET=$(tput sgr0)
    ANSI_BOLD=$(tput bold)
    ANSI_BLINK=$(tput blink)
    ANSI_REVERSE=$(tput rev)
    ANSI_UNDERLINE=$(tput smul)

    local color counter=0
    for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE;
    do
        eval ANSI_$color=$(tput setaf $counter)
        eval ANSI_BG_$color=$(tput setab $counter)
        counter=$((counter+1))
    done
}
init_ansi_colors
unset init_ansi_colors

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
if [[ $? ]]; then
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

for f in            \
    ~/.bash_prompt  \
    ~/.bash_aliases \
    ~/local/perlbrew/etc/bashrc
do
    [[ -f $f ]] && source $f
done
