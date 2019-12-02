#!/bin/zsh

# Useful resources since I don't write shell scripts too often
# https://arslan.io/2019/07/03/how-to-write-idempotent-bash-scripts/
# https://tecadmin.net/tutorial/bash-scripting/

##########################
# Install Antibody
##########################

if [ -x "$(command -v antibody)" ]
then
  antibody update
else 
  curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
fi

##########################
# Install C/C++
##########################

sudo apt-get install gcc gdb g++ clang-format make libtinfo5 libopenmpi-dev --yes

##########################
# LLVM
# Based on https://apt.llvm.org/llvm.sh
##########################

sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

LLVM_VERSION=9
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$LLVM_VERSION 100
sudo update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-$LLVM_VERSION 100

# Additional Libraries needed for Silverfish
sudo apt install libc++-dev --yes
sudo apt install libc++abi-dev --yes

##########################
# Install Rust
##########################

if [ -x "$(command -v rustup)" ]
then
  rustup update
else 
  curl https://sh.rustup.rs -sSf | sh
fi
source ~/.zshrc
rustup component add rustfmt
rustup component add clippy

##########################
# Install Java
##########################

sudo apt-get install openjdk-11-jdk openjdk-8-jdk maven --yes
if [ ! -d "~/.jenv" ]; then
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  source ~/.zshrc
fi
jenv add /usr/lib/jvm/java-8-openjdk-amd64
jenv add /usr/lib/jvm/java-11-openjdk-amd64
jenv global 11.0

##########################
# Install Python
##########################

# Python Build Dependencies
sudo apt-get install build-essential libsqlite3-dev sqlite3 bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev libgdbm-compat-dev liblzma-dev libreadline-dev libncursesw5-dev libffi-dev uuid-dev

# I use pyenv to manage my tools https://github.com/pyenv/pyenv
if pyenv --version | grep -q 'pyenv 1'; then
  echo "pyenv 1.x is already installed and in path"
else
  echo "Installing Pyenv"
  curl https://pyenv.run | bash
  source ~/.zshrc
  pyenv install 3.7.5
  pyenv global 3.7.5
fi 

if python3 --version | grep -q 'Python 3.7.5'; then
  echo "Python 3.7.5 is already installed and in path"
else
  pyenv install 3.7.5
  pyenv global 3.7.5
fi

############################
# Install Ansible
############################
if python3 --version | grep -q 'ansible'; then
  echo "Ansible installed and in path"
else 
  sudo pip install -U ansible
fi 

ansible_python_interpreter=/usr/bin/python2

############################
# Install Node.js 
############################

# Note: you need to remove the N_PREFIX value from zshrc prior to installation
if [ -x "$(command -v n)" ]
then
  n-update -y
  source ~/.zshrc
else 
  curl -L https://git.io/n-install | bash
  source ~/.zshrc
fi

############################
# Install Misc Tools
############################

# Fira Code for X Window Apps
sudo apt-get install fonts-firacode --yes 

# Install VIM
sudo apt-get install vim --yes

# Install Curl
sudo apt-get install curl --yes

# Simple HTTP Server. https://www.npmjs.com/package/http-server
if ! [ -x "$(command -v http-server)" ]; then
  npm i -g http-server
fi

# Netlify CLI. https://github.com/netlify/cli
if ! [ -x "$(command -v netlify)" ]; then
  npm i -g netlify-cli
fi

# Fancy Kill. Nicer UX for killing processes
if ! [ -x "$(command -v fkill)" ]; then
  npm i -g fkill-cli
fi

# Rimraf tool. I'm unclear why this is getting installed globally
# if ! [ -x "$(command -v rimraf)" ]; then
#   npm i -g rimraf
# fi

# Install Exercism
if [ ! -x "$(command -v exercism)" ]; then
  cd ~
  curl -O -J -L https://github.com/exercism/cli/releases/download/v3.0.12/exercism-linux-64bit.tgz
  tar -xvf exercism-linux-64bit.tgz
  mkdir -p ~/bin
  mv exercism ~/bin
  rm exercism-linux-64bit.tgz
  echo "Be sure to manually configure the Exercism CLI with your Token"
else 
  exercism upgrade
fi

############################
# Docker
# Legacy Approach for WSL1
############################

# sudo apt-get install -y \
# 	apt-transport-https \
# 	ca-certificates \
# 	curl \
# 	software-properties-common

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo apt-key fingerprint 0EBFCD88
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-get install -y docker-ce
# sudo usermod -aG docker $USER
# pip install --user docker-compose


###########################
# Kubernetes
###########################
if [ ! -x "$(command -v kubectl)" ]; then
  echo "Installing Kubectl"
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
fi 

# Helm 2
if [ ! -x "$(command -v helm)" ]; then
  echo "Installing Helm"
  cd ~
  wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz   
  tar -xvf helm-v2.16.1-linux-amd64.tar.gz linux-amd64/tiller linux-amd64/helm  
  sudo mv linux-amd64/tiller /usr/bin
  sudo mv linux-amd64/helm /usr/bin
  rm -r linux-amd64
  rm helm-v2.16.1-linux-amd64.tar.gz  
  helm init --upgrade
fi

# Helm 3 - Too early !
# curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

############################
# Open Whisk
############################
if [ ! -x "$(command -v wsk)" ]; then
  echo "Installing OpenWhisk"
  cd ~
  wget https://github.com/apache/openwhisk-cli/releases/download/1.0.0/OpenWhisk_CLI-1.0.0-linux-amd64.tgz
  tar -xvf OpenWhisk_CLI-1.0.0-linux-amd64.tgz wsk  
  sudo mv wsk /usr/bin
  rm OpenWhisk_CLI-1.0.0-linux-amd64.tgz 
fi


############################
# WSL Specific 
############################

if grep -qi Microsoft /proc/version; then
  echo "WSL Detected"
  # WSL reuse of Windows host environment fonts seems to cause issues using Windows apps while running X window apps
  sudo rm -f /etc/fonts/local.conf
  ln -sf /c/Users/Sean ~/winhome
  ln -sf /c/Users/Sean/.ssh ~/.ssh

fi

############################
# QEMU
############################
sudo apt-get install qemu --yes

############################
# Cleanup
############################
sudo apt autoremove -y

############################
# Unused archive of scripts
############################

## Backup.... Install OpenMPI from Source... This is SLOW!
# cd ~
# wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz
# tar -xvf openmpi-3.1.3.tar.gz
# cd openmpi-3.1.3
# ./configure --prefix="/home/$USER/.openmpi"
# make
# rm -r openmpi-3.1.3


# Install Emscripten Stuff (not idempotent
# cd ~
# mkdir Tooling
# cd Tooling
# git clone https://github.com/juj/emsdk.git
# cd emsdk
# ./emsdk install sdk-1.38.15-64bit
# ./emsdk activate sdk-1.38.15-64bit

# Install Fix for VSCode Python language server needed libssl 1.0.0
# sudo apt-get install multiarch-support --yes
# cd ~
# wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u11_amd64.deb
# sudo dpkg -i libssl1.0.0_1.0.1t-1+deb8u11_amd64.deb

# Install Android Malware Tools
# pip install -U androguard pyqt5 pyperclip
# sudo apt-get install qtdeclarative5-dev

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