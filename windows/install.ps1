# Must be run from PowerShell run as Administrator

# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# And Install Choco Packages
choco install 7zip
choco install vlc
choco install git
choco install foxitreader
choco install zoom
choco install steam
choco install vscode
choco install docker-desktop
choco install firacode

# winget install 7zip.7zip
# winget install VideoLAN.VLC
# winget install Git.Git
# winget install Foxit.FoxitReader
# winget install Zoom.Zoom
# winget install Valve.Steam
# winget install Microsoft.VisualStudioCode.User-x64
# winget install Docker.DockerDesktop
# winget install Discord.Discord
# winget install Spotify.Spotify
# winget install Microsoft.WindowsTerminal
# winget install Blizzard.BattleNet
# winget install PrivateInternetAccess.PrivateInternetAccess
# winget install Microsoft.Teams
# winget install GOG.Galaxy
# winget install Apple.iTunes
# winget install OBSProject.OBSStudio
# winget install LogMeIn.LastPass

# Install PowerShell Modules
Install-Module -Name posh-git

# Configure Optional Windows Features
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform               # Enable Windows VM Platform          
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux    # Enable WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All               # Enable Hyper-V
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online    # Disable IE11

Restart-Computer
