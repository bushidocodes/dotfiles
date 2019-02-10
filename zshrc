# Fix lack of Delete key binding
bindkey "^[[3~" delete-char

# Add to my path
export PATH=$HOME/bin:/usr/local/bin:$HOME/miniconda/bin:$PATH

# Antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

# Add OpenMPI to path
export PATH=$PATH:/home/sean/.openmpi/bin
export LD_LIBRARY_PATH=:/home/sean/.openmpi/lib/

# Activate Conda Environment
# alias jn="~/miniconda/envs/graphs/bin/jupyter-notebook --no-browser"#

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
