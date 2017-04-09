#!/bin/sh

# This script is called by aria2c when a download completes..
#
# The following arguments are passed to the script:
#     GID
#     file count
#     file path

PATH=$HOME/bin:$HOME/local/bin:/opt/local/bin:/usr/local/bin:/usr/bin:/bin

set -o errexit
set -o nounset

path=$3

[ 0 -ge $2 ] && exit 0

has_cmd () { command -v "$@" >/dev/null 2>&1; }

# Mark files a different color in Finder to indicate they are finished
# seeding and can safely be deleted.
case $OSTYPE in
    darwin*)
        # 10.9 allows multiple tags; don't clear other tags when adding.
        if has_cmd tag; then
            hilite () { tag --descend --add red "$@" 2>/dev/null 2>&1; }
        else
            attr=0000000000000000000C00000000000000000000000000000000000000000000
            hilite () {
                xattr -r -wx com.apple.FinderInfo $attr "$@" 2>/dev/null 2>&1
            }
        fi
        ;;
    *) hilite () { :; }
esac

! hilite "$path"

if has_cmd growlnotify; then
    name=${path##*/}
    growlnotify -t aria2c -m "Finished downloading $name" \
        >/dev/null 2>&1
fi
