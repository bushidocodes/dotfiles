#!/bin/zsh

# Useful resources since I don't write BASH scripts too often
# https://arslan.io/2019/07/03/how-to-write-idempotent-bash-scripts/
# https://tecadmin.net/tutorial/bash-scripting/

# Install Python Tools
curl https://pyenv.run | bash
sudo apt-get install python3 --yes

# Add add-apt-repository based on https://itsfoss.com/add-apt-repository-command-not-found/
sudo apt-get install software-properties-common --yes

# If running on WSL, wipe out the local.conf fonts file because WSL reuse of Windows host environment fonts caused issues using Windows apps while running X window apps
if grep -q Microsoft /proc/version; then
  echo "Ubuntu on Windows"
  sudo rm -f /etc/fonts/local.conf
fi

# Install Fira Code for use in X Window Apps.
sudo apt-get install fonts-firacode --yes

# Install VIM
sudo apt-get install vim --yes

# Install Curl
sudo apt-get install curl --yes

# Install Antibody
if [ -x "$(command -v antibody)" ]
then
  antibody update
else 
  curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
fi

# Install C / C++ tools
sudo apt-get install gcc gdb g++ clang-format make libtinfo5 libopenmpi-dev --yes

# Install Rust Tools
if [ -x "$(command -v rustup)" ]
then
  rustup update
else 
  curl https://sh.rustup.rs -sSf | sh
fi
source ~/.zshrc
rustup component add rustfmt
rustup component add clippy

# Install Exercism
if [ ! -x "$(command -v exercism)" ]; then
  cd ~
  curl -O -J -L https://github.com/exercism/cli/releases/download/v3.0.12/exercism-linux-64bit.tgz
  tar -xvf exercism-linux-64bit.tgz
  mkdir -p ~/bin
  mv exercism ~/bin
  rm exercism-linux-64bit.tgz
  echo "Be sure to manually configure the Exercism CLI with your Token"
fi
exercism upgrade


# Add Java tools
sudo apt-get install openjdk-11-jdk openjdk-8-jdk maven --yes
if [ ! -d "~/.jenv" ]; then
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  source ~/.zshrc
fi
jenv add /usr/lib/jvm/java-8-openjdk-amd64
jenv add /usr/lib/jvm/java-11-openjdk-amd64
jenv global 11.0

# Install N, Node, and the Native Module build tools 
# Note: you need to remove the N_PREFIX value from zshrc prior to installation
# n-install: ERROR:
#   Aborting, because an existing definition of $N_PREFIX added by someone else
#   was found in '/home/sean/.zshrc':

#   export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

#   Please remove it and try again.
# n-install: ERROR: ABORTING due to unexpected error.
if [ -x "$(command -v n)" ]
then
  n-update -y
  source ~/.zshrc
else 
  curl -L https://git.io/n-install | bash
  source ~/.zshrc
fi

if ! [ -x "$(command -v http-server)" ]; then
  npm i -g http-server
fi

if ! [ -x "$(command -v netlify)" ]; then
  npm i -g netlify-cli
fi

if ! [ -x "$(command -v fkill)" ]; then
  npm i -g fkill-cli
fi

if ! [ -x "$(command -v rimraf)" ]; then
  npm i -g rimraf
fi

## Auto-remove stuff I don't need
sudo apt autoremove -y

## TODO Stuff

# Move to zshrc
# sudo echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

# Alias for colonialzero
# ssh seanmcbride@login.colonialone.gwu.edu

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