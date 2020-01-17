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

extensions_file="$HOME/.dotfiles/vscode_extensions.txt"
settings_file="$HOME/.dotfiles/vscode_settings.json"
windows_vscode_settings_path="$HOME/winhome/AppData/Roaming/Code/User/settings.json"

# Assumes Windows User directory linked to ~/winhome
vscode_list_extensions() {
  if is_wsl; then
    original_path="$(pwd)"
    cd ~/winhome || exit
    powershell.exe 'code --list-extensions'
    cd "$original_path" || exit
  else
    code --list-extensions
  fi
}

# Assumes Windows User directory linked to ~/winhome
vscode_install_extension() {
  extension=$1
  if is_wsl; then
    # DOS does not support UNC paths, so I navigate to my Windows user home directory first
    original_path="$(pwd)"
    cd "$HOME/winhome" || return
    # If, I just call cmd.exe, execution seems to not block as expected, causing only the first
    # extension to install if calling this within a BASH function. Adding a useless echo before
    # calling the DOS interpreter seems to cause things to block properly. No idea why ¯\_(ツ)_/¯
    echo "" | cmd.exe /C "code --install-extension $extension"
    cd "$original_path" || return
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
  if ! diff -q "$a" "$b" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

vscode_diff_extensions() {
  diff --ignore-all-space --suppress-common-lines --side-by-side "$extensions_file" <(vscode_list_extensions)
}

vscode_diff() {
  if is_wsl && are_different "$settings_file" "$windows_vscode_settings_path"; then
    # Linux is able to symlink directly out of the repo
    banner "VSCode Settings"
    echo "Repo | System"
    diff --ignore-all-space --suppress-common-lines --side-by-side "$settings_file" "$windows_vscode_settings_path"
  fi

  if are_different "$extensions_file" <(vscode_list_extensions); then
    banner "VSCode Extensions"
    echo "Repo | System"
    diff --ignore-all-space --suppress-common-lines --side-by-side "$extensions_file" <(vscode_list_extensions)
  fi
}

vscode_system_to_repo() {
  if is_wsl; then
    cp "$windows_vscode_settings_path" "$settings_file"
  fi

  extensions=$(vscode_list_extensions)
  rm "$extensions_file" 2>/dev/null
  for extension in $extensions; do
    echo "$extension" >>"$extensions_file"
  done
}

# Note: This installs all extensions under Windows. Some actually need to be be installed in the WSL-Remote component,
# but the CLI API does not seem to be able to handle this properly. One must manually click the "Install in WSL" button
# in the extensions pane and then restart VSCode.
vscode_repo_to_system() {
  if is_wsl; then
    cp "$settings_file" "$windows_vscode_settings_path"
  fi

  if are_different "$extensions_file" <(vscode_list_extensions); then
    # Install Extensions in file
    for extension in $(diff --ignore-all-space --changed-group-format='%<' --unchanged-group-format='' "$extensions_file" <(vscode_list_extensions)); do
      vscode_install_extension "$extension"
    done
    # Remove Extensions not in file
    for extension in $(diff --ignore-all-space --changed-group-format='%>' --unchanged-group-format='' "$extensions_file" <(vscode_list_extensions)); do
      vscode_uninstall_extension "$extension"
    done
  fi
}
