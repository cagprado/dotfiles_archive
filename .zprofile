# ZSH Configuration
# Profile - loaded in login shell

#unsetopt GLOBAL_RCS    # prevent shell from reading global configuration

umask 022

# GENERIC VARIABLES #########################################################
export GENERIC_TERM="xterm-256color"   # for setting TERM fallback
export ZSH_FUNCTIONS="$HOME/bin/zsh"
export EDITOR="vim"
export BROWSER="google-chrome-stable"
export TEXMFHOME="$HOME/.texmf"
export LESS="-cx3MRFX"
export LESSOPEN="| /usr/bin/lesspipe.sh %s"
export GNUPGHOME="$HOME/.gnupg"
export HOMEPRINTER="esc67"
export SAMPAPRINTER="hphepic"
[[ -r $HOME/etc/dircolors ]] && eval $(TERM=$GENERIC_TERM dircolors "$HOME/etc/dircolors")

# HOSTNAMES #################################################################
export HOSTNAME=$(hostname)
export SAMPA=sampassh.if.usp.br
export IFUSP=fep.if.usp.br

[[ "$HOSTNAME" =~ "sampa" ]] && AT_SAMPA_VALUE=true && AT_HOME_VALUE=false || AT_SAMPA_VALUE=false
AT_SAMPA() { [[ "$AT_SAMPA_VALUE" = "true" ]] }
AT_HOME()
{
  if [[ -z "$AT_HOME_VALUE" ]]; then
    local MREDSONIP=$(dig +short +timeout=1 +tries=1 mredson.homenet.org 2>/dev/null)
    local MYIP=$(dig +short +timeout=1 +tries=1 myip.opendns.com @resolver1.opendns.com 2>/dev/null)

    [[ "$MREDSONIP" =~ "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}" ]] || return 1
    [[ "$MYIP" =~ "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}" ]] || return 1

    if [[ "$MYIP" = "$MREDSONIP" ]]; then
      AT_HOME_VALUE=true
    else
      AT_HOME_VALUE=false
    fi
  fi

  [[ "$AT_HOME_VALUE" = "true" ]]
}
MREDSON() { AT_HOME && echo '192.168.0.100' || echo 'mredson.homenet.org' }

# HOST SPECIFIC VARIABLES ###################################################
if AT_SAMPA; then
  export TERM=$GENERIC_TERM
  export PRINTER=$SAMPAPRINTER

  # ALICE
  export ALIVERSIONS="VO_ALICE@ROOT::v5-34-30,VO_ALICE@pythia::v8186"
  source /cvmfs/alice.cern.ch/etc/login.sh

  # GCC
  export CC="$HOME/usr/local/gcc/bin/gcc"
  export CXX="$HOME/usr/local/gcc/bin/g++"
  export CPP="$HOME/usr/local/gcc/bin/cpp"
  export F77="$HOME/usr/local/gcc/bin/gfortran"
  export FC="$HOME/usr/local/gcc/bin/gfortran"
  export LDFLAGS="-fPIC -Wl,-rpath,$HOME/usr/local/gcc/lib64"
  export MANPATH=$HOME/usr/local/gcc/share/man:$(manpath)
  PATH="$HOME/usr/local/gcc/bin:$PATH"

  # LOCAL BUILDS
  PATH="$HOME/usr/local/cmake/bin:$PATH"  # CMAKE-3.4
  PATH="$HOME/usr/local/Python/bin:$PATH" # PYTHON-2.7.11
  PATH="$HOME/usr/local/pythia/bin:$PATH" # PYTHIA-8212
  PATH="$HOME/usr/local/root/bin:$PATH"   # ROOT-6.05.02

  ## CUDA
  #export CUDA_PATH="/usr/local/cuda-6.0"
  #path=($CUDA_PATH/bin $path)
  #export GLPATH=/usr/lib64

  ## OpenCL
  #export AMDAPPSDKROOT="/sampa/cagprado/opt/amd_app_sdk/AMDAPPSDK-2.9.1"
  #path=($AMDAPPSDKROOT/bin/x86_64 $path)

  #export LD_LIBRARY_PATH=.:$AMDAPPSDKROOT/lib/x86_64:$CUDA_PATH/lib64:$LD_LIBRARY_PATH
else
  # Environment
  AT_HOME && export PRINTER=$HOMEPRINTER || export PRINTER=$SAMPAPRINTER
  export QT_QPA_PLATFORMTHEME=qt5ct

  # KEY MANAGEMENT
  export SSH_ASKPASS=/usr/lib/ssh/x11-ssh-askpass
  keychain --quiet --agents gpg,ssh 36316E64 id_rsa
  [[ -f $HOME/.keychain/${HOSTNAME}-sh ]] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null
  [[ -f $HOME/.keychain/${HOSTNAME}-sh-gpg ]] && . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null
fi

# SET HOME AT HEAD OF PATH
PATH="$HOME/bin:$PATH"

# ZSH FUNCTIONS #############################################################
fpath=($HOME/bin/zsh.zwc $fpath)   # add to fpath
zcompile -U $ZSH_FUNCTIONS $ZSH_FUNCTIONS/*(.x)

# COMPILE ZSH FILES #########################################################
zcompile $HOME/.zprofile
zcompile $HOME/.zshrc
zcompile $HOME/.zlogin
