sudo snap install code --classic
sudo snap install slack --classic

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

# Docker
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

if docker-compose --version | grep -q 'docker-compose version 1'; then
  echo "docker-compose is already installed and in path"
else
  echo "Installing Docker Compose"
  pip install --user docker-compose
fi 