#!/bin/zsh

# Set correct permissions for some sensitive config files
chmod 600 $HOME/.ssh/config
chmod 600 $HOME/.gnupg/dirmngr.conf
chmod 600 $HOME/.gnupg/gpg.conf
chmod 600 $HOME/.gnupg/gpg-agent.conf
chmod 700 $HOME/.gnupg
chmod 600 $HOME/.msmtprc