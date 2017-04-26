# Interactive shell (not run by scripts)

# Options ###################################################################
unsetopt bgnice
setopt notify longlistjobs extendedglob globdots autocd correct autonamedirs
setopt histignoredups appendhistory histverify histignorespace autolist
setopt autopushd pushdsilent pushdtohome pushdminus pushdignoredups

# Keybindings ###############################################################

# use VIM bindings and allow backspace past insert point
bindkey -v
bindkey '^?' backward-delete-char

# always use 'application mode' of the terminal
echoti smkx 2>/dev/null

# main (insert) mode
bindkey '[3~' vi-delete-char                     # Del
bindkey '[1~' beginning-of-line                  # Home
bindkey '[4~' end-of-line                        # End
bindkey '[5~' history-beginning-search-backward  # PgUp
bindkey '[6~' history-beginning-search-forward   # PgDown
bindkey 'q'   push-line-or-edit                  # Alt+q

# cmdmode
bindkey -a '[3~' vi-delete-char                     # Del
bindkey -a '[1~' beginning-of-line                  # Home
bindkey -a '[4~' end-of-line                        # End
bindkey -a '[5~' history-beginning-search-backward  # PgUp
bindkey -a '[6~' history-beginning-search-forward   # PgDown
bindkey -a 'q'   push-line-or-edit                  # Alt+q

# Interface #################################################################

# Autoload functions from zsh scripts! Only +x files are selected
# Old way, keep in case the new one doesn't work: (){ setopt localoptions histsubstpattern; for func in $ZSH_FUNCTIONS/*(N-.x:t); autoload -U $func }
for func in $ZSH_FUNCTIONS/*(.x:t); do autoload -Uz $func; done

# History
HISTFILE="$HOME/.zshhist"
HISTSIZE=1000
SAVEHIST=1000

# Directories
cdpath=(~)      # cd <TAB> will always suggest content from paths listed here

# Named Directories
BIN=~/bin
ETC=~/etc
USR=~/usr
SRC=~/src
USP=~/usr/usp/pg/doutorado
OWNCLOUD=~/usr/owncloud

# Dirstack: cd -<TAB> for last visited directories
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
DIRSTACKSIZE=20

if [[ -f $DIRSTACKFILE && $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
cdUndoKey() {
  popd      > /dev/null
  zle       reset-prompt
  echo
  ls
  echo
}
cdParentKey() {
  pushd .. > /dev/null
  zle      reset-prompt
  echo
  ls
  echo
}
zle -N                 cdParentKey
zle -N                 cdUndoKey
bindkey '^[[1;3A'      cdParentKey  # alt-up
bindkey '^[[1;3D'      cdUndoKey    # alt-left

# Aliases ###################################################################

# jobs and interface
alias d='dirs -v'
alias h='history'
alias j='jobs -l'

# system
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
alias df='df -h'
alias dmesg='dmesg -e'
alias du='du -h'
alias free='free -h'
alias grep='egrep --color=auto'
alias ls='ls --quoting-style=literal --color=auto -Fh --group-directories-first'
alias lsa='ls -A'
alias lsl='ls -l'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

# compiler
alias asy='asy -nosafe'
alias asyinline='asy -inlinetex'
alias ccorp-config='echo -I$HOME/usr/local/ccorp/include -L$HOME/usr/local/ccorp/lib -lccorp -Wl,-rpath,$HOME/usr/local/ccorp/lib'
alias GCC='gcc -Wall -ansi -O2'
alias G++='g++ -Wall -O4 --std=c++11 $=LDFLAGS'
alias root-config='root-config --cflags --libs'

# ssh and certificates
alias certutil='certutil -d sql:$HOME/.pki/nssdb'
alias pk12util='pk12util -d sql:$HOME/.pki/nssdb'
[[ "$AT_SAMPA_VALUE" = "true" ]] && alias qstat='qstat -u cagprado -t' || alias qstat='ssh cagprado@$SAMPA qstat -u cagprado -t'

# programs and utils
[[ "$TERM" =~ "linux" ]] && alias alot='alot -C16' || :
alias dropbox='dropbox-cli'
alias ifusp='fusessh -p $HOME/ifusp -s caioagp@$IFUSP'
alias lp='lp -d $(printer)'
alias mredson='fusessh -p $HOME/mredson -s cagprado@$(MREDSON)'
alias msedna='fusessh -p $HOME/msedna -s cagprado@192.168.0.101'
alias o='xdg-open'
alias pushnotmuch='notmuch dump | xz -9 | ssh cagprado@$(MREDSON) "xz -d | notmuch restore"'
alias pullnotmuch='ssh cagprado@$(MREDSON) "notmuch dump | xz -9" | xz -d | notmuch restore'
alias sampa='fusessh -p $HOME/sampa -s cagprado@$SAMPA'
alias zshfunctions='zcompile -Uz $ZSH_FUNCTIONS $ZSH_FUNCTIONS/*(.x)'

# lists all aliases and scripts
scripts()
{
  local -x LIST_WIDTH=25
  local FILE

  print -P "%BALIASES%b"
  eval "$(alias | sed -e "s|^\([^=]*\)='\?\([^']*\)'\?.*$|print -P -f '%${LIST_WIDTH}s  %s\\\\n' '%B\1%b' '\2';|")"

  print -P "\n%BZSH FUNCTIONS%b"
  for FILE in $ZSH_FUNCTIONS/*(.x:t); do $FILE -H; done

  print -P "\n%BSCRIPTS%b"
  #for FILE in $BIN/*(.x); do echo $FILE; done
}

# Completion ################################################################
zmodload zsh/complist
autoload -U compinit && compinit
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*' format '%B---- %d%b'
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b{\e[0m%}'
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
hosts=($( ( [[ -r $HOME/.ssh/known_hosts ]] && awk '{print $1}' $HOME/.ssh/known_hosts | tr , '\n'; [ -r /etc/ssh/ssh_known_hosts ] && awk '{print $1}' /etc/ssh/ssh_known_hosts | tr , '\n') | sort -u ))
zstyle ':completion:*' hosts $hosts
[[ -f "/usr/share/doc/pkgfile/command-not-found.zsh" ]] && source /usr/share/doc/pkgfile/command-not-found.zsh || :

# Prompt ####################################################################
cfg_flag() { cfg update-index --refresh >/dev/null || echo "[${RED}M$NOR]" }
precmd()
{
  echo -ne '\a' # beep when prompt appears (window manager can use it to cue when command ended execution)
}
setprompt() {
  setopt prompt_subst
  local BLK="%{$(echoti setaf 0)%}"
  local RED="%{$(echoti setaf 1)%}"
  local GRE="%{$(echoti setaf 2)%}"
  local YEL="%{$(echoti setaf 3)%}"
  local BLU="%{$(echoti setaf 4)%}"
  local MAG="%{$(echoti setaf 5)%}"
  local CYA="%{$(echoti setaf 6)%}"
  local WHI="%{$(echoti setaf 7)%}"
  local BOL="%{$(echoti bold)%}"
  local BGR="%{$(echoti Tc >/dev/null && echo '\e[48;2;239;239;239m')%}"
  local DEF="%{$(echoti sgr0)%}"
  local NOR="%{$DEF$BGR%}"

  PROMPT="${NOR}[$GRE%T$NOR%(1j./$RED%j$NOR.)] %(0?.$BLU.$RED)%n$NOR@$MAG$BOL%m$NOR$(cfg_flag)%#$NOR "
  RPROMPT="$NOR @ $MAG%~$DEF"
}
setprompt

# Set colors and fonts
if [[ "$TERM" =~ linux && -z "$SSH_CONNECTION" ]]; then
  colors
  setfont $HOME/.local/share/fonts/bitmap/tamsyn-patched/Tamsyn8x16r.psf.gz
fi
[[ -r $HOME/etc/dircolors ]] && eval $(dircolors "$HOME/etc/dircolors")
export LESS_TERMCAP_so=$(tput setaf 3; tput smso)     # begin standout
export LESS_TERMCAP_se=$(tput sgr0; tput rmso)        # end standout
export LESS_TERMCAP_us=$(tput sitm; tput setaf 6)     # begin underline (italic)
export LESS_TERMCAP_ue=$(tput ritm; tput sgr0)        # end underline
export LESS_TERMCAP_md=$(tput bold;)                  # begin bold
export LESS_TERMCAP_mb=$(tput blink)                  # starts blink
export LESS_TERMCAP_me=$(tput sgr0)                   # end blink/bold/standout/underline

# Keys management
. $HOME/.keychain.sh

# VI-mode set cursor for NORMAL/INSERT/REPLACE
export KEYTIMEOUT=1

#local cursor_normal="$(echoti Ss 2 2>/dev/null)"
#local cursor_replace="$(echoti Ss 4 2>/dev/null)"
#local cursor_insert="$(echoti Ss 6 2>/dev/null)"
#function zle-line-init zle-keymap-select {
#  if [[ "$KEYMAP" == "vicmd" ]]; then
#    echo -n $cursor_normal
#  elif [[ $ZLE_STATE == *overwrite* ]]; then
#    echo -n $cursor_replace
#  else
#    echo -n $cursor_insert
#  fi
#}
#function vi-replace-chars {
#  echo -n $cursor_replace
#  zle .vi-replace-chars -- "$@"
#  echo -n $cursor_normal
#}

#zle -N zle-line-init
#zle -N zle-keymap-select
#zle -N vi-replace-chars

# Source syntax highlighting plugin
if ! atsampa && [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  #source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Show a nice cowsay message
(which cowsay >/dev/null 2>&1) && (which fortune >/dev/null 2>&1) && cowsay $(fortune) || :
