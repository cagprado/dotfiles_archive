# ZSH Configuration
# Environment - interactive/non-interactive shell
#
# I reserve this file for setting variables which are necessary for scripts.

export HOSTNAME=$(hostname)

#unsetopt GLOBAL_RCS    # prevent shell from reading global configuration
source $HOME/.profile  # loads my general profile file
fpath=($HOME/bin/zsh.zwc $fpath)
