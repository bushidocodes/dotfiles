# The intent here is to add a script for things I want to install between my UNIX environments
# This isn't idempotent, so I don't want to run this directly yet...

# Setup Ubuntu
sudo apt update --yes
sudo apt upgrade --yes

# Get Miniconda and make it the main python interpreter
wget --no-check-certificate https://repo.continuum.io/miniconda/Miniconda-3-latest-Linux-x86_64.sh -O ~/miniconda.sh
chmod +x ~/miniconda.sh
zsh ~/miniconda.sh -b -p ~/miniconda
rm ~/miniconda.sh
conda update
conda create --name myenv
soure activate myenv

# Install Antibody
curl -sL git.io/antibody | sh -s

# Install VIM
sudo apt-get install vim

# TODO: Install MPI... maybe just add binaries to repo and add to path?

# NVM, NPM, Node.js

# Global NPM Modules
# http-server
# netlify-cli


# wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz
# tar -xvf openmpi-3.1.3.tar.gz
# cd openmpi-3.1.3
# ./configure --prefix="/home/$USER/.openmpi"
# make

# Move to zshrc
# sudo echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

# Alias for colonialzero
# ssh seanmcbride@login.colonialone.gwu.edu

# ipcluster start -n 4 --engines=MPIEngineSetLauncher
# ipcluster nbextension enable --user
# cd $IPYTHONDIR
# vim ipcluster_config.py
# I need to get the last line of this file and create a commend to append to this..
