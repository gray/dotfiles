let g:perl_compiler_force_warnings = 0
compiler perl

" Show line numbers
setlocal number

setlocal keywordprg=sh\ -c\ 'cpandoc\ \$1\ \|\|\ cpandoc\ -f\ \$1\'\ --
if has('mac')
    " groff bug converts some characters to utf-8.
    let b:keywordprg = "PERLDOC='-n\"nroff -Tascii\"' " . &keywordprg
endif

setlocal equalprg=perltidy\ -q

let perl_include_pod = 1
let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_string_as_statement = 1

" Fold POD and heredocs
let perl_fold = 1
let perl_nofold_packages = 1
let perl_nofold_subs = 1

" Deparse obfuscated code
nnoremap <silent> <localleader>pD :%!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> <localleader>pD :!perl -MO=Deparse 2>/dev/null<cr>
