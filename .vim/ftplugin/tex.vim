" Add \item inside itemize environment
function AddItem()
  if searchpair('\\begin{itemize}', '', '\\end{itemize}', '')
    return "\\item "
  else
    return ""
  endif
endfunction

" Automatically add \item inside itemize environment when <CR> or o and O
inoremap <expr><buffer> <CR> getline('.') =~ '\item $' ? '<c-w><c-w>' : '<CR>'.AddItem()
nnoremap <expr><buffer> o "o".AddItem()
nnoremap <expr><buffer> O "O".AddItem()