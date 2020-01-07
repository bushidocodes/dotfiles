#!/bin/bash

# Useful resources since I don't write shell scripts too often
# https://arslan.io/2019/07/03/how-to-write-idempotent-bash-scripts/
# https://tecadmin.net/tutorial/bash-scripting/
# https://www.gnu.org/software/bash/manual/bash.html

############################
# Configure Git
# Note: Fill in email and fullname below to set
############################
email=""
fullname=""

if [[ -n "$email"  && -n "$fullname" ]]; then
  git config --global user.name "$fullname"
  git config --global user.email "$email"
fi

############################
# Install Misc Tools
############################

# Fira Code for X Window Apps
sudo apt install fonts-firacode --yes 

# Install VIM
sudo apt install vim --yes

# Install Curl
sudo apt install curl --yes

# Install HTTPie
sudo apt install httpie --yes

# Install Apache Bench
sudo apt install apache2-utils --yes

##########################
# Install C/C++
##########################

sudo apt install gcc gdb g++ clang-format make libtinfo5 libopenmpi-dev --yes

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

if [[ -x "$(command -v rustup)" ]]; then
  rustup update
else
  # See flags and options with curl https://sh.rustup.rs -sSf | bash -s -- --help
  curl https://sh.rustup.rs -sSf | bash -s -- -y
  source "$HOME/.cargo/env"
  export PATH="$HOME/.cargo/bin:$PATH"
fi

rustup component add rustfmt
rustup component add clippy

##########################
# Install Go
##########################

sudo snap install go --classic
mkdir -p "$HOME/go"
go env -w GOPATH="$HOME/go"   

##########################
# Install Java
##########################

sudo apt install openjdk-11-jdk openjdk-8-jdk maven --yes

if [[ ! -d "$HOME/.jenv" ]]; then
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  source ~/.bash_profile
  source ~/.bashrc
fi

jenv add /usr/lib/jvm/java-8-openjdk-amd64
jenv add /usr/lib/jvm/java-11-openjdk-amd64
jenv global 11.0

##########################
# Install Python
##########################

# Python Build Dependencies
sudo apt install build-essential libsqlite3-dev sqlite3 bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev libgdbm-compat-dev liblzma-dev libreadline-dev libncursesw5-dev libffi-dev uuid-dev --yes

# I use pyenv to manage my tools https://github.com/pyenv/pyenv
if pyenv --version | grep -q 'pyenv 1'; then
  echo "pyenv 1.x is already installed and in path"
else
  echo "Installing Pyenv"
  curl https://pyenv.run | bash
  source ~/.bash_profile
  source ~/.bashrc
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
if [[ -x "$(command -v ansible)" ]]; then
  echo "Ansible installed and in path"
else 
  sudo apt-add-repository ppa:ansible/ansible
  sudo apt update
  sudo apt install ansible --yes
fi 

export ansible_python_interpreter=/usr/bin/python2

############################
# Install Node.js 
############################

if [[ -x "$(command -v n)" ]]; then
  echo "n installed and in path"
  n-update -y
  source ~/.bash_profile
  source ~/.bashrc
else
  # We use the -n argument because we have already configured our profile in our .dotfiles repo for n
  curl -L https://git.io/n-install | bash -s -- -n
  sudo chown -R "$USER":"$(id -gn "$USER")" /home/sean/.config
  source ~/.bash_profile
  source ~/.bashrc
fi

############################
# Bash Stuff
############################
npm i -g bats

# ShellCheck, a static analysis tool for shell scripts
# https://github.com/koalaman/shellcheck
if grep -qi Microsoft /proc/version; then
  echo "WSL Detected"
  cd ~ || exit
  wget https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz
  tar -xvf shellcheck-stable.linux.x86_64.tar.xz
  sudo mv ./shellcheck-stable/shellcheck /usr/bin
  rm -rf ./shellcheck-stable 
  rm shellcheck-stable.linux.x86_64.tar.xz
else 
  snap install --channel=edge shellcheck
fi

# Simple HTTP Server. https://www.npmjs.com/package/http-server
if [[ ! -x "$(command -v http-server)" ]]; then
  npm i -g http-server
fi

# Netlify CLI. https://github.com/netlify/cli
if [[ ! -x "$(command -v netlify)" ]]; then
  npm i -g netlify-cli
fi

# Fancy Kill. Nicer UX for killing processes
if [[ ! -x "$(command -v fkill)" ]]; then
  npm i -g fkill-cli
fi

# Install Exercism
if [[ ! -x "$(command -v exercism)" ]]; then
  cd ~ || exit
  curl -O -J -L https://github.com/exercism/cli/releases/download/v3.0.12/exercism-linux-64bit.tgz
  tar -xvf exercism-linux-64bit.tgz
  mkdir -p ~/bin
  mv exercism ~/bin
  rm exercism-linux-64bit.tgz
  echo "Be sure to manually configure the Exercism CLI with your Token"
else 
  exercism upgrade
fi

###########################
# Wasmer
###########################
if [[ ! -x "$(command -v wasmer)" ]]; then
  curl https://get.wasmer.io -sSfL | sh
fi 

###########################
# Wasmtime
###########################
if [[ ! -x "$(command -v wasmtime)" ]]; then
  curl https://wasmtime.dev/install.sh -sSf | bash
fi

###########################
# WAVM Pre-Release Nightly
###########################
if [[ ! -x "$(command -v wavm)" ]]; then
  WAVM_DEB_PATH=https://github.com/WAVM/WAVM/releases/download/nightly%2F2019-12-25/wavm-0.0.0-prerelease-linux.deb
  WAVM_DEB_NAME=wavm-0.0.0-prerelease-linux.deb
  cd ~ || exit
  wget $WAVM_DEB_PATH
  mv $WAVM_DEB_NAME wavm-1.0.0-linux.deb
  sudo apt install ./wavm-1.0.0-linux.deb
  rm wavm-1.0.0-linux.deb
fi

###########################
# Lucet
###########################
# cd ~/projects
# git clone --recurse-submodules git@github.com:bytecodealliance/lucet.git
# cd lucet
# source devenv_setenv.sh
# cd ~

############################
# QEMU
############################
sudo apt install qemu --yes

############################
# Emscripten
############################

if [[ ! -x "$(command -v emsdk)" ]]; then
  cd ~ || exit
  git clone https://github.com/emscripten-core/emsdk
  # Update and activate latest
  cd ~/emsdk || exit
  ./emsdk install latest
  ./emsdk activate latest
  cd ~ || exit
fi

###########################
# Kubernetes
###########################
# if [ ! -x "$(command -v kubectl)" ]; then
#   echo "Installing Kubectl"
#   sudo apt-get update && sudo apt-get install -y apt-transport-https
#   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#   echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
#   sudo apt-get update
#   sudo apt-get install -y kubectl
# fi 

# Helm 2
# if [ ! -x "$(command -v helm)" ]; then
#   echo "Installing Helm"
#   cd ~
#   wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz   
#   tar -xvf helm-v2.16.1-linux-amd64.tar.gz linux-amd64/tiller linux-amd64/helm  
#   sudo mv linux-amd64/tiller /usr/bin
#   sudo mv linux-amd64/helm /usr/bin
#   rm -r linux-amd64
#   rm helm-v2.16.1-linux-amd64.tar.gz  
#   helm init --upgrade
# fi

# Helm 3 - Too early !
# curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

############################
# Open Whisk
############################
# if [ ! -x "$(command -v wsk)" ]; then
#   echo "Installing OpenWhisk"
#   cd ~
#   wget https://github.com/apache/openwhisk-cli/releases/download/1.0.0/OpenWhisk_CLI-1.0.0-linux-amd64.tgz
#   tar -xvf OpenWhisk_CLI-1.0.0-linux-amd64.tgz wsk  
#   sudo mv wsk /usr/bin
#   rm OpenWhisk_CLI-1.0.0-linux-amd64.tgz 
# fi


############################
# WSL Specific 
############################

# if grep -qi Microsoft /proc/version; then
  # echo "WSL Detected"
  # WSL reuse of Windows host environment fonts seems to cause issues using Windows apps while running X window apps
  # sudo rm -f /etc/fonts/local.conf
  # Assume that this was done manually as part of README
  # ln -sf /c/Users/Sean ~/winhome
  # ln -sf /c/Users/Sean/.ssh ~/.ssh

# fi


############################
# Cleanup
############################
sudo apt autoremove -y
