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
  Plugin 'lifepillar/vim-solarized8'          " Solarized theme
  Plugin 'vim-airline/vim-airline'            " Airline status line
  Plugin 'luochen1990/rainbow'                " Rainbow parenthesis
  Plugin 'tpope/vim-surround'                 " Module for surrounding moves
  Plugin 'vim-pandoc/vim-pandoc-syntax'       " Pandoc markdown syntax
  Plugin 'chikamichi/mediawiki.vim'           " Mediawiki syntax
  Plugin 'SirVer/ultisnips'                   " Snippets engine
  "Plugin 'honza/vim-snippets'                 " Snippets collection
  "Plugin 'klen/python-mode'                   " Python syntax plugin
  "Plugin 'tpope/vim-fugitive'
call vundle#end()
filetype plugin indent on                     " Required (indent is optional)

" TERMINAL DEPENDENT CONFIGURATION ##########################################

" Set cursor shape for different modes
let &t_SI = system('tput Ss 5')
let &t_EI = system('tput Ss 2')
if exists('&t_SR')
  let &t_SR = system('tput Ss 3')
endif
autocmd VimEnter * silent exe '!echo -ne ' . shellescape(&t_EI)
autocmd VimLeave * silent exe '!tput Se'

if &term !~ '\vcons|linux'
  " Use powerline fonts that look (a lot) nicer than symbols
  let g:airline_powerline_fonts = 1

  " Use rainbow parenthesis
  "let g:rainbow_active=1
endif

"if &term =~ '\vcons|linux'
"  " In order for solarized scheme to work correctly it needs to set 'bright
"  " background'. We use the blink attribute for bright background
"  " (console_codes(4)) and the bold attribute for bright foreground. The
"  " redefinition of t_AF is necessary for bright "Normal" highlighting to not
"  " influence the rest.
"  " let &t_Co=16
"  "set t_AB=[%?%p1%{7}%>%t5%p1%{8}%-%e25%p1%;m[4%dm
"  "set t_AF=[%?%p1%{7}%>%t1%p1%{8}%-%e22%p1%;m[3%dm
"else

" BASIC INTERFACE ###########################################################
" options depending on other sections of .vimrc are commented with <USER SEC>

" misc
set title              " automatically set window title <USER TERM>
set hidden             " hide buffer if opening new one (no need to save/undo)
set ttyfast            " fast terminal connection: smooths things
set wildignore=*.swp,*.bak,*.pyc,*.class,*.zwc  " ignore when completing
set wildmode=list:longest,full  " complete command-line (list options and complete common part then cycle)
set nospell            " turn off spell checking
set spelllang=en_us    " set default spell language
set complete+=kspell   " current spell for keyword completion (C-P C-N)
set timeoutlen=3000    " timeout for key mapping
set ttimeoutlen=10     " timeout for key codes
set relativenumber     " show relative line numbers
set cursorline         " highlight cursor position line
set showmatch          " highlight matching ( )
set laststatus=2       " always show status line
set showcmd            " show partially-typed commands in status line
set showmode           " show mode (Insert, Replace, Visual) in status line
set foldmethod=marker  " set the folding method TODO
set makeprg=           " set makeprg empty (to be filled later by FileType)

" printing (set html options for :TOhtml)
let g:html_number_lines=1
let g:html_pre_wrap=1
let g:html_ignore_conceal=1
let g:html_ignore_folding=1
let g:html_font="terminalfont"

" indenting
set tabstop=4             " \t length
set shiftwidth=2          " indenting steps (=0: tabstop)
set softtabstop=-1        " <TAB> inserts N spaces|\t if possible (=neg: shiftwidth)
set expandtab             " <TAB> never inserts \t (C-V<TAB> will do)
set shiftround            " round > and < to multiples of shiftwidth
set autoindent            " copies indent of previous line
set copyindent            " use same structure instead of tab characters

" searching and substituting <USER KEYMAP>
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
set undodir=~/var/backup      " undofile location
set undofile                  " turn on undo file
set viminfo=%,h,'50           " saves up to 50 buffers, buf-list and disable hlsearch

" editing behaviour:
set joinspaces                  " when joining insert two spaces after .?!
set cpoptions+=J                " a sentence will end with two spaces
set nowrap                      " don't wrap lines
set backspace=indent,eol,start  " backspace over everything
set virtualedit=all             " allow cursor to travel anywhere
set clipboard^=unnamedplus      " copy/paste to "+ without explicit set
set scrolloff=3                 " N lines of context around cursor
set list                        " turn on list mode: listchars sets contexts
if &term =~ '\vcons|linux'
   set listchars=tab:._,trail:·,extends:»,precedes:«,nbsp:~
else
   set listchars=tab:.…,trail:·,extends:»,precedes:«,nbsp:~
endif
set formatoptions=tcroqjn       " options for formating, :help fo-table croql
" formatlistpat will match numeric and bullet (-|·) lists
set formatlistpat=^\\s*\\(\\d\\+[\\]:.)}\\t\ ]\\\\|-\\\\|·\\)\\s*
set textwidth=77                " text width length
set colorcolumn=+1              " highlight 1 column after textwidth

if has('syntax')
  syntax on

  if &term !~ '\vcons|linux'
    if has('termguicolors')
      set termguicolors
    endif

    colorscheme solarized8_light
    " Override spell syntax (undercurl is only useful in gui)
    hi SpellBad    cterm=NONE,reverse  gui=NONE,reverse  ctermfg=1  guifg=#dc322f ctermbg=15   guibg=#fdf6e3
    hi SpellCap    cterm=NONE,standout gui=NONE,standout ctermfg=9  guifg=#cb4b16 ctermbg=NONE guibg=NONE
    hi SpellLocal  cterm=NONE,reverse  gui=NONE,reverse  ctermfg=3  guifg=#b58900 ctermbg=NONE guibg=NONE
    hi SpellRare   cterm=NONE          gui=NONE          ctermfg=15 guifg=#fdf6e3 ctermbg=4    guibg=#268bd2
    hi String      cterm=italic        gui=italic        ctermfg=6  guifg=#2aa198 ctermbg=NONE guibg=NONE
  else
  endif
endif

" ULTISNIPS #################################################################
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"

" PYTHON-MODE ###############################################################
"let g:pymode_python = 'python3'

" FUNCTIONS/AUTOCMD #########################################################

" Convert current buffer to pdf
function! ToPdf()
  write
  let g:shell_background = 'light'
  call SetSolarized()

  " Generate HTML file
  let l:filename=expand('%:S')
  let l:htmlname=expand('%') . '.html'
  TOhtml
  let &l:makeprg = "wkhtmltopdf --disable-smart-shrinking -s A4 --header-left " . l:filename . " --header-right '[page]/[toPage]' --header-line --header-spacing 2 -T 18 -B 12 -L 18 -R 18 %:S %:r:S.pdf"

  " Fix font size, write and make the final pdf
  0,20s/font-size: 1em;/font-size: 12px;/
  write | make!

  " Delete temporary HTML file
  call delete(expand('%')) | bdelete!

  let g:shell_background = $BACKGROUND
  call SetSolarized()
endfunction
command! -bar ToPdf call ToPdf()

" Restore cursor position to last position when load buffer
function! RestoreCursor()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
au BufWinEnter * call RestoreCursor()

" Cycle through spelllang list (rather than setting multiple at same time)
let g:SpellLangList = ["","en_us","pt_br"]
function! CycleSpellLang()
  let b:CurrentLang = g:SpellLangList[(index(g:SpellLangList, &spelllang)+1) % len(g:SpellLangList)]
  if b:CurrentLang == ""
    exe "setlocal nospell spelllang="
    echo "spell checking off"
  else
    exe "setlocal spell spelllang=" . b:CurrentLang
    echo "spell checking language:" . b:CurrentLang
  endif
endfunction

" MAKEFILE: noexpandtab, textwidth, shiftwidth
au FileType make setlocal noet tw=0 sw=0

" DATA FILES: noexpandtab, tabstop, textwidth, shiftwidth
augroup filetype
  au BufNewFile,BufRead *.dat setlocal filetype=data
augroup END
au Filetype data setlocal noet ts=20 tw=0 sw=0

" MARKDOWN: use pandoc syntax highlight
augroup pandoc_syntax
  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
au Filetype markdown.pandoc setlocal sw=4

" MEDIAWIKI: wrap, textwidth
au FileType mediawiki setlocal wrap tw=0


" KEY MAPPING ###############################################################

" Use ; as :
nnoremap ; :

" Paragraph formatting
vmap Q gq
nmap Q gqap

" Clear trailing spaces
nnoremap <leader>cs :%s/\s\+$//<CR>:let @/=''<CR>

" Clear search highlight with ,/
nmap <silent> <leader>/ :nohlsearch<CR>

" Use \v for all search (makes pattern closer to other languages)
nnoremap / /\v
vnoremap / /\v

" Show all used highlighting groups
map <silent> <F10> :runtime syntax/hitest.vim<CR>

" runtime syntax/hitest.vim
" toggle pastemode
set pastetoggle=<F2>

" select text just pasted (will work if issued right after pasting)
nnoremap <leader>v V`]

" Up/Down to next row when wrapping lines
nnoremap j gj
nnoremap k gk

" Change windows easily: <C-X> instead of <C-w>X
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" If forgot sudo use w!! to sudo when saving file
cmap w!! w !sudo tee % >/dev/null

" cycle through SpellLangList
map <silent> <F12> :call CycleSpellLang()<CR>
imap <silent> <F12> <C-o>:call CycleSpellLang()<CR>

" set spell checking on for some file types
au BufNewFile,BufRead *.{txt,mail,tex} setlocal spell
au FileType help setlocal nospell

" compile
function! SetMakePrg()
  let filedir = expand('%:p:h')

  silent exe "!test -x %:S" | redraw!
  if ! v:shell_error
    let &makeprg = "./%:S"                     " Executable: exec itself
  elseif filereadable(filedir . "/Makefile")
    let &makeprg = "make -C " . filedir        " Make in the same dir as file
  elseif filereadable("Makefile")
    let &makeprg = "make"                      " Make in the current dir
  " -- File Specific compile/run commands -----------------------------------
  elseif expand("%") =~ '\.sh$\|\.zsh$'
    let &makeprg = "zsh %:S"
  elseif expand("%") =~ '\.asy$'
    let &makeprg = "asy -nosafe %:S"
  elseif expand("%") =~ '\.py$'
    let &makeprg = "python %:S"
  elseif expand("%") =~ '\.md$'
    let &makeprg = "pandoc -s -S -f markdown %:S -o %:r:S.pdf"
  elseif expand("%") =~ '\.wiki$'
    let &makeprg = "pandoc -s -S -f mediawiki %:S -o %:r:S.pdf"
  else
    let &makeprg = 'echo "No makeprg configured for this file..."'
  endif
endfunction
au BufNewFile,BufRead * call SetMakePrg()
map <silent> <F11> :w <bar> :make!<CR>
imap <silent> <F11> <C-o>:w <bar> :make!<CR>

" snippets
map <leader>esn :UltiSnipsEdit<CR>

" ###########################################################################
" ###########################################################################
" ###########################################################################
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
