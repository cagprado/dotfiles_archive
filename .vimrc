" vim: nospell:

" INITIALIZATION ############################################################
" clear autocmd and set nocompatible (not vi compatible)
autocmd!
set nocompatible   " this is also REQUIRED for Vundle
let mapleader=','  " set mapleader for custom maps

" PLUGIN MANAGER ############################################################
"                                                                           |
" First time installation:                                                  |
"   mkdir ~/.vundle                                                         |
"   git clone http://github.com/VundleVim/Vundle.vim .vundle/Vundle.vim     |
"                                                                           |
" Basic commands:                                                           |
"   :PluginList           - list current plugins                            |
"   :PluginInstall[!]     - install (or update with !)                      |
"   :PluginUpdate         - update                                          |
"   :PluginSearch[!] foo  - search foo (force cache update with !)          |
"   :PluginClean[!]       - remove unused plugins (no confirm with !)       |
"                                                                           |
"----------------------------------------------------------------------------

filetype off                                  " Required for Vundle to work
set runtimepath+=~/.vundle/Vundle.vim
call vundle#begin('~/.vundle')
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'altercation/vim-colors-solarized'
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  "Plugin 'tpope/vim-fugitive'
  "Plugin 'vim-pandoc/vim-pandoc'
  "Plugin 'vim-pandoc/vim-pandoc-syntax'
call vundle#end()
filetype plugin indent on                     " Required (indent is optional)

" TERMINAL DEPENDENT CONFIGURATION ##########################################

if &term =~ 'vte\|xterm'
  let &t_ts = "]2;"    " start set title escape
  let &t_fs = ""       " end set title escape
  let &t_SI = "[6 q"   " vertical bar on insert mode (vte only?)
  let &t_SR = "[4 q"   " underline on replace mode (vte only?)
  let &t_EI = "[2 q"   " block cursor when leaving insert/replace modes (vte only?)
  " Set block cursor when entering vim and restore vertical bar when leaving
  autocmd VimEnter * silent exe '!echo -ne "[2 q"'
  autocmd VimLeave * silent exe '!echo -ne "[ q"'

  " Use powerline fonts that look (a lot) nicer than symbols
  let g:airline_powerline_fonts = 1

elseif &term =~ 'cons\|linux'
  " In order for solarized scheme to work correctly it needs to set 'bright
  " background'. We use the blink attribute for bright background
  " (console_codes(4)) and the bold attribute for bright foreground. The
  " redefinition of t_AF is necessary for bright "Normal" highlighting to not
  " influence the rest.
  let &t_Co=16
  set t_AB=[%?%p1%{7}%>%t5%p1%{8}%-%e25%p1%;m[4%dm
  set t_AF=[%?%p1%{7}%>%t1%p1%{8}%-%e22%p1%;m[3%dm
endif

" BASIC INTERFACE ###########################################################
" options depending on other sections of .vimrc are commented with <USER SEC>

" misc
set wildignore=*.swp,*.bak,*.pyc,*.class,*.zwc  " ignore when completing
set wildmode=list:longest,full  " complete command-line (list options and complete common part then cycle)
set timeoutlen=3000    " timeout for key mapping TODO
set ttimeoutlen=10     " timeout for key codes TODO
set hidden             " hide buffer if opening new one (no need to save/undo)
set number             " show line numbers
set showmatch          " highlight matching ( )
set title              " automatically set window title <USER TERM>
set laststatus=2       " always show status line
set showcmd            " show partially-typed commands in status line
set showmode           " show mode (Insert, Replace, Visual) in status line
set nowrap             " don't wrap lines
set foldmethod=marker  " set the folding method TODO
set textwidth=77       " text width length
if exists('+colorcolumn')
  set colorcolumn=+1   " highlight 1 column after textwidth
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>'.&textwidth.'v.\+', -1)
endif

" indenting TODO
set tabstop=15            " \t length
set shiftwidth=2          " indenting steps (=0: tabstop)
set softtabstop=-1        " <TAB> inserts N spaces|\t if possible (=neg: shiftwidth)
set expandtab             " <TAB> never inserts \t (C-V<TAB> will do)
set shiftround            " round > and < to multiples of shiftwidth
"set autoindent            " turn on auto indenting
"set copyindent            " use same structure instead of tab
set indentexpr=cindent()  " use function to indent

" searching and substituting
set ignorecase       " ignore case when searching
set smartcase        " only ignore case if all lowercase
set hlsearch         " highlight search terms <USER MAP>
set incsearch        " search as you type
set gdefault         " assume g flag on :s (put explicit g to disable flag)

" history and backup
set history=1000              " remember X commands and search history
set undolevels=1000           " save X undo levels
set directory=~/var/backup    " swapfile location
set swapfile                  " turn on swapfile
set backupdir=~/var/backup    " backup file location
set backup                    " turn on backup
set viminfo=%,h,'50           " saves up to 50 buffers, buf-list and disable hlsearch

" editing behaviour:
set backspace=indent,eol,start  " backspace over everything
set virtualedit=all             " allow cursor to travel anywhere
set clipboard^=unnamedplus      " copy/paste to "+ without explicit set
set list                        " turn on list mode: listchars sets contexts
set listchars=tab:[>,trail:·,extends:»,precedes:«,nbsp:~


" SYNTAX HIGHLIGHTING (SOLARIZED) ###########################################
" options depending on other sections of .vimrc are commented with <USER SEC>
" this will work properly only on solarized modified terminals

if has('syntax')
  syntax on
  set background=dark
  let g:solarized_termcolors=16  " only 16 colors
  let g:solarized_termtrans=1    " transparent background (i.e. terminal bg)
  let g:solarized_bold=1         " bolds
  let g:solarized_underline=1    " underlines
  let g:solarized_italic=1       " italics
  colorscheme solarized          " solarized theme

  " Overwrite spell syntax (solarized uses undercurl; only good in gui)
  hi SpellBad     cterm=none    ctermfg=7   ctermbg=1
  hi SpellCap     cterm=none    ctermfg=7   ctermbg=3
  hi SpellRare    cterm=none    ctermfg=7   ctermbg=4
  hi SpellLocal   cterm=none    ctermfg=7   ctermbg=6

  " Add italic to Comments and Strings (because I like it)
  if &term !~ 'linux'
    hi Comment    cterm=italic  ctermfg=10
    hi String     cterm=italic  ctermfg=6   gui=italic  guifg=#00afaf
  endif
endif

" FUNCTIONS/AUTOCMD #########################################################

" Restore cursor position to last position when load buffer
function! RestoreCursor()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
autocmd BufWinEnter * call RestoreCursor()

" KEY MAPPING ###############################################################

" Use ; as :
nnoremap ; :

" Paragraph formatting
vmap Q gq
nmap Q gqap

" Up/Down to next row when wrapping lines
nnoremap j gj
nnoremap k gk

" Change windows easily: <C-X> instead of <C-w>X
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Clear search buffer with ,/
nmap <silent> <leader>/ :nohlsearch<CR>

" Ask for sudo after saving file (if forgot to use sudoedit)
cmap w!! w !sudo tee % >/dev/null

" toggle pastemode
set pastetoggle=<F2>

"#########################################################################################
"#########################################################################################
"#########################################################################################
"" spell check (use F12)
"set spell            " spell check on
"set complete+=kspell " use the currently defined spell for completion (C-P C-N)
"set spell spelllang=en_us
"let g:myLangList=["nospell","en_us","pt_br"]
"function! ToggleSpell()
"  if !exists( "b:myLang" )
"    if &spell
"      let b:myLang=index(g:myLangList, &spelllang)
"    else
"      let b:myLang=0
"    endif
"  endif
"  let b:myLang=b:myLang+1
"  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
"  if b:myLang==0
"    setlocal nospell
"  else
"    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
"  endif
"  echo "spell checking language:" g:myLangList[b:myLang]
"endfunction
"nmap <silent> <F11> :call ToggleSpell()<CR>
"imap <silent> <F11> <C-o>:call ToggleSpell()<CR>
"
"augroup filetype
"  autocmd BufNewFile,BufRead *.txt set filetype=human
"  autocmd BufNewFile,BufRead *.mail set filetype=mail
"augroup END
"
"" in human-language files, automatically format everything at 72 chars:
"autocmd FileType mail,human set formatoptions+=t textwidth=72
"
"" for C-like programming, have automatic indentation:
"autocmd FileType c,cpp,slang set cindent
"
"" for actual C (not C++) programming where comments have explicit end
"" characters, if starting a new line in the middle of a comment automatically
"" insert the comment leader characters:
"autocmd FileType c set formatoptions+=ro
"
"" for Perl programming, have things in braces indenting themselves:
"autocmd FileType perl set smartindent
"
"" for CSS, also have things in braces indented:
"autocmd FileType css set smartindent
"
"" for HTML, generally format text, but if a long line has been created leave it
"" alone when editing:
"autocmd FileType html,php set formatoptions+=tl
"
"" for both CSS and HTML, use genuine tab characters for indentation, to make
"" files a few bytes smaller:
"autocmd FileType html,css,php set noexpandtab tabstop=2
"
"" in makefiles, don't expand tabs to spaces, since actual tab characters are
"" needed, and have indentation at 8 chars to be sure that all indents are tabs
"" (despite the mappings later):
"autocmd FileType make set noexpandtab shiftwidth=8
