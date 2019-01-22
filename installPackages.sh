# The intent here is to add a script for things I want to install between my UNIX environments
# This isn't idempotent, so I don't want to run this directly yet...

# Setup Ubuntu
sudo apt update --yes
sudo apt upgrade --yes

# Get Miniconda and make it the main python interpreter
wget --no-check-certificate https://repo.continuum.io/miniconda/Miniconda-3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/miniconda
rm ~/miniconda.sh

# Install Antibody
curl -sL git.io/antibody | sh -s

# TODO: Install MPI... maybe just add binaries to repo and add to path?