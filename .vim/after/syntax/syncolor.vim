highlight ColorColumn cterm=NONE ctermbg=red ctermfg=white
    \ gui=NONE guibg=darkred guifg=white

highlight CursorLine term=reverse cterm=reverse gui=reverse
highlight CursorColumn term=reverse cterm=reverse gui=reverse

highlight DiffAdd cterm=NONE ctermbg=darkgreen ctermfg=white
    \ gui=NONE guibg=darkgreen guifg=white
highlight! link diffAdded DiffAdd
highlight DiffChange cterm=NONE ctermbg=darkblue ctermfg=white
    \ gui=NONE guibg=darkblue guifg=white
highlight! link diffChanged DiffChange
highlight DiffDelete cterm=NONE ctermbg=darkred ctermfg=white
    \ gui=NONE guibg=darkred guifg=white
highlight! link diffRemoved DiffDelete
highlight DiffText cterm=NONE ctermbg=darkmagenta ctermfg=white
    \ gui=NONE guibg=darkmagenta guifg=white

highlight Search cterm=NONE ctermfg=yellow ctermbg=blue
    \ gui=NONE guifg=yellow guibg=blue

highlight SpellBad cterm=NONE ctermbg=red ctermfg=white
    \ gui=NONE guibg=red guifg=white

syntax keyword myTodo containedin=.*Comment.*,perlPOD contained
    \ BUG  FIXME  HACK  NOTE  README  TBD  TODO  WARNING  XXX 
    \ BUG: FIXME: HACK: NOTE: README: TBD: TODO: WARNING: XXX:
highlight! default link myTodo Todo
highlight Todo cterm=NONE ctermbg=darkred ctermfg=white
    \ gui=NONE guibg=darkred guifg=white

syntax match nonAscii '[^\t -~]'
highlight nonAscii term=reverse cterm=reverse gui=reverse

syntax match vcsConflictMarker '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
highlight! default link vcsConflictMarker ErrorMsg
