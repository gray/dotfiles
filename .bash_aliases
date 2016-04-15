alias sane='printf "\033v\033o\n"'
alias c=clear
alias h=history

alias ls="ls $LS_OPTIONS -F"
alias la="ls $LS_OPTIONS -FA"
alias ll="ls $LS_OPTIONS -Flh"
alias lla="ls $LS_OPTIONS -FlhA"
alias llc="ls $LS_OPTIONS -Flhtrc"
alias llca="ls $LS_OPTIONS -FlhtrcA"
alias llt="ls $LS_OPTIONS -Flhtr"
alias llta="ls $LS_OPTIONS -FlhtrA"
alias lls="ls $LS_OPTIONS -FlhSr"
alias llsa="ls $LS_OPTIONS -FlhSrA"

alias grep='grep --color=auto --devices=skip --binary-files=without-match'

# Don't try to connect to the X server- shortens startup time.
alias vim='vim -X'
alias vi=vim

# Use human-readable unit sizes, in base 2.
alias df='df -h'
alias du='du -h'

# Normalize diff output for patches.
alias diff='LC_ALL=C TZ=UTC0 diff -Naur'

# Don't print welcome message; load math library so scale is set to 20.
alias bc='bc -lq'

alias wget='wget --continue --no-check-certificate'

# Download magnet links as torrent files.
alias magnet='aria2c -q --bt-metadata-only --bt-save-metadata'

# Get external IP address.
alias xip='curl -o - -s icanhazip.com || curl -o - -s ifconfig.me/ip'

# groff bug converts some characters to utf-8.
alias man='LANG=C man'

alias sqlite=sqlite3

perldoc () {
    if hash cpandoc 2>/dev/null; then
        cpandoc "$@"
    else
        echo 'Install Pod::Cpandoc'
        command perldoc "$@"
    fi
}

case $OSTYPE in
    darwin*)
        alias gvim=mvim
        ;;
    *)
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
esac

- () { cd -; }

# ..   -> cd ..
# .. 3 -> cd ../../..
.. () {
    local arg=${1:-1};
    while [ $arg -gt 0 ]; do
        cd .. >/dev/null 2>&1
        arg=$(($arg - 1))
    done
}

mkcd () { mkdir -p "$1" && cd "$1"; }
mktd () { local d=$(mktemp -d ${TMPDIR:-/tmp}/tmp.XXXXXXXXXX) && cd $d; }
mktouch () { mkdir -p "${1%/*}" && touch "$1"; }

# Print active network interfaces.
upifs () {
    perl -MSys::HostIP=interfaces -e \
        'print "$_\n" for grep !/^lo0?/, keys %{interfaces()}'
}

logurls () {
    local ifs=$(upifs)
    [[ -n $ifs ]] || return
    set -- $ifs
    sudo urlsnarf -i $1 -v '\.(gif|jpe?g|png|css|js|ico)( |\?|%22)' \
        | tee -a /tmp/urls.log
}

ansi_colors () {
    local attr
    for attr in 0 1 4 5 7; do
        echo "----------------------------------------------------------------"
        printf "ESC[%s;fgcolor;bgcolor :\n" $attr
        local fg
        for fg in 30 31 32 33 34 35 36 37 39; do
            local bg
            for bg in 40 41 42 43 44 45 46 47; do
                printf '\033[%s;%s;%sm %02s;%02s  ' $attr $fg $bg $fg $bg
            done
            printf '\n'
        done
        printf '\033[0m'
    done
}
