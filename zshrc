# .zshrc is for interactive shell configuration. 
# You set options for the interactive shell there with the setopt and unsetopt commands. 
# You can also load shell modules, set your history options, change your prompt, set up zle and completion, et cetera. 
# You also set any variables that are only used in the interactive shell (e.g. $LS_COLORS).
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

# Before we do an zshrc, manually load zshenv and zprofile if not loaded as expected
if [ -z "$LOADED_ZSHENV" ]; then
  source $HOME/.zshenv
fi

if [ -z "$LOADED_ZPROFILE" ]; then
  source $HOME/.zprofile
fi

# Setup History
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt sharehistory
setopt extendedhistory

# Fix lack of Delete key binding
bindkey "^[[3~" delete-char

# Antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

# Pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Jenv
eval "$(jenv init -)"

# alias open to behave like Mac in WSL
if grep -i -q Microsoft /proc/version; then
  alias open=Explorer.exe
fi
# Wasmer
export WASMER_DIR="/home/sean/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"