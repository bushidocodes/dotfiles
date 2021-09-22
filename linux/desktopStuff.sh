#!/bin/bash

# Desktop Apps
sudo snap install code --classic
sudo snap install slack --classic
sudo snap install teams-for-linux

# Docker CE
# Based on https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

if docker-compose --version | grep -q 'docker-compose version 1'; then
	echo "docker-compose is already installed and in path"
else
	echo "Installing Docker Compose"
	pip install --user docker-compose
fi
