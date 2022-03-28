setlocal number
setlocal formatprg=perltidy\ -q;true

let &l:path = './lib,./blib/lib,./blib/arch,' . &l:path
let $PERL5LIB = substitute(&l:path, ',', ':', 'g')

let &l:keywordprg = executable('cpandoc') ? 'cpandoc' : 'perldoc'
if has('mac') && empty($PERLDOC)
    " groff bug converts some characters to utf-8.
    let $PERLDOC = '-n"nroff -Tascii"'
endif
let g:ref_perldoc_cmd = &l:keywordprg
let g:ref_perldoc_auto_append_f = 1

let g:perl_compiler_force_warnings = 0
let g:perl_string_as_statement = 1

if expand("%:e") == 't'
    compiler perlprove
endif

" Deparse obfuscated code
nnoremap <silent> <buffer> <localleader>pd :%!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> <buffer> <localleader>pd :!perl -MO=Deparse 2>/dev/null<cr>
