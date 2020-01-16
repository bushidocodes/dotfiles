#!/usr/bin/env bash

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
  printf "%s\n" "$(wslpath 'C:\')"
}

get_win_user() {
  is_wsl || return
  powershell.exe '$env:UserName' | sed 's/\r//g'
}

get_win_host() {
  is_wsl || return
  printf "%s\n" "$(tail -1 /etc/resolv.conf | cut -d' ' -f2)"
}

get_code_extensions() {
  original_path="$(pwd)"
  cd ~/winhome || exit
  powershell.exe 'code --list-extensions'
  cd "$original_path" || exit
}

link_windows_home() {
  is_wsl || return
  win_user="$(get_win_user)"
  c_path="$(get_win_c_path)"
  ln -sf "${c_path}Users/${win_user}" ~/winhome
}

link_windows_ssh() {
  is_wsl || return
  ln -sf /c/Users/Sean/.ssh ~/.ssh
}
