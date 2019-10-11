# Must be run from PowerShell run as Administrator

# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# And Install Choco Packages
choco install googlechrome
choco install firefox
choco install 7zip
choco install vlc
choco install git
choco install foxitreader
choco install zoom
choco install steam
choco install vscode
choco install docker-desktop
choco install firacode

# Install PowerShell Modules
Install-Module -Name posh-git

# Install VSCode Extensions
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

# Configure Optional Windows Features
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform               # Enable Windows VM Platform          
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux    # Enable WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All               # Enable Hyper-V
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online    # Disable IE11

Restart-Computer
