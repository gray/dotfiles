if [[ 1 = "$SHLVL" ]]; then
    DEFAULT_PATH=$PATH
    PATH=$HOME/bin:$HOME/local/bin
    PATH=$PATH:$HOME/local/perlbrew/perls/latest/bin
    PATH=$PATH:$HOME/local/go/bin
    PATH=$PATH:/opt/local/bin:/opt/local/sbin
    PATH=$PATH:/usr/local/bin:/usr/local/sbin:/bin
    PATH=$PATH:$DEFAULT_PATH
    export PATH
fi

ulimit -n 8192
umask 0022

case $OSTYPE in
    darwin*)
        # XCode 4 no longer supports PPC.
        export ARCHFLAGS='-arch i386 -arch x86_64'

        # Prevent tar from copying resource forks.
        export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
        export COPYFILE_DISABLE=1
esac

# Allow only interactive shells.
[[ -z $PS1 ]] && return

# Prevent C-s from accidentally freezing the terminal.
[[ -t 0 ]] && stty ixany

shopt -s no_empty_cmd_completion
shopt -s checkwinsize  # Update windows size after each command.
shopt -s cmdhist       # Store multiline commands as a single entry.
shopt -s cdspell       # Allow minor mispellings.
shopt -s histappend    # Append history from all running bash processes.
shopt -s histreedit    # Reedit a history substitution line upon failure.
shopt -s histverify    # Edit a recalled history line before executing.
set -o ignoreeof       # Prevent accidental exiting of shell via C-d.

PROMPT_COMMAND='history -a; history -c; history -r;'

HISTCONTROL=ignoredups:erasedups
HISTIGNORE='?:??:pwd:.. *:jobs:history:clear:exit:ll[a.c]:llc[a.]'
HISTIGNORE=$HISTIGNORE':*password=*:*PASSWORD=*'
HISTSIZE=20000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT='[%F %T] '

FIGNORE='~:.a:.class:.la:.mo:.o:.obj:.pyc:.pyo:.so:.swo:.swp'

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
    for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
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

export GREP_COLOR='33;44'

if ls --version >/dev/null 2>&1; then
    # GNU
    LS_OPTIONS='--color=auto --time-style="+%b %d %T %Y"'
    LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;'
    export LS_COLORS=$LS_COLORS'43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
else
    # BSD
    LS_OPTIONS='-GT'
    export LSCOLORS=gxfxcxdxbxegedabagacad
fi

export PERL5LIB=$HOME/local/perl5
export PERLBREW_ROOT=$HOME/local/perlbrew
export PERL_CPANM_OPT='-q'
# groff bug converts some characters to utf-8.
export PERLDOC='-n"nroff -Tascii"'

export GOPATH=$HOME/local/go

for f in            \
    ~/.bash_prompt  \
    ~/.bash_aliases \
    ~/local/perlbrew/etc/bashrc
do
    [[ -f $f ]] && source $f
done
