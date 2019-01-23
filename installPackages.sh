# The intent here is to add a script for things I want to install between my UNIX environments
# This isn't idempotent, so I don't want to run this directly yet...

# Setup Ubuntu
sudo apt update --yes
sudo apt upgrade --yes

# Add Universe
sudo add-apt-repository universe

# Install Fira Code for VSCode
sudo apt install fonts-firacode --yes

# Install VIM
sudo apt-get install vim --yes

# Get Miniconda and make it the main python interpreter
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh 
chmod +x ~/miniconda.sh
zsh ~/miniconda.sh -b -p ~/miniconda
rm ~/miniconda.sh
export PATH=$PATH:$HOME/miniconda/bin
conda update --prefix /home/sean/miniconda anaconda
conda create --name myenv --yes
source activate myenv

# Install Antibody
curl -sL git.io/antibody | sh -s

# Install N, Node, and the Native Module build tools 
curl -L https://git.io/n-install | bash
sudo apt-get install gcc g++ make --yes
# http-server
npm i -g http-server
# netlify-cli
npm i -g netlify-cli

## Install OpenMPI from Apt
sudo apt-get install openmpi-bin openmpi-common openssh-client openssh-server libopenmpi3
libopenmpi3-dbgsym libopenmpi-dev --yes

## Install OpenMPI from Source... This is SLOW!
# cd ~
# wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz
# tar -xvf openmpi-3.1.3.tar.gz
# cd openmpi-3.1.3
# ./configure --prefix="/home/$USER/.openmpi"
# make
# rm -r openmpi-3.1.3


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
