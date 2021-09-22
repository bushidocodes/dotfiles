# Must be run from PowerShell run as Administrator

# TODO: Install firacode font
# choco install firacode
# winget does not yet support font installation. See https://github.com/tonsky/FiraCode/wiki/Installing

winget install 7zip.7zip
winget install Apple.iTunes
winget install Blizzard.BattleNet
winget install Discord.Discord
winget install Foxit.FoxitReader
winget install Git.Git
winget install GOG.Galaxy
winget install LogMeIn.LastPass
winget install Microsoft.Teams
winget install Microsoft.VisualStudioCode.User-x64
winget install Microsoft.WindowsTerminal
winget install OBSProject.OBSStudio
winget install PrivateInternetAccess.PrivateInternetAccess
winget install SlackTechnologies.Slack
winget install Spotify.Spotify
winget install Valve.Steam
winget install VideoLAN.VLC
winget install Zoom.Zoom

# Install PowerShell Modules
Install-Module -Name posh-git

# Configure Optional Windows Features
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform               # Enable Windows VM Platform          
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux    # Enable WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All               # Enable Hyper-V
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online    # Disable IE11

Restart-Computer
