#!/bin/sh

##########################
# Update, Upgrade
##########################
sudo apt update --yes                                 # Update Aptitude Repositories
sudo apt upgrade --yes                                # Upgrade Aptitude Packages
sudo apt install software-properties-common --yes # Install PPA Dependencies

############################
# Nuke config files and link dotfiles
############################

mkdir ~/.cargo
rm ~/.profile ~/.bashrc ~/.bash_logout ~/.gitconfig ~/.zshrc ~/.zsh_plugins.txt ~/.zprofile
mkdir -p ~/bin
if grep -qi Microsoft /proc/version; then
  # We assume PowerShell installed Code by this point, so just set the settings file...
  export CODE_PATH="$HOME/winhome/AppData/Roaming/Code/User"
else
  mkdir -p ~/.config/  
  mkdir -p ~/.config/Code/ 
  mkdir -p ~/.config/Code/User/
  cp ~/.dotfiles/vscode_settings.json ~/winhome/AppData/Roaming/Code/User
fi

sudo ./install