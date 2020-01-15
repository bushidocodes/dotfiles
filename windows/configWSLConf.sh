#!/usr/bin/env bash

# Test if running under WSL
is_wsl() {
  grep -qi Microsoft /proc/version
}

# Symlink our custom wsl.conf, which mounts Windows drives at root
symlink_wsl_conf() {
  wsl_conf_symlink="/etc/wsl.conf"
  if [ ! -L "$wsl_conf_symlink" ]; then
    sudo ln -s ~/.dotfiles/windows/wsl.conf /etc/wsl.conf
  fi
}

main() {
  if is_wsl; then
    symlink_wsl_conf
  fi
}

main "$@"
