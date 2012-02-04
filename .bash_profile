DEFAULT_PATH=$PATH
PATH=$HOME/bin:$HOME/local/bin
PATH=$PATH:$HOME/local/perlbrew/perls/latest/bin
PATH=$PATH:/opt/local/bin:/opt/local/sbin
PATH=$PATH:/usr/local/bin:/usr/local/sbin:/bin
PATH=$PATH:$DEFAULT_PATH
export PATH

umask 0022

# Prevent C-s from accidentally freezing the terminal.
[[ -t 0 ]] && stty ixany

case $OSTYPE in
    darwin*)
        # XCode 4 no longer supports PPC.
        export ARCHFLAGS='-arch i386 -arch x86_64'

        # Prevent tar from copying resource forks.
        export COPY_EXTENDED_ATTRIBUTES_DISABLE=1
        export COPYFILE_DISABLE=1
esac

# Interactive shell.
[[ "$PS1" && -f ~/.bashrc ]] && source ~/.bashrc
