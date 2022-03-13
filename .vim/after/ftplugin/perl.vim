setlocal number
setlocal equalprg=perltidy\ -q;true

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
let g:perl_fold = 1
let g:perl_nofold_packages = 1
let g:perl_nofold_subs = 1
let g:perl_string_as_statement = 1
let g:perl_include_pod = 1

if exists('loaded_matchit')
    let b:match_ignorecase = 0
    " Skip variables and methods.
    let s:not_start = '\%(\%([$@%&]\|->\)\s*\)\@<!'
    let s:has_paren = '\%(\s*(\s*\)\@='
    let s:has_brace = '\%(\s*{\s*\)\@='
    let s:has_container = '\%(\s*[{(]\s*\)\@='
    let b:match_words =
        \         s:not_start . '\<\%(if\|unless\)\>' . s:has_paren
        \ . ':' . s:not_start . '\<elsif\>' . s:has_paren
        \ . ':' . s:not_start . '\<else\>' . s:has_brace
        \
        \ . ',' . s:not_start . '\<\%(for\|foreach\|while\|until\)\>'
        \ . ':' . s:not_start . '\<next\>'
        \ . ':' . s:not_start . '\<break\>'
        \ . ':' . s:not_start . '\<continue\>' . s:has_brace
        \
        \ . ',' . s:not_start . '\<try\>' . s:has_brace
        \ . ':' . s:not_start . '\<catch\>' . s:has_container
        \ . ':' . s:not_start . '\<finally\>' . s:has_container
        \
        \ . ',' . s:not_start . '\<do\>' . s:has_brace
        \ . ':' . s:not_start . '\<\%(while\|until\)\>'
    unlet s:not_start s:has_paren s:has_brace
endif

" Deparse obfuscated code
nnoremap <silent> <buffer> <localleader>pd :%!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> <buffer> <localleader>pd :!perl -MO=Deparse 2>/dev/null<cr>
