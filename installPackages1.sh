#!/bin/sh

##########################
# Update, Upgrade
##########################
sudo apt update --yes                                 # Update Aptitude Repositories
sudo apt upgrade --yes                                # Upgrade Aptitude Packages
sudo apt-get install software-properties-common --yes # Install PPA Dependencies

##########################
# Install zsh
##########################
if grep -q 'zsh' $SHELL; then
  echo "zsh is already default"
else
  echo "zsh is not default"
  sudo apt-get install zsh -y
  chsh -s /bin/zsh
fi

############################
# Nuke config files and link dotfiles
############################
rm ~/.profile ~/.bashrc ~/.bash_logout ~/.gitconfig ~/.zshrc ~/.zsh_plugins.txt
mkdir ~/.config/  
mkdir ~/.config/Code/ 
mkdir ~/.config/Code/User/
./install