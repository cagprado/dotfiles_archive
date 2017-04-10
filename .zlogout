# ZSH Configuration - Logout

if [[ -z "$SSH_CLIENT" && -z "$SSH_TTY" && -z "$SSH_CONNECTION" && ! "$(ps -o comm= -p $PPID)" =~ "sshd" ]]; then
  # Not an ssh connection
  if [[ "$TERM" =~ "linux" ]]; then
    # Reset linux console colors and cursor
    echo -en "\e]R\e[0;37;40m\e[8]"
    clear
    tput Se
  fi
fi
