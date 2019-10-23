# .zshenv is automatically sourced , so it is for environment variables that change frequently

# Since .zshenv is always sourced, it often contains exported variables that should be available to other programs. 
# For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv. 
# Also, you can set $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

# WSL is not a "login" shell by default, so load .zprofile manually

export LOADED_ZSHENV=1