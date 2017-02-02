# ZSH Configuration
# Profile - loaded in login shell

#unsetopt GLOBAL_RCS    # prevent shell from reading global configuration

[[ "$(id -un)" == "$(id -gn)" ]] && umask 002 || umask 022

# GENERIC VARIABLES #########################################################
export TERMINAL="roxterm"
export GENERIC_TERM="xterm-256color"   # for setting TERM fallback
export EDITOR="vim"
export DE="generic"                    # generic desktop environment for xdg
export TEXMFHOME="$HOME/.texmf"
export TMPHOME="/tmp/cagprado"
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
[[ "$HOSTNAME" =~ "sampa" ]] && export AT_SAMPA_VALUE=true && export AT_HOME_VALUE=false || export AT_SAMPA_VALUE=false

# HOST SPECIFIC VARIABLES ###################################################
if [[ "$AT_SAMPA_VALUE" = "true" ]]; then
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
  export QT_QPA_PLATFORMTHEME=qt5ct
fi

# SET HOME AT HEAD OF PATH
export PATH="$HOME/bin:$PATH"

# COMPILE ZSH FILES #########################################################
zcompile -Uz $ZSH_FUNCTIONS $ZSH_FUNCTIONS/*(.x)
zcompile $HOME/.zshenv
zcompile $HOME/.zprofile
zcompile $HOME/.zshrc
zcompile $HOME/.zlogout

# SET PAGER (LESS) COLORS ###################################################
export LESS_TERMCAP_mb=$'\E[35m'     # blink
export LESS_TERMCAP_md=$'\E[1;37m'   # bold
export LESS_TERMCAP_me=$'\E[0m'      # end
export LESS_TERMCAP_so=$'\E[37;41m'  # begin standout
export LESS_TERMCAP_se=$'\E[0m'      # end standout
export LESS_TERMCAP_us=$'\E[36m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'      # end underline

# SET LINUX CONSOLE COLORS ##################################################
if [[ "$TERM" = "linux" ]]; then
  # Solarized theme
  echo -en "\e]P0073642"
  echo -en "\e]P1dc322f"
  echo -en "\e]P2859900"
  echo -en "\e]P3b58900"
  echo -en "\e]P4268bd2"
  echo -en "\e]P5d33682"
  echo -en "\e]P62aa198"
  echo -en "\e]P7eee8d5"
  echo -en "\e]P8002b36"
  echo -en "\e]P9cb4b16"
  echo -en "\e]PA586e75"
  echo -en "\e]PB657b83"
  echo -en "\e]PC839496"
  echo -en "\e]PD6c71c4"
  echo -en "\e]PE93a1a1"
  echo -en "\e]PFfdf6e3"
  echo -en "\e[1;5;34;40m\e[8]" # Set default fg/bg
  # NOTE: Solarized uses 16 colors but linux terminal only support 8 BG
  # colors, while 16 foreground colors can be obtained with bold (\e[1m). One
  # workaround is set blink (\e[5m) so it uses 'bright background' color.
  # Note that this workaround doesn't work with X terminals and bright
  # foreground is obtained by setting 90..97 while bright background is
  # obtained with 100..107.
  clear
fi
