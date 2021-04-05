# dotfiles

![](https://media.giphy.com/media/9kSM4y028LvvW/giphy.gif)

## General Notes

A developer's toolchain is like a lightsaber. Just as Jedi quest across the galaxy, get Khyber crystals and other components, and assemble their weapon, developers experiment with shells, compilers, debuggers, etc., develop opinions, and assemble a custom toolchain. Different fighting styles suit different lightsabers just as different toolchains suit different development styles.

Dotfiles are an automation tool used by software craftsman to achieve stabile and repeatable builds of their custom toolchains across one or more machines. You can tell a lot about a developer by looking at their dotfiles. You can also potentially discover tools you can used to improve your own toolchain.

For example, looking at my dotfiles, you can see I'm a pragmatic polyglot software craftsman with a UNIX mentality and an affinity for Microsoft tools. Some of you might consider this a bit of a contradiction, and that's fine!

The important thing is that these are MY dotfiles automating MY toolchain based on MY opinions. By all means, take a look and copy anything you might find useful, but this repo is designed and intended for me and me alone. Use at your own risk.

In the spirit of the software craftsmanship movement, I suggest that you build and maintain similar dotfiles for your infrastructure. However, you shouldn't just clone other folks' automation, as that likely means that you won't understand how things work, so your automation will quickly became a fragile and unmaintainable stack of black boxes. Plz. Learn your tools!

## My Opinions

My personal opinion is that the highest velocity way to customize your toolchain is to have a clean bimodal separation between a highly customized environment that evolves quickly (perhaps WSL or a Docker container) running on top of a stable foundation (via Windows or perhaps Ubuntu LTS). Experimenting with developer tools should not risk destabilizing my Desktop environment or apps. Additionally, I don't view having a highly customized operating system as pragmatic or time-efficient, which is where I differ from the many software craftsmen using Arch Linux.

Here is what my toolchain currently looks like:

- Windows 10 as the desktop environment
- [winget](https://github.com/microsoft/winget-cli) for native Windows package management
- [WSL2](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) and Ubuntu 20 LTS as my dev environment
- [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal-preview/9n0dx20hk701)
- [VSCode](https://code.visualstudio.com/) as the main code editor, using the [WSL Remote extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)
- Tooling for a wide variety of development stacks

While I generally use this repo to quickly standup my dev stack using Windows and a Debian-based WSL distro, it's organized so I can also install my tools on a native Debian-based system (typically a beefy remote dev server). One of those systems happens to be a native Debian "escape hatch" on a separate partition just in case I have to do something that seems to require native Linux. The most recent thing I've has to use this for was neural network stuff that required CUDA and direct access to the GPU. However, I expect that [WSL's net GPU passthrough feature](https://www.docker.com/blog/wsl-2-gpu-support-is-here/) may eliminate this use case.

## Why a Unix Hacker might want to use Windows

I like Windows because it's an open ecosystem with a huge variety of devices, strong drivers, and support for games. You can get Mac-like ultrabooks from a ton of manufacturers. You can buy used gear for cheap. You can slap together beastly gaming rigs using parts of your choice, and things _generally just work_. You aren't forced to buy devices with touchbars or keyboards you don't like. You don't need to stress about resolution and aspect ratios when plugging into projectors. You don't need to download hacked together drivers (or worse... mother-flipping Hackintosh kernel extensions) to try to run an operating system that your computer wasn't designed and tested for.

Obviously, there are rough spots in Windows. Here my annoyances:

- How-to tutorials can be quite out-of-date, as the sorts of Windows admins that google how to do things are the sort that need Wizards, and Microsoft seems to change these super frequently. This is why I always search "How to X using PowerShell" to get smarter non-fragile solutions.
- It feels like there are often ten ways to do things, nine of which are archaic and retained for backwards-compatibility reasons. Much of these things are visually hidden, but remain a WindowsKey+R keystroke away. Crappy blog posts will suggest all sorts of insane things.
- Sometimes you open a rarely used component, and you see a weird Windows XP design that looks out of place in Windows 10. These are usually the things that you have to WindowsKey+R to get to.
- Things are unfamiliar for \*NIX hackers. Config stuff is likely not just a text file away. Editing the Windows Registry feels like playing Jenga. The command-line traditionally feels like a second class citizen because I can't `Install-App -Name Xbox` and `Install-App -Name Gears5`. This is improving due to [winget](https://github.com/microsoft/winget-cli), but for whatever reason, silent installation flags seem to be poorly documented and fail regularly.
- Windows apps seem to require being run as Admin more than one would expect, making the lack of `sudo` quite painful. It sucks to have to relaunch a terminal emulator program as an Administrator, particularly since the new Microsoft Terminal app does not support per-tab user permissions.
- Many many systems restart!

## Windows Setup

As mentioned above, Windows currently cannot be automated as completely as a \*NIX system. However, I've done my best to carry over the spirit of dotfiles to Windows. If you're on a new system, you won't have clone this repo, and you may not even have git. I normally manually download the PowerShell scripts in this repo and wait to clone this repo until in WSL.

1. Install Windows 10
2. Trigger Updates.
3. Configure SSH keys in WINHOME/.ssh
4. Run `windows/install.ps1` in PowerShell as Admin
5. Install Windows Store Apps other than a WSL distro (these may autodownload if you sync via a Microsoft account).
   - Your Phone
   - Xbox
   - X410
   - Sticky Nodes
   - OneNote
   - To Do
   - Photos
   - Mail and Calendar
6. Manually Install other Windows Software
   - [Fira Code](https://github.com/tonsky/FiraCode/wiki/Installing)
   - [Office 365](https://www.office.com/)
   - [Scansnap Manager for S1100i](http://scansnap.fujitsu.com/global/dl/)
   - [Davinci Resolve](https://www.blackmagicdesign.com/products/davinciresolve/)
   - [Brother MGL-Pro Suite DCP-L2540DW](https://support.brother.com/g/b/downloadtop.aspx?c=us&lang=en&prod=dcpl2540dw_us_as)
7. If on 20H1 or later, tun `windows/install2.ps1` in PowerShell with Admin. This sets WSL2 as default
8. Install a WSL Distro from the Windows Store
9. Launch your WSL Distro and create a user
10. Configure WSL to mount Windows volume with Linux metadata. We need this to be able to share SSH keys between WSL and native Windows.

Create /etc/wsl.conf with the following:

```
[automount]
enabled             = true
crossDistro         = true
root                = /
options             = metadata

[interop]
enabled             = true
appendWindowsPath   = true
```

Then terminate your WSL distro to force the changes to take effect:

```
wsl.exe --terminate <distro_name>
```

10. Link SSH from Windows and make sure the config files have the proper metadata configured:

```sh
ln -s /c/Users/sean ~/winhome
ln -s /c/Users/sean/.ssh ~/.ssh
sudo chmod 644 ~/.ssh/config
chmod 400 ~/.ssh/id_rsa
```

## Linux Stuff

1. Install a System Python Interpreter
   `sudo apt-get install python-pip`

2. Clone gitfiles and run ./installPackages.sh to link dotfiles

```sh
git clone git@github.com:bushidocodes/dotfiles.git
mv dotfiles .dotfiles
cd ~/.dotfiles/
./install.sh
```
