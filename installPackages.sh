# Setup Ubuntu
# sudo apt update --yes
# sudo apt upgrade --yes

# Get Miniconda and make it the main python interpreter
wget --no-check-certificate https://repo.continuum.io/miniconda/Miniconda-3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/miniconda
rm ~/miniconda.sh

# Install Antibody
curl -sL git.io/antibody | sh -s