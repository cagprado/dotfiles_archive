#!/bin/zsh

# Set correct permissions for some sensitive config files
chmod 600 $HOME/.ssh/config
chmod 600 $HOME/.gnupg/dirmngr.conf
chmod 600 $HOME/.gnupg/gpg.conf
chmod 600 $HOME/.gnupg/gpg-agent.conf
chmod 600 $HOME/.msmtprc

# Prevent dropbox from updating itself (pacman will do it ok)
install -dm0 $HOME/.dropbox-dist

# Install the certificates
DATABASEDIR=$HOME/.pki/nssdb
if [[ ! -d $DATABASEDIR ]]; then
  mkdir -p $DATABASEDIR
  certutil -d $DATABASEDIR -N
fi

certutil -d sql:$HOME/.pki/nssdb -A -n "CCIFUSP CA" -t CT,C,C -i "$HOME/etc/certificates/CCIFUSP-CA.crt"
certutil -d sql:$HOME/.pki/nssdb -A -n "CERN Root CA" -t ,, -i "$HOME/etc/certificates/CERN Root Certification Authority 2.crt"
certutil -d sql:$HOME/.pki/nssdb -A -n "CERN Grid CA" -t CT,C,C -i "$HOME/etc/certificates/CERN Grid Certification Authority.crt"
certutil -d sql:$HOME/.pki/nssdb -A -n "CERN CA" -t CT,C,C -i "$HOME/etc/certificates/CERN Certification Authority.crt"
