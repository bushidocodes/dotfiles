# Desktop Apps
sudo snap install code --classic
sudo snap install slack --classic
sudo snap install teams-for-linux

# VSCode Extensions
code --install-extension PKief.material-icon-theme
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension stardog-union.stardog-rdf-grammars
code --install-extension 13xforever.language-x86-64-assembly
code --install-extension ms-vscode.cpptools
code --install-extension naumovs.color-highlight
code --install-extension vscjava.vscode-java-pack
code --install-extension ms-azuretools.vscode-docker
code --install-extension MS-vsliveshare.vsliveshare-pack
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.python
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension ms-vscode.PowerShell
code --install-extension bungcip.better-toml
code --install-extension CoenraadS.bracket-pair-colorizer-2
code --install-extension rust-lang.rust
code --install-extension serayuzgur.crates
code --install-extension jpoissonnier.vscode-styled-components
code --install-extension WakaTime.vscode-wakatime

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