# ~/.bash_profile: executed by the command interpreter for login shells.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Because WSL adds the Windows path, we might have namespace conflicts with devtools we install for both Windows and Ubuntu
# We can use sed to clean these out now
# Based on https://github.com/WhitewaterFoundry/pengwin-setup/commit/cea92cd2438e522d1d81accc43e6884e8d762b62
if grep -qi Microsoft /proc/version; then
  WIN_C_PATH="\$(wslpath 'C:\')"
  
  WIN_NPM_PATH="$(dirname "\$(which npm)")"
  if [[ "\${WIN_NPM_PATH}" == "\${WIN_C_PATH}"* ]]; then
    export PATH=$(echo "${PATH}" | sed -e "s#${WIN_NPM_PATH}##")
  fi
  
  WIN_YARN_PATH="$(dirname "\$(which yarn)")"
  if [[ "\${WIN_YARN_PATH}" == "\${WIN_C_PATH}"* ]]; then
    export PATH=$(echo "\${PATH}" | sed -e "s#\${WIN_YARN_PATH}##")
  fi
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
# Automatically add ~/.local/bin to path (used by Docker)
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Go 
export GOPATH="$HOME/go" 

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# N
export N_PREFIX="$HOME/n"
export PATH="$N_PREFIX/bin:$PATH"

# Wasmer
export WASMER_DIR="/home/sean/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
export WASMTIME_HOME="$HOME/.wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"

# Emscripten
source ~/emsdk/emsdk_env.sh > /dev/null

# WSL Convenience helpers
if grep -qi Microsoft /proc/version; then
  export WIN_C_PATH="$(wslpath 'C:\')"
  export WSL_VERSION=$(wsl.exe -l -v | grep -a '[*]' | sed 's/[^0-9]*//g')
  export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
  export DISPLAY=$WSL_HOST:0
fi

# # if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
# 	. "$HOME/.bashrc"
#     fi
# fi