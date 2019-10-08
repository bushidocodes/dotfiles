# Setup History
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt sharehistory
setopt extendedhistory

# Set display env var to allow X forwarding
export DISPLAY=127.0.0.1:0.0

# Fix lack of Delete key binding
bindkey "^[[3~" delete-char

# Add to my path
export PATH=$HOME/bin:/usr/local/bin:$HOME/miniconda/bin:$PATH

# Pyenv
export PATH="/home/sean/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

# Add OpenMPI to path
export PATH=$PATH:/home/sean/.openmpi/bin
export LD_LIBRARY_PATH=:/home/sean/.openmpi/lib/

# Java managed by jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Emscripten
# source ~/Tooling/emsdk/emsdk_env.sh > /dev/null

# Disable HiDPI Support
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1
export GDK_SCALE=1

# WSL aliases and environment vars
# Some WSL distros seem to start in the Windows HOME directory, so explicitly cd
if grep -i -q Microsoft /proc/version; then
  cd ~
  alias open=Explorer.exe
  # This allows WSL apps to open the default Windows browser via Explorer
  # export BROWSER="/c/Program\Windows/explorer.exe"
fi
