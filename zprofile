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

# N
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export LOADED_ZPROFILE=1