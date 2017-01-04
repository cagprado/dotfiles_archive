#!/bin/zsh

# Set repository local option
print -P "%BConfiguring local home-git repository...%b"
git --git-dir=$HOME/.cfg --work-tree=$HOME config --local status.showUntrackedFiles no

# Create some dirs used by configuration
print -P "%BSetting up directories...%b"
install -dm0 $HOME/.dropbox-dist
mkdir -p $HOME/.cache/zsh
mkdir -p $HOME/var/backup
mkdir -p $HOME/.vundle
git clone http://github.com/VundleVim/Vundle.vim .vundle/Vundle.vim

# Setting up permissions
print -P "%BSetting up correct permissions for sensitive configurations...%b"
$HOME/etc/setpermissions.sh

# Install the certificates
if command -v certutil >/dev/null 2>&1; then
  print -P "%BInstalling certificates...%b"
  DATABASEDIR=$HOME/.pki/nssdb
  if [[ ! -d $DATABASEDIR ]]; then
    mkdir -p $DATABASEDIR
    certutil -d $DATABASEDIR -N
  fi

  certutil -d sql:$HOME/.pki/nssdb -A -n "CCIFUSP CA" -t CT,C,C -i "$HOME/etc/certificates/CCIFUSP-CA.crt"
  certutil -d sql:$HOME/.pki/nssdb -A -n "CERN Root CA" -t ,, -i "$HOME/etc/certificates/CERN Root Certification Authority 2.crt"
  certutil -d sql:$HOME/.pki/nssdb -A -n "CERN Grid CA" -t CT,C,C -i "$HOME/etc/certificates/CERN Grid Certification Authority.crt"
  certutil -d sql:$HOME/.pki/nssdb -A -n "CERN CA" -t CT,C,C -i "$HOME/etc/certificates/CERN Certification Authority.crt"
fi

# Setup hooks
print -P "%BSetting up git hooks...%b"
mkdir $HOME/.cfg/hooks/scripts
cp $HOME/etc/setpermissions.sh $HOME/.cfg/hooks/scripts
cp $HOME/etc/post-checkout $HOME/.cfg/hooks/scripts
cp $HOME/etc/post-merge $HOME/.cfg/hooks/scripts
print "[31mBasic configuration done! Please, add hooks manually now![0m"
