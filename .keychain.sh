#!/bin/zsh
# This script will load keychain, it’s separated from zshrc as I want it to
# be loaded by X (sddm) also.

if [[ "$AT_SAMPA_VALUE" = "false" ]]; then
  # KEY MANAGEMENT
  export SSH_ASKPASS=/usr/lib/ssh/x11-ssh-askpass
  keychain --quiet --agents gpg,ssh 36316E64 id_rsa
  [[ -f $HOME/.keychain/${HOSTNAME}-sh ]] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null
  [[ -f $HOME/.keychain/${HOSTNAME}-sh-gpg ]] && . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
fi
