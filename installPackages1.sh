#!/bin/sh

# Setup Ubuntu
sudo apt update --yes
sudo apt upgrade --yes

# Install zsh
sudo apt-get install zsh -y
chsh -s /bin/zsh
