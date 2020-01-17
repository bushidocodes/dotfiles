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

# Configure Optional Windows Features
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform               # Enable Windows VM Platform          
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux    # Enable WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All               # Enable Hyper-V
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online    # Disable IE11

Restart-Computer
