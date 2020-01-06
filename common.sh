#!/bin/bash

########################################################################
# Stuff that I want both bashrc and bash_profile to run
########################################################################

########################################################################
# History
########################################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

########################################################################
# Look and Feel
########################################################################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

########################################################################
# Completion Features
########################################################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

########################################################################
# Aliases
########################################################################

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if grep -qi Microsoft /proc/version; then
    alias open=Explorer.exe
else 
    alias open=xdg-open
fi

########################################################################
# WSL Convenience Helpers
########################################################################

if grep -qi Microsoft /proc/version; then
    export WIN_C_PATH="$(wslpath 'C:\')"
    export WSL_VERSION=$(wsl.exe -l -v | grep -a '[*]' | sed 's/[^0-9]*//g')
    export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
    export DISPLAY=$WSL_HOST:0
fi

########################################################################
# Private Path
########################################################################

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
# Automatically add ~/.local/bin to path (used by Docker)
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#########################
# Language Toolchains
#########################

# Go 
export GOPATH="$HOME/go" 

# Java
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Node.js
if grep -qi Microsoft /proc/version; then
    # Because WSL adds the Windows path, we might have namespace conflicts with devtools we install for both Windows and Ubuntu
    # We can use sed to clean these out now
    # Based on https://github.com/WhitewaterFoundry/pengwin-setup/commit/cea92cd2438e522d1d81accc43e6884e8d762b62
    WIN_C_PATH="$(wslpath 'C:\')"
    WIN_NPM_PATH="$(dirname "\$(which npm)")"
    if [[ "\${WIN_NPM_PATH}" == "\${WIN_C_PATH}"* ]]; then
        export PATH=$(echo "${PATH}" | sed -e "s#${WIN_NPM_PATH}##")
    fi
    WIN_YARN_PATH="$(dirname "\$(which yarn)")"
    if [[ "\${WIN_YARN_PATH}" == "\${WIN_C_PATH}"* ]]; then
        export PATH=$(echo "${PATH}" | sed -e "s#${WIN_YARN_PATH}##")
    fi
fi
export N_PREFIX="$HOME/n"
export PATH="$N_PREFIX/bin:$PATH"

# Python
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

###########################################
# WebAssembly Tools and Runtimes
###########################################

# Emscripten
# Note: This klobbers my Python and Node.js interpreters, so I only want to do this when needed
# source ~/emsdk/emsdk_env.sh > /dev/null

# Wasmer
export WASMER_DIR="/home/sean/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Wasmtime
export WASMTIME_HOME="$HOME/.wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"

# Lucet
# To get access to lucetc, you need to run the following
# This assumes that lucet has been installed into ~/projects/lucet
# source ~/projects/lucet/devenv_setenv.sh

# Awsm
# TODO

############################################
# Systems Administration Tools
############################################

# Ansible
export ansible_python_interpreter=/usr/bin/python2
