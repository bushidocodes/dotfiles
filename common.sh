#!/bin/bash

source "$HOME/.dotfiles/utils.sh"

configure_history() {
	# don't put duplicate lines or lines starting with space in the history.
	# See bash(1) for more options
	HISTCONTROL=ignoreboth

	# append to the history file, don't overwrite it
	shopt -s histappend

	# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
	HISTSIZE=10000
	HISTFILESIZE=20000
}

configure_look_and_feel() {
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
		xterm-color | *-256color) color_prompt=yes ;;
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
		xterm* | rxvt*)
			PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
			;;
		*) ;;

	esac

	# enable color support of ls and also add handy aliases
	if [ -x /usr/bin/dircolors ]; then
		if test -r ~/.dircolors; then
			eval "$(dircolors -b ~/.dircolors)"
		else
			eval "$(dircolors -b)"
		fi
		alias ls='ls --color=auto'
		alias dir='dir --color=auto'
		alias vdir='vdir --color=auto'
		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
	fi

	# colored GCC warnings and errors
	export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

}

configure_completion() {
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
}

configure_mac_style_open_alias() {
	if is_wsl; then
		alias open='Explorer.exe'
	elif is_native_ubuntu; then
		alias open=xdg-open
	fi
}

configure_aliases() {
	# some more ls aliases
	alias ll='ls -alF'
	alias la='ls -A'
	alias l='ls -CF'
	if is_wsl; then
		alias clip='clip.exe'
	fi
	# Add an "alert" alias for long running commands.  Use like so:
	#   sleep 10; alert
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

	alias bats='bats *_test.sh'
	alias batsall='BATS_RUN_SKIPPED=true bats'

	configure_mac_style_open_alias
}

# ~/.local/bin is used by Docker
init_private_paths() {
	if [ -d "$HOME/.local/bin" ]; then
		mkdir -p "$HOME/.local/bin"
		mkdir -p "$HOME/bin"
		export PATH="$HOME/.local/bin:$PATH"
		export PATH="$HOME/bin:$PATH"
	fi
}

init_go() {
	export GOPATH="$HOME/go"
}

init_java() {
	export PATH="$HOME/.jenv/bin:$PATH"
	eval "$(jenv init -)"
}

# WSL adds the Windows path to the WSL Path. Quite possibly, Node is installed in Windows
# We can use set to cleanup namespace conflicts
# Based on https://github.com/WhitewaterFoundry/pengwin-setup/commit/cea92cd2438e522d1d81accc43e6884e8d762b62
remove_win_node_from_path() {
	# shellcheck disable=SC1003
	WIN_C_PATH="$(get_win_c_path)"
	WIN_NPM_PATH="$(dirname "$(command -v npm)")"
	if [[ "${WIN_NPM_PATH}" =~ ^${WIN_C_PATH} ]]; then
		export PATH=${PATH/"${WIN_NPM_PATH}"/}
	fi
	WIN_YARN_PATH="$(dirname "$(command -v yarn)")"
	if [[ "${WIN_YARN_PATH}" =~ ^${WIN_C_PATH} ]]; then
		export PATH="${PATH/"$WIN_YARN_PATH"/}"
	fi
}

init_node() {
	if grep -qi Microsoft /proc/version; then
		remove_win_node_from_path
	fi
	export PNPM_HOME="/home/sean/.local/share/pnpm"
	export PATH="$PNPM_HOME:$PATH"
}

init_deno() {
	export DENO_INSTALL="$HOME/.deno"
	export PATH="$DENO_INSTALL/bin:$PATH"
}

init_rust() {
	export PATH="$HOME/.cargo/bin:$PATH"
	. "$HOME/.cargo/env"
}

###########################################
# WebAssembly Tools and Runtimes
###########################################

# Wasmtime
init_wasmtime() {
	export WASMTIME_HOME="$HOME/.wasmtime"
	export PATH="$WASMTIME_HOME/bin:$PATH"
}

init_wasi_sdk() {
	export WASI_SDK_PATH="/opt/wasi-sdk/"
}

# Adds /snap/bin to PATH is snap is in PATH
init_snaps() {
	type -p snap >/dev/null && export PATH="/snap/bin:$PATH"
}

init_common() {
	configure_history
	configure_look_and_feel
	configure_completion
	configure_aliases
	init_private_paths
	init_deno
	init_go
	init_java
	init_node
	init_rust
	init_snaps
	init_wasi_sdk
	init_wasmtime
}
