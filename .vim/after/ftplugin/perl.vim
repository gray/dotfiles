let g:perl_compiler_force_warnings = 0
compiler perl

" Show line numbers
setlocal number

" TODO: find a better solution: perldoc, then perldoc -f
setlocal keywordprg=sh\ -c\ 'perldoc\ -f\ \$1\ \|\|\ perldoc\ \$1'\ --

" TODO: $VIMRUNTIME/ftplugin/perl.vim is setting path to @INC, and this
" slows down keyword matching (C-P, C-N), so reset it
" let &l:path='.'

let perl_include_pod = 1
let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_string_as_statement = 1

" Fold POD and heredocs
let perl_fold = 1
let perl_nofold_packages = 1
let perl_nofold_subs = 1

nnoremap <silent> <localleader>pt :%!perltidy -q<cr>
vnoremap <silent> <localleader>pt :!perltidy -q<cr>

" Deparse obfuscated code
nnoremap <silent> <localleader>pD :%!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> <localleader>pD :!perl -MO=Deparse 2>/dev/null<cr>
