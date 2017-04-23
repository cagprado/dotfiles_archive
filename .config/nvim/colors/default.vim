" This theme is intended for use with:
" - linux console: 8 colors; not true 16 colors since background is limited
"   to 8, although 16 colors of foreground is achievable using bold
"   attribute.
" - 24bit color terminal (gui): truecolor in terminals which supports it.
"
" It does NOT use 256 palette colors (if truecolor is not supported it will
" be limited to the 8+8 colors). It completely ignores monochromatic
" terminals (unset all 'term' attributes).
"
" All 'gui' attributes are reproduced in 'cterm', including italics. No
" undercurl is used at all.
"
" Normally I'll avoid underline, I hate it. I also avoid setting the
" background directly and prefer to use reverse to accomplish the same
" result, this way the background will not be changed by cursorline. I must
" say I hate colored backgrounds and restrict it to errors, spelling and
" other items that deserve imediate attention, and also some vim elements.
"
" Finally, it's intended for light background only and assumes that the
" default 8+8 colors have good visibility (default 16 colors usually have
" not, i.e. yellow is terrible, or cyan) so it probably will only work nice
" if the default terminal colors have been tweeked a little bit. I based my
" terminal colors in the Tomorrow theme.
"############################################################################

" Cleanup everything before starting
hi clear
syntax reset

" Basic syntax groups
hi Normal        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi ColorColumn   term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Comment       term=NONE ctermfg=7    ctermbg=NONE cterm=bold guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Conceal       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Constant      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi String        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Cursor        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi CursorColumn  term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi CursorLine    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi CursorLineNr  term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi DiffAdd       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi DiffChange    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi DiffDelete    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi DiffText      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Directory     term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Error         term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi ErrorMsg      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi FoldColumn    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Folded        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Identifier    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Ignore        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi IncSearch     term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi lCursor       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi LineNr        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi MatchParen    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi ModeMsg       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi MoreMsg       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi NonText       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Pmenu         term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi PmenuSbar     term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi PmenuSel      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi PmenuThumb    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi PreProc       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Question      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Search        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi SignColumn    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Special       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi SpecialKey    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi SpellBad      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi SpellCap      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi SpellLocal    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi SpellRare     term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Statement     term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi StatusLine    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi StatusLineNC  term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi TabLine       term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi TabLineFill   term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi TabLineSel    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Title         term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Todo          term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Type          term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Underlined    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi VertSplit     term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi Visual        term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi VisualNOS     term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi WarningMsg    term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
hi WildMenu      term=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE guisp=NONE
