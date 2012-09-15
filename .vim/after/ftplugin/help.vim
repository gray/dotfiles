setlocal wrap
setlocal nonumber
setlocal keywordprg=:help

" Follow link
nmap <buffer> <cr> <c-]>
" Return from link
nmap <buffer> <bs> <c-t>

" Option links
nmap <silent> <buffer> o /'\zs[a-z]\{2,\}\ze'<cr>zz
nmap <silent> <buffer> O ?'\zs[a-z]\{2,\}\ze'<cr>zz

" Subject links
nmap <silent> <buffer> s /\|\zs\S\+\ze\|<cr>zz
nmap <silent> <buffer> S ?\|\zs\S\+\ze\|<cr>zz

" Keyword anchors
nmap <silent> <buffer> a /\*\zs\S\+\*\ze$<cr>zz
nmap <silent> <buffer> A ?\*\zs\S\+\*\ze$<cr>zz
