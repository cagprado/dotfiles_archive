if [[ "$TERM" = "linux" ]]; then
  # Reset linux console colors
  echo -en "\e]R\e[0;37;40m\e[8]"
  clear
fi
