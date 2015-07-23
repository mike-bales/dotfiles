module () {  eval `/usr/bin/modulecmd bash $*`
}
scl () {  local CMD=$1;
 if [ "$CMD" = "load" -o "$CMD" = "unload" ]; then
 eval "module $@";
 else
 /usr/bin/scl "$@";
 fi
}
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
if [ -z "$PS1" ]; then
    return
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


case "$TERM" in
    xterm-color)
        color_prompt=yes
        ;;
    *)
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            # We have color support; assume it's compliant with Ecma-48
            # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
            # a case would tend to support setf rather than setaf.)
            color_prompt=yes
        else
            color_prompt=
        fi
        ;;
esac


# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

#TODO: set this on load


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

#
### load the dotfiles
#  ln -s ${WORKON_HOME}/dotfiles/src/dotfiles ~/.dotfiles
__DOTFILES=${__DOTFILES:-"$HOME/-dotfiles"}
if [ -n $__DOTFILES ] && [ -d $__DOTFILES ]; then
    _dotfiles_bashrc="${__DOTFILES}/etc/bash/00-bashrc.before.sh"
    if [[ -f "${_dotfiles_bashrc}" ]]; then
        source "${_dotfiles_bashrc}"
    else
        echo "ERROR: _dotfiles_bashrc: ${_dotfiles_bashrc}"
    fi
fi
#!/bin/bash
## 00-bashrc.before.sh     -- bash dotfiles configuration root
#  source ${__DOTFILES}/etc/bash/00-bashrc.before.sh    -- dotfiles_reload()
#
dotfiles_reload() {
  #  dotfiles_reload()  -- (re)load the bash configuration
  #  $__DOTFILES (str): -- path to the dotfiles symlink (~/-dotfiles)

  echo "#"
  echo "# dotfiles_reload()"

  export __WRK="${HOME}/-wrk"

  if [ -n $__DOTFILES ]; then
    export __DOTFILES=${__DOTFILES}
  else
    _dotfiles_src=${WORKON_HOME}/dotfiles/src/dotfiles
    _dotfiles_link=${HOME}/-dotfiles

    if [ -d $_dotfiles_link ]; then
        __DOTFILES=${_dotfiles_link}
    elif [ -d $_dotfiles_src ]; then
        __DOTFILES=${_dotfiles_src}
    fi
    export __DOTFILES=${__DOTFILES}
  fi

  conf=${__DOTFILES}/etc/bash

  #
  ## 01-bashrc.lib.sh           -- useful bash functions (paths)
  #  lspath()           -- list every file along $PATH
  #  realpath()         -- readlink -f (python os.path.realpath)
  #  walkpath()         -- list every directory along ${1:-"."}
  source ${conf}/01-bashrc.lib.sh

  #
  ## 02-bashrc.platform.sh      -- platform things
  source ${conf}/02-bashrc.platform.sh
  detect_platform
  #  detect_platform()  -- set $__IS_MAC or $__IS_LINUX
  if [ -n "${__IS_MAC}" ]; then
      export PATH=$(echo ${PATH} | sed 's,/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin,/usr/sbin:/sbin:/bin:/usr/local/bin:/usr/bin,')

  ## 03-bashrc.darwin.sh
      source ${conf}/03-bashrc.darwin.sh
  fi

  #
  ## 04-bashrc.TERM.sh          -- set $TERM and $CLICOLOR
  source ${conf}/04-bashrc.TERM.sh

  #
  ## 05-bashrc.dotfiles.sh      -- dotfiles
  #  $__DOTFILES (str): -- path to the dotfiles symlink (~/.dotfiles)
  #  dotfiles_status()  -- print dotfiles variables
  #  ds()               -- print dotfiles variables
  source ${conf}/05-bashrc.dotfiles.sh
  dotfiles_add_path

  #
  ## 06-bashrc.completion.sh    -- configure bash completion
  source ${conf}/06-bashrc.completion.sh

  #
  ##
  #  virtualenvwrapper / virtualenv / venv constants
  #
  #  $PROJECT_HOME (str): path to project directory (~/-wrk)
  #  $WORKON_HOME  (str): path to virtualenvs directory (~/-wrk/-ve27)
  #  $VIRTUAL_ENV  (str): path to current $VIRTUAL_ENV ($WORKON_HOME/$VENVSTR)

  #
  ## 07-bashrc.python.sh            -- python
  #  _setup_python()              -- configure PYTHONSTARTUP
  #  _setup_pip()                 -- configure PIP_REQUIRE_VIRTUALENV
  #  _setup_pyenv()               -- setup pyenv PYENV_ROOT and eval (manual)
  source ${conf}/07-bashrc.python.sh

  #
  ## 08-bashrc.conda.sh             -- conda
  #  _setup_conda()               -- setup conda paths (manual)
  #                                  WORKON_HOME=CONDA_ENVS_PATH
  #    $1 (str): (optional) CONDA_ENVS_PATH (WORKON_HOME)
  #    $2 (str): (optional) CONDA_ROOT_PATH (or '27' or '34')
  #  $CONDA_ROOT      (str): path to conda install (~/-wrk/-conda34)
  #  $CONDA_ENVS_PATH (str): path to condaenvs directory (~/-wrk/-ce34) [conda]
  source ${conf}/08-bashrc.conda.sh

  #
  ## 07-bashrc.virtualenvwrapper.sh -- virtualenvwrapper
  #  _setup_virtualenvwrapper     -- configure virtualenvwrapper
  #  backup_virtualenv($VENVSTR)  -- backup a venv in WORKON_HOME
  #                                  $WORKON_HOME/$VENVSTR -> ./-bkp/$VENVSTR
  #  backup_virtualenvs()         -- backup all venvs in WORKON_HOME
  #                                  $WORKON_HOME/*        -> ./-bkp/*
  #  rebuild_virtualenv($VENVSTR) -- rebuild $WORKON_HOME/$VENVSTR
  #  rebuild_virtualenvs()        -- rebuild $WORKON_HOME/*
  #  TODO: restore_virtualenv($BACKUPVENVSTR, [$NEWVENVSTR])
  source ${conf}/07-bashrc.virtualenvwrapper.sh

  #
  ## 08-bashrc.gcloud.sh        -- gcloud: Google Cloud SDK
  #  _setup_google_cloud()  -- setup google cloud paths
  source ${conf}/08-bashrc.gcloud.sh

  #
  ## 10-bashrc.venv.sh          -- venv: virtualenvwrapper extensions
  #  _setup_venv()
  #  $__PROJECTSRC     (str): script to source (${PROJECT_HOME}/.projectsrc.sh)
  #  $VIRTUAL_ENV_NAME (str): basename of $VIRTUAL_ENV [usrlog: prompt, title]
  #  $_APP             (str): $VIRTUAL_ENV/src/${_APP}
  #  we() -- workon a new venv
  #     $1: VIRTUAL_ENV_NAME [$WORKON_HOME/${VIRTUAL_ENV_NAME}=>$VIRTUAL_ENV]
  #     $2: _APP (optional; defaults to $VIRTUAL_ENV_NAME)
  #
  #     we dotfiles
  #     we dotfiles etc/bash; cdw; ds; # ls -altr; lll; cd ~; ew etc/bash/*.sh
  #     type workon_venv; which venv.py; venv.py --help
  source ${conf}/10-bashrc.venv.sh
  #

  #
  ## 11-bashrc.venv.pyramid.sh  -- venv-pyramid: pyramid-specific config
  source ${conf}/11-bashrc.venv.pyramid.sh

  #
  ## 20-bashrc.editor.sh        -- $EDITOR configuration
  #  $EDITOR  (str): cmdstring to open $@ (file list) in editor
  #  $EDITOR_ (str): cmdstring to open $@ (file list) in current editor
  #  e()        -- open paths in current EDITOR_                   [scripts/e]
  #  ew()       -- open paths relative to $_WRD in current EDITOR_ [scripts/ew]
  #                (~ cd $_WRD; $EDITOR_ ${@}) + tab completion
  source ${conf}/20-bashrc.editor.sh
  #
  ## 20-bashrc.vimpagers.sh     -- $PAGER configuration
  #  $PAGER   (str): cmdstring to run pager (less/vim)
  #  lessv()    -- open in vim with less.vim
  #                VIMPAGER_SYNTAX="python" lessv
  #  lessg()    -- open in a gvim with less.vim
  #                VIMPAGER_SYNTAX="python" lessv
  #  lesse()    -- open with $EDITOR_
  source ${conf}/29-bashrc.vimpagers.sh

  #
  ## 30-bashrc.usrlog.sh        -- $_USRLOG configuration
  #  _setup_usrlog()    -- configure usrlog
  #  $_USRLOG (str): path to a -usrlog.log command log
  #                __USRLOG=~/-usrlog.log
  #                 _USRLOG=${VIRTUAL_ENV}/-usrlog.log
  #  lsusrlogs  -- ls -tr   "${__USRLOG}" "${WORKON_HOME}/*/-usrlog.log"
  #  stid       -- set $TERM_ID to a random string (e.g. "#Yt0PyyKWPro")
  #  stid $name -- set $TERM_ID to string (e.g. \#20150704, "#20150704")
  #  note       -- log a #note to $_USRLOG (histn==#note)
  #  todo       -- log a #todo to $_USRLOG (histn==#todo)
  #  usrlogv    -- open usrlog with vim:    $VIMBIN    $_USRLOG
  #  usrlogg    -- open usrlog with gmvim:  $GUIVIMBIN $_USRLOG
  #  usrloge    -- open usrlog with editor: $EDITOR    $_USRLOG
  #  ut         -- tail -n__ $_USRLOG [ #BUG workaround: see venv.py]
  #  ug         -- egrep current usrlog: egrep $@ $_USRLOG
  #  ugall      -- egrep all usrlogs [ #BUG workaround: see venv.py ]
  #                     egrep $@ "${__USRLOG}" "${WORKON_HOME}/*/-usrlog.log"
  #  ugrin      -- grin current usrlog: grin $@ ${_USRLOG}
  #  ugrinall   -- grin $@  "${__USRLOG}" "${WORKON_HOME}/*/-usrlog.log"
  source ${conf}/30-bashrc.usrlog.sh

  #
  ## 30-bashrc.xlck.sh          -- screensaver, (auto) lock, suspend
  #  _setup_xlck()      -- configure xlck
  source ${conf}/30-bashrc.xlck.sh

  #
  ## 40-bashrc.aliases.sh       -- aliases
  #  _setup_venv_aliases()  -- source in e, ew, makew, ssv, hgw, gitw
  #    _setup_supervisord() -- configure _SVCFG
  #       $1 (str): path to a supervisord.conf file "${1:-${_SVCFG}"
  source ${conf}/40-bashrc.aliases.sh
  ## 42-bashrc.commands.sh      -- example commands
  source ${conf}/42-bashrc.commands.sh

  #
  ## 50-bashrc.bashmarks.sh     -- bashmarks: local bookmarks
  source ${conf}/50-bashrc.bashmarks.sh

  #
  ## 70-bashrc.repos.sh         -- repos: $__SRC repos, docs
  source ${conf}/70-bashrc.repos.sh

  #
  ## 99-bashrc.after.sh         -- after: cleanup
  source ${conf}/99-bashrc.after.sh
}

dr() {
    # dr()  -- dotfiles_reload
    dotfiles_reload $@
}
    # ds()  -- print dotfiles_status()

dotfiles_main() {
    dotfiles_reload
}

dotfiles_main
#
# dotfiles_reload()

### bashrc.lib.sh


## bash

#__THIS=$(readlink -e "$0")
#__THISDIR=$(dirname "${__THIS}")

echo_args() {
    # echo_args         -- echo $@ (for checking quoting)
    echo $@
}

function_exists() {
    # function_exists() -- check whether a bash function exists
    declare -f $1 > /dev/null
    return $?
}

PATH_prepend ()
{
  # PATH_prepend()     -- prepend a directory ($1) to $PATH
    #   instead of:
    #       export PATH=$dir:$PATH
    #       PATH_prepend $dir 
    #http://superuser.com/questions/ \
    #\ 39751/add-directory-to-path-if-its-not-already-there/39840#39840
    if [[ "$PATH" =~ (^|:)"${1}"(:|$) ]]; then
        return 0
    fi
    export PATH=${1}:${PATH}
}

PATH_remove() {
    # PATH_remove()  -- remove a directory from $PATH
    # note: empty path components ("::") will be stripped
    local _path=${1}
    _PATH=$(echo "${PATH}" | tr ':' '\n' \
      | grep -v '^$' \
      | grep -v "^${_path}$" \
      | tr '\n' ':')
    export PATH=${_PATH}
}

PATH_contains() {
    # PATH_contains() -- test whether $PATH contains $1
    local _path=${1}
    local _output=$(echo "${PATH}" | tr ':' '\n' \
      | grep "^${_path}$")
    if [ -z "${output}" ]; then
        return 1
    else
        echo "${output}"
    fi
}

lightpath() {
    # lightpath()       -- display $PATH with newlines
    echo ''
    echo $PATH | tr ':' '\n'
}

lspath() {
    # lspath()          -- list files in each directory in $PATH
    echo "# PATH=$PATH"
    lightpath | sed 's/\(.*\)/# \1/g'
    echo '#'
    cmd=${1:-'ls -ald'}
    for f in $(lightpath); do
        echo "# $f";
        ${cmd} $f/*;
        echo '#'
    done
}

lspath-less() {
    # lspath_less()     -- lspath with less (color)
    if [ -n "${__IS_MAC}" ]; then
        cmd=${1:-'ls -ald -G'}
    else
        cmd=${1:-'ls -ald --color=always'}
    fi
    lspath "${cmd}" | less -R
}

## file paths

realpath () {
    # realpath()        -- print absolute path (os.path.realpath) to $1
    #                      note: OSX does not have readlink -f
    python -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "${1}"
    return
}
path () {
    # path()            -- realpath()
    realpath ${1}
}


walkpath () {
    # walkpath()        -- walk down path $1 and $cmd each component
    #   $1: path (optional; default: pwd)
    #   $2: cmd  (optional; default: 'ls -ald --color=auto')
    #http://superuser.com/a/65076 
    dir=${1:-$(pwd)}
    if [ -n "${__IS_MAC}" ]; then
        cmd=${2:-"ls -ldaG"}
    else
        cmd=${2:-"ls -lda --color=auto"}
    fi
    dir=$(realpath ${dir})
    parts=$(echo ${dir} \
        | awk 'BEGIN{FS="/"}{for (i=1; i < NF+2; i++) print $i}')
    paths=('/')
    unset path
    for part in $parts; do
        path="$path/$part"
        paths=("${paths[@]}" $path)
    done
    ${cmd} ${paths[@]}
}


ensure_symlink() {
    # ensure_symlink()  -- create or update a symlink to $2 from $1
    #                      if $2 exists, backup with suffix $3
    _from=$1
    _to=$2
    _date=${3:-$(date +%FT%T%z)}  #  ISO8601 w/ tz
    if [ -s $_from ]; then
        _to_path=(realpath $_to)
        _from_path=(realpath $_from)
        if [ $_to_path == $_from_path ]; then
            printf "%s already points to %s" "$_from" "$_to"
        else
            printf "%s points to %s" "$_from" "$_to"
            mv -v ${_from} "${_from}.bkp.${_date}"
            ln -v -s ${_to} ${_from}
        fi
    else
        if [ -e ${_from} ]; then
            printf "%s exists" "${_from}"
            mv -v ${_from} "${_from}.bkp.${_date}"
            ln -v -s ${_to} ${_from}
        else
            ln -v -s $_to $_from
        fi
    fi
}

ensure_mkdir() {
    # ensure_mkdir()    -- create directory $1 if it does not yet exist
    path=$1
    test -d ${path} || mkdir -p ${path}
}

### bashrc.platform.sh

detect_platform() {
    # detect_platform() -- set $__IS_MAC or $__IS_LINUX according to $(uname)
    UNAME=$(uname)
    if [ ${UNAME} == "Darwin" ]; then
        export __IS_MAC='true'
    elif [ ${UNAME} == "Linux" ]; then
        export __IS_LINUX='true'
    fi
}

j() {
    # j()               -- jobs
    jobs
}

f() {
    # f()               -- fg %$1
    fg %${1}
}

b() {
    # b()               -- bg %$1
    bg %${1}
}

killjob() {
    # killjob()         -- kill %$1
    kill %${1}
}

### bashrc.TERM.sh

configure_TERM() {
    # configure_TERM            -- configure the $TERM variable (man terminfo)
    #   $1: (optional; autodetects if -z)
    term=$1
    if [ -n "${TERM}" ]; then
        __term=${TERM}
    fi
    if [ -n "${term}" ]; then
        export TERM="${term}"
    else
        if [ -n "${TMUX}" ] ; then
            #tmux
            export TERM="screen"
            configure_TERM_CLICOLOR
        elif [ -n "$(echo $TERMCAP | grep -q screen)" ]; then
            #screen
            export TERM="screen"
            configure_TERM_CLICOLOR
        elif [ -n "${ZSH_TMUX_TERM}" ]; then
            #zsh+tmux: oh-my-zsh/plugins/tmux/tmux.plugin.zsh
            export TERM="${ZSH_TMUX_TERM}"
            configure_TERM_CLICOLOR
        fi
    fi
    if [ "${TERM}" != "${__term}" ]; then
        echo "# TERM='${__term}'"
        echo "TERM='${TERM}'"
    fi
}

configure_TERM_CLICOLOR() {
    # configure_TERM_CLICOLOR   -- configure $CLICOLOR and $CLICOLOR_256
    #   CLICOLOR=1
    export CLICOLOR=1

    #todo
    #CLICOLOR_256=1
    #export CLICOLOR_256=$CLICOLOR

    if [ -n "${CLICOLOR_256}" ]; then
        (echo $TERM | grep -v -q 256color) && \
            export TERM="${TERM}-256color"
    fi
}

    # configure_TERM when sourced
configure_TERM

### bashrc.dotfiles.sh


dotfiles_add_path() {
    # dotfiles_add_path()       -- add ${__DOTFILES}/scripts to $PATH
    if [ -d "${__DOTFILES}" ]; then
        #PATH_prepend "${__DOTFILES}/bin"  # [01-bashrc.lib.sh]
        PATH_prepend "${__DOTFILES}/scripts"
    fi
}

shell_escape_single() {
    # shell_escape_single()
    strtoescape=${1}
    output="$(echo "${strtoescape}" | sed "s,','\"'\"',g")"
    echo "'"${output}"'"
}

dotfiles_status() {
    # dotfiles_status()         -- print dotfiles_status
    echo "# dotfiles_status()"
    echo HOSTNAME=$(shell_escape_single "${HOSTNAME}")
    echo USER=$(shell_escape_single "${USER}")
    echo __WRK=$(shell_escape_single "${__WRK}")
    echo PROJECT_HOME=$(shell_escape_single "${PROJECT_HOME}")
    if [ -n "${CONDA_ROOT}" ]; then
        echo CONDA_ROOT=$(shell_escape_single "${CONDA_ROOT}")
    fi
    if [ -n "${CONDA_ENVS_PATH}" ]; then
        echo CONDA_ENVS_PATH=$(shell_escape_single "${CONDA_ENVS_PATH}")
    fi
    echo WORKON_HOME=$(shell_escape_single "${WORKON_HOME}")
    echo VIRTUAL_ENV_NAME=$(shell_escape_single "${VIRTUAL_ENV_NAME}")
    echo VIRTUAL_ENV=$(shell_escape_single "${VIRTUAL_ENV}")
    echo _SRC=$(shell_escape_single "${_SRC}")
    echo _APP=$(shell_escape_single "${_APP}")
    echo _WRD=$(shell_escape_single "${_WRD}")
    #echo "__DOCSWWW=$(shell_escape_single "${_DOCS}")
    #echo "__SRC=$(shell_escape_single "${__SRC}")
    #echo "__PROJECTSRC=$(shell_escape_single "${__PROJECTSRC}")
    echo _USRLOG=$(shell_escape_single "${_USRLOG}")
    echo _TERM_ID=$(shell_escape_single "${_TERM_ID}")
    echo PATH=$(shell_escape_single "${PATH}")
    echo __DOTFILES=$(shell_escape_single "${__DOTFILES}")
    #echo $PATH | tr ':' '\n' | sed 's/\(.*\)/#     \1/g'
    echo "#"
    if [ -n "${_MSG}" ]; then
        echo _MSG=$(shell_escape_single "${_MSG}")
        echo '#'
    fi
}
ds() {
    # ds()                      -- print dotfiles_status
    dotfiles_status $@
}

clr() {
    # clr()                     -- clear scrollback
    if [ -d '/Library' ]; then # see __IS_MAC
        # osascript -e 'if application "Terminal" is frontmost then tell application "System Events" to keystroke "k" using command down'
        clear && printf '\e[3J'
    else
        reset
    fi
}


cls() {
    # cls()                     -- clear scrollback and print dotfiles_status()
    clr ; dotfiles_status
}

#dotfiles_term_uri() {
    ##dotfiles_term_uri()        -- print a URI for the current _TERM_ID
    #term_path="${HOSTNAME}/usrlog/${USER}"
    #term_key=${_APP}/${_TERM_ID}
    #TERM_URI="${term_path}/${term_key}"
    #echo "TERM_URI='${TERM_URL}'"
#}

debug-env() {
    _log=${_LOG:-"."}
    OUTPUT=${1:-"${_log}/$(date +"%FT%T%z").debug-env.env.log"}
    dotfiles_status
    echo "## export"
    export | tee $OUTPUT
    echo "## alias"
    alias | tee $OUTPUT
    # echo "## lspath"
    # lspath | tee $OUTPUT
}

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#The-Shopt-Builtin

debug-on() {
    # debug-on()                 -- set -x -v
    set -x -v
    shopt -s extdebug
}
debug-off() {
    # debug-off()                -- set +x +v
    set +x +v
    shopt -s extdebug
}

_virtualenvwrapper_get_step_num() {

    # Virtualenvwrapper numeric sequence
    # * to make logs in /var/log/venv.nnn-stepname.log naturally ordered
    #
    # * 0xx : 'initialization' actions  : [initialize]
    # * 1xx : 'creation' actions        : [pre|post]mk[virtualenv|project]
    # * 2xx : 'vation' actions          : [pre|post][activate|deactivate]
    # * 8xx : 'managment' actions       : [pre|post][cpvirtualenv|rmvirtualenv]
    # * 868 : unknown
    # * xx0 : 'pre' actions
    # * xx9 : 'post' actions
    # Source-ordered according to the virtualenvwrapper docs
    # * https://virtualenvwrapper.readthedocs.org/en/latest/scripts.html#scripts
    step=${1}
    n="868"  # unknown
    case ${step} in
        "get_env_details")
            n="800" ;;
        "initialize")
            n="010" ;;
        "premkvirtualenv")
            n="120" ;;
        "postmkvirtualenv")
            n="129" ;;
        "precpvirtualenv")
            n="820" ;;
        "postcpvirtualenv")
            n="829" ;;
        "preactivate")
            n="230" ;;
        "postactivate")
            n="239" ;;
        "predeactivate")
            n="290" ;;
        "postdeactivate")
            n="299" ;;
        "prermvirtualenv")
            n="810" ;;
        "postrmvirtualenv")
            n="819" ;;
        "premkproject")
            n="140" ;;
        "postmkproject")
            n="149" ;;
    esac
    echo "${n}"
}

log_dotfiles_state() {
    # log_dotfiles_state()      -- save current environment to logfiles
    #   $1 -- logkey (virtualenvwrapper step name)
    test -n "${DOTFILES_SKIP_LOG}" && echo '#DOTFILES_SKIP_LOG' && return
    _log=${_LOG:-"${HOME}/var/log"}
    if [ "${_log}" == "/var/log" ]; then
        _log="${HOME}/var/log"
    fi
    logkey=${1:-'log_dotfiles_state'}
    stepnum="$(_virtualenvwrapper_get_step_num "${logkey}")"
    logdir=${_log:-"var/log"}/venv..${VIRTUAL_ENV_NAME}..${stepnum}..${logkey}
    exportslogfile=${logdir}/exports.log
    envlogfile=${logdir}/exports_env.log
    test -n ${logdir} && test -d ${logdir} || mkdir -p ${logdir}
    # XXX:
    export > ${exportslogfile}
    set > ${envlogfile}
}


dotfiles_initialize() {
    # dotfiles_initialize()     -- virtualenvwrapper initialize
    log_dotfiles_state 'initialize'
}


dotfiles_premkvirtualenv() {
    # dotfiles_premkvirtualenv -- virtualenvwrapper premkvirtualenv
    if [ -n "${1}" ]; then
        export VIRTUAL_ENV="${WORKON_HOME}/${1}"
    fi
}

dotfiles_postmkvirtualenv() {
    # dotfiles_postmkvirtualenv -- virtualenvwrapper postmkvirtualenv

    log_dotfiles_state 'postmkvirtualenv'

    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "VIRTUAL_ENV is not set? (err: -1)"
        return -1
    fi

    declare -f 'venv_mkdirs' 2>&1 >/dev/null && venv_mkdirs
    test -d ${VIRTUAL_ENV}/var/log || mkdir -p ${VIRTUAL_ENV}/var/log
    echo ""
    echo $(which pip)
    pip_freeze="${VIRTUAL_ENV}/var/log/pip.freeze.postmkvirtualenv.txt"
    echo "pip_freeze='${pip_freeze}'"
    pip freeze | tee ${pip_freeze}
    echo ""
    pip_list="${VIRTUAL_ENV}/var/log/pip.freeze.postmkvirtualenv.txt"
    echo "pip_list='${pip_list}'"
    pip list | tee ${pip_list}
}

dotfiles_preactivate() {
    # dotfiles_preactivate()    -- virtualenvwrapper preactivate
    log_dotfiles_state 'preactivate'
}

dotfiles_postactivate() {
    # dotfiles_postactivate()   -- virtualenvwrapper postactivate
    log_dotfiles_state 'postactivate'

    local bash_debug_output=$(
        $__VENV -e --verbose --diff --print-bash 2>&1 /dev/null)
    local venv_return_code=$?
    if [ ${venv_return_code} -eq 0 ]; then
        if [ -n "${__VENV}" ]; then
            source <($__VENV -e --print-bash)
        fi
    else
        echo "${bash_debug_output}" # >2
    fi

    declare -f '_setup_usrlog' 2>&1 > /dev/null \
        && _setup_usrlog

    declare -f '_setup_venv_prompt' 2>&1 > /dev/null \
        && _setup_venv_prompt

}

dotfiles_predeactivate() {
    # dotfiles_predeactivate()  -- virtualenvwrapper predeactivate
    log_dotfiles_state 'predeactivate'
}

dotfiles_postdeactivate() {
    # dotfiles_postdeactivate() -- virtualenvwrapper postdeactivate
    log_dotfiles_state 'postdeactivate'
    unset VIRTUAL_ENV
    unset VIRTUAL_ENV_NAME
    unset VENVSTR
    unset VENVSTRAPP
    unset VENVPREFIX
    unset _APP
    unset _BIN
    unset _CFG
    unset _EDITCFG_
    export EDITOR_=${EDITOR}
    unset _EDIT_
    unset _ETC
    unset _ETCOPT
    unset _HOME
    unset _IPQTLOG
    unset _IPSESSKEY
    unset _LIB
    unset _LOG
    unset _MEDIA
    unset _MNT
    unset _NOTEBOOKS
    unset _OPT
    unset _PYLIB
    unset _PYSITE
    unset _ROOT
    unset _SBIN
    unset _SERVE_
    unset _SHELL_
    unset _SRC
    unset _SRV
    unset _SVCFG
    unset _SVCFG_
    unset _TEST_
    unset _TMP
    unset _USR
    unset _USRBIN
    unset _USRINCLUDE
    unset _USRLIB
    unset _USRLOCAL
    unset _USRLOG
    unset _USRSBIN
    unset _USRSHARE
    unset _USRSRC
    unset _VAR
    unset _VARCACHE
    unset _VARLIB
    unset _VARLOCK
    unset _VARMAIL
    unset _VAROPT
    unset _VARRUN
    unset _VARSPOOL
    unset _VARTMP
    unset _VENV
    unset _WRD
    unset _WRD_SETUPY
    unset _WWW

    declare -f '_usrlog_set__USRLOG' 2>&1 > /dev/null \
        && _usrlog_set__USRLOG "${__USRLOG}"

    dotfiles_reload
}

### bashrc.completion.sh

_configure_bash_completion() {
    # _configure_bash_completion()  -- configure bash completion
    #                               note: `complete -p` lists completions

    if [ -n "$__IS_MAC" ]; then
        #configure brew (brew install bash-completion)
        BREW=$(which brew 2>/dev/null || false)
        if [ -n "${BREW}" ]; then
            brew_prefix=$(brew --prefix)
            if [ -f ${brew_prefix}/etc/bash_completion ]; then
                source ${brew_prefix}/etc/bash_completion
            fi
        fi
    else
        if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
            source /etc/bash_completion
        elif [ -f /etc/profile.d/bash_completion.sh ] && ! shopt -oq posix; then
            source /etc/profile.d/bash_completion.sh
        fi
    fi
}
_configure_bash_completion
# Check for interactive bash and that we haven't already been sourced.
if [ -n "${BASH_VERSION-}" -a -n "${PS1-}" -a -z "${BASH_COMPLETION_COMPAT_DIR-}" ]; then

    # Check for recent enough version of bash.
    if [ ${BASH_VERSINFO[0]} -gt 4 ] || \
       [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -ge 1 ]; then
        [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] && \
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
        if shopt -q progcomp && [ -r /usr/share/bash-completion/bash_completion ]; then
            # Source completion code.
            . /usr/share/bash-completion/bash_completion
        fi
    fi

fi
#                                                          -*- shell-script -*-
#
#   bash_completion - programmable completion functions for bash 4.1+
#
#   Copyright © 2006-2008, Ian Macdonald <ian@caliban.org>
#             © 2009-2015, Bash Completion Maintainers
#                     <bash-completion-devel@lists.alioth.debian.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#   The latest version of this software can be obtained here:
#
#   http://bash-completion.alioth.debian.org/
#
#   RELEASE: 2.1

if [[ $- == *v* ]]; then
    BASH_COMPLETION_ORIGINAL_V_VALUE="-v"
else
    BASH_COMPLETION_ORIGINAL_V_VALUE="+v"
fi

if [[ ${BASH_COMPLETION_DEBUG-} ]]; then
    set -v
else
    set +v
fi
unset BASH_COMPLETION_ORIGINAL_V_VALUE

# ex: ts=4 sw=4 et filetype=sh

### bashrc.python.sh

pypath() {
    # pypath()              -- print python sys.path and site config
    /usr/bin/env python -m site
}


_setup_python () {
    # _setup_python()       -- configure $PYTHONSTARTUP
    export PYTHONSTARTUP="${HOME}/.pythonrc"
    #export
}
_setup_python

_setup_pip () {
    # _setup_pip()          -- set $PIP_REQUIRE_VIRTUALENV=false
    export PIP_REQUIRE_VIRTUALENV=false
}
_setup_pip


## Pyenv

_setup_pyenv() {
    # _setup_pyvenv()       -- set $PYENV_ROOT, PATH_prepend, and pyenv venvw
    export PYENV_ROOT="${HOME}/.pyenv"
    PATH_prepend "${PYENV_ROOT}/bin"
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper
}


### bashrc.conda.sh

## Conda / Anaconda

_setup_conda_defaults() {
    # _setup_conda_defaults()   -- configure CONDA_ENVS_PATH*, CONDA_ROOT*
    #    $1 (pathstr): prefix for CONDA_ENVS_PATHS and CONDA_ROOT
    #                 (default: ${__WRK})
    local __wrk=${1:-${__WRK}}
    export CONDA_ENVS__py27="${__wrk}/-ce27"
    export CONDA_ENVS__py34="${__wrk}/-ce34"
    export CONDA_ENVS_DEFAULT="CONDA_ENVS__py27"
    export CONDA_ENVS_PATH="${__wrk}/-ce27"

    export CONDA_ROOT__py27="${__wrk}/-conda27"
    export CONDA_ROOT__py34="${__wrk}/-conda34"
    export CONDA_ROOT_DEFAULT="CONDA_ROOT__py27"
    export CONDA_ROOT="${__wrk}/-conda27"
}

_setup_conda() {
    # _setup_anaconda()     -- set CONDA_ENVS_PATH, CONDA_ROO
    #   $1 (pathstr or {27, 34}) -- lookup($1, CONDA_ENVS_PATH,
    #                                                   CONDA_ENVS__py27)
    #   $2 (pathstr or "")       -- lookup($2, CONDA_ROOT,
    #                                                   CONDA_ROOT__py27)
    #
    #  Usage:
    #   _setup_conda    # __py27
    #   _setup_conda 27 # __py27
    #   _setup_conda 34 # __py34
    #   _setup_conda ~/envs             # __py27
    #   _setup_conda ~/envs/ /opt/conda # /opt/conda
    #
    local _conda_envs_path=${1}
    local _conda_root_path=${2}
    _setup_conda_defaults "${__WRK}"
    if [ -z "${_conda_envs_path}" ]; then
        export CONDA_ENVS_PATH=${CONDA_ENVS_PATH:-${CONDA_ENVS__py27}}
        export CONDA_ROOT=${CONDA_ROOT:-${CONDA_ROOT__py27}}
    else
        if [ "$_conda_envs_path" == "27" ]; then
            export CONDA_ENVS_PATH=$CONDA_ENVS__py27
            export CONDA_ROOT=$CONDA_ROOT__py27
        elif [ "$_conda_envs_path" == "34" ]; then
            export CONDA_ENVS_PATH=$CONDA_ENVS__py34
            export CONDA_ROOT=$CONDA_ROOT__py34
        else
            export CONDA_ENVS_PATH=${_conda_envs_path}
            export CONDA_ROOT=(
            ${_conda_root_path:-${CONDA_ROOT:-${CONDA_ROOT__py27}}})
        fi
    fi
    _setup_conda_path
}

_setup_conda_path() {
    _unsetup_conda_path_all
    PATH_prepend "${CONDA_ROOT}/bin" 2>&1> /dev/null
}

_unsetup_conda_path_all() {
    PATH_remove "${CONDA_ROOT}/bin" 2>&1 > /dev/null
    PATH_remove "${CONDA_ROOT__py27}/bin" 2>&1> /dev/null
    PATH_remove "${CONDA_ROOT__py34}/bin" 2>&1> /dev/null
    declare -f 'dotfiles_status' 2>&1 > /dev/null && dotfiles_status
}

lscondaenvs() {
    paths=$(  \
    ( echo "${CONDA_ENVS_PATH}"; \
    echo "${CONDA_ENVS__py27}";  \
    echo "${CONDA_ENVS__py34}";) | uniq)
    (set -x; find ${paths} -maxdepth 1 -type d)
}

_condaenvs() {
    local files=("${CONDA_ENVS_PATH}/$2"*)
    [[ -e ${files[0]} ]] && COMPREPLY=( "${files[@]##*/}" )
}

workon_conda() {
    # workon_conda()        -- workon a conda + venv project
    local _conda_envname=${1}
    local _venvstrapp=${2}
    local _conda_envs_path=${3}
    _setup_conda ${_conda_envs_path}
    local CONDA_ENV="${CONDA_ENVS_PATH}/${_conda_envname}"
    source "${CONDA_ROOT}/bin/activate" "${CONDA_ENV}"
    source <(set -x;
      $__VENV --wh="${CONDA_ENVS_PATH}" \
        --ve="${CONDA_ENV}" --venvstrapp="${_venvstrapp}" \
        --print-bash)
    declare -f "_setup_venv_prompt" 2>&1 > /dev/null && _setup_venv_prompt
    dotfiles_status
    deactivate() {
        source deactivate
        dotfiles_postdeactivate
    }
}
complete -o default -o nospace -F _condaenvs workon_conda

wec() {
    # wec()                 -- workon a conda + venv project
    #                       note: tab-completion only shows regular virtualenvs
    workon_conda $@
}
complete -o default -o nospace -F _condaenvs wec

mkvirtualenv_conda() {
    # mkvirtualenv_conda()  -- mkvirtualenv and conda create
    local _conda_envname=${1}
    local _conda_envs_path=${2}
    shift; shift
    local _conda_pkgs=${@}
    _setup_conda ${_conda_envs_path}
    if [ -z "$CONDA_ENVS_PATH" ]; then
        echo "\$CONDA_ENVS_PATH is not set. Exiting".
        return
    fi
    local CONDA_ENV="${CONDA_ENVS_PATH}/${_conda_envname}"
    if [ "$_conda_envs_path" == "27" ]; then
        conda_python="python=2"
    elif [ "$_conda_envs_path" == "34" ]; then
        conda_python="python=3"
    else
        conda_python="python=2"
    fi
    conda create --mkdir --prefix "${CONDA_ENV}" --yes \
        ${conda_python} readline pip ${_conda_pkgs}

    export VIRTUAL_ENV="${CONDA_ENV}"
    workon_conda "${_conda_envname}" "${_conda_envs_path}"
    export VIRTUAL_ENV="${CONDA_ENV}"
    dotfiles_postmkvirtualenv

    echo ""
    echo $(which conda)
    conda_list=${_LOG}/conda.list.no-pip.postmkvirtualenv.txt
    echo "conda_list=${conda_list}"
    conda list -e --no-pip | tee "${conda_list}"
}

rmvirtualenv_conda() {
    # rmvirtualenv_conda()  -- rmvirtualenv conda
    local _conda_envname=${1}
    local _conda_envs_path=${2}
    _setup_conda ${_conda_envs_path}
    local CONDA_ENV=${CONDA_ENVS_PATH}/$_conda_envname
    if [ -z "$CONDA_ENVS_PATH" ]; then
        echo "\$CONDA_ENVS_PATH is not set. Exiting".
        return
    fi
    echo "Removing ${CONDA_ENV}"
    rm -rf "${CONDA_ENV}"
}


mkvirtualenv_conda_if_available() {
    # mkvirtualenv_conda_if_available() -- mkvirtualenv_conda OR mkvirtualenv
    (declare -f 'mkvirtualenv_conda' 2>&1 > /dev/null \
        && mkvirtualenv_conda $@) \
    || \
    (declare -f 'mkvirtualenv' 2>&1 > /dev/null \
        && mkvirtualenv $@)
}

workon_conda_if_available() {
    # workon_conda_if_available()       -- workon_conda OR we OR workon
    (declare -f 'workon_conda' 2>&1 > /dev/null \
        && workon_conda $@) \
    || \
    (declare -f 'we' 2>&1 > /dev/null \
        && we $@) \
    || \
    (declare -f 'workon' 2>&1 > /dev/null \
        && workon $@)
}
### bashrc.virtualenvwrapper.sh
#
# Installing Virtualenvwrapper:
#   apt:
#     sudo apt-get install virtualenvwrapper
#   pip:
#     [sudo] pip install -U pip virtualenvwrapper
#

## Configure dotfiles/virtualenv root/prefix environment variables
# __WRK         workspace root
# PROJECT_HOME  virtualenvwrapper project directory (mkproject)
# WORKON_HOME   virtualenvwrapper virtualenv prefix
#               VIRTUAL_ENV=${WORKON_HOME}/${VIRTUAL_ENV_NAME}
#               _APP=${VIRTUAL_ENV_NAME}  #[/subpath]
#               _SRC=${VIRTUAL_ENV}/${_APP}
#               _WRD=${VIRTUAL_ENV}/${_APP}

_setup_virtualenvwrapper_default_config() {
    export __WRK=${__WRK:-"${HOME}/workspace"}
    export PROJECT_HOME="${__WRK}"
    export WORKON_HOME="${HOME}/.virtualenvs"
}
_setup_virtualenvwrapper_dotfiles_config() {
    export __WRK=${__WRK:-"${HOME}/-wrk"}
    export PROJECT_HOME="${__WRK}"
    export WORKON_HOME="${__WRK}/-ve27"
}

_setup_virtualenvwrapper_dirs() {
    umask 027
    mkdir -p "${__WRK}" || chmod o-rwx "${__WRK}"
    mkdir -p "${PROJECT_HOME}" || chmod o-rwx "${PROJECT_HOME}"
    mkdir -p "${WORKON_HOME}" || chmod o-rwx "${WORKON_HOME}"
}

_setup_virtualenvwrapper_config () {
    # _setup_virtualenvwrapper_config()    -- configure $VIRTUALENVWRAPPER_*
    #export VIRTUALENVWRAPPER_SCRIPT="/usr/local/bin/virtualenvwrapper.sh"
    #export VIRTUALENVWRAPPER_SCRIPT="${HOME}/.local/bin/virtualenvwrapper.sh"
    export VIRTUALENVWRAPPER_SCRIPT=$(which virtualenvwrapper.sh)
    export VIRTUALENVWRAPPER_HOOK_DIR="${__DOTFILES}/etc/virtualenvwrapper"
    export VIRTUALENVWRAPPER_LOG_DIR="${PROJECT_HOME}/.virtualenvlogs"
    if [ -n "${__IS_MAC}" ]; then
        export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python"
    else
        export VIRTUALENVWRAPPER_PYTHON=$(which python)
    fi
    unset VIRTUALENV_DISTRIBUTE
    source "${VIRTUALENVWRAPPER_SCRIPT}"
}

lsvirtualenvs() {
    # lsvirtualenvs()       -- list virtualenvs in $WORKON_HOME
    cmd=${@:-""}
    (cd ${WORKON_HOME} &&
    for venv in $(ls -adtr ${WORKON_HOME}/**/lib/python?.? | \
        sed "s:$WORKON_HOME/\(.*\)/lib/python[0-9]\.[0-9]:\1:g"); do
        if [ -n "${cmd}" ]; then
            $cmd $venv ;
        else
            echo "${venv}" ;
        fi
    done)
}
lsve() {
    # lsve()                -- list virtualenvs in $WORKON_HOME
    lsvirtualenvs $@
}

backup_virtualenv() {
    # backup_virtualenv()   -- backup VIRTUAL_ENV_NAME $1 to [$2]
    venv=${1}
    _date=$(date +'%FT%T%z')
    bkpdir=${2:-"${WORKON_HOME}/_venvbkps/${_date}"}
    test -d ${bkpdir} || mkdir -p ${bkpdir}
    archivename="venvbkp.${venv}.${_date}.tar.gz"
    archivepath="${bkpdir}/${archivename}"
    (cd ${WORKON_HOME}; \
    tar czf ${archivepath} ${venv} \
        && echo "${archivename}" \
        || (echo "err: ${venv} (${archivename})" 1>&2))
}

backup_virtualenvs() {
    # backup_virtualenvs()  -- backup all virtualenvs in $WORKON_HOME to [$1]
    date=$(date +'%FT%T%z')
    bkpdir=${1:-"${WORKON_HOME}/_venvbkps/${date}"}
    echo BKPDIR="${bkpdir}"
    test -d ${bkpdir} || mkdir -p ${bkpdir}
    lsvirtualenvs
    venvs=$(lsvirtualenvs)
    (cd ${WORKON_HOME}; \
    for venv in ${venvs}; do
        backup_virtualenv ${venv} ${bkpdir} \
        2>> ${bkpdir}/venvbkps.err \
        | tee -a ${bkpdir}/venvbkps.list
    done)
    cat ${bkpdir}/venvbkps.err
    echo BKPDIR="${bkpdir}"
}

_rebuild_virtualenv() {
    # rebuild_virtualenv()      -- rebuild a virtualenv, leaving pkgs in place
    #    $1="$VENVSTR"
    #    $2="$VIRTUAL_ENV"
    echo "rebuild_virtualenv()"
    VENVSTR="${1}"
    VIRTUAL_ENV=${2:-"${WORKON_HOME}/${VENVSTR}"}
    _BIN="${VIRTUAL_ENV}/bin"
    #rm -fv ${_BIN}/python ${_BIN}/python2 ${_BIN}/python2.7 \
        #${_BIN}/pip ${_BIN}/pip-2.7 \
        #${_BIN}/easy_install ${_BIN}/easy_install-2.7 \
        #${_BIN}/activate*
    pyver=$(python -c "import sys; print('{}.{}'.format(*sys.version_info[:2]))")
    _PYSITE="${VIRTUAL_ENV}/lib/python${pyver}/site-packages"
    find -E "${_PYSITE}" -iname 'activate*' -delete
    find -E "${_PYSITE}" -iname 'pip*' -delete
    find -E "${_PYSITE}" -iname 'setuptools*' -delete
    find -E "${_PYSITE}" -iname 'distribute*' -delete
    find -E "${_PYSITE}" -iname 'easy_install*' -delete
    find -E "${_PYSITE}" -iname 'python*' -delete
    declare -f 'deactivate' 2>&1 /dev/null && deactivate
    mkvirtualenv -i setuptools -i wheel -i pip ${VENVSTR} 
    #mkvirtualenv --clear would delete ./lib/python<pyver>/site-packages
    workon ${VENVSTR} && \
    we ${VENVSTR}
    _BIN="${VIRTUAL_ENV}/bin"

    if [ "${_BIN}" == "/bin" ]; then
        echo "err: _BIN='${_BIN}'"
        return 1
    fi

    find ${_BIN} -type f | grep -v '.bak$' | grep -v 'python*$' \
        | xargs head -n1
    find ${_BIN} -type f | grep -v '.bak$' | grep -v 'python*$' \
        | LC_ALL=C xargs  sed -i.bak -E 's,^#!.*python.*,#!'${_BIN}'/python,'
    find $_BIN -name '*.bak' -delete

    find ${_BIN} -type f | grep -v '.bak$' | grep -v 'python*$' \
        | xargs head -n1
    echo "
    # TODO: adjust paths beyond the shebang
    #${_BIN}/pip install -v -v -r <(${_BIN}/pip freeze)
    #${_BIN}/pip install -r ${_WRD}/requirements.txt
    "
}

rebuild_virtualenv() {
    #  rebuild_virtualenv()     -- rebuild a virtualenv
    #    $1="$VENVSTR"
    #    $2="$VIRTUAL_ENV"
    (set -x; _rebuild_virtualenv $@)
}

rebuild_virtualenvs() {
    # rebuild_virtualenvs()     -- rebuild all virtualenvs in $WORKON_HOME
    lsve rebuild_virtualenv
}


_setup_virtualenvwrapper_dotfiles_config  # ~/-wrk/-ve27 {-ve34,-ce27,-ce34}

_setup_virtualenvwrapper() {
  # _setup_virtualenvwrapper_default_config # ~/.virtualenvs/
  _setup_virtualenvwrapper_config
  _setup_virtualenvwrapper_dirs
}



if [[ "$BASH_SOURCE" == "$0" ]]; then
  _setup_virtualenvwrapper
else
  if [ -z "${VIRTUALENVWRAPPER_SCRIPT}" ]; then
    _setup_virtualenvwrapper
  fi
fi

### bashrc.gcloud.sh

_setup_google_cloud() {
    # _setup_google_cloud() -- configure gcloud $PATH and bash completions
    export _GCLOUD_PREFIX="/srv/wrk/google-cloud-sdk"

    #The next line updates PATH for the Google Cloud SDK.
    source "${_GCLOUD_PREFIX}/path.bash.inc"

    #The next line enables bash completion for gcloud.
    source "${_GCLOUD_PREFIX}/completion.bash.inc"
}
### bashrc.venv.sh
#   note: most of these aliases and functions are overwritten by `we` 
## Variables


function _setup_venv {
    # _setup_venv()    -- configure __PROJECTSRC, PATH, __VENV, _setup_venv_SRC()
    #  __PROJECTSRC (str): path to local project settings script to source
    export __PROJECTSRC="${__WRK}/.projectsrc.sh"
    [ -f $__PROJECTSRC ] && source $__PROJECTSRC

    # PATH="~/.local/bin:$PATH" (if not already there)
    PATH_prepend "${HOME}/.local/bin"

    # __VENV      -- path to local venv config script (executable)
    export __VENV="${__DOTFILES}/scripts/venv.py"

    _setup_venv_SRC
}


function _setup_venv_SRC {
    # _setup_venv_SRC() -- configure __SRCVENV and __SRC global virtualenv
    # __SRCVENV (str): global 'src' venv symlink (~/-wrk/src)
    #                  (e.g. ln -s ~/-wrk/-ve27/src ~/-wrk/src)
    export __SRCVENV="${__WRK}/src"
    # __SRC     (str): global 'src' venv ./src directory path (~/-wrk/src/src)
    export __SRC="${__SRCVENV}/src"

    if [ ! -e "${__SRCVENV}" ]; then
        if [ ! -d "${WORKON_HOME}/src" ]; then
            mkvirtualenv -p $(which python) -i pyrpo -i pyline -i pgs src
        fi
        ln -s "${WORKON_HOME}/src" "${__SRCVENV}"
    fi

    #               ($__SRC/git $__SRC/git)
    if [ ! -d $__SRC ]; then
        mkdir -p \
            ${__SRC}/git/github.com \
            ${__SRC}/git/bitbucket.org \
            ${__SRC}/hg/bitbucket.org
    fi
}

_setup_venv

## Functions

venv() {
    # venv $@   -- call $_VENV $@
    # venv -h   -- print venv --help
    # venv --print-bash   -- print bash configuration
    # venv --print-json   -- print IPython configuration as JSON
    (set -x; $__VENV $@)
}
venvw() {
    # venvw $@ -- venv -E $@ (for the current environment)
    (set -x; $__VENV -e $@)
}

workon_venv() {
    # workon_venv() -- workon a virtualenv and load venv (TAB-completion)
    #  param $1: $VIRTUAL_ENV_NAME ("dotfiles")
    #  param $2: $_APP ("dotfiles") [default: $1)
    #   ${WORKON_HOME}/${VIRTUAL_ENV_NAME}  # == $VIRTUAL_ENV
    #   ${VIRTUAL_ENV}/src                  # == $_SRC
    #   ${_SRC}/${VIRTUAL_ENV_NAME}         # == $_WRD
    #  examples:
    #   we dotfiles
    #   we dotfiles dotfiles

    #append to shell history
    history -a

    if [ -n "$1" ] && ( test -d "$WORKON_HOME/$1" || test -d "${1}" ); then
        workon $1 && \
        source <($__VENV --print-bash $@) && \
        dotfiles_status && \
        declare -f '_setup_venv_prompt' 2>&1 > /dev/null \
            && _setup_venv_prompt ${_TERM_ID:-$1}
    else
        #if no arguments are specified, list virtual environments
        lsvirtualenvs
        return 1
    fi
}
we () {
    # we()          -- workon_venv
    workon_venv $@
}
complete -o default -o nospace -F _virtualenvs workon_venv
complete -o default -o nospace -F _virtualenvs we

# CdAlias functions and completions
source ${__DOTFILES}/etc/venv/scripts/venv.sh
#!/bin/bash
## venv.sh
# generated from $(venv --print-bash --prefix=/)


eval '
cdhome () {
    # cdhome            -- cd $HOME /$@
    [ -z "$HOME" ] && echo "HOME is not set" && return 1
    cd "$HOME"${@:+"/${@}"}
}
_cd_HOME_complete () {
    local cur="$2";
    COMPREPLY=($(cdhome && compgen -d -- "${cur}" ))
}
cdh () {
    # cdh               -- cd $HOME
    cdhome $@
}
complete -o default -o nospace -F _cd_HOME_complete cdhome
complete -o default -o nospace -F _cd_HOME_complete cdh

';

cdhome () {
    # cdhome            -- cd $HOME /$@
    [ -z "$HOME" ] && echo "HOME is not set" && return 1
    cd "$HOME"${@:+"/${@}"}
}
_cd_HOME_complete () {
    local cur="$2";
    COMPREPLY=($(cdhome && compgen -d -- "${cur}" ))
}
cdh () {
    # cdh               -- cd $HOME
    cdhome $@
}
complete -o default -o nospace -F _cd_HOME_complete cdhome
complete -o default -o nospace -F _cd_HOME_complete cdh

eval '
cdwrk () {
    # cdwrk             -- cd $__WRK /$@
    [ -z "$__WRK" ] && echo "__WRK is not set" && return 1
    cd "$__WRK"${@:+"/${@}"}
}
_cd___WRK_complete () {
    local cur="$2";
    COMPREPLY=($(cdwrk && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd___WRK_complete cdwrk

';

cdwrk () {
    # cdwrk             -- cd $__WRK /$@
    [ -z "$__WRK" ] && echo "__WRK is not set" && return 1
    cd "$__WRK"${@:+"/${@}"}
}
_cd___WRK_complete () {
    local cur="$2";
    COMPREPLY=($(cdwrk && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd___WRK_complete cdwrk

eval '
cddotfiles () {
    # cddotfiles        -- cd $__DOTFILES /$@
    [ -z "$__DOTFILES" ] && echo "__DOTFILES is not set" && return 1
    cd "$__DOTFILES"${@:+"/${@}"}
}
_cd___DOTFILES_complete () {
    local cur="$2";
    COMPREPLY=($(cddotfiles && compgen -d -- "${cur}" ))
}
cdd () {
    # cdd               -- cd $__DOTFILES
    cddotfiles $@
}
complete -o default -o nospace -F _cd___DOTFILES_complete cddotfiles
complete -o default -o nospace -F _cd___DOTFILES_complete cdd

';

cddotfiles () {
    # cddotfiles        -- cd $__DOTFILES /$@
    [ -z "$__DOTFILES" ] && echo "__DOTFILES is not set" && return 1
    cd "$__DOTFILES"${@:+"/${@}"}
}
_cd___DOTFILES_complete () {
    local cur="$2";
    COMPREPLY=($(cddotfiles && compgen -d -- "${cur}" ))
}
cdd () {
    # cdd               -- cd $__DOTFILES
    cddotfiles $@
}
complete -o default -o nospace -F _cd___DOTFILES_complete cddotfiles
complete -o default -o nospace -F _cd___DOTFILES_complete cdd

eval '
cdprojecthome () {
    # cdprojecthome     -- cd $PROJECT_HOME /$@
    [ -z "$PROJECT_HOME" ] && echo "PROJECT_HOME is not set" && return 1
    cd "$PROJECT_HOME"${@:+"/${@}"}
}
_cd_PROJECT_HOME_complete () {
    local cur="$2";
    COMPREPLY=($(cdprojecthome && compgen -d -- "${cur}" ))
}
cdp () {
    # cdp               -- cd $PROJECT_HOME
    cdprojecthome $@
}
cdph () {
    # cdph              -- cd $PROJECT_HOME
    cdprojecthome $@
}
complete -o default -o nospace -F _cd_PROJECT_HOME_complete cdprojecthome
complete -o default -o nospace -F _cd_PROJECT_HOME_complete cdp
complete -o default -o nospace -F _cd_PROJECT_HOME_complete cdph

';

cdprojecthome () {
    # cdprojecthome     -- cd $PROJECT_HOME /$@
    [ -z "$PROJECT_HOME" ] && echo "PROJECT_HOME is not set" && return 1
    cd "$PROJECT_HOME"${@:+"/${@}"}
}
_cd_PROJECT_HOME_complete () {
    local cur="$2";
    COMPREPLY=($(cdprojecthome && compgen -d -- "${cur}" ))
}
cdp () {
    # cdp               -- cd $PROJECT_HOME
    cdprojecthome $@
}
cdph () {
    # cdph              -- cd $PROJECT_HOME
    cdprojecthome $@
}
complete -o default -o nospace -F _cd_PROJECT_HOME_complete cdprojecthome
complete -o default -o nospace -F _cd_PROJECT_HOME_complete cdp
complete -o default -o nospace -F _cd_PROJECT_HOME_complete cdph

eval '
cdworkonhome () {
    # cdworkonhome      -- cd $WORKON_HOME /$@
    [ -z "$WORKON_HOME" ] && echo "WORKON_HOME is not set" && return 1
    cd "$WORKON_HOME"${@:+"/${@}"}
}
_cd_WORKON_HOME_complete () {
    local cur="$2";
    COMPREPLY=($(cdworkonhome && compgen -d -- "${cur}" ))
}
cdwh () {
    # cdwh              -- cd $WORKON_HOME
    cdworkonhome $@
}
cdve () {
    # cdve              -- cd $WORKON_HOME
    cdworkonhome $@
}
complete -o default -o nospace -F _cd_WORKON_HOME_complete cdworkonhome
complete -o default -o nospace -F _cd_WORKON_HOME_complete cdwh
complete -o default -o nospace -F _cd_WORKON_HOME_complete cdve

';

cdworkonhome () {
    # cdworkonhome      -- cd $WORKON_HOME /$@
    [ -z "$WORKON_HOME" ] && echo "WORKON_HOME is not set" && return 1
    cd "$WORKON_HOME"${@:+"/${@}"}
}
_cd_WORKON_HOME_complete () {
    local cur="$2";
    COMPREPLY=($(cdworkonhome && compgen -d -- "${cur}" ))
}
cdwh () {
    # cdwh              -- cd $WORKON_HOME
    cdworkonhome $@
}
cdve () {
    # cdve              -- cd $WORKON_HOME
    cdworkonhome $@
}
complete -o default -o nospace -F _cd_WORKON_HOME_complete cdworkonhome
complete -o default -o nospace -F _cd_WORKON_HOME_complete cdwh
complete -o default -o nospace -F _cd_WORKON_HOME_complete cdve

eval '
cdcondaenvspath () {
    # cdcondaenvspath   -- cd $CONDA_ENVS_PATH /$@
    [ -z "$CONDA_ENVS_PATH" ] && echo "CONDA_ENVS_PATH is not set" && return 1
    cd "$CONDA_ENVS_PATH"${@:+"/${@}"}
}
_cd_CONDA_ENVS_PATH_complete () {
    local cur="$2";
    COMPREPLY=($(cdcondaenvspath && compgen -d -- "${cur}" ))
}
cda () {
    # cda               -- cd $CONDA_ENVS_PATH
    cdcondaenvspath $@
}
cdce () {
    # cdce              -- cd $CONDA_ENVS_PATH
    cdcondaenvspath $@
}
complete -o default -o nospace -F _cd_CONDA_ENVS_PATH_complete cdcondaenvspath
complete -o default -o nospace -F _cd_CONDA_ENVS_PATH_complete cda
complete -o default -o nospace -F _cd_CONDA_ENVS_PATH_complete cdce

';

cdcondaenvspath () {
    # cdcondaenvspath   -- cd $CONDA_ENVS_PATH /$@
    [ -z "$CONDA_ENVS_PATH" ] && echo "CONDA_ENVS_PATH is not set" && return 1
    cd "$CONDA_ENVS_PATH"${@:+"/${@}"}
}
_cd_CONDA_ENVS_PATH_complete () {
    local cur="$2";
    COMPREPLY=($(cdcondaenvspath && compgen -d -- "${cur}" ))
}
cda () {
    # cda               -- cd $CONDA_ENVS_PATH
    cdcondaenvspath $@
}
cdce () {
    # cdce              -- cd $CONDA_ENVS_PATH
    cdcondaenvspath $@
}
complete -o default -o nospace -F _cd_CONDA_ENVS_PATH_complete cdcondaenvspath
complete -o default -o nospace -F _cd_CONDA_ENVS_PATH_complete cda
complete -o default -o nospace -F _cd_CONDA_ENVS_PATH_complete cdce

eval '
cdvirtualenv () {
    # cdvirtualenv      -- cd $VIRTUAL_ENV /$@
    [ -z "$VIRTUAL_ENV" ] && echo "VIRTUAL_ENV is not set" && return 1
    cd "$VIRTUAL_ENV"${@:+"/${@}"}
}
_cd_VIRTUAL_ENV_complete () {
    local cur="$2";
    COMPREPLY=($(cdvirtualenv && compgen -d -- "${cur}" ))
}
cdv () {
    # cdv               -- cd $VIRTUAL_ENV
    cdvirtualenv $@
}
complete -o default -o nospace -F _cd_VIRTUAL_ENV_complete cdvirtualenv
complete -o default -o nospace -F _cd_VIRTUAL_ENV_complete cdv

';

cdvirtualenv () {
    # cdvirtualenv      -- cd $VIRTUAL_ENV /$@
    [ -z "$VIRTUAL_ENV" ] && echo "VIRTUAL_ENV is not set" && return 1
    cd "$VIRTUAL_ENV"${@:+"/${@}"}
}
_cd_VIRTUAL_ENV_complete () {
    local cur="$2";
    COMPREPLY=($(cdvirtualenv && compgen -d -- "${cur}" ))
}
cdv () {
    # cdv               -- cd $VIRTUAL_ENV
    cdvirtualenv $@
}
complete -o default -o nospace -F _cd_VIRTUAL_ENV_complete cdvirtualenv
complete -o default -o nospace -F _cd_VIRTUAL_ENV_complete cdv

eval '
cdsrc () {
    # cdsrc             -- cd $_SRC /$@
    [ -z "$_SRC" ] && echo "_SRC is not set" && return 1
    cd "$_SRC"${@:+"/${@}"}
}
_cd__SRC_complete () {
    local cur="$2";
    COMPREPLY=($(cdsrc && compgen -d -- "${cur}" ))
}
cds () {
    # cds               -- cd $_SRC
    cdsrc $@
}
complete -o default -o nospace -F _cd__SRC_complete cdsrc
complete -o default -o nospace -F _cd__SRC_complete cds

';

cdsrc () {
    # cdsrc             -- cd $_SRC /$@
    [ -z "$_SRC" ] && echo "_SRC is not set" && return 1
    cd "$_SRC"${@:+"/${@}"}
}
_cd__SRC_complete () {
    local cur="$2";
    COMPREPLY=($(cdsrc && compgen -d -- "${cur}" ))
}
cds () {
    # cds               -- cd $_SRC
    cdsrc $@
}
complete -o default -o nospace -F _cd__SRC_complete cdsrc
complete -o default -o nospace -F _cd__SRC_complete cds

eval '
cdwrd () {
    # cdwrd             -- cd $_WRD /$@
    [ -z "$_WRD" ] && echo "_WRD is not set" && return 1
    cd "$_WRD"${@:+"/${@}"}
}
_cd__WRD_complete () {
    local cur="$2";
    COMPREPLY=($(cdwrd && compgen -d -- "${cur}" ))
}
cdw () {
    # cdw               -- cd $_WRD
    cdwrd $@
}
complete -o default -o nospace -F _cd__WRD_complete cdwrd
complete -o default -o nospace -F _cd__WRD_complete cdw

';

cdwrd () {
    # cdwrd             -- cd $_WRD /$@
    [ -z "$_WRD" ] && echo "_WRD is not set" && return 1
    cd "$_WRD"${@:+"/${@}"}
}
_cd__WRD_complete () {
    local cur="$2";
    COMPREPLY=($(cdwrd && compgen -d -- "${cur}" ))
}
cdw () {
    # cdw               -- cd $_WRD
    cdwrd $@
}
complete -o default -o nospace -F _cd__WRD_complete cdwrd
complete -o default -o nospace -F _cd__WRD_complete cdw

eval '
cdbin () {
    # cdbin             -- cd $_BIN /$@
    [ -z "$_BIN" ] && echo "_BIN is not set" && return 1
    cd "$_BIN"${@:+"/${@}"}
}
_cd__BIN_complete () {
    local cur="$2";
    COMPREPLY=($(cdbin && compgen -d -- "${cur}" ))
}
cdb () {
    # cdb               -- cd $_BIN
    cdbin $@
}
complete -o default -o nospace -F _cd__BIN_complete cdbin
complete -o default -o nospace -F _cd__BIN_complete cdb

';

cdbin () {
    # cdbin             -- cd $_BIN /$@
    [ -z "$_BIN" ] && echo "_BIN is not set" && return 1
    cd "$_BIN"${@:+"/${@}"}
}
_cd__BIN_complete () {
    local cur="$2";
    COMPREPLY=($(cdbin && compgen -d -- "${cur}" ))
}
cdb () {
    # cdb               -- cd $_BIN
    cdbin $@
}
complete -o default -o nospace -F _cd__BIN_complete cdbin
complete -o default -o nospace -F _cd__BIN_complete cdb

eval '
cdetc () {
    # cdetc             -- cd $_ETC /$@
    [ -z "$_ETC" ] && echo "_ETC is not set" && return 1
    cd "$_ETC"${@:+"/${@}"}
}
_cd__ETC_complete () {
    local cur="$2";
    COMPREPLY=($(cdetc && compgen -d -- "${cur}" ))
}
cde () {
    # cde               -- cd $_ETC
    cdetc $@
}
complete -o default -o nospace -F _cd__ETC_complete cdetc
complete -o default -o nospace -F _cd__ETC_complete cde

';

cdetc () {
    # cdetc             -- cd $_ETC /$@
    [ -z "$_ETC" ] && echo "_ETC is not set" && return 1
    cd "$_ETC"${@:+"/${@}"}
}
_cd__ETC_complete () {
    local cur="$2";
    COMPREPLY=($(cdetc && compgen -d -- "${cur}" ))
}
cde () {
    # cde               -- cd $_ETC
    cdetc $@
}
complete -o default -o nospace -F _cd__ETC_complete cdetc
complete -o default -o nospace -F _cd__ETC_complete cde

eval '
cdlib () {
    # cdlib             -- cd $_LIB /$@
    [ -z "$_LIB" ] && echo "_LIB is not set" && return 1
    cd "$_LIB"${@:+"/${@}"}
}
_cd__LIB_complete () {
    local cur="$2";
    COMPREPLY=($(cdlib && compgen -d -- "${cur}" ))
}
cdl () {
    # cdl               -- cd $_LIB
    cdlib $@
}
complete -o default -o nospace -F _cd__LIB_complete cdlib
complete -o default -o nospace -F _cd__LIB_complete cdl

';

cdlib () {
    # cdlib             -- cd $_LIB /$@
    [ -z "$_LIB" ] && echo "_LIB is not set" && return 1
    cd "$_LIB"${@:+"/${@}"}
}
_cd__LIB_complete () {
    local cur="$2";
    COMPREPLY=($(cdlib && compgen -d -- "${cur}" ))
}
cdl () {
    # cdl               -- cd $_LIB
    cdlib $@
}
complete -o default -o nospace -F _cd__LIB_complete cdlib
complete -o default -o nospace -F _cd__LIB_complete cdl

eval '
cdlog () {
    # cdlog             -- cd $_LOG /$@
    [ -z "$_LOG" ] && echo "_LOG is not set" && return 1
    cd "$_LOG"${@:+"/${@}"}
}
_cd__LOG_complete () {
    local cur="$2";
    COMPREPLY=($(cdlog && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd__LOG_complete cdlog

';

cdlog () {
    # cdlog             -- cd $_LOG /$@
    [ -z "$_LOG" ] && echo "_LOG is not set" && return 1
    cd "$_LOG"${@:+"/${@}"}
}
_cd__LOG_complete () {
    local cur="$2";
    COMPREPLY=($(cdlog && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd__LOG_complete cdlog

eval '
cdpylib () {
    # cdpylib           -- cd $_PYLIB /$@
    [ -z "$_PYLIB" ] && echo "_PYLIB is not set" && return 1
    cd "$_PYLIB"${@:+"/${@}"}
}
_cd__PYLIB_complete () {
    local cur="$2";
    COMPREPLY=($(cdpylib && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd__PYLIB_complete cdpylib

';

cdpylib () {
    # cdpylib           -- cd $_PYLIB /$@
    [ -z "$_PYLIB" ] && echo "_PYLIB is not set" && return 1
    cd "$_PYLIB"${@:+"/${@}"}
}
_cd__PYLIB_complete () {
    local cur="$2";
    COMPREPLY=($(cdpylib && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd__PYLIB_complete cdpylib

eval '
cdpysite () {
    # cdpysite          -- cd $_PYSITE /$@
    [ -z "$_PYSITE" ] && echo "_PYSITE is not set" && return 1
    cd "$_PYSITE"${@:+"/${@}"}
}
_cd__PYSITE_complete () {
    local cur="$2";
    COMPREPLY=($(cdpysite && compgen -d -- "${cur}" ))
}
cdsitepackages () {
    # cdsitepackages    -- cd $_PYSITE
    cdpysite $@
}
complete -o default -o nospace -F _cd__PYSITE_complete cdpysite
complete -o default -o nospace -F _cd__PYSITE_complete cdsitepackages

';

cdpysite () {
    # cdpysite          -- cd $_PYSITE /$@
    [ -z "$_PYSITE" ] && echo "_PYSITE is not set" && return 1
    cd "$_PYSITE"${@:+"/${@}"}
}
_cd__PYSITE_complete () {
    local cur="$2";
    COMPREPLY=($(cdpysite && compgen -d -- "${cur}" ))
}
cdsitepackages () {
    # cdsitepackages    -- cd $_PYSITE
    cdpysite $@
}
complete -o default -o nospace -F _cd__PYSITE_complete cdpysite
complete -o default -o nospace -F _cd__PYSITE_complete cdsitepackages

eval '
cdvar () {
    # cdvar             -- cd $_VAR /$@
    [ -z "$_VAR" ] && echo "_VAR is not set" && return 1
    cd "$_VAR"${@:+"/${@}"}
}
_cd__VAR_complete () {
    local cur="$2";
    COMPREPLY=($(cdvar && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd__VAR_complete cdvar

';

cdvar () {
    # cdvar             -- cd $_VAR /$@
    [ -z "$_VAR" ] && echo "_VAR is not set" && return 1
    cd "$_VAR"${@:+"/${@}"}
}
_cd__VAR_complete () {
    local cur="$2";
    COMPREPLY=($(cdvar && compgen -d -- "${cur}" ))
}
complete -o default -o nospace -F _cd__VAR_complete cdvar

eval '
cdwww () {
    # cdwww             -- cd $_WWW /$@
    [ -z "$_WWW" ] && echo "_WWW is not set" && return 1
    cd "$_WWW"${@:+"/${@}"}
}
_cd__WWW_complete () {
    local cur="$2";
    COMPREPLY=($(cdwww && compgen -d -- "${cur}" ))
}
cdww () {
    # cdww              -- cd $_WWW
    cdwww $@
}
complete -o default -o nospace -F _cd__WWW_complete cdwww
complete -o default -o nospace -F _cd__WWW_complete cdww

';

cdwww () {
    # cdwww             -- cd $_WWW /$@
    [ -z "$_WWW" ] && echo "_WWW is not set" && return 1
    cd "$_WWW"${@:+"/${@}"}
}
_cd__WWW_complete () {
    local cur="$2";
    COMPREPLY=($(cdwww && compgen -d -- "${cur}" ))
}
cdww () {
    # cdww              -- cd $_WWW
    cdwww $@
}
complete -o default -o nospace -F _cd__WWW_complete cdwww
complete -o default -o nospace -F _cd__WWW_complete cdww

eval 'cdls () {
    set | grep "^cd.*()" | cut -f1 -d" " #${@}
}';
cdls () {
    set | grep "^cd.*()" | cut -f1 -d" " #${@}
}
alias cdhelp="cat ${__DOTFILES}/''etc/venv/venv.sh | pyline.py -r '^\\s*#+\\s+.*' 'rgx and l'" ;
if [ "$VENVPREFIX" == "/" ]; then
    source ${__DOTFILES}/etc/venv/scripts/venv_root_prefix.sh
fi

## Grin search
# virtualenv / virtualenvwrapper
grinv() {
    # grinv()   -- grin $VIRTUAL_ENV
    grin --follow $@ "${VIRTUAL_ENV}"
}
grindv() {
    # grindv()  -- grind $VIRTUAL_ENV
    grind --follow $@ --dirs "${VIRTUAL_ENV}"
}

# venv
grins() {
    # grins()   -- grin $_SRC
    grin --follow $@ "${_SRC}"
}
grinds() {
    # grinds()  -- grind $_SRC
    grind --follow $@ --dirs "${_SRC}"
}
grinw() {
    # grinw()   -- grin $_WRD
    grin --follow $@ "${_WRD}"
}
grindw() {
    # grindw()  -- grind $_WRD
    grind --follow $@ --dirs "${_WRD}"
}

edit_grin_w() {
    # edit_grin_w() -- edit $(grinw -l $@)
    edit $(grinw -l $@)
}

egw() {
    # egw           -- edit $(grinw -l $@)
    edit_grin_w $@
}

# ctags
grindctags() {
    # grindctags()      -- generate ctags from grind (in ./tags)
    if [ -n "${__IS_MAC}" ]; then
        # brew install ctags
        if [ -x "/usr/local/bin/ctags" ]; then
            ctagsbin="/usr/local/bin/ctags"
        fi
    else
        # apt-get install exuberant-ctags
        ctagsbin=$(which ctags)
    fi
    (set -x;
    path=${1:-'.'}
    grindargs=${2}
    cd ${path};
    grind --follow ${grindargs} \
        | grep -v 'min.js$' \
        | ${ctagsbin} -L - 2>tags.err && \
    wc -l ${path}/tags.err;
    ls -alhtr ${path}/tags*;)
}
grindctagssys() {
    # grindctagssys()   -- generate ctags from grind --sys-path ($_WRD/tags)
    grindctags "${_WRD}" "--sys-path"
}
grindctagsw() {
    # grindctagsw()     -- generate ctags from (cd $_WRD; grind) ($_WRD/tags)
    grindctags "${_WRD}"
}
grindctagss() {
    # grindctagss()     -- generate ctags from (cd $_SRC; grind) ($_SRC/tags)
    grindctags "${_SRC}"
}

_setup_venv_aliases() {
    # _setup_venv_aliases()  -- load venv aliases
    #   note: these are overwritten by `we` [`source <(venv -b)`]

    source "${__DOTFILES}/scripts/e"
    source "${__DOTFILES}/scripts/ew"

    # makew     -- make -C "${WRD}" ${@}    [scripts/makew <TAB>]
    source "${__DOTFILES}/scripts/makew"

    
    source "${__DOTFILES}/scripts/ssv"
    _setup_supervisord

    # hgw       -- hg -R  ${_WRD}   [scripts/hgw <TAB>]
    source "${__DOTFILES}/scripts/hgw"

    # gitw      -- git -C ${_WRD}   [scripts/gitw <TAB>]
    source "${__DOTFILES}/scripts/gitw"

    # serve-()  -- ${_SERVE_}
    # alias serve-='${_SERVE_}'
    # shell-()  -- ${_SHELL_}
    # alias shell-='${_SHELL_}'
    # test-()   -- cd ${_WRD} && python setup.py test
    alias testpyw='(cd ${_WRD} && python "${_WRD_SETUPY}" test)'
    # testr-()  -- reset; cd ${_WRD} && python setup.py test
    alias testpywr='(reset; cd ${_WRD} && python "${_WRD_SETUPY}" test)'

}
_setup_venv_aliases
#!/usr/bin/env bash
## 
function edit {
    #  edit()   -- EDITOR_ or EDITOR $@
    ${GUIVIMBIN} --servername ${VIRTUAL_ENV_NAME:-"/"} \
        --remote-tab-silent \
        ${@}
    return
}

function e {
    # e()       -- EDTIOR or EDITOR $@
    edit ${@}
    return
}

if [ "${BASH_SOURCE}" == "${0}" ]; then
    edit ${@}
    exit
fi
#!/bin/sh
## 
editwrd () 
{
    #
    (cd $_WRD;
    (for arg in ${@}; do echo "${arg}"; done) \
        | el --each -x 'e {0}'
    )
    return
}

ew () {
    editwrd $@
    return
}
_ew__complete () {
    local cur=${2};
    COMPREPLY=($(cd ${_WRD}; compgen -f -- ${cur}));
}
complete -o default -o nospace -F _ew__complete editwrd
complete -o default -o nospace -F _ew__complete ew

if [ ${BASH_SOURCE} == "${0}" ]; then
    editwrd ${@}
    exit
fi
#!/bin/bash
## 

_makew() {
    # makew()   -- cd $_WRD && make $@
    (cd "${_WRD}" && make ${@})
}
_makew_complete() {
    local cur=${2}
    # see: /usr/local/etc/bash_completion.d/make (brew)
    COMPREPLY=( $( compgen -W "$( make -C ${_WRD} -qp 2>/dev/null | \
    awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ \
    {split($1,A,/ /);for(i in A)print A[i]}' )" \
    -- "$cur" ) )
}
complete -F _makew_complete makew

if [[ ${BASH_SOURCE} == "${0}" ]]; then
    _makew ${@}
fi
#!/bin/sh

##
#  ssv -- a command wrapper for common supervisord commands
#  
#  Variables
#    _SVCFG     -- absolute path to a supervisord.conf file
#      _SVCFG="${VIRTUAL_ENV}/etc/supervisord.conf"  # (default)
#      _SVCFG="${_WRD}/supervisord.conf"
#
#  .. note::  supervisord paths containing ``%(here)s`` evaluate
#      to the (TODO verify) os.realpath of the file.
#      if symlinked from _WRD/supervisord.conf to _ETC/supervisord.conf,
#      paths require an additional upward traversal. 
#      For example::
#
#         # Relative to VIRTUAL_ENV/etc
#         program=%(here)s/../bin/theprogramtorun

#         # Relative to VIRTUAL_ENV/src/<dotfiles>
#         program=%(here)s/../../bin/theprogramtorun
#
#
#  These functions can be utilized in a number of ways:
#
#  * As shell scripts (symlinked to ssv)
#  * As shell functions (``source $__DOTFILES/scripts/ssv``)


function supervisord_sv_create_symlinks() {
    src="${BASH_SOURCE}"
    test -e sv  || ln -s ${src} sv    # supervisorctl $@
    test -e svs || ln -s ${src} svs   # supervisorctl status $@
    test -e svr || ln -s ${src} svr   # supervisorctl restart $@
    test -e svt || ln -s ${src} svt   # supervisorctl tail $@
    test -e svd || ln -s ${src} svd   # sv restart $1:-"dev" && sv tail 'dev'
    test -e sve || ln -s ${src} sve   # EDITOR[_] $_SVCFG
}

function _setup_supervisord() {
    #  _setup_supervisord()      -- set _SVCFG to a supervisord.conf
    local svcfg=${1:-${_SVCFG}}
    if [ -z "${svcfg}" ]; then
        if [ -n "${VIRTUAL_ENV}" ]; then
            local _svcfg="${VIRTUAL_ENV}/etc/supervisord.conf"
        else
            local _svcfg="supervisord.conf"
        fi
        if [ -n "${_svcfg}" ]; then
            svcfg="${_svcfg}"
        fi
    fi
    export _SVCFG="${svcfg}"
}

## 
function supervisord_start() {
    #  supervisord_start()      -- start supervisord -c $_SVCFG
    supervisord -c "${_SVCFG}"
    return
}
function ssv() {
    #  ssv()                    -- start supervisord -c $_SVCFG
    supervisord_start $@
    return
}
function sv() {
    #  sv()                     -- supervisorctl -c $_SVCFG
    supervisorctl -c "${_SVCFG}" ${@}
    return
}
function svs() {
    #  svs()                    -- sv status $@
    sv status ${@}
    return
}
function svr() {
    #  svr()                    -- sv restart $@
    sv restart ${@}
    return
}

function svd() {
    # svd()                     -- sv restart ${1:-"dev"} && sv tail -f ${1:-"dev"}
    name=${1:-"dev"}
    sv restart "${name}" && sv tail -f "${name}"
}

function svt() {
    # svt()                     -- sv tail -f
    name=${1}
    sv tail -f ${name}
}

function sve() {
    #  sve()                    -- $EDITOR[_] $_SVCFG
    ${EDITOR_:-${EDITOR}} ${1:-${_SVCFG}}
}



function supervisord_stop() {
    #  supervisord_start()      -- start supervisord
    supervisorctl -c "${_SVCFG}" "shutdown"
    return
}

# echo "${BASH_SOURCE}"
# echo "${0}"

if [[ "${BASH_SOURCE}" == "${0}" ]]; then
    _setup_supervisord

    cmd=$(basename "${0}")
    echo "cmd: ${cmd}"

    case "${cmd}" in
        sve)
            sve ${@}
            ;;
        ssv)
            supervisord_start ${@}
            ;;
        sv)
            sv ${@}
            ;;
        svd)
            svd ${@}
            ;;
        svt)
            svt ${@}
            ;;
        svs)
            svs ${@}
            ;;
    esac
    exit
fi
#!/bin/sh
## 
function __hgw() {
    #  hgw()                    -- hg -R "${_WRD}" $@
    hg -R "${_WRD}" $@
}

# see: /mercurial/contrib/bash_completion
complete -o bashdefault -o default -o nospace -F _hg hgw \
    || complete -o default -o nospace -F _hg hgw

if [[ ${BASH_SOURCE} == "${0}" ]]; then
    __hgw ${@}
fi
#!/bin/
## 
function gitw () {
    #  gitw()                    -- git -C "${_WRD}" $@
    git -C "${_WRD}" $@
}
declare -f '__git_complete' 2>&1 >/dev/null && __git_complete gitw __git_main
declare -f '__git_complete' 2>&1 >/dev/null && __git_complete gitkw __gitk_main

if [[ ${BASH_SOURCE} == "${0}" ]]; then
    gitw ${@}
fi


_setup_venv_prompt() {
    # _setup_venv_prompt()    -- set PS1 with $WINDOW_TITLE, $VIRTUAL_ENV_NAME,
    #                          and ${debian_chroot}
    #           "WINDOW_TITLE (venvprompt) [debian_chroot]"
    # try: _APP, VIRTUAL_ENV_NAME, $(basename VIRTUAL_ENV)
    local venvprompt=""
    venvprompt=${_APP:-${VIRTUAL_ENV_NAME:-${VIRTUAL_ENV:+"$(basename $VIRTUAL_ENV)"}}}
    # TODO: CONDA
    export VENVPROMPT="${venvprompt:+"($venvprompt) "}${debian_chroot:+"[$debian_chroot] "}${WINDOW_TITLE:+"$WINDOW_TITLE "}"
    if [ -n "$BASH_VERSION" ]; then
        if [ "$color_prompt" == yes ]; then
            PS1='${VENVPROMPT}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
        else
            PS1='${VENVPROMPT}\u@\h:\w\n\$ '
            unset color_prompt
        fi
    fi
}
_setup_venv_prompt



venv_ls() {
    # venv_ls()     -- list virtualenv directories
    prefix=${1:-${VIRTUAL_ENV}}
    if [ -z "${prefix}" ]; then
        return
    fi
    #ls -ld ${prefix}/**
    ls -ld $(find ${prefix} ${prefix}/lib -type d -maxdepth 2)
}
lsvenv() {
    # lsvenv()      -- venv_ls()
    venv_ls $@
}

venv_mkdirs() {
    # venv_mkdirs()  -- create FSH paths in ${1} or ${VIRTUAL_ENV} 
    prefix=${1:-${VIRTUAL_ENV}}
    if [ -z "${prefix}" ]; then
        return
    fi
    ensure_mkdir ${prefix}
    ensure_mkdir ${prefix}/bin
    ensure_mkdir ${prefix}/etc
    #ensure_mkdir ${prefix}/home
    ensure_mkdir ${prefix}/lib
    #ensure_mkdir ${prefix}/opt
    #ensure_mkdir ${prefix}/sbin
    #ensure_mkdir ${prefix}/share/doc
    ensure_mkdir ${prefix}/src
    #ensure_mkdir ${prefix}/srv
    ensure_mkdir ${prefix}/tmp
    ensure_mkdir ${prefix}/usr/share/doc
    ensure_mkdir ${prefix}/var/cache
    ensure_mkdir ${prefix}/var/log
    ensure_mkdir ${prefix}/var/run
    ensure_mkdir ${prefix}/var/www

    venv_ls
}


### bashrc.venv.pyramid.sh

workon_pyramid_app() {
    # workon_pyramid_app()  -- $VIRTUAL_ENV_NAME [$_APP] [open_terminals]
    _VENVNAME=$1
    _APP=$2

    _OPEN_TERMS=${3:-""}

    _VENVCMD="workon ${_VENVNAME}"
    we "${_VENVNAME}" "${_APP}"

    export _EGGSETUPPY="${_WRD}/setup.py"
    export _EGGCFG="${_WRD}/development.ini"

    _EDITCFGCMD="${_EDITCMD} ${_EGGCFG}"
    _SHELLCMD="${_BIN}/pshell ${_EGGCFG}"
    _SERVECMD="${_BIN}/pserve --reload --monitor-restart ${_EGGCFG}"
    _TESTCMD="python ${_EGGSETUPPY} nosetests"

    alias _serve="${_SERVECMD}"
    alias _shell="${_SHELLCMD}"
    alias _test="${_TESTCMD}"
    alias _editcfg="${_EDITCFGCMD}"
    alias _glog="hgtk -R "${_WRD}" log"
    alias _log="hg -R "${_WRD}" log"

    if [ -n "${_OPEN_TERMS}" ]; then
        ${EDITOR} "${_WRD}" &
        #open tabs
        #gnome-terminal \
        #--working-directory="${_WRD}" \
        #--tab -t "${_APP} serve" -e "bash -c \"${_SERVECMD}; bash -c \"workon_pyramid_app $VIRTUAL_ENV_NAME $_APP 1\"\"" \
        #--tab -t "${_APP} shell" -e "bash -c \"${_SHELLCMD}; bash\"" \
        #--tab -t "${_APP} bash" -e "bash"
    fi
}



### bashrc.editor.sh

_setup_editor() {
    # setup_editor()    -- configure ${EDITOR}
    #   VIMBIN  (str):   /usr/bin/vim
    #   GVIMBIN (str):   /usr/bin/gvim
    #   MVIMBIN (str):   /usr/local/bin/mvim
    #   GUIVIMBIN (str): $GVIMBIN || $MVIMBIN || ""
    #   EDITOR  (str):   $VIMBIN -f || $GUIVIMBIN -f
    #   EDITOR_ (str):   $EDITOR || $GUIVIMBIN $VIMCONF --remote-tab-silent
    #   VIMCONF (str):   --servername ${VIRTUAL_ENV_NAME:-'EDITOR'}
    #   SUDO_EDITOR (str): $EDITOR
    export VIMBIN="/usr/bin/vim"
    export GVIMBIN="/usr/bin/gvim"
    export MVIMBIN="/usr/local/bin/mvim"
    export GUIVIMBIN=""
    if [ -x ${GVIMBIN} ]; then
        export GUIVIMBIN=$GVIMBIN
    elif [ -x ${MVIMBIN} ]; then
        export GUIVIMBIN=$MVIMBIN
    fi

    export EDITOR="${VIMBIN} -f"
    export EDITOR_="${EDITOR}"
    export SUDO_EDITOR="${VIMBIN} -f"

    if [ -n "${GUIVIMBIN}" ]; then
        export VIMCONF="--servername ${VIRTUAL_ENV_NAME:-"/"}"
        export EDITOR="${GUIVIMBIN} -f"
        export EDITOR_="${GUIVIMBIN} ${VIMCONF} --remote-tab-silent"
        export SUDO_EDITOR="${GUIVIMBIN} -f"
        alias gvim="${GUIVIMBIN}"
    else
        unset -f $GVIMBIN
        unset -f $MVIMBIN
        unset -f $USEGVIM
    fi

    export _EDITOR="${EDITOR}"
}
_setup_editor


_setup_pager() {
    # _setup_pager()    -- set PAGER='less'
    export PAGER='/usr/bin/less -R'
}
_setup_pager


ggvim() {
    # ggvim()   -- ${EDITOR} $@ 2>&1 >/dev/null
    ${EDITOR} $@ 2>&1 > /dev/null
}


edits() {
    # edits()   -- open $@ in ${GUIVIMBIN} --servername $1
    servername=$1
    shift
    ${GUIVIMBIN} --servername ${servername} --remote-tab $@
}


editcfg() {
    # editcfg() -- ${EDITOR_} ${_CFG} [ --servername $VIRTUAL_ENV_NAME ]
    e ${_CFG}
}

sudoe() {
    # sudoe()   -- EDITOR=${SUDO_EDITOR} sudo -e
    EDITOR="${SUDO_EDITOR}" sudo -e $@
}
sudovim() {
    # sudoe()   -- EDITOR=${SUDO_EDITOR} sudo -e
    sudoe $@
}

### bashrc.vimpagers.sh

_configure_lesspipe() {
    # _configure_lesspipe() -- (less <file.zip> | lessv)
    lesspipe=$(which lesspipe.sh 2>/dev/null || false)
    if [ -n "${lesspipe}" ]; then
        eval "$(${lesspipe})"
    fi
}
_configure_lesspipe


vimpager() {
    # vimpager() -- call vimpager
    _PAGER=$(which vimpager)
    if [ -x "${_PAGER}" ]; then
        ${_PAGER} $@
    else
        echo "error: vimpager not found. (see lessv: 'lessv $@')"
    fi
}


lessv () {
    # lessv()   -- less with less.vim and vim (g:tinyvim=1)
    if [ -t 1 ]; then
        if [ $# -eq 0 ]; then
            if [ -n "$VIMPAGER_SYNTAX" ]; then
                #read stdin
                ${VIMBIN} --cmd "let g:tinyvim=1" \
                    --cmd "runtime! macros/less.vim" \
                    --cmd "set nomod" \
                    --cmd "set noswf" \
                    -c "set colorcolumn=0" \
                    -c "map <C-End> <Esc>G" \
                    -c "set syntax=${VIMPAGER_SYNTAX}" \
                    -
            else
                ${VIMBIN} --cmd "let g:tinyvim=1" \
                    --cmd "runtime! macros/less.vim" \
                    --cmd "set nomod" \
                    --cmd "set noswf" \
                    -c "set colorcolumn=0" \
                    -c "map <C-End> <Esc>G" \
                    -
            fi
        elif [ -n "$VIMPAGER_SYNTAX" ]; then
            ${VIMBIN} \
                --cmd "let g:tinyvim=1" \
                --cmd "runtime! macros/less.vim" \
                --cmd "set nomod" \
                --cmd "set noswf" \
                -c "set colorcolumn=0" \
                -c "map <C-End> <Esc>G" \
                -c "set syntax=${VIMPAGER_SYNTAX}" \
                ${@}

        else
            ${VIMBIN} \
                --cmd "let g:tinyvim=1" \
                --cmd "runtime! macros/less.vim" \
                --cmd "set nomod" \
                --cmd "set noswf" \
                -c "set colorcolumn=0" \
                -c "map <C-End> <Esc>G" \
                ${@}
        fi
    else
        #Output is not a terminal, cat arguments or stdin
        if [ $# -eq 0 ]; then
            less
        else
            less $@
        fi
    fi
}

lessg() {
    # lessg()   -- less with less.vim and gvim / mvim
    VIMBIN=${GUIVIMBIN} lessv $@
}

lesse() {
    # lesse()   -- less with current venv's vim server
    ${EDITOR_} $@
}

manv() {
    # manv()    -- view manpages in vim
    alias man_="/usr/bin/man"
    if [ $# -eq 0 ]; then
        /usr/bin/man
    else
        #/usr/bin/whatis "$@" >/dev/null
        $(which vim) \
            --noplugin \
            -c "runtime ftplugin/man.vim" \
            -c "Man $*" \
            -c 'silent! only' \
            -c 'nmap q :q<CR>' \
            -c 'set nomodifiable' \
            -c 'set colorcolumn=0'
    fi
}

mang() {
    # mang()    -- view manpages in gvim / mvim
    if [ $# -eq 0 ]; then
        /usr/bin/man
    else
        ${GUIVIMBIN} \
            --noplugin \
            -c "runtime ftplugin/man.vim" \
            -c "Man $*" \
            -c 'silent! only' \
            -c 'nmap q :q<CR>' \
            -c 'set nomodifiable' \
            -c 'set colorcolumn=0'
    fi
}

mane() {
    # mane()    -- open manpage with venv's vim server
    ${GUIVIMBIN} ${VIMCONF} --remote-send "<ESC>:Man $@<CR>"
}

### bashrc.usrlog.sh
    # _USRLOG (str): path to .usrlog userspace shell command log
    # stid()      -- set $TERM_ID to a random string
    # stid $name  -- set $TERM_ID to string
    # note()      -- add a dated note to $_USRLOG [_usrlog_append]
    # usrlogv()   -- open usrlog with vim:   $VIMBIN + $_USRLOG
    # usrlogg()   -- open usrlog with gmvim: $GUIVIMBIN + $_USRLOG
    # usrloge()   -- open usrlog with editor:$EDITOR + $_USRLOG
    # ut()        -- tail $_USRLOG
    # ug()        -- egrep current usrlog: egrep $@ $_USRLOG
    # ugall()     -- egrep $@ $__USRLOG ${WORKON_HOME}/*/.usrlog
    # ugrin()     -- grin current usrlog: grin $@ $_USRLOG
    # ugrinall()  -- grin $@  $__USRLOG ${WORKON_HOME}/*/.usrlog
    # lsusrlogs() -- ls -tr   $__USRLOG ${WORKON_HOME}/*/.usrlog

_setup_usrlog() {
    # _setup_usrlog()   -- source ${__DOTFILES}/etc/usrlog.sh
    source "${__DOTFILES}/scripts/usrlog.sh"
    #calls _usrlog_setup when sourced
}
_setup_usrlog
#!/bin/sh
### usrlog.sh -- Shell CLI REPL command logs in userspace (per $VIRTUAL_ENV)
#
#  Log shell commands with metadata as tab-separated lines to ${_USRLOG}
#  with a shell identifier to differentiate between open windows,
#  testing/screencast flows, etc
#
#  By default, _USRLOG will be set to a random string prefixed with '#'
#  by the `stid()` bash function (`_usrlog_set__TERM_ID()`)
#
#  * _TERM_ID can be set to any string;
#  * _TERM_ID is displayed in the PS1 prompt
#  * _TERM_ID is displayed in the window title
#  * _TERM_ID is reset to __TERM_ID upon 'deactivate'
#    (westurner/dotfiles//etc/bash/07-bashrc.virtualenvwrapper.sh:
#     TODO: virtualenvwrapper, conda)
#
#  Environment Variables:
#
#   __USRLOG (str): default -usrlog.log file (~/-usrlog.log)
#   _USRLOG  (str): current -usrlog.log file to append REPL command strings to
#   _TERM_ID (str): a terminal identifier with which command loglines will
#                   be appended (default: _usrlog_randstr)
#

function _usrlog_get_prefix  {
    #  _usrlog_get_prefix()    -- get a dirpath for the current usrlog
    #                             (VIRTUAL_ENV or HOME)
    local prefix="${VENVPREFIX:-${VIRTUAL_ENV:-${HOME}}}"
    if [ "${prefix}" == "/" ]; then
        prefix=$HOME
    fi
    echo "$prefix"
}

function _usrlog_set__USRLOG  {
    #  _usrlog_set__USRLOG()    -- set $_USRLOG (and $__USRLOG)
    export __USRLOG="${HOME}/-usrlog.log"
    prefix="$(_usrlog_get_prefix)"
    export _USRLOG="${prefix}/-usrlog.log"

}

function _usrlog_set_HISTFILE  {
    #  _usrlog_set_HISTFILE()   -- configure shell history
    prefix="$(_usrlog_get_prefix)"

    #   history -a   -- append any un-flushed lines to $HISTFILE
    history -a

    if [ -n "$ZSH_VERSION" ]; then
        export HISTFILE="${prefix}/.zsh_history"
    elif [ -n "$BASH" ]; then
        export HISTFILE="${prefix}/.bash_history"
    else
        export HISTFILE="${prefix}/.history"
    fi

    #   history -c && history -r $HISTFILE   -- clear; reload $HISTFILE
    history -c && history -r $HISTFILE
}

function _usrlog_set_HIST {
    #  _usrlog_set_HIST()    -- set shell $HIST<...> variables

    #  see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=1000000

    #avoid duplicating datetimes in .usrlog
    #HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%z" (iso8601)
    #HISTTIMEFORMAT="%t%Y-%m-%dT%H:%M:%S%z%t"
    #  note that HOSTNAME and USER come from the environ
    #  and MUST be evaluated at the time HISTTIMEFORMAT is set.
    HISTTIMEFORMAT="%t%Y-%m-%dT%H:%M:%S%z%t${HOSTNAME}%t${USER}%t\$\$%t"  #  %n  "

    #don't put duplicate lines in the history. See bash(1) for more options
    #  ... or force ignoredups and ignorespace
    #  HISTCONTROL=ignoredups:ignorespace
    HISTCONTROL=ignoredups:ignorespace

    #  append current lines to history
    history -a

    _usrlog_set_HISTFILE

    if [ -n "$BASH" ] ; then
        #  append to the history file, don't overwrite it
        #  https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#The-Shopt-Builtin
        shopt -s histappend > /dev/null 2>&1
        #  replace newlines with semicolons
        shopt -s cmdhist > /dev/null 2>&1
        shopt -s lithist > /dev/null 2>&1

        #  enable autocd (if available)
        shopt -s autocd > /dev/null 2>&1
    elif [ -n "$ZSH_VERSION" ]; then
        setopt APPEND_HISTORY
        setopt EXTENDED_HISTORY
    fi
}

function _usrlog_randstr {
    #  _usrlog_randstr      -- Generate a random string
    #    $1: number of characters

    if [[ `uname -s` == "Darwin" ]]; then
        echo $(dd if=/dev/urandom bs=1 count=$1 2>/dev/null |
                base64 -b 0 |
                rev |
                cut -b 2- |
                tr '/+' '0' |
                rev)
    else
        echo $(dd if=/dev/urandom bs=1 count=$1 2>/dev/null |
                base64 -w 0 |
                rev |
                cut -b 2- |
                tr '/+' '0' |
                rev)
            fi
}

function _usrlog_get__TERM_ID {
    #  _usrlog_get__TERM_ID()   -- echo the current _TERM_ID and $_USRLOG
    echo "#  _TERM_ID="$_TERM_ID" # [ $_USRLOG ]" >&2
    echo $_TERM_ID
}

function _usrlog_set__TERM_ID  {
    #  _usrlog_Set__TERM_ID     -- set or randomize the $_TERM_ID key
    #    $1: terminal name
    new_term_id="${@}"
    if [ -z "${new_term_id}" ]; then
        new_term_id="#$(_usrlog_randstr 8)"
    fi
    if [[ "${new_term_id}" != "${_TERM_ID}" ]]; then
        #TODO: _usrlog_append_echo
        if [ -z "${_TERM_ID}" ]; then
            _usrlog_append "#ntid  _TERM_ID=\"${new_term_id}\"  #_USRLOG=\"${_USRLOG}\""
        else
            _usrlog_append "#stid  _TERM_ID=\"${new_term_id}\"  #_TERM_ID__=\"${_TERM_ID}\"  #_USRLOG=\"${_USRLOG}\""
        fi
        export _TERM_ID="${new_term_id}"
        _usrlog_set_title

    fi
}


function _usrlog_echo_title  {
    #  _usrlog_echo_title   -- set window title (by echo'ing escape codes)
    local title="${WINDOW_TITLE:+"$WINDOW_TITLE "}"
    if [ -n "$_APP" ]; then
        title="($_APP) ${title}"
    else
        title="${VIRTUAL_ENV_NAME:+"($VIRTUAL_ENV_NAME) ${title}"}"
    fi
    title="${title} ${USER}@${HOSTNAME}:${PWD}"
    USRLOG_WINDOW_TITLE=${title:-"$@"}
    if [ -n $CLICOLOR ]; then
        echo -ne "\033]0;${USRLOG_WINDOW_TITLE}\007"
    #  else
    #     echo -ne "${USRLOG_WINDOW_TITLE}"
    fi
}

function _usrlog_set_title {
    #  _usrlog_set_title()  --  set xterm title
    export WINDOW_TITLE=${1:-"$_TERM_ID"}
    _usrlog_echo_title
    declare -f '_setup_venv_prompt' 2>&1 > /dev/null \
        && _setup_venv_prompt
}


function _usrlog_setup {
    #  _usrlog_setup()      -- configure usrlog for the current shell
    local _usrlog="${1:-$_USRLOG}"
    local term_id="${2:-$_TERM_ID}"

    _usrlog_set_HIST

    _usrlog_set__USRLOG $_usrlog

    #TERM_SED_STR='s/^\s*[0-9]*\s\(.*\)/$_TERM_ID: \1/'
    TERM_SED_STR='s/^\s*[0-9]*\s*//'

    _usrlog_set__TERM_ID $term_id
    touch $_USRLOG

    _usrlog_set_title $_TERM_ID

    #  setup bash
    if [ -n "$BASH" ]; then
        PROMPT_COMMAND="_usrlog_writecmd; _usrlog_echo_title;"
    fi

    #  setup zsh
    if [ -n "$ZSH_VERSION" ]; then
        precmd_functions=(_usrlog_writecmd _usrlog_echo_title)
    fi
}

function _usrlog_append {
    #  _usrlog_append()  -- Write a line to $_USRLOG w/ an ISO8601 timestamp
    #    $1: text (command) to log
    #    note: _TERM_ID must not contain a tab character (tr '\t' ' ')
    #    note: _TERM_ID can be a URN, URL, URL, or simple \w+ str key
    #  example:
    #    2014-11-15T06:42:00-0600	dotfiles	 8311  ls
      #  (pwd -p)?
       #  this from HISTORY
    local cmd="${*}";
    (printf "#  %s\t%s\t%s\t%s\n" \
        "$(date +%Y-%m-%dT%H:%M:%S%z)" \
        "$(echo "${_TERM_ID}" | tr '\t' ' ')" \
        "$(echo "${PWD}" | tr '\t' ' ')" \
        "$(echo "${cmd}" | tr '\n' ' ')" \
        ) >> "${_USRLOG:-${__USRLOG}}" 2>/dev/null
    printf "%s\n" \
        "$(echo "${cmd}" | sed 's|.*	$$	\(.*\)|#  \1|g')"
}

function _usrlog_append_oldstyle {
    #  _usrlog_append_oldstype -- Write a line to $_USRLOG
    #    $1: text (command) to log
    #  examples:
    #    # qMZwZSGvJv8: 10/28/14 17:25.54 :::   522  histgrep BUG
    #    #ZbH08n8unY8	2014-11-11T12:27:22-0600	 2238  ls
    printf "#  %-11s: %s : %s" \
        "$_TERM_ID" \
        "$(date +'%D %R.%S')" \
        "${1:-'\n'}" \
            | tee -a $_USRLOG >&2
}


function _usrlog_writecmd {
    #  _usrlog_writecmd()    -- write the most recent command to $_USRLOG
    _usrlog_set_HISTFILE

    if [ -n "$ZSH_VERSION" ]; then
        id 2>&1 > /dev/null
        _cmd=$(fc -l -1 | sed -e $TERM_SED_STR)
    elif [ -n "$BASH" ]; then
        _cmd=$(history 1 | sed -e $TERM_SED_STR)
    else
        _cmd=$(history 1 | sed -e $TERM_SED_STR)
    fi
    _usrlog_append "${_cmd}"
}




function _usrlog_parse_newstyle {
    #  _usrlog_parse_newstyle -- Parse a newstyle HISTTIMEFORMAT usrlog
    #  with pyline
    #  TODO: handle HISTTIMEFORMAT="" (" histn  <cmd>")
    #  TODO: handle newlines
    local usrlog="${1}"
    if [ -n "${usrlog}" ]; then
        if [ "${usrlog}" != "-" ]; then
            usrlog="-f ${usrlog}"
        fi
    fi
    pyline.py ${usrlog} \
        -m collections \
        '[collections.OrderedDict((
            ("l", [l]),
            ("date", w[0].lstrip("#  ")),
            ("id", w[1]),
            ("path", w[2]),
            ("histstr", w[3:]),
            ("histn", w[3].strip()),    #  int or "#note"
            ("histdate", (w[4] if len(w) > 4 else None)),
            ("histhostname", (w[5] if len(w) > 5 else None)),
            ("histuser", (w[6] if len(w) > 6 else None)),
            ("histcmd", (w[8:] if len(w) > 8 else None)),
            ))
            for w in [ line.split("\t",8) ]
                if len(w) >= 4]' \
                    -O json
}


function _usrlog_parse_cmds {
    #  _usrlog_parse_cmds -- Show histcmd or histstr from HISTTIMEFORMAT usrlog
    #  with pyline
    #  TODO: handle HISTTIMEFORMAT="" (" histn  <cmd>")
    #  TODO: handle newlines (commands that start on the next line)
    #  TODO: HISTTIMEFORMAT histn (OSX  ) [ 8 ]
    #  TODO: HISTTIMEFORMAT histn (Linux) [ 7 ]
    local usrlog="${1}"
    if [ -n "${usrlog}" ]; then
        if [ "${usrlog}" != "-" ]; then
            usrlog="-f ${usrlog}"
        fi
    fi
    pyline.py ${usrlog} \
        'list((
            (" ".join(w[8:]).rstrip() if len(w) > 8 else None)
            or (" ".join(w[7:]).rstrip() if len(w) > 7 else None)
            or (" ".join(w[3:]).rstrip() if len(w) > 3 else None)
            or " ".join(w).rstrip())
            for w in [ line and line.startswith("#") and line.split("\t",8) or [line] ]
            )'
}
function ugp {
    _usrlog_parse_cmds ${@}
}



## usrlog.sh API
function ut {
    #  ut()  -- show recent commands
    usrlog_tail $@ | _usrlog_parse_cmds
}



function termid {
    #  termid()      -- echo $_TERM_ID
    _usrlog_get__TERM_ID
}


function set_term_id {
    #  set_term_id() -- set $_TERM_ID to a randomstr or $1
    _usrlog_set__TERM_ID $@
}

function stid {
    #  stid()        -- set $_TERM_ID to a randomstr or $1
    _usrlog_set__TERM_ID $@
}
function st {
    #  st()          -- set $_TERM_ID to a randomstr or $1
    _usrlog_set__TERM_ID $@
}


## Old (hist, histgrep, histgrep_session)

function hist {
    #  less()       --  less the current session log
    less $_USRLOG
}


function histgrep  {
    #  histgrep()   -- egrep $@ $_USRLOG
    egrep $@ $_USRLOG
}

function histgrep_session  {
    #  histgrep_session()    -- grep for specific sessions
    #    $1: session name
    #    $2: don't strip the line prefix
    NO_STRIP_LINE_PREFIX=$2
    #echo $_USRLOG >&2
    cat $_USRLOG | egrep "$1 .* \:\:\:|Renaming .* to $1" | \
        if [ -n $NO_STRIP_LINE_PREFIX ]; then
            sed -e 's/^\s*.*\:\:\:\s\(.*\)/\1/'
        else
            cat
        fi
}

## New (u*, usrlog*)

function usrlog_tail {
    #  usrlog_tail()     -- tail -n20 $_USRLOG
    if [ -n "$@" ]; then
        _usrlog=${@:-${_USRLOG}}
        tail ${_usrlog}
    else
        tail $_USRLOG
    fi
}

function usrlog_tail_follow {
    #  usrlogtf()    -- tail -f -n20 $_USRLOG
    tail -f -n20 ${@:-"${_USRLOG}"}
}
function utf {
    #  utf()         -- tail -f -n20 $_USRLOG
    usrlog_tail_follow $@
}


function usrlog_grep {
    #  usrlog_grep() -- egrep -n $_USRLOG
    set -x
    args=${@}
    egrep -n "${args}" "${_USRLOG}"
    set +x
}
function ug {
    #  ug()          -- egrep -n $_USRLOG
    usrlog_grep ${@}
}

#function usrlog_grep_session_id {
#     # usrlog_grep_session_id()  -- egrep ".*\t${1:-$_TERM_ID}"
#     (set -x;
#     local _term_id=${1:-"${_TERM_ID}"};
#     local _usrlog=${2:-"${_USRLOG}"};
#     egrep "# [\d-T:Z ]+\t${_term_id}\t" ${_USRLOG} )
#}

function _usrlog_grep_venvs {
    egrep ${@} '((we[c]?)|workon|workon_conda|mkvirtualenv|mkvirtualenv_conda|rmvirtualenv|rmvirtualenv_conda)[ ;]'

}
function usrlog_grep_venvs {
    cat ${@:-${_USRLOG}} | _usrlog_grep_venvs
}
function ugv {
    usrlog_grep_venvs ${@}
}

function _usrlog_grep_todo_fixme_xxx {
    grep -E -i '(todo|fixme|xxx)'
}
function _usrlog_grep_todos {
    grep '$$'$'\t''#\(TODO\|NOTE\)'
}
function usrlog_grep_todos {
    cat ${@:-${_USRLOG}} | _usrlog_grep_todos
}
function uggt {
    usrlog_grep_todos ${@}
}

function usrlog_grep_todos_parse {
    usrlog_grep_todos ${@} | _usrlog_parse_cmds
}

function ugtp {
    # usrlog_grep_todos | _usrlog_parse_cmds
    uggt $@ | ugp
}

function usrlog_format_as_txt {
    sed 's/^#TODO: /- [ ] /' \
        | sed 's/^#NOTE: /- /'
    # pyline '(l.replace("#TODO: ", "- [ ] ", 1).replace("#NOTE:", "- ", 1) if l.startswith("#TODO: ", "#NOTE: ") else l)'
}

function ugft {
    usrlog_format_as_txt "${@}"
}

function ugt {
    #usrlog_grep_todos_parse | usrlog_format_as_txt
    ugtp | ugft
}

function usrlog_grin {
    #  usrlog_grin() -- grin -s $@ $_USRLOG
    local args=${@}
    (set -x;
    grin -s "${args}" "${_USRLOG}")
}
function ugrin  {
    #  ugrin()       -- grin -s $@ $_USRLOG
    usrlog_grin ${@}
}


function usrlog_grin_session_id {
    #  usrlog_grin_session_id()  -- egrep ".*\t${1:-$_TERM_ID}"
    (set -x;
    local _term_id="${1:-"${_TERM_ID}"}";
    local _usrlog="${2:-"${_USRLOG}"}";
    grin -s '#  [\d\-:TZ\s]+\t'${_term_id}'\t(.*)$' ${_usrlog} --no-color;);
}


function usrlog_grin_session_id_cmds {
    #  usrlog_grin_session_id()  -- egrep ".*\t${1:-$_TERM_ID}"
    (set -x;
    local _term_id="${1:-"${_TERM_ID}"}";
    local _usrlog="${2:-"${_USRLOG}"}";
    grin -N --no-color --without-filename -s \
        '#  [\d\-:TZ\s]+\t'${_term_id}'\t(.*)$' \
        "${_usrlog}" \
            | _usrlog_parse_cmds -  ;
    );
}


function usrlog_grin_session_id_all {
    #  usrlog_grin_session_id_all()  -- grep $2:-$_USRLOG for $1:-$_TERM_ID
    #                                   in column position
    #    :returns: unsorted list of log entries in files
    #              listed by mtime and then cat
    #
    #  .. warning:: output lines are in file sequence but otherwise
    #                unsorted
    #
    (set -x;
    local _term_id=${1:-"${_TERM_ID}"}; \
    local _usrlog=${2:-"${_USRLOG}"}; \
    local _usrlogs=$(lsusrlogs_date_desc);
    grin -s     '#  [\d\-:TZ\s]+\t'${_term_id}'\t' ${_usrlogs} --no-color;)
}
function ugrins  {
    #  ugrins()  -- grep $2:-$_USRLOG for $1:-$_TERM_ID in column position
    usrlog_grin_session_id_all ${@}
}

function usrlog_grin_session_id_all_cmds {
    #  usrlog_grin_session_id_all_cmds()  -- grep $2:-$_USRLOG for $1:-$_TERM_ID
    #                                        in column position
    (set -x;
    local _term_id=${1:-"${_TERM_ID}"}; \
    local _usrlog=${2:-"${_USRLOG}"}; \
    local _usrlogs=$(lsusrlogs_date_asc);
    grin -N --no-color --without-filename -s \
        '#  [\d\-:TZ\s]+\t'${_term_id}'\t' \
        "${_usrlogs}" \
        | _usrlog_parse_cmds -  ;
    );
}


function lsusrlogs_date_desc {
    #  lsusrlogs_date_desc()   -- ls $__USRLOG ${WORKON_HOME}/*/.usrlog
    #                             (oldest first)
    ls -tr \
        "${__USRLOG}" \
        ${WORKON_HOME}/*/.usrlog \
        ${WORKON_HOME}/*/-usrlog.log $@
}
function lsusrlogs_date_asc {
    #  lsusrlogs_date_desc()   -- ls $__USRLOG ${WORKON_HOME}/*/.usrlog
    #                             (newest first)
    ls -t \
        "${__USRLOG}" \
        ${WORKON_HOME}/*/.usrlog \
        ${WORKON_HOME}/*/-usrlog.log $@
}
function lsusrlogs  {
    #  lsusrlogs()             -- list usrlogs (oldest first)
    lsusrlogs_date_desc $@
}

function usrlog_lately {
    #  usrlog_lately()      -- lsusrlogs by mtime
    lsusrlogs_date_desc $@ | xargs ls -ltr
}
function ull {
    #  ull()                -- usrlog_lately() (lsusrlogs by mtime)
    usrlog_lately $@
}

function usrlog_grep_all {
    #  usrlog_grep_all()    -- grep usrlogs (drop filenames with -h)
    (set -x;
    args="${@}"
    usrlogs=$(lsusrlogs)
    egrep ${args} ${usrlogs} \
        | sed 's/:/'$'\t''/')
       #| pyline.py 'l.replace(":","\t",1)'  # grep filename output
}
function ugall {
    #  ugall()              -- grep usrlogs (drop filenames with -h)
    usrlog_grep_all "${@}"
}

function usrlog_grin_all {
    #  usrlog_grin_all()    -- grin usrlogs
    (set -x;
    args="${@}"
    usrlogs=$(lsusrlogs)
    grin --no-skip-hidden-files ${args} ${usrlogs} \
        | sed 's/:/'$'\t''/' \
        | grin ${args})
}
function ugrinall {
    #  usrlog_grin_all()    -- grin usrlogs
    usrlog_grin_all "${@}"
}

function note {
    #  note()   -- _usrlog_append "#note  #note: $@"
    startstr="#NOTE	$(date +'%FT%T%z')	${HOSTNAME}	${USER}	\$$	"
    #_usrlog_append "#note  #note: $@"  # old style
    _usrlog_append "${startstr}#NOTE: ${@}"
}
function todo {
    #  todo()   -- _usrlog_append "#note  #TODO: $@"
    startstr="#TODO	$(date +'%FT%T%z')	${HOSTNAME}	${USER}	\$$	"
    #_usrlog_append "#note  #note: $@"
    _usrlog_append "${startstr}#TODO: ${@}"
}

function usrlog_screenrec_ffmpeg {
    #  usrlog_screenrec_ffmpeg() -- record a screencast
    #    $1: destination directory (use /tmp if possible)
    #    $2: video name to append to datestamp
    #    - Press "q" to stop recording
    DATESTR=$(date +%Y%m%d-%H%M)
    FILEBASE="screenrec-${DATESTR}"
    if [ -z "$2" ]; then
        FILENAME="$1/${FILEBASE}_unnamed.mpg"
    else
        FILENAME="$1/${FILEBASE}_${2}.mpg"
    fi
    SCREENDIM="$(xdpyinfo | grep 'dimensions:'| awk '{print $2}')"
    ffmpeg \
        -f x11grab \
        -s "$SCREENDIM" \
        -r 25
        -i 0:0 \
        -sameq "$FILENAME" \
            2>&1 | tee "$FILENAME.log"
}

function _setup_usrlog {
    #  _setup_usrlog() -- call _usrlog_setup $@
    _usrlog_setup $@
}

## calls _usrlog_setup when sourced
_usrlog_setup
]0;(dotfiles) #testing  wturner@mb1:/home/wturner/-wrk/-ve27/dotfiles/src/dotfiles

usrlogv() {
    # usrlogv() -- open $_USRLOG w/ $VIMBIN (and skip to end)
    file=${1:-$_USRLOG}
    lessv + ${file}
}

usrlogg() {
    # usrlogg() -- open $_USRLOG w/ $GUIVIMBIN (and skip to end)
    file=${1:-$_USRLOG}
    lessg + ${file}
}

usrloge() {
    # usrloge() -- open $_USRLOG w/ $EDITOR_ [ --servername $VIRTUAL_ENV_NAME ]
    file=${1:-$_USRLOG}
    lesse "+ ${file}"
}

### 30-bashrc.xlck.sh
## xlck     -- minimal X screensaver
    # xlck 
    # xlck -I  --  (I)nstall xlck (apt-get)
    # xlck -U  --  check stat(U)s (show xautolock processes on this $DISPLAY)
    # xlck -S  --  (S)tart xlck (start xautolock on this $DISPLAY)
    # xlck -P  --  sto(P) xlck (stop xautolock on this $DISPLAY)
    # xlck -R  --  (R)estart xlck
    # xlck -M  --  suspend to ra(M) (and lock)
    # xlck -D  --  suspend to (D)isk (and lock)
    # xlck -L  --  (L)ock
    # xlck -X  --  shutdown -h now
    # xlck -h  --  help
    # xlck_status_all()             -- pgrep 'xautolock|xlock|i3lock', ps ufw
    # xlck_status_this_display()    -- show status for this $DISPLAY

_setup_xlck() {
    # _setup_xlck() -- source ${__DOTFILES}/etc/xlck.sh (if -z __IS_MAC)
    if [ -z "${__IS_MAC}" ]; then
        source "${__DOTFILES}/scripts/xlck.sh"
    fi
}


### bashrc.aliases.sh

#annotate this file with comments
#cat ./40-bashrc.aliases.sh | pyline -r '(\s*?)alias\s(.*?)=(.*)' '(rgx and "{}# {:<8} -- {}\n{}".format(rgx.groups()[0], rgx.groups()[1], rgx.groups()[2], l)) or l'

_loadaliases () {
    #  _load_aliases()  -- load aliases
    # chmodr   -- 'chmod -R'
    alias chmodr='chmod -R'
    # chownr   -- 'chown -R'
    alias chownr='chown -R'

    # grep     -- 'grep --color=auto'
    alias grep='grep --color=auto'
    # egrep    -- 'egrep --color=auto'
    alias egrep='egrep --color=auto'
    # fgrep    -- 'fgrep --color=auto'
    alias fgrep='fgrep --color=auto'

    # grindp   -- 'grind --sys.path'
    alias grindp='grind --sys.path'
    # grinp    -- 'grin --sys-path'
    alias grinp='grin --sys-path'

    # fumnt    -- 'fusermount -u'
    alias fumnt='fusermount -u'

    # ga       -- 'git add'
    alias ga='git add'

    gac () {
    # gac()    -- 'git diff ${files}; git commit -m $1 ${files}'
    #   $1 (str): quoted commit message
    #   $2- (list): file paths
        local msg=${1:-""}
        shift
        local files=$@
        git diff ${files}
        if [ -n "${msg}" ]; then
            git commit ${files} -m "${msg}"
        fi
    }
    # gb       -- 'git branch -v'
    alias gb='git branch -v'
    # gd       -- 'git diff'
    alias gd='git diff'
    # gds      -- 'git diff -p --stat'
    alias gds='git diff -p --stat'
    # gc       -- 'git commit'
    alias gc='git commit'
    # gco      -- 'git checkout'
    alias gco='git checkout'
    # gdc      -- 'git diff --cached'
    alias gdc='git diff --cached'
    # gl       -- 'git log --pretty=format:"%h : %an : %s" --topo-order --graph'
    alias gl='git log --pretty=format:"%h : %an : %s" --topo-order --graph'
    # gr       -- 'git remote -v'
    alias gr='git remote -v'
    # gs       -- 'git status'
    alias gs='git status'
    # gsi      -- 'git is; git diff; git diff --cached'
    alias gsi='(set -x; git is; git diff; git diff --cached)'
    # gsiw      -- 'git -C $_WRD gsi'
    alias gsiw='(cd $_WRD; gsi)'
    # gsl      -- 'git stash list'
    alias gsl='git stash list'
    # gsn      -- 'git stash save'
    alias gsn='git stash save'
    # gss      -- 'git stash save'
    alias gss='git stash save'
    # gitr     -- 'git remote -v'
    alias gitr='git remote -v'

    # hga      -- 'hg add'
    alias hga='hg add'

    hgac () {
    # hgac()   -- 'hg add $@[1:]; hg commit $1'
    #   $1 (str): quoted commit message
    #   $2- (list): file paths
        local msg=${1:-""}
        shift
        local files=$@
        hg diff ${files}
        if [ -n "${msg}" ]; then
            hg commit -m "${msg}" ${files}
        fi
    }
    # hgl      -- 'hg glog --pager=yes'
    alias hgl='hg glog --pager=yes'
    # hgs      -- 'hg status'
    alias hgs='hg status'
    # hgd      -- 'hg diff'
    alias hgd='hg diff'
    # hgds     -- 'hg diff --stat'
    alias hgds='hg diff --stat'
    # hgdl     -- 'hg diff --color=always | less -R'
    alias hgdl='hg diff --color=always | less -R'
    # hgc      -- 'hg commit'
    alias hgc='hg commit'
    # hgu      -- 'hg update'
    alias hgu='hg update'
    # hgq      -- 'hg qseries'
    alias hgq='hg qseries'
    # hgqd     -- 'hg qdiff'
    alias hgqd='hg qdiff'
    # hgqs     -- 'hg qseries'
    alias hgqs='hg qseries'
    # hgqn     -- 'hg qnew'
    alias hgqn='hg qnew'
    # hgr      -- 'hg paths'
    alias hgr='hg paths'

    # __IS_MAC
    if [ -n "${__IS_MAC}" ]; then
        # la       -- 'ls -A -G'
        alias la='ls -A -G'
        # ll       -- 'ls -alF -G'
        alias ll='ls -alF -G'
        # ls       -- 'ls -G'
        alias ls='ls -G'
        # lt       -- 'ls -altr -G'
        alias lt='ls -altr -G'
        # lll      -- 'ls -altr -G'
        alias lll='ls -altr -G'
    # else
    else
        # la       -- 'ls -A --color=auto'
        alias la='ls -A --color=auto'
        # ll       -- 'ls -alF --color=auto'
        alias ll='ls -alF --color=auto'
        # ls       -- 'ls --color=auto'
        alias ls='ls --color=auto'
        # lt       -- 'ls -altr --color=auto'
        alias lt='ls -altr --color=auto'
        # lll      -- 'ls -altr --color=auto'
        alias lll='ls -altr --color=auto'
    fi

    # __IS_LINUX
    if [ -n "${__IS_LINUX}" ]; then
        # psx      -- 'ps uxaw'
        alias psx='ps uxaw'
        # psf      -- 'ps uxawf'
        alias psf='ps uxawf'
        # psxs     -- 'ps uxawf --sort=tty,ppid,pid'
        alias psxs='ps uxawf --sort=tty,ppid,pid'
        # psxh     -- 'ps uxawf --sort=tty,ppid,pid | head'
        alias psxh='ps uxawf --sort=tty,ppid,pid | head'

        # psh      -- 'ps uxaw | head'
        alias psh='ps uxaw | head'

        # psc      -- 'ps uxaw --sort=-pcpu'
        alias psc='ps uxaw --sort=-pcpu'
        # psch     -- 'ps uxaw --sort=-pcpu | head'
        alias psch='ps uxaw --sort=-pcpu | head'

        # psm      -- 'ps uxaw --sort=-pmem'
        alias psm='ps uxaw --sort=-pmem'
        # psmh     -- 'ps uxaw --sort=-pmem | head'
        alias psmh='ps uxaw --sort=-pmem | head'
    # __IS_MAC
    elif [ -n "${__IS_MAC}" ]; then
        # psx      -- 'ps uxaw'
        alias psx='ps uxaw'
        # psf      -- 'ps uxaw' # no -f
        alias psf='ps uxaw' # no -f

        # psh      -- 'ps uxaw | head'
        alias psh='ps uxaw | head'

        # psc      -- 'ps uxaw -c'
        alias psc='ps uxaw -c'
        # psch     -- 'ps uxaw -c | head'
        alias psch='ps uxaw -c | head'

        # psm      -- 'ps uxaw -m'
        alias psm='ps uxaw -m'
        # psmh     -- 'ps uxaw -m | head'
        alias psmh='ps uxaw -m | head'
    fi
    
    # shtop    -- 'sudo htop'
    alias shtop='sudo htop'
    # t        -- 'tail'
    alias t='tail'
    # tf       -- 'tail -f'
    alias tf='tail -f'
    # xclipc   -- 'xclip -selection c'
    alias xclipc='xclip -selection c'
}
_loadaliases




### bashrc.commands.sh
# usage: bash -c 'source bashrc.commands.sh; funcname <args>'

chown-me () {
    # chown-me()        -- chown -Rv user
    (set -x; \
    chown -Rv $(id -un) $@ )
}

chown-me-mine () {
    # chown-me-mine()   -- chown -Rv user:user && chmod -Rv go-rwx
    (set -x; \
    chown -Rv $(id -un):$(id -un) $@ ; \
    chmod -Rv go-rwx $@ )
}

chown-sme () {
    # chown-sme()       -- sudo chown -Rv user
    (set -x; \
    sudo chown -Rv $(id -un) $@ )
}

chown-sme-mine () {
    # chown-sme-mine()  -- sudo chown -Rv user:user && chmod -Rv go-rwx
    (set -x; \
    sudo chown -Rv $(id -un):$(id -un) $@ ; \
    sudo chmod -Rv go-rwx $@ )
}

chmod-unumask () {
    # chmod-unumask()   -- recursively add other+r (files) and other+rx (dirs)
    path=$1
    sudo find "${path}" -type f -exec chmod -v o+r {} \;
    sudo find "${path}" -type d -exec chmod -v o+rx {} \;
}


### bashrc.bashmarks.sh
## bashmarks
    # l()  -- list bashmarks
    # s()  -- save bashmarks as $1
    # g()  -- goto bashmark $1
    # p()  -- print bashmark $1
    # d()  -- delete bashmark $1
source "${__DOTFILES}/etc/bashmarks/bashmarks.sh"
# Copyright (c) 2010, Huy Nguyen, http://www.huyng.com
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, are permitted provided 
# that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, this list of conditions 
#       and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
#       following disclaimer in the documentation and/or other materials provided with the distribution.
#     * Neither the name of Huy Nguyen nor the names of contributors
#       may be used to endorse or promote products derived from this software without 
#       specific prior written permission.
#       
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.


# USAGE: 
# s bookmarkname - saves the curr dir as bookmarkname
# g bookmarkname - jumps to the that bookmark
# g b[TAB] - tab completion is available
# p bookmarkname - prints the bookmark
# p b[TAB] - tab completion is available
# d bookmarkname - deletes the bookmark
# d [TAB] - tab completion is available
# l - list all bookmarks

# setup file to store bookmarks
if [ ! -n "$SDIRS" ]; then
    SDIRS=~/.sdirs
fi
touch $SDIRS

RED="0;31m"
GREEN="0;33m"

# save current directory to bookmarks
function s {
    check_help $1
    _bookmark_name_valid "$@"
    if [ -z "$exit_message" ]; then
        _purge_line "$SDIRS" "export DIR_$1="
        CURDIR=$(echo $PWD| sed "s#^$HOME#\$HOME#g")
        echo "export DIR_$1=\"$CURDIR\"" >> $SDIRS
    fi
}

# jump to bookmark
function g {
    check_help $1
    source $SDIRS
    target="$(eval $(echo echo $(echo \$DIR_$1)))"
    if [ -d "$target" ]; then
        cd "$target"
    elif [ ! -n "$target" ]; then
        echo -e "\033[${RED}WARNING: '${1}' bashmark does not exist\033[00m"
    else
        echo -e "\033[${RED}WARNING: '${target}' does not exist\033[00m"
    fi
}

# print bookmark
function p {
    check_help $1
    source $SDIRS
    echo "$(eval $(echo echo $(echo \$DIR_$1)))"
}

# delete bookmark
function d {
    check_help $1
    _bookmark_name_valid "$@"
    if [ -z "$exit_message" ]; then
        _purge_line "$SDIRS" "export DIR_$1="
        unset "DIR_$1"
    fi
}

# print out help for the forgetful
function check_help {
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
        echo ''
        echo 's <bookmark_name> - Saves the current directory as "bookmark_name"'
        echo 'g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"'
        echo 'p <bookmark_name> - Prints the directory associated with "bookmark_name"'
        echo 'd <bookmark_name> - Deletes the bookmark'
        echo 'l                 - Lists all available bookmarks'
        kill -SIGINT $$
    fi
}

# list bookmarks with dirnam
function l {
    check_help $1
    source $SDIRS
        
    # if color output is not working for you, comment out the line below '\033[1;32m' == "red"
    env | sort | awk '/DIR_.+/{split(substr($0,5),parts,"="); printf("\033[0;33m%-20s\033[0m %s\n", parts[1], parts[2]);}'
    
    # uncomment this line if color output is not working with the line above
    # env | grep "^DIR_" | cut -c5- | sort |grep "^.*=" 
}
# list bookmarks without dirname
function _l {
    source $SDIRS
    env | grep "^DIR_" | cut -c5- | sort | grep "^.*=" | cut -f1 -d "=" 
}

# validate bookmark name
function _bookmark_name_valid {
    exit_message=""
    if [ -z $1 ]; then
        exit_message="bookmark name required"
        echo $exit_message
    elif [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
        exit_message="bookmark name is not valid"
        echo $exit_message
    fi
}

# completion command
function _comp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_l`' -- $curw))
    return 0
}

# ZSH completion command
function _compzsh {
    reply=($(_l))
}

# safe delete line from sdirs
function _purge_line {
    if [ -s "$1" ]; then
        # safely create a temp file
        t=$(mktemp -t bashmarks.XXXXXX) || exit 1
        trap "rm -f -- '$t'" EXIT

        # purge line
        sed "/$2/d" "$1" > "$t"
        mv "$t" "$1"

        # cleanup temp file
        rm -f -- "$t"
        trap - EXIT
    fi
}

# bind completion command for g,p,d to _comp
if [ $ZSH_VERSION ]; then
    compctl -K _compzsh g
    compctl -K _compzsh p
    compctl -K _compzsh d
else
    shopt -s progcomp
    complete -F _comp g
    complete -F _comp p
    complete -F _comp d
fi
lsbashmarks () {
    # lsbashmarks() -- list Bashmarks (e.g. for NERDTree)
    export | grep 'DIR_' | pyline "line[15:].replace('\"','').split('=',1)"
}

    # see also: ${__DOTFILES}/scripts/nerdtree_to_bashmarks.py



### 70-bashrc.repos.sh


function git-commit() {
    #  git-commit()   -- git commit ${2:} -m ${1}; git log -n1 
    (set -x;
    msg="${1}";
    shift;
    files="${@}";
    git commit ${files} -m "${msg}" && \
    git log -n1 --stat --decorate=full --color=always;
    )
}

function gc() {
    #  gc()             -- git-commit() <files> -m <log> ; log log -n1
    git-commit "${@}"
}

function git-add-commit() {
    #  git-add-commit()   -- git add ${2:}; git commit ${2} -m ${1}; git log -n1 
    (set -x;
    msg="${1}";
    shift;
    files="${@}";
    git add ${files};
    git commit ${files} -m "${msg}" && \
    git log -n1 --stat --decorate=full --color=always;
    )
}

function gac() {
    #  gac()            -- git-add-commit $@
    git-add-commit "${@}"
}

function msg() {
    #  msg()        -- set a commit message for the current context
    if [ -z "${@}" ]; then
        echo _MSG="${_MSG}"
    elif [ -n "${@}" ]; then
        if [ "${1}" == "clear" ]; then
            unset _MSG
        else
            export _MSG="${@}"
        fi
        echo _MSG="${_MSG}"
    fi
}

function git-commit-msg() {
    #  gitcmsg()    -- gitc "${_MSG}" ${@}
    git-commit "${_MSG}" ${@} && msg clear
}

function git-add-commit-msg() {
    #  gitcaddmsg()    -- gitc "${_MSG}" ${@}
    git-add-commit "${_MSG}" ${@} && msg clear
}


#objectives:
#* [ ] create a dotfiles venv (should already be created by dotfiles install)
#* [ ] create a src venv (for managing a local set of repositories)
#
#* [x] create Hg_ methods for working with a local repo set
#* [ ] create Git_ methods for working with a local repo set
#
#* [-] host docs locally with a one-shot command (host_docs)
#
# Use Cases
# * Original: a bunch of commands that i was running frequently
#   before readthedocs (and hostthedocs)
# * local mirrors (manual, daily?)
#   * no internet, outages
#   * push -f
#   * (~offline) Puppet/Salt source installs
#     * bandwidth: testing a recipe that pulls a whole repositor(ies)
# * what's changed in <project>'s source dependencies, since i looked last
#
# Justification
# * very real risks for all development projects
#   * we just assume that GitHub etc. are immutable and forever
#
# Features (TODO) [see: pyrpo]
# * Hg <subcommands>
# * Git <subcommands>
# * Bzr <subcommands>
# * periodic backups / mirroring
# * gitweb / hgweb
# * mirror_and_backup <URL>
# * all changes since <date> for <set_of_hg-git-bzr-svn_repositories>
# * ideally: transparent proxy
#   * +1: easiest
#   * -1: pushing upstream
#
# Caveats
# * pasting / referencing links which are local paths
# * synchronization lag
# * duplication: $__SRC/hg/<pkg> AND $VIRTUAL_ENV/src/<pkg>
#

setup_dotfiles_docs_venv() {
    #  setup_dotfiles_docs_venv -- create default 'docs' venv
    deactivate

    __DOCSENV="docs"
    export __DOCS="${WORKON_HOME}/${__DOCSENV}"
    export __DOCSWWW="${__DOCS}/var/www"
    mkvirtualenv_conda_if_available $__DOCSENV
    workon_conda_if_available $__DOCS
    _venv_ensure_paths $__DOCS
}

setup_dotfiles_src_venv() {
    #  setup_dotfiles_src_venv -- create default 'src' venv
    #
    #   __SRC_HG=${WORKON_HOME}/src/src/hg
    #   __SRC_GIT=${WORKON_HOME}/src/src/git
    #
    #  Hg runs hg commands as user hg
    #  Git runs git commands as user git
    #
    #  Hgclone will mirror to $__SRC_HG
    #  Gitclone will mirror to $__SRC_GIT
    #
    #
    deactivate
    __SRCENV="src"
    export __SRC=${WORKON_HOME}/${__SRCENV}/src
    export __SRC_HG=${__SRC}/hg
    export __SRC_GIT=${__SRC_GIT}/git
    mkvirtualenv_conda_if_available $__SRCENV
    workon_conda_if_available $__SRCENV

    _venv_ensure_paths ${WORKON_HOME}/${__SRCENV}
    ensure_mkdir $__SRC
    ensure_mkdir $__SRC/git
    ensure_mkdir $__SRC/hg
    ensure_mkdir ${prefix}/var/www
}


fixperms () {
    #fix permissions for hgweb? TODO
    __PATH=$1
    sudo chown -R hg:hgweb "$__PATH"
    sudo chmod -R g+rw "$__PATH"
}

# __SRC_GIT_REMOTE_URI_PREFIX   -- default git remote uri prefix
__SRC_GIT_REMOTE_URI_PREFIX="ssh://git@git.create.wrd.nu"
# __SRC_GIT_REMOTE_NAME         -- name for git remote v
__SRC_GIT_REMOTE_NAME="create"
# __SRC_HG_REMOTE_URI_PREFIX    -- default hg remote uri prefix
__SRC_HG_REMOTE_URI_PREFIX="ssh://hg@hg.create.wrd.nu"
# __SRC_HG_REMOTE_NAME          -- name for hg paths
__SRC_HG_REMOTE_NAME="create"

__SRC_GIT_GITOLITE_ADMIN=$HOME/gitolite-admin

Git_create_new_repo(){
    ## Create a new hosted repository with gitolite-admin
    #  $1   -- repo [user/]name (e.g. westurner/dotfiles)
    reponame=$1  # (e.g. westurner/dotfiles)
    cd $__SRC_GIT_GITOLITE_ADMIN_REPO && \
    ./add_repo.sh "$reponame" 
}

Git_pushtocreate() {
    ## push a git repository to local git storage
    #  $1   -- repo [user/]name (e.g. westurner/dotfiles) 
    reponame=$1
    repo_uri="${__SRC_GIT_URI}/${reponame}"
    here=$(pwd)
    #  $2   -- path of local repo (e.g. ~/wrk/.ve/dotfiles/src/dotfiles)
    repo_local_path=$2
    remote_name=${__SRC_GIT_REMOTE_NAME}

    Git_create_new_repo $reponame
    (cd $repo_local_path;  \
        git remote add $remote_name $repo_uri  \
            "${__SRC_GIT_URI}/${username}/${reponame}" && \
        git push --all $remote_name && \
        cd $here)
}

Hg_create_new_repo() {
    ## Create a new hosted repository with mercurial-ssh
    reponame=$1
    cd $__SRC_HG_SERVER_REMOTE_ADMIN && \
        ./add_repo.sh "$reponame"  # TODO: create add_repo.sh
}

Hg_pushtocreate() {
    ## push a hg repository to local git storage
    #  $1   -- repo [user/]name (e.g. westurner/dotfiles)
    reponame=$1
    repo_uri="${__SRC_HG_URI}/${reponame}"
    here=$(pwd)
    #  $2   -- path of local repo (e.g. ~/wrk/.ve/dotfiles/src/dotfiles)
    repo_local_path=$2
    remote_name=${__SRC_HG_REMOTE_NAME}    
}


Hgclone () {
    url=$1
    shift
    path="${__SRC}/hg/$1"
    if [ -d $path ]; then
        echo "$path existing. Exiting." >&2
        echo "see: update_repo $1"
        return 0
    fi
    sudo -u hg -i /usr/bin/hg clone $url $path
    fixperms $path
}

Hg() {
    path="${__SRC}/hg/$1"
    path=${path:-'.'}
    shift
    cmd=$@
    sudo -H -u hg -i /usr/bin/hg -R "${path}" $cmd

    #if [ $? -eq 0 ]; then
    #    fixperms ${path}
    #fi
}

Hgcheck() {
    path="${__SRC}/$1"
    path=${path:-'.'}
    shift
    Hg $path tags
    Hg $path id -n
    Hg $path id
    Hg $path branch

    #TODO: last pulled time
}

Hgupdate() {
    path=$1
    shift
    Hg $path update $@
}

Hgstatus() {
    path=$1
    shift
    Hg $path update $@
}

Hgpull() {
    path=$1
    shift
    Hg $path pull $@
    Hgcheck $path
}

Hglog() {
    path=$1
    shift
    Hg -R $path log $@
}

Hgcompare () {
    one=$1
    two=$2
    diff -Naur \
        <(hg -R "${one}" log) \
        <(hg -R "${two}" log)
}

host_docs () {
    #  host_docs    -- build and host documentation in a local directory
    #   param $1: <project_name>
    #   param $2: [<path>]
    #   param $3: [<docs/Makefile>]
    #   param $4: [<docs/conf.py>]
    # * log documentation builds
    # * build a sphinx documentation set with a Makefile and a conf.py
    # * rsync to docs webserver
    # * set permissions

    # this is not readthedocs.org

    # note: you must manually install packages into the
    # local 'docs' virtualenv'
    set -x
    pushd .
    #workon docs
    name=${1}

    if [ -z "${name}" ]; then
        echo "must specify an application name"
        return 1
    fi

    path=${2:-"${__SRC}/${name}"}
    _makefile=${3}
    _confpy=${4}
    _default_makefile="${path}/docs/Makefile"
    _default_confpy="${path}/docs/conf.py"

    _default_builddir="${path}/_build"

    dest="${__DOCSWWW}/${name}"
    group="www-data"

    if [ -z "${_makefile}" ]; then
        if [ -f $_default_makefile ]; then
            _makefile=$_default_makefile;
        else
            echo "404: default_makefile: $_default_makefile" >&2
            __makefiles=$(find "${path}" -maxdepth 2 -type f -name Makefile)
            for __makefile in ${__makefiles[@]}; do
                if [ -n "${__makefile}" ]; then
                    grep -n -H 'sphinx-build' ${__makefile} \
                        && grep -n -H '^html:' ${__makefile}
                    if [ $? -eq 0 ]; then
                        echo 'Found sphinx-build Makefile: $__makefile'
                        # TODO: prompt?
                        _makefile=$__makefile
                    fi
                fi
            done
        fi

        if [ -f "${_makefile}" ]; then
            _builddir=$(dirname $_makefile)
        fi
    fi

    if [ -z "${_confpy}" ]; then
        if [ -f $_default_confpy ]; then
            _confpy=$_default_confpy;
        else
            echo "404: default_confpy: $_default_confpy" >&2
            confpys=$(find "${path}" -maxdepth 2 -type f -name conf.py)
            for __confpy in ${confpys[@]}; do
                grep -n -H 'sphinx-build' ${__confpy}
                if [ $? -eq 0 ]; then
                    echo 'found conf.py: $__confpy'
                    #TODO: prompt?
                    _confpy=$__confpy
                fi
            done
        fi

        if [ ! -f $_makefile ]; then
            _builddir=$(dirname $__confpy)
        fi

    fi

    _builddir=${_builddir:-${_default_builddir}}
    _buildlog="${_builddir}/build.log"
    _currentbuildlog="${_builddir}/build.current.log"


    cd $path
    rm -f $_currentbuildlog
    html_path=""
    echo '#' $(date) | tee -a $_buildlog | tee $_currentbuildlog

    if [ -n "$_makefile" ]; then
        #TODO
        #>> 'SPHINX_BUILD =    sphinx-build -Dhtml_theme=default -Dother '
        #<< 'SPHINX_BUILD =    sphinx-build -Dhtml_theme=default'
        #sed -i -r 's/(^SPHINXBUILD)( *= *)(sphinx-build)(.*)/\1\2\3 -Dhtml_theme="default"/g' $_makefile

        cd $(dirname $_makefile)
        make \
            SPHINXBUILD="sphinx-build -Dhtml_theme=\"default\"" \
            html | \
            tee -a $_buildlog | tee $_currentbuildlog
        html_path=$(tail -n 1 $_currentbuildlog | \
            sed -r 's/(.*)The HTML pages are in (.*).$/\2/g')
        echo $html_path

    elif [ -n "$_confpy" ]; then
        # >> 'html_theme = "_-_"
        # << 'html_theme = 'default'
        sed -i.bak -r 's/(^ *html_theme)( *= *)(.*)/\1\2"default"' $_confpy
        sourcedir=$(dirname $_confpy)
        html_path="${sourcedir}/_build/html"
        mkdir -p $html_path
        SPHINXBUILD="sphinx-build -Dhtml_theme=\"default\"" \
            sphinx-build \
                -b html \
                -D html_theme="default" \
                -c "${_confpy}" \
                $sourcedir \
                $html_path
    fi

    if [ -n "${html_path}" ]; then
        echo "html-path:" ${html_path}
        echo "dest:" ${dest}
        set -x
        rsync -avr "${html_path}/" "${dest}/" \
            | tee -a $_buildlog \
            | tee $_currentbuildlog
        set +x
        sudo chgrp -R $group "${dest}" \
            | tee -a $_buildlog \
            | tee $_currentbuildlog
    else
        echo "### ${_currentbuildlog}"
        cat $_currentbuildlog
    fi

    popd

    set +x
    deactivate
}



dotfiles_status
# dotfiles_status()
HOSTNAME='mb1'
USER='wturner'
__WRK='/home/wturner/-wrk'
PROJECT_HOME='/home/wturner/-wrk'
CONDA_ROOT='/home/wturner/-wrk/-conda27'
CONDA_ENVS_PATH='/home/wturner/-wrk/-ce27'
WORKON_HOME='/home/wturner/-wrk/-ve27'
VIRTUAL_ENV_NAME='dotfiles'
VIRTUAL_ENV='/home/wturner/-wrk/-ve27/dotfiles'
_SRC='/home/wturner/-wrk/-ve27/dotfiles/src'
_APP='dotfiles'
_WRD='/home/wturner/-wrk/-ve27/dotfiles/src/dotfiles'
_USRLOG='/home/wturner/-wrk/-ve27/dotfiles/-usrlog.log'
_TERM_ID='#testing'
PATH='/home/wturner/-wrk/-ve27/dotfiles/bin:/home/wturner/-dotfiles/scripts:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/home/wturner/.local/bin:/home/wturner/bin'
__DOTFILES='/home/wturner/-dotfiles'
#
### </end dotfiles .bashrc>


exit
exit
