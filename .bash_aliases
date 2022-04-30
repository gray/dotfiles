alias bc='bc -lq'
alias df='df -h'
alias du='du -h'
alias exip='curl -o - -s icanhazip.com || curl -o - -s ifconfig.me/ip'
alias flexget='LC_ALL=en_US.utf8 flexget'
alias grep='grep --color=auto --devices=skip --binary-files=without-match'
alias la="ls $LS_OPTIONS -FA"
alias ll="ls $LS_OPTIONS -Flh"
alias lla="ls $LS_OPTIONS -FlhA"
alias llc="ls $LS_OPTIONS -Flhtrc"
alias llca="ls $LS_OPTIONS -FlhtrcA"
alias lls="ls $LS_OPTIONS -FlhSr"
alias llsa="ls $LS_OPTIONS -FlhSrA"
alias llt="ls $LS_OPTIONS -Flhtr"
alias llta="ls $LS_OPTIONS -FlhtrA"
alias ls="ls $LS_OPTIONS -F"
alias man='LANG=C man'
alias qdf='qpdf --qdf --object-streams=disable'
alias sane='printf "\033v\033o\n"'
alias sqlite=sqlite3
alias udiff='LC_ALL=C TZ=UTC0 diff -Naur'
alias urls='lynx -listonly -nonumbers -dump'
alias vi=vim
alias vim='vim -X'

- () { cd -; }
.. () {
    local d; eval printf -v d '%*s' "${1-1}"
    [ -n "$d" ] && cd ${d// /../}
}

dict () { command dict "$@" | $PAGER; }

mkcd () { mkdir -p "$1" && cd "$1"; }
mktd () { local d=$(mktemp -d ${TMPDIR:-/tmp}/tmp.XXXXXXXXXX) && cd $d; }
mktouch () { mkdir -p "${1%/*}" && touch "$1"; }
yes () { [ 0 -eq $# ] && y=y || y="$*"; command yes "$y"; }

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

        mdl () {
            [ 0 -lt $# ] || return
            mdfind NOT kind:folder -name $(echo "$*" | tr ._ ' ') | sort
        }
        mdl0 () {
            [ 0 -lt $# ] || return
            mdfind NOT kind:folder -0 -name $(echo "$*" | tr ._ ' ')
        }
        mdll () { mdl0 "$*" | sort -z | xargs -0 ls -ld; }
        mdlo () { mdl0 "$*" | xargs -0 open; }
        ;;
    *)
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
esac

