### Configure terminal -- rxvt
# how to detect RXVT?

# numblock keys !
if [ "$TERM" = rxvt ]
then
    # only if Under rxvt!
    echo -ne '\e[?66l'
    # (control) backspace is control-h or control-?
    # rxvt backspace:
    echo -ne '\e[?67h'
fi

# Configure (kernel) PTY, how Shell should keep it:
ttyctl -u
# CHAR will redraw the current line
stty rprnt '^T'
# freeze back:
ttyctl -f

### I want C-s to search, not stop !!!
unsetopt FLOW_CONTROL


# echo -n "/etc/zsh/zshrc"
# for compatibility w/ bash:
# problem on Debian:
if [ -z "$MODULE_PATH" ];
then
    MODULE_PATH=/usr/lib/zsh/${ZSH_VERSION}/
fi

: ${MYZSHDIR=/usr/share/zsh/site-functions/}
source ${MYZSHDIR}/functions


#### Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Where to look for autoloaded function definitions
# But I want it at the beginning!
fpath=(~/.zfunc $fpath)
# Prefer my site-functions:
after=/usr/share/zsh/functions/Misc
before=/usr/share/zsh/site-functions/Misc

index=${fpath[(i)$after]}
index2=${fpath[(i)$before]}

# echo "indices $index $index2"
if (( index < index2 ))
then
    fpath[$index]=$before
    fpath[$index2]=$after
fi

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# manpath=($X11HOME/man /usr/man /usr/lang/man /usr/local/man)
# export MANPATH

### History before profile!
HISTFILE=~/.zsh_history/$HOST$(echo $TTY| sed -e 's/\//_/g')
typeset HISTSIZE=20000
# HISTFILE=~/.history
# history related stuff.
export SAVEHIST=5000
# export HISTFILE=~/.zsh_history
setopt hist_ignore_dups        # ignore same commands run twice+

# 2003-06-29
setopt nohistbeep
setopt cshjunkiehistory
setopt extendedhistory
setopt histverify              # when using ! cmds, confirm first

setopt appendhistory           # don't overwrite history
setopt incappendhistory
#export HISTIGNORE=\&
setopt EXTENDED_HISTORY
#typeset EXTENDED_HISTORY=1


# only now I'm ready!
# but beware: this sets prompt PS1...
possibly_source /etc/profile

###  Special (zsh) functions
## Period ... update
PERIOD=60
# but I have periodic in ./functions/functions !
# function periodic (){
# #    echo "running periodic"
# #    ali   #  this is an alias !!!
#     rehash -f
# }


### Prompt && title etc.
source  ${MYZSHDIR}/title
source  ${MYZSHDIR}/prompt

# Some environment variables

# mmc: problems:
# export LESS=-cex3M
# export HELPDIR=/usr/local/lib/zsh/help  # directory for run-help function to find docs

DIRSTACKSIZE=20

# Set/unset  shell options
setopt  correct autocd autopushd histignoredups noclobber pushdsilent cdablevars
setopt  promptcr
unsetopt AUTO_REMOVE_SLASH
# globdots:   * != .*
# notify  pushdtohome  autolist
# setopt  correctall  recexact longlistjobs
# setopt  autoresume
# setopt  pushdminus extendedglob rcquotes mailwarning
# unsetopt bgnice autoparamslash


# now, or after compinit?
source $MYZSHDIR/keybindings


# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit
compinit

### Completion Styles
source $MYZSHDIR/completion-styles


### line editing:
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'




source ${MYZSHDIR}/zsh-alias
source ${MYZSHDIR}/space_separated

### MISC:
#  core dump
ulimit -c unlimited

#ZBEEB='\e[?5h\e[?5l'
ZBEEB='\e[?5l\e[?5h'

setopt BEEP
setopt LIST_BEEP

zle -C all-matches complete-word _generic
zle -C match-word complete-word _generic

source ${MYZSHDIR}/background
source ${MYZSHDIR}/load_buffer
source ${MYZSHDIR}/fcd

#  [16 dic 03] from ~/...

# complete after alias
#setopt nocompletealiases

## run for Every _interactive_  Zsh session

### The following lines were added by compinstall
_compdir=/usr/share/zsh/functions/Core
[[ -z $fpath[(r)$_compdir] ]] && fpath=($fpath $_compdir)

# End of lines added by compinstall

# told from info:
autoload -U compinstall

setopt AUTO_PUSHD

### test alias/function
cvsrm(){
    file=$1
    rm $file
    cvs rm $file
}


### demian
# .zshrc - customisations for the all-powerful shell
#
# the latest copy of this file can be found at
#   http://repose.cx/conf

typeset -U path
# path=(~/.bin ~/Muse /sbin /usr/sbin $path)

typeset -U cdpath
cdpath=(. $cdpath)

#setopt nobeep                  # i hate beeps
#setopt noautomenu              # don't cycle completions
setopt autocd                  # change to dirs without cd

#setopt autopushd               # automatically append dirs to the push/pop list
setopt pushdignoredups         # and don't duplicate them
setopt cdablevars              # avoid the need for an explicit $

# setopt nocheckjobs             # don't warn me about bg processes when exiting
# setopt nohup                   # and don't kill them, either

setopt listpacked              # compact completion lists
setopt nolisttypes             # show types in completion
# setopt dvorak                  # with spelling correction, assume dvorak kb

setopt extendedglob            # weird & wacky pattern matching - yay zsh!

setopt nonullglob # better failures (in big directories)
# mmc: i don't want the failures ...

setopt completeinword          # not just at the end
setopt alwaystoend             # when complete from middle, move cursor
setopt correct                 # spelling correction
setopt nopromptcr              # don't add \n which overwrites cmds with no \n
setopt interactivecomments     # escape commands so i can use them later
setopt printexitvalue          # alert me if something's failed

# woo! so glad i found this. jump to each element in a path with m-f m-b, same
# for kill-word, etc.
export WORDCHARS=''

# this is defined in ~/.bin/e now
#
# i have gnuclient set to load files in my current emacs buffer, so i'd like to
# jump to it afterwards. i use a program "e" to edit files in this manner.
# e() {
#     sawfish-client -f de-gnuserv-activate > /dev/null
#     # now run gnuclient. we'll be returned to this window when c-x # is hit in
#     # emacs
#     gnuclient $1
# }

# export CVSROOT=~/CVS

source $MYZSHDIR/help-functions

# -k -z  ksh-style: (evaluate)
autoload -z zload-file

# For Sawfish WM:
wid_asigned=n
# precmd
assign_wid_maybe()
{
    # match .. prints... either position?  or the matched string!
    if [ $wid_asigned != y -a  "$(expr match $PWD  ".*\(mp3\|youtube\)")" != "" ];
    then
        wid_asigned=y
        if [ -n "${WINDOWID-}" ]; then
            sawfish-client -e "(bind-wid-to-window \"s\" (get-window-by-id $WINDOWID))"
        fi
    fi
}
typeset -a chpwd_functions
chpwd_functions+=(assign_wid_maybe)

possibly_source $MYZSHDIR/task
possibly_source $MYZSHDIR/user-functions

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# builtin:
zle_highlight=("isearch:bold,fg=40,underline" "region=:bold,bg=30")


reload_function()
{
    cecho red "reloading $1"
    unfunction $1
    autoload -U $1
}
