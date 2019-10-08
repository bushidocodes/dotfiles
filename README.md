# dotfiles
Dotbot managed dotfiles... attempting to keep my environments in sync


```sh
cd ~
ln -s /mnt/c/Users/Sean ~/winhome  
ln -s ~/winhome/.ssh ~/.ssh
git clone git@github.com:bushidocodes/dotfiles.git
mv dotfiles .dotfiles
cd ~/.dotfiles/
./installPackages1.sh
```

Restart Shell

```sh
cd ~/.dotfiles/
./installPackages2.sh
rm ~/.profile ~/.bashrc ~/.bash_logout ~/.gitconfig ~/.zshrc ~/.zsh_plugins.txt
mkdir ~/.config/  
mkdir ~/.config/Code/ 
mkdir ~/.config/Code/User/
./install
```
