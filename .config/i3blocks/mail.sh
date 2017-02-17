 #!/bin/sh

if [[ -n "$BLOCK_BUTTON" ]]; then
  case $BLOCK_BUTTON in
    1) $TERMINAL -T Mail -e alot; i3-msg workspace "9:  " &> /dev/null ;;
  esac
fi

echo -n " $(notmuch count is:unread)"
