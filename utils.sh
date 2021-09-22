#!/usr/bin/env bash

banner() {
	heading=$1
	string_length=${#heading}
	for ((i = 0; i < string_length + 4; i++)); do
		printf "*"
	done
	printf "\n"
	printf "* %s *\n" "$heading"
	for ((i = 0; i < string_length + 4; i++)); do
		printf "*"
	done
	printf "\n"
}

is_wsl() {
	grep -qi Microsoft /proc/version
}

is_native_ubuntu() {
	grep -qi Ubuntu /proc/version
}

get_wsl_version() {
	is_wsl || return
	printf "%d\n" "$(wsl.exe -l -v | grep -a '[*]' | sed 's/[^0-9]*//g')"
}

get_win_c_path() {
	is_wsl || return
	if ! is_wsl; then return; fi
	# shellcheck disable=SC1003
	printf "%s\n" "$(wslpath 'C:\')"
}

get_win_user() {
	is_wsl || return
	# shellcheck disable=SC2016
	powershell.exe '$env:UserName' | sed 's/\r//g'
}

get_win_host() {
	is_wsl || return
	printf "%s\n" "$(tail -1 /etc/resolv.conf | cut -d' ' -f2)"
}

link_windows_home() {
	is_wsl || return
	win_user="$(get_win_user)"
	c_path="$(get_win_c_path)"
	ln -sf "${c_path}Users/${win_user}" ~/winhome
}

# Assumes C:\ has been mounted at /c/ via link_wsl_conf
link_windows_ssh() {
	is_wsl || return
	win_user="$(get_win_user)"
	ln -sf "/c/Users/$win_user/.ssh" ~/.ssh
}

# Symlink wsl.conf, which mounts Windows drives at root
link_wsl_conf() {
	is_wsl || return
	wsl_conf_symlink="/etc/wsl.conf"
	if [ ! -L "$wsl_conf_symlink" ]; then
		sudo ln -s ~/.dotfiles/windows/wsl.conf /etc/wsl.conf
	fi
}

# VSCode stuff

# Assumes Windows User directory linked to ~/winhome
vscode_list_extensions() {
	if is_wsl; then
		pushd ~/winhome 1> /dev/null || return
		powershell.exe 'code --list-extensions'
		popd 1> /dev/null || return
	else
		code --list-extensions
	fi
}

# Assumes Windows User directory linked to ~/winhome
vscode_install_extension() {
	extension=$1
	if is_wsl; then
		# DOS does not support UNC paths, so I navigate to my Windows user home directory first
		pushd ~/winhome || return
		# If, I just call cmd.exe, execution seems to not block as expected, causing only the first
		# extension to install if calling this within a BASH function. Adding a useless echo before
		# calling the DOS interpreter seems to cause things to block properly. No idea why ¯\_(ツ)_/¯
		echo "" | cmd.exe /C "code --install-extension $extension"
		popd || return
	else
		code --install-extension "$extension"
	fi
}

# Assumes Windows User directory linked to ~/winhome
vscode_uninstall_extension() {
	extension=$1
	if is_wsl; then
		# DOS does not support UNC paths, so I navigate to my Windows user home directory first
		original_path="$(pwd)"
		cd "$HOME/winhome" || return
		# If, I just call cmd.exe, execution seems to not block as expected, causing only the first
		# extension to install if calling this within a BASH function. Adding a useless echo before
		# calling the DOS interpreter seems to cause things to block properly. No idea why ¯\_(ツ)_/¯
		echo "" | cmd.exe /C "code --uninstall-extension $extension"
		cd "$original_path" || return
	else
		code --uninstall-extension "$extension"
	fi
}

are_different() {
	a=$1
	b=$2
	if ! diff -q "$a" "$b" &> /dev/null; then
		return 0
	else
		return 1
	fi
}
