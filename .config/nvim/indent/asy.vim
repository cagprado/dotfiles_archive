" Vim indent file
" Language:	asy

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

" ASY is like C, which is built-in, thus this is very simple
setlocal cindent

let b:undo_indent = "setl cin<"
