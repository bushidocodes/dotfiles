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

LLVM_VERSION=9
DISTRO=$(lsb_release -is)
VERSION=$(lsb_release -sr)
DIST_VERSION="${DISTRO}_${VERSION}"

declare -A LLVM_VERSION_PATTERNS
LLVM_VERSION_PATTERNS[8]="-8"
LLVM_VERSION_PATTERNS[9]="-9"
LLVM_VERSION_PATTERNS[10]=""

if [ ! ${LLVM_VERSION_PATTERNS[$LLVM_VERSION]+_} ]; then
    echo "This script does not support LLVM version $LLVM_VERSION"
    exit 3
fi

LLVM_VERSION_STRING=${LLVM_VERSION_PATTERNS[$LLVM_VERSION]}

# find the right repository name for the distro and version
case "$DIST_VERSION" in
    Debian_9* )       REPO_NAME="deb http://apt.llvm.org/stretch/  llvm-toolchain-stretch$LLVM_VERSION_STRING main" ;;
    Debian_10* )      REPO_NAME="deb http://apt.llvm.org/buster/   llvm-toolchain-buster$LLVM_VERSION_STRING  main" ;;
    Debian_unstable ) REPO_NAME="deb http://apt.llvm.org/unstable/ llvm-toolchain$LLVM_VERSION_STRING         main" ;;
    Debian_testing )  REPO_NAME="deb http://apt.llvm.org/unstable/ llvm-toolchain$LLVM_VERSION_STRING         main" ;;
    Ubuntu_16.04 )    REPO_NAME="deb http://apt.llvm.org/xenial/   llvm-toolchain-xenial$LLVM_VERSION_STRING  main" ;;
    Ubuntu_18.04 )    REPO_NAME="deb http://apt.llvm.org/bionic/   llvm-toolchain-bionic$LLVM_VERSION_STRING  main" ;;
    Ubuntu_18.10 )    REPO_NAME="deb http://apt.llvm.org/cosmic/   llvm-toolchain-cosmic$LLVM_VERSION_STRING  main" ;;
    Ubuntu_19.04 )    REPO_NAME="deb http://apt.llvm.org/disco/    llvm-toolchain-disco$LLVM_VERSION_STRING   main" ;;
    * )
        echo "Distribution '$DISTRO' in version '$VERSION' is not supported by this script (${DIST_VERSION})."
esac

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository "${REPO_NAME}"
sudo apt-get update
sudo apt-get install -y clang-$LLVM_VERSION lldb-$LLVM_VERSION lld-$LLVM_VERSION clangd-$LLVM_VERSION

# Note: The binaries are all suffixed by the major version, so symlink what we just installed
LLVMFILES=/usr/bin/llvm-*
CLANGFILES=/usr/bin/clang*
LLC=/usr/bin/llc-3.6
OPT=/usr/bin/opt-3.6

for f in $LLVMFILES $CLANGFILES $LLC $OPT
do
	link=${f%-*}
	echo "linking" $f "to" $link
	sudo ln -s $f $link
done

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
  echo "Installing Python 3"
  curl https://pyenv.run | bash
fi 

if python3 --version | grep -q 'Python 3.7.4'; then
  echo "Python 3.7.4 is already installed and in path"
else
  pyenv install 3.7.4
  pyenv global 3.7.4
fi

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

############################
# WSL Specific 
############################

if grep -qi Microsoft /proc/version; then
  echo "WSL Detected"
  # WSL reuse of Windows host environment fonts seems to cause issues using Windows apps while running X window apps
  sudo rm -f /etc/fonts/local.conf
  ln -s /c/Users/Sean ~/winhome
  ln -s /c/Users/Sean/.ssh ~/.ssh

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