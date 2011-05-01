alias sane='printf "\033v\033o\n"'
alias c=clear
alias h=history

alias ls="ls $LS_OPTIONS -F"
alias la="ls $LS_OPTIONS -FA"
alias l.="ls $LS_OPTIONS -Fd $* .*"
alias ll="ls $LS_OPTIONS -Flh"
alias lla="ls $LS_OPTIONS -FlhA"
alias ll.="ls $LS_OPTIONS -Fd $* .*"
alias llc="ls $LS_OPTIONS -Flhtrc"
alias llca="ls $LS_OPTIONS -FlhtrcA"
alias llc.="ls $LS_OPTIONS -FlhtrcdA $* .*"

alias vim='vim -X'
alias vi=vim
alias df='df -h'
alias du='du -h'
alias diff='LC_ALL=C TZ=UTC0 diff -Naur'

alias bc='bc -lq'

alias wget='wget --continue --no-check-certificate'

alias xip="curl -o - -s http://checkip.dyndns.org/ \
    | grep -E -m 1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'"

case $OSTYPE in
    darwin*)
        alias gvim='open -a MacVim $*'

        # groff bug converts some characters to utf-8.
        alias man='LANG=C man'
        alias perldoc='LANG=C perldoc'
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

# Make and change to a directory.
md () { mkdir -p "$1" && cd "$1"; }

# Print active network interfaces.
upifs () {
    for iface in $(ifconfig -lu) ; do
        case $iface in
            lo*) continue ;;
        esac
        ifconfig $iface | grep -q 'status: active' && echo $iface
    done
}

logurls () {
    ifs=$(upifs)
    [ "$ifs" ] || return
    set -- $ifs
    sudo urlsnarf -i $1 -v '\.(gif|jpe?g|png|css|js|ico)( |\?|%22)' \
        | tee -a /tmp/urls
}
