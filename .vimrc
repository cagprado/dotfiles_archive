" first clear any existing auto commands:
autocmd!

" PLUGIN MANAGER ============================================================
"
" At first install:
" mkdir ~/.vundle
" git clone http://github.com/VundleVim/Vundle.vim .vundle/Vundle.vim
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

set nocompatible
filetype off
set rtp+=~/.vundle/Vundle.vim
call vundle#begin('~/.vundle')
Plugin 'VundleVim/Vundle.vim'

" EXAMPLES
"
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'

call vundle#end()
filetype plugin indent on

" environment
let is_sampa=$IS_SAMPA

" backup and swapfile
set backup
set backupdir=~/var/backup
set directory=~/var/backup

" interface
if is_sampa == "false"
  set cc=+1 " highlight 1 column after textwidth
endif
set backspace=2 " indent,eol,start
set history=50 " 50 lines of history
set gdefault " assume /g flag on :s
set hlsearch " turn search hightlighting on
set ignorecase " ignore case in seaches
set smartcase " if ignorecase is on, search for upper case when typed
set incsearch " show match while typing
set mouse=a " mouse always
"set nomodeline " disable reading file vim instructions
"set relativenumber " relative number line
set number " number lines
set shortmess+=r " use [RO] instead of [readonly] in status line
set showcmd " show partially-typed commands in status line
set showmode " show mode in status line
set spell " spell check
" F12 toggle search highlighting
noremap <F12> <Esc>:set hlsearch! hlsearch?<CR>
set foldmethod=marker
set ttimeoutlen=100
set laststatus=2
let g:airline_powerline_fonts = 1

" printer
set printencoding=utf-8

" spell check (use F12)
set complete+=kspell " use the currently defined spell for completion (C-P C-N)
set spell spelllang=pt_br
let g:myLangList=["nospell","pt_br","en_us"]
function! ToggleSpell()
  if !exists( "b:myLang" )
    if &spell
      let b:myLang=index(g:myLangList, &spelllang)
    else
      let b:myLang=0
    endif
  endif
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction
nmap <silent> <F11> :call ToggleSpell()<CR>
imap <silent> <F11> <C-o>:call ToggleSpell()<CR>

" useless
" hide real text
map <F10> ggVGg?

" long options (with explanation) ====================================

" have syntax highlighting in terminals which can display colours:
if has('syntax')
  syntax on
  "set t_Co=256
  set background=dark
  let g:solarized_termtrans = 1
  colorscheme solarized
endif


" viminfo options; see help 'viminfo'
set viminfo=%,'10,/10,:20,<100,h,r/mnt/memory,r/mnt/cdrom

" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" when using list, keep tabs at their full width and display `arrows':
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
" (Character 187 is a right double-chevron, and 183 a mid-dot.)

"=====================================================================
" FORMATING

set autoindent " keep indent on new lines
set expandtab " TAB/Spaces
set nowrap " no wrap
set shiftwidth=2 "  [auto]indent space
set smartindent " indent for '{', '}' and '#'
set softtabstop=2 " <TAB> acts like inserting n spaces
set tabstop=8 " lenght of tab
set textwidth=77 " text width

" get rid of the default style of C comments, and define a style with two stars
" at the start of `middle' rows which (looks nicer and) avoids asterisks used
" for bullet lists being treated like C comments; then define a bullet list
" style for single stars (like already is for hyphens):
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*

" treat lines starting with a quote mark as comments (for `Vim' files, such as
" this very one!), and colons as well so that reformatting usenet messages from
" `Tin' users works OK:
set comments+=b:\"
set comments+=n::

"=====================================================================
" autocmd
function! ResCur() " Restore cursor position at startup
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

" FILETYPE specific options

" enable filetype detection:
filetype plugin indent on

augroup filetype
  autocmd BufNewFile,BufRead *.txt set filetype=human
  autocmd BufNewFile,BufRead *.mail set filetype=mail
augroup END

" in human-language files, automatically format everything at 72 chars:
autocmd FileType mail,human set formatoptions+=t textwidth=72

" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html,php set formatoptions+=tl

" for both CSS and HTML, use genuine tab characters for indentation, to make
" files a few bytes smaller:
autocmd FileType html,css,php set noexpandtab tabstop=2

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8

" laTeX
au FileType tex nnoremap <buffer> <F9> :w<cr>:!latexmk<cr>
au FileType tex inoremap <buffer> <F9> <ESC>:w<cr>:!latexmk<cr>

" asymptote
au FileType asy nnoremap <buffer> <F9> :w<cr>:!asy -nosafe %<cr>
au FileType asy inoremap <buffer> <F9> <ESC>:w<cr>:!asy -nosafe %<cr>

" Skeletons

" LUA
autocmd BufNewFile *.lua 0r ~/.vim/styles/skeleton.lua
autocmd BufNewFile *.lua ks|call LastMod()|'s
fun LastMod()
	if line("$") > 20
		let l = 20
	else
		let l = line("$")
	endif
	exe "1,".l."g/Created: /s/Created: .*/Created: ".strftime("%Y %b %d")
endfun

command SmallCaps :%s/\\textsc{\(.\{-}\)}/\U\1/
