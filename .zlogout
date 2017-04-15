# ZSH Configuration - Logout

if [[ -z "$SSH_CLIENT" && -z "$SSH_TTY" && -z "$SSH_CONNECTION" && ! "$(ps -o comm= -p $PPID)" =~ "sshd" ]]; then
  # Not an ssh connection
  if [[ "$TERM" =~ "linux" ]]; then
    # Reset linux console colors and cursor
    tput setaf 7
    tput setab 0
    echo -en '\e]R\e[8]\e[?c\e[1;6]'
    clear
  fi
fi
