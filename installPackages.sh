#!/bin/zsh

# The intent here is to add a script for things I want to install between my UNIX environments
# This isn't idempotent, so I don't want to run this directly yet...

# Setup Ubuntu
sudo apt update --yes
sudo apt upgrade --yes

# Add add-apt-repository based on https://itsfoss.com/add-apt-repository-command-not-found/
sudo apt-get install software-properties-common

# If running on WSL, wipe out the local.conf fonts file because WSL reuse of Windows host environment fonts caused issues using Windows apps while running X window apps
if grep -q Microsoft /proc/version; then
  echo "Ubuntu on Windows"
  sudo rm -f /etc/fonts/local.conf
fi

# Install Fira Code for VSCode. Commented out because WSL can reuse Windows host environment fonts
sudo apt install fonts-firacode --yes

# Install VIM
sudo apt-get install vim --yes

# Install Curl
sudo apt-get install curl --yes

# Get Miniconda and make it the main python interpreter
# Warning: Not idempotent
# wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh 
# chmod +x ~/miniconda.sh
# zsh ~/miniconda.sh -b -p ~/miniconda
# rm ~/miniconda.sh
# export PATH=$PATH:$HOME/miniconda/bin
# conda update --prefix /home/sean/miniconda anaconda
# conda create --name myenv --yes
# source activate myenv

# Install Android Malware Tools
pip install -U androguard pyqt5 pyperclip
sudo apt-get install qtdeclarative5-dev

# Install Antibody
curl -sL git.io/antibody | sh -s

# Install C / C++ tools
sudo apt-get install gcc gdb g++ clang-format make libtinfo5 --yes

# Install Emscripten Stuff (not idempotent
cd ~
mkdir Tooling
cd Tooling
git clone https://github.com/juj/emsdk.git
cd emsdk
./emsdk install sdk-1.38.15-64bit
./emsdk activate sdk-1.38.15-64bit

# Add Java tools
sudo apt-get install maven --yes

# Google Cloud
# https://cloud.google.com/sdk/docs/#deb
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get install google-cloud-sdk --yes

# Install N, Node, and the Native Module build tools 
# Note: you need to remove the N_PREFIX value from zshrc prior to installation
# n-install: ERROR:
#   Aborting, because an existing definition of $N_PREFIX added by someone else
#   was found in '/home/sean/.zshrc':

#   export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

#   Please remove it and try again.
# n-install: ERROR: ABORTING due to unexpected error.
curl -L https://git.io/n-install | bash
# Source in order to have Node and npm in path for global installs
source ~/.zshrc
npm i -g http-server
npm i -g netlify-cli
npm i -g fkill-cli
npm i -g rimraf

## Install OpenMPI from Apt
sudo apt install libopenmpi-dev

## Install OpenMPI from Source... This is SLOW!
# cd ~
# wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz
# tar -xvf openmpi-3.1.3.tar.gz
# cd openmpi-3.1.3
# ./configure --prefix="/home/$USER/.openmpi"
# make
# rm -r openmpi-3.1.3

## Auto-remove stuff I don't need
sudo apt autoremove -y

## TODO Stuff

# Move to zshrc
# sudo echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

# Alias for colonialzero
# ssh seanmcbride@login.colonialone.gwu.edu

# ipcluster start -n 4 --engines=MPIEngineSetLauncher
# ipcluster nbextension enable --user
# cd $IPYTHONDIR
# vim ipcluster_config.py
# I need to get the last line of this file and create a commend to append to this..
