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

let g:perl_fold = 1
let g:perl_nofold_packages = 1
let g:perl_nofold_subs = 1
let g:perl_string_as_statement = 1
let g:perl_include_pod = 1

if exists('loaded_matchit')
    let b:match_ignorecase = 0
    " Skip variables and methods.
    let s:not_start = '\%(\%([$@%]\|->\)\s*\)\@<!'
    let s:has_paren = '\%(\s*(\s*\)\@='
    let s:has_brace = '\%(\s*{\s*\)\@='
    let b:match_words =
        \         s:not_start . '\<\%(if\|unless\)\>' . s:has_paren
        \ . ':' . s:not_start . '\<elsif\>' . s:has_paren
        \ . ':' . s:not_start . '\<else\>'
        \
        \ . ',' . s:not_start . '\<\%(for\|foreach\|until\|while\)\>'
        \ . ':' . s:not_start . '\<continue\>' . s:has_brace
        \
        \ . ',' . s:not_start . '\<try\>' . s:has_brace
        \ . ':' . s:not_start . '\<catch\>' . s:has_brace
        \ . ':' . s:not_start . '\<finally\>' . s:has_brace
    unlet s:not_start s:has_paren s:has_brace
endif

" Deparse obfuscated code
nnoremap <silent> <buffer> <localleader>pd :%!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> <buffer> <localleader>pd :!perl -MO=Deparse 2>/dev/null<cr>
