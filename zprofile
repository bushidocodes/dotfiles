# .zprofile is loaded before zshrc. Used for Environment Variables that don't change frequently
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"

# Jenv
export PATH="$HOME/.jenv/bin:$PATH"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Automatically add ~/bin to path
export PATH="$HOME/bin:$PATH"

# Automatically add ~/.local/bin to path (used by Docker)
export PATH="$HOME/.local/bin:$PATH"

# N
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export LOADED_ZPROFILE=1

if grep -qi Microsoft /proc/version; then
  export WSL_VERSION=$(wsl.exe -l -v | grep -a '[*]' | sed 's/[^0-9]*//g')
  export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
  export DISPLAY=$WSL_HOST:0
  # Used to be used for Docker with WSL1. Commented out because now using WSL2
  # export DOCKER_HOST=tcp://$WSL_HOST:2375
fi