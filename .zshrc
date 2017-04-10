# Interactive shell (not run by scripts)

# Interface #################################################################
#typeset -U path fpath cdpath manpath
unsetopt bgnice
setopt notify longlistjobs extendedglob globdots autocd correct autonamedirs
setopt histignoredups appendhistory histverify histignorespace autolist
setopt autopushd pushdsilent pushdtohome pushdminus pushdignoredups
bindkey -v   # VIM-like
bindkey  '[5~'    history-beginning-search-backward  # PgUp
bindkey  '[6~'    history-beginning-search-forward   # PgDown
bindkey  'q'      push-line-or-edit                  # Alt+q
bindkey  '^?'       backward-delete-char               # like vim backspace=2

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
bindkey '^[[1;3A'      cdParentKey
bindkey '^[[1;3D'      cdUndoKey

# Aliases ###################################################################

# jobs and interface
alias h='history'
alias j='jobs -l'
alias d='dirs -v'

# system
alias free='free -h'
alias df='df -h'
alias du='du -h'
alias ls='ls --quoting-style=literal --color=auto -Fh --group-directories-first'
alias lsl='ls -l'
alias lsa='ls -A'
alias grep='egrep --color=auto'
alias dmesg='dmesg -e'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

# compiler
alias GCC='gcc -Wall -ansi -O2'
alias G++='g++ -Wall -O4 --std=c++11 $=LDFLAGS'
alias asy='asy -nosafe'
alias asyinline='asy -inlinetex'
alias root-config='root-config --cflags --libs'
alias ccorp-config='echo -I$HOME/usr/local/ccorp/include -L$HOME/usr/local/ccorp/lib -lccorp -Wl,-rpath,$HOME/usr/local/ccorp/lib'

# ssh and certificates
alias certutil='certutil -d sql:$HOME/.pki/nssdb'
alias pk12util='pk12util -d sql:$HOME/.pki/nssdb'
[[ "$AT_SAMPA_VALUE" = "true" ]] && alias qstat='qstat -u cagprado -t' || alias qstat='ssh cagprado@$SAMPA qstat -u cagprado -t'

# programs and utils
alias o='xdg-open'
alias zshfunctions='zcompile -Uz $ZSH_FUNCTIONS $ZSH_FUNCTIONS/*(.x)'
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
alias sampa='fusessh -p $HOME/sampa -s cagprado@$SAMPA'
alias ifusp='fusessh -p $HOME/ifusp -s caioagp@$IFUSP'
alias mredson='fusessh -p $HOME/mredson -s cagprado@$(MREDSON)'
alias msedna='fusessh -p $HOME/msedna -s cagprado@192.168.0.101'
alias lp='lp -d $(printer)'
alias dropbox='dropbox-cli'
alias pushnotmuch='notmuch dump | xz -9 | ssh cagprado@$(MREDSON) "xz -d | notmuch restore"'
alias pullnotmuch='ssh cagprado@$(MREDSON) "notmuch dump | xz -9" | xz -d | notmuch restore'

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
precmd()
{
  echo -ne '\a' # beep when prompt appears (window manager can use it to cue when command ended execution)
}
setprompt() {
  setopt prompt_subst
  C1=$'%{\e[34m%}'
  C2=$'%{\e[35m%}'
  C3=$'%{\e[32m%}'
  C4=$'%{\e[31m%}'
  C5=$'%{\e[1;35m%}'
  C6=$'%{\e[37m%}'
  NO=$'%{\e[m%}'
  PROMPT='[$C3%T$NO%(1j./$C4%j$NO.)] %(0?,$C1,$C4)%n$NO@$C5%m$NO$(cfg update-index --refresh >/dev/null || echo "[${C4}M$NO]")%# '
  RPROMPT=' $C6@ $C2%~$NO'
}
setprompt

# Set colors
colors tomorrow
[[ -r $HOME/etc/dircolors ]] && eval $(dircolors "$HOME/etc/dircolors")
export LESS_TERMCAP_so=$(tput setaf 0; tput setab 3)  # begin standout
export LESS_TERMCAP_se=$(tput sgr0)                   # end standout
export LESS_TERMCAP_us=$(tput sitm; tput setaf 6)     # begin underline (italic)
export LESS_TERMCAP_ue=$(tput ritm; tput sgr0)        # end underline
export LESS_TERMCAP_md=$(tput bold;)                  # begin bold
export LESS_TERMCAP_mb=$(tput blink)                  # starts blink
export LESS_TERMCAP_me=$(tput sgr0)                   # end blink/bold/standout/underline
if [[ "$TERM" =~ "linux" ]]; then
  # console doesn't support bold typeface: choose another color
  export LESS_TERMCAP_md=$(tput setaf 7)              # begin bold
fi

# Keys management
. $HOME/.keychain.sh

# VI-mode set cursor for NORMAL/INSERT/REPLACE
export KEYTIMEOUT=1
function zle-line-init zle-keymap-select {
  if [[ "$KEYMAP" == "vicmd" ]]; then
    tput Ss 2
  elif [[ $ZLE_STATE == *overwrite* ]]; then
    tput Ss 3
  else
    tput Ss 5
  fi
}
function vi-replace-chars {
  tput Ss 3
  zle .vi-replace-chars -- "$@"
  tput Ss 2
}
zle -N zle-line-init
zle -N zle-keymap-select
zle -N vi-replace-chars

# Source syntax highlighting plugin
[[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" || :

# Show a nice cowsay message
(which cowsay >/dev/null 2>&1) && (which fortune >/dev/null 2>&1) && cowsay $(fortune) || :
