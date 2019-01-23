# Fix lack of Delete key binding
bindkey "^[[3~" delete-char

# Add to my path
export PATH=$HOME/bin:/usr/local/bin:/home/sean/anaconda3/bin:$PATH

# Antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

# Add OpenMPI to path
export PATH=$PATH:/home/sean/.openmpi/bin
export LD_LIBRARY_PATH=:/home/sean/.openmpi/lib/

# Activate Conda Environment
# alias jn="~/anaconda3/envs/graphs/bin/jupyter-notebook --no-browser"#