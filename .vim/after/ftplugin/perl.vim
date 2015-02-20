setlocal number
setlocal equalprg=perltidy\ -q

let &l:path = './lib,./blib/lib,./blib/arch,' . &l:path
let $PERL5LIB = substitute(&l:path, ',', ':', 'g')

setlocal keywordprg=cpandoc
if has('mac')
    " groff bug converts some characters to utf-8.
    let b:keywordprg = "PERLDOC='-n\"nroff -Tascii\"' " . &keywordprg
endif

let g:perl_compiler_force_warnings = 0

let g:perl_include_pod = 1
let g:perl_extended_vars = 1
let g:perl_want_scope_in_variables = 1
let g:perl_string_as_statement = 1

" Fold POD and heredocs
let g:perl_fold = 1
let g:perl_nofold_packages = 1
let g:perl_nofold_subs = 1

" Deparse obfuscated code
nnoremap <silent> <buffer> <localleader>pd :%!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> <buffer> <localleader>pd :!perl -MO=Deparse 2>/dev/null<cr>
