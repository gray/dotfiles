" Initialize --------------------------------------------------------------{{{1

set nocompatible  " Explicitly set in case Vim was started with the -u flag

" Adds .vim/bundle/* to runtimepath.
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()


" Files, Backup -----------------------------------------------------------{{{1

set history=1000    " Size of command/search history
set viminfo='1000   " Save marks for N files
set viminfo+=<1000  " Save N lines for each register
set viminfo+=h      " Disable hlsearch at startup
set viminfo+=r/tmp  " Disable viminfo for tmp directories
set viminfo+=r/private/var/tmp
let &viminfo .= ',r' . substitute(expand($TMPDIR), '/\+$', '', '')
set viminfo+=n~/.vim/tmp/.viminfo  " Save the viminfo file elsewhere

set cpoptions+=W    " Do not overwrite readonly files
set cpoptions+=>    " Separate register items by line breaks

set modelines=0     " Trust no one

set autoread        " Reload file if externally, but not internally modified
set autowrite       " Write file if modified
set directory=~/.vim/tmp/swap//
set backupdir=~/.vim/tmp/
set backupskip+=/private/tmp/*

if has('persistent_undo')
    set undodir=~/.vim/tmp/undo/
    set undofile
endif


" Display, Terminal -------------------------------------------------------{{{1

set numberwidth=1     " Make line number column as narrow as possible
set lazyredraw        " Don't redraw while executing macros
set ttyfast           " Indicates a fast terminal connection
set title             " Set descriptive window/terminal title
set display=lastline  " Show as much of the last line as possible

set noerrorbells      " Error bells are annoying
set visualbell t_vb=  " No visual bell

set printoptions=paper:letter

if $TERM_PROGRAM == 'Apple_Terminal'
    if &term == 'xterm-color'
        set t_Co=16
    endif
    " Fixes backspace interaction with delimitMate.
    execute 'set t_kb=\<c-h>'
elseif &term =~ '256-\?color'
    set t_Co=256
elseif &term =~ 'xterm'
    set t_Co=8
endif

if has('multi_byte')
    set encoding=utf-8
    if empty(&termencoding)
        set termencoding=utf-8
    endif
    if &termencoding == 'utf-8'
        let &showbreak = "\u21aa "
    endif
endif

set nowrap            " Don't wrap long lines
set linebreak         " Wrap lines at convenient points
set list              " Visually display tabs and trailing spaces
let &listchars = "tab:\ubb\ub7,trail:\ub7,extends:\ubb,precedes:\uab"

set ttimeoutlen=50    " Reduce delay for key codes


" Messages, Statusline ----------------------------------------------------{{{1

set shortmess=a   " Use abbreviated messages
set shortmess+=T  " Truncate messages in the middle if too long
set shortmess+=I  " Disable intro message
set shortmess+=t  " Truncate filename at start if too long
set shortmess+=o  " Do not prompt to overwrite file
set shortmess+=O  " Message for reading file overwrites previous

set showcmd       " Display the command in the last line
set showmode      " Display the current mode in the last line
set report=1      " Always report the number of lines changed
set ruler         " Display info on current position
set laststatus=2  " Always show status line
set statusline=Editing:\ %r%t%m\ %=Location:\ Line\ %l/%L\ \ Col:\ %c\ (%p%%)


" Cursor movement ---------------------------------------------------------{{{1

set backspace=indent,eol,start  " Allow backspacing over these
set whichwrap+=h,l,<,>,[,]      " h l <Left> <Right> can also change lines
set virtualedit=block           " Select a rectangle in visual mode
set scrolloff=2      " Lines visible above/below cursor when scrolling
set sidescrolloff=2  " Lines visible left/right of cursor when scrolling
set sidescroll=1     " Smoother scrolling when reaching end of screen
set nostartofline    " Keep the cursor in the same column


" Text-Formatting, Identing, Tabbing --------------------------------------{{{1

if has('eval') && ! &diff
    filetype plugin on
    filetype indent on
endif

set textwidth=78
set autoindent        " Use indent from previous line
set smarttab          " Smart handling of the tab key
set expandtab         " Use spaces for tabs
set tabstop=8         " View (and :retab) others' code as intended
set softtabstop=4     " Backspace will now delete 4 spaces at a time
set shiftwidth=4      " Number of spaces for each indent
set shiftround        " Round indent to multiple of shiftwidth
set nojoinspaces      " Don't insert two spaces after join command

set formatoptions-=t  " Don't auto-wrap text
set formatoptions+=c  " Auto-wrap comments
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=r  " Insert comment leader after <cr> in insert mode.
set formatoptions+=q  " Allow formatting of comments with 'gq'
set formatoptions+=1  " Break a line before, not after, a one-letter word

set foldclose=all     " Close folds at startup


" Matching, Searching, Substituting ---------------------------------------{{{1

set showmatch        " Show matching bracket
set matchtime=2      " (for only .2 seconds)

set incsearch        " Show search matches as you type
set ignorecase       " Ignore case when searching
set smartcase        " Override 'ignorecase' when needed
set hlsearch         " Highlight search results

set gdefault         " Apply substitution to all matches


" Menus, Completion -------------------------------------------------------{{{1

set complete-=i            " Don't scan included files
set complete+=k            " Use dictionary files for completion
set completeopt=longest    " Insert longest completion match
set completeopt+=menu      " Use popup menu with completions
set completeopt+=menuone   " Show popup even with one match
set infercase              " Try to adjust insert completions for case

set wildmenu                    " Enable wildmenu for completion
set wildmode=list:longest,full  " Complete longest common string,
set wildignore+=*~,*.swo,*.swp,*/.vim/tmp/*,tags
set wildignore+=*.a,*.class,*.la,*.mo,*.o,*.obj,*.pyc,*.pyo,*.so
set wildignore+=.DS_Store,*.gif,*.jpg,*.png
set wildignore+=**/CVS/*,**/.bzr/*,**/.git/*,**/.hg/*,**/.svn/*,blib

set tags=tags;/  " Search for a ctags file
set showfulltag


" Buffers, Windows, Tabs --------------------------------------------------{{{1

set hidden                    " Allow edit buffers to be hidden
set switchbuf=useopen,usetab  " Jump to first open window or tab with buffer

if has('clipboard') && empty($SSH_CLIENT)
    set clipboard^=unnamed    " Use system clipboard
endif

set mouse=a            " Enable the mouse for all modes
set mousehide          " Hide mouse while typing
set mousemodel=popup   " Use popup menu for right mouse button

set noequalalways      " Don't resize windows to the same size
set splitright         " When splitting vertically, split to the right
set splitbelow         " When splitting horizontally, split below

set tabpagemax=128     " Maximum number of tabs open


" Syntax Highlighting -----------------------------------------------------{{{1

" NOTE: enabling syntax clears any pre-existing Syntax autocommands.
if has('syntax') && ! &diff
    syntax enable
endif

" For sh syntax; most shells are POSIX-compliant.
let g:is_posix = 1


" Functions ---------------------------------------------------------------{{{1

" Calling a function from a ranged-command triggers a bug that resets the
" cursor position to 1,1 before the function is called. To avoid this, pass in
" the line numbers as arguments instead of using a range.
function! s:StripWhitespace (line1, line2)
    let l:saved_pos = getpos('.')
    let l:saved_search = @/
    execute 'silent! keepjumps' a:line1 . ',' . a:line2 . 's/\s\+$//e'
    call setpos('.', l:saved_pos)
    let @/ = l:saved_search
endfunction

function! GetCurrentSyntax ()
    return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

function! s:AdjustColorScheme ()
    let l:bg = synIDattr(hlID('Normal'), 'bg#')
    if empty(l:bg) || l:bg == -1
        return
    endif

    " If the background color is dark, set it to black.
    " TODO: also force the background of comments, strings, etc.
    if has('gui_running')
        " Calculate the perceived brightness.
        let [l:r, l:g, l:b] = map([1,3,5], 'str2nr(l:bg[v:val : 1+v:val], 16)')
        let l:light = sqrt(0.241 * l:r*l:r + 0.691 * l:g*l:g + 0.068 * l:b*l:b)
        if l:light < 130
            highlight Normal guibg=black
        endif
    else
        let l:dark_range = range(7) + [8] + range(16, 32) + range(52, 67)
            \ + range(88, 99) + range(124, 134) + range(160, 165)
            \ + [196, 197] + range(232, 244)
        if index(l:dark_range, str2nr(l:bg)) >= 0
            " Vim resets the colors to default if the ctermbg for the Normal
            " group is set without first unsetting g:colors_name and setting
            " g:syntax_cmd to an invalid value.
            if exists('g:colors_name')
                let l:colors_name = g:colors_name | unlet g:colors_name
            endif
            if exists('g:syntax_cmd')
                let l:syntax_cmd = g:syntax_cmd
            endif
            let g:syntax_cmd = 'do not reset to default colors'

            highlight Normal ctermbg=black

            " Vim resets the background to light if a colorscheme sets the
            " Normal group's ctermbg to a value greater than 8.
            if &t_Co == 256 | set background=dark | endif

            if exists('l:colors_name')
                let g:colors_name = l:colors_name
            endif
            unlet g:syntax_cmd
            if exists('l:syntax_cmd')
                let g:syntax_cmd = l:syntax_cmd
            endif
        endif
    endif
endfunction

function! s:AdjustSyntaxHighlighting ()
    highlight Search cterm=NONE ctermfg=yellow ctermbg=blue
        \ gui=NONE guifg=yellow guibg=blue

    highlight CursorLine term=reverse cterm=reverse gui=reverse
    highlight CursorColumn term=reverse cterm=reverse gui=reverse

    for l:group in ['ColorColumn', 'SpellBad', 'Todo']
        execute 'highlight' l:group 'cterm=NONE ctermbg=red ctermfg=white'
            \ 'gui=NONE guibg=red guifg=white'
    endfor
    syntax keyword myTodo containedin=.*Comment,perlPOD contained
        \ BUG FIXME HACK NOTE README TBD TODO WARNING XXX
    highlight default link myTodo Todo

    syntax match nonAscii '[^\t -~]'
    highlight nonAscii term=reverse cterm=reverse gui=reverse

    highlight DiffAdd cterm=NONE ctermbg=green ctermfg=white
    highlight DiffChange cterm=bold ctermbg=cyan ctermfg=black
    highlight DiffDelete cterm=bold ctermbg=red ctermfg=white
    highlight DiffText cterm=bold ctermbg=NONE ctermfg=black
endfunction


" Commands ----------------------------------------------------------------{{{1

" Show unsaved changes to current buffer
" TODO: if window size can be changed, double it and make new window vertical,
"     else make new window horizontal.
command! DiffBuff vertical new | let t:diff_bufnr = bufnr('$') |
    \ setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile filetype= |
    \ r # | 0d_ | diffthis | wincmd p | diffthis |
    \ if exists('b:current_syntax') | let b:saved_syntax = b:current_syntax |
    \ endif | syntax clear

" Close DiffBuff's diff window and reset syntax.
command! DiffOff execute 'bwipeout' t:diff_bufnr | diffoff |
    \ if exists('b:saved_syntax') | let &l:syntax = b:saved_syntax | endif

command! -range=% -bar StripWhitespace call s:StripWhitespace(<line1>, <line2>)


" Plugin Settings ---------------------------------------------------------{{{1

let g:SuperTabDefaultCompletionType = 'context'

if executable('ag')
    let g:ackprg = 'ag --nogroup --nocolor --column'
endif

let g:ctrlp_map = '<leader>ff'
let g:ctrlp_cache_dir = '~/.vim/tmp/cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_extensions = [ 'tag', 'buffertag', 'dir', 'line', 'rtscript' ]

let g:NERDSpaceDelims = 1
let g:NERDTreeShowHidden = 1

let g:Tlist_Enable_Fold_Column = 0
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_File_Fold_Auto_Close = 1
let g:Tlist_GainFocus_On_ToggleOpen = 1
let g:Tlist_Inc_Winwidth = 0
let g:Tlist_Show_One_File = 1
let g:tlist_make_settings = 'make;t:targets;m:macros'
let g:tlist_perl_settings = 'perl;p:packages;c:constants;l:labels;' .
    \ 's:subroutines'
let g:tlist_xs_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;' .
    \ 'v:variable;f:function'

let g:tagbar_left = 1
let g:tagbar_autofocus = 1
let g:tagbar_type_make = { 'kinds' : [ 't:targets', 'm:macros' ] }
let g:tagbar_type_xs = {
    \ 'ctagstype' : 'c',
    \ 'kinds'     : [
    \     'd:macros:1', 'p:prototypes:1', 'g:enums', 'e:enumerators',
    \     't:typedefs', 's:structs', 'u:unions', 'f:functions',
    \     'm:members', 'v:variables'
    \ ],
    \ 'sro'        : '::',
    \ 'kind2scope' : { 'g' : 'enum', 's' : 'struct', 'u' : 'union' },
    \ 'scope2kind' : { 'enum' : 'g', 'struct' : 's', 'union' : 'u' },
    \ }

let g:netrw_nogx = 1
if has('macunix')
    let g:openbrowser_browser_commands = [{
        \ 'name': "open",
        \ 'args': ['{browser}', '-g', '{uri}']
        \ }]
endif

let g:LargeFile = 50

nmap <plug>IgnoreMarkSearchNext <plug>MarkSearchNext
nmap <plug>IgnoreMarkSearchPrev <plug>MarkSearchPrev

let g:gist_show_privates = 1
let g:gist_post_private = 1
let g:gist_detect_filetype = 1

let g:ref_cache_dir = expand('~/.vim/tmp/cache', 1)
let g:ref_perldoc_cmd = 'cpandoc'
let g:ref_perldoc_auto_append_f = 1

let g:cpan_mod_cachef = expand('~/.vim/tmp/cache/cpan-modules.txt', 1)

if ! exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = "\u2387 "
let g:airline_left_sep = "\u25b6"
let g:airline_right_sep = "\u25c0"
let g:airline_section_z = '%l/%L : %c (%p%%)'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#wordcount#enabled = 0


" Mappings ----------------------------------------------------------------{{{1

let mapleader = ','
let maplocalleader = ','

inoremap jj <esc>

" Use ,, to work around , as leader.
noremap ,, ,

" Save current buffer with root permissions.
cnoremap <silent> w!! :SudoWrite<cr>

" Insert a single character.
noremap <leader>i i<space><esc>r

" Make this consistent with C and D operators.
nnoremap Y y$

" Preserve undo history.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-@> <c-g>u<c-@>
inoremap <c-a> <c-g>u<c-a>
inoremap <c-w> <c-g>u<c-w>

map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)

" Make it easier to navigate displayed lines when lines wrap.
inoremap <down> <c-o>gj
inoremap <up> <c-o>gk
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Saner paging behaviour.
noremap <silent> <pagedown> <c-d><c-d>
noremap <silent> <pageup> <c-u><c-u>
map <silent> <s-down> <pagedown>
map <silent> <s-up> <pageup>
inoremap <silent> <pagedown> <c-\><c-o><c-d><c-\><c-o><c-d>
inoremap <silent> <pageup> <c-\><c-o><c-u><c-\><c-o><c-u>
imap <silent> <s-down> <pagedown>
imap <silent> <s-up> <pageup>

cnoremap <c-a> <home>
inoremap <c-a> <home>
inoremap <c-f> <right>
inoremap <c-b> <left>

" Redraw screen, toggle search highlighting, sync syntax, toggle list.
nnoremap <silent> <c-l> <esc>:setlocal invhlsearch invlist
    \ <cr>:call mark#Toggle()<cr>:syntax sync fromstart
    \ <cr>:setlocal cursorcolumn! cursorline!<cr><c-l>
inoremap <silent> <c-l> <esc>:setlocal invhlsearch invlist
    \ <cr>:call mark#Toggle()<cr>:syntax sync fromstart
    \ <cr>:setlocal cursorcolumn! cursorline!<cr><c-l>a

" Return to visual mode after indenting.
vnoremap < <gv
vnoremap > >gv

" Select last pasted text.
nnoremap gV `[v`]

" Paragraph formatting.
nnoremap Q gqap
vnoremap Q gq

" Avoid accidentally calling up the command history.
nmap q: <nop>

" Avoid accidentally deleting selection when using NerdCommenter mappings.
vmap <leader>c <nop>

" Toggle various plugins.
noremap <silent> <leader>fb :CtrlPBuffer<cr>
noremap <silent> <leader>fr :CtrlPMRU<cr>
noremap <silent> <leader>fv :CtrlPRTS<cr>
noremap <silent> <leader>nt :NERDTreeToggle<cr>
noremap <silent> <leader>tl :TlistToggle<cr>
noremap <silent> <leader>tb :TagbarToggle<cr>
noremap <silent> <leader>ut :UndotreeToggle<cr>
noremap <silent> <leader>hw :Histwin<cr>

nmap <silent> <leader>z <plug>ZoomWin

noremap <silent> <leader>ss :SplitjoinSplit<cr>
noremap <silent> <leader>sj :SplitjoinJoin<cr>

nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)


" Autocommands ------------------------------------------------------------{{{1

if has('autocmd')
    augroup vimrc
    autocmd!

    " GUI startup resets the visual bell; turn it back off.
    autocmd GUIEnter * set visualbell t_vb=

    autocmd GUIEnter,ColorScheme * call s:AdjustColorScheme()
    autocmd ColorScheme,Syntax * call s:AdjustSyntaxHighlighting()

    " Disable undo files for tmp directories.
    if has('persistent_undo') |
        autocmd BufNewFile,BufRead /tmp/*,/private/tmp/*,$TMPDIR/*
            \ setlocal noundofile |
    endif

    " Restore the cursor position.
    autocmd BufRead *
        \ if line("'\"") <= line('$') && ! &diff && ! exists('b:no_viminfo') |
        \     execute 'normal! g`"' | let b:restored_pos = 1 |
        \ endif
    " Open any containing folds on startup or when restoring cursor position.
    autocmd VimEnter * execute 'normal! zv' | redraw!
    autocmd BufWinEnter *
        \ if exists('b:restored_pos') |
        \     execute 'normal! zv' | unlet b:restored_pos |
        \ endif

    " Create the parent directory if it does not already exist.
    autocmd BufWritePre,FileWritePre *
        \ if ! isdirectory(expand('<afile>:p:h')) |
        \     silent! call mkdir(fnameescape(expand('<afile>:p:h')), 'p') |
        \ endif

    " Make new scripts executable.
    autocmd BufNewFile * let b:is_new_file = 1
    autocmd BufWritePost,FileWritePost *
        \ if exists('b:is_new_file') |
        \     unlet b:is_new_file |
        \     if getline(1) =~ '^#!.*/bin/' |
        \         execute 'silent! !chmod +x' shellescape(expand('<afile>')) |
        \     endif |
        \ endif

    " Prevent the current line from shifting screen position when a hidden
    " buffer is displayed again.
    autocmd BufHidden *
        \ if ! &diff |
        \     let b:saved_winview = winsaveview() |
        \     let b:last_winsize = [winheight(0), winwidth(0)] |
        \ endif
    autocmd BufWinEnter *
        \ if exists('b:saved_winview') && ! &diff
        \         && b:last_winsize == [winheight(0), winwidth(0)] |
        \     call winrestview(b:saved_winview) |
        \ endif

    " Disable insert mode when idle for 15 seconds.
    autocmd InsertEnter *
        \ let g:saved_updatetime = &updatetime | set updatetime=15000
    autocmd InsertLeave *
        \ if exists('g:saved_updatetime') |
        \    let &updatetime = g:saved_updatetime | unlet g:saved_updatetime |
        \ endif
    autocmd BufLeave,CursorHoldI * stopinsert | doautocmd InsertLeave

    " Make visible only in insert mode.
    if exists('+colorcolumn')
        autocmd InsertEnter * setlocal colorcolumn=80
        autocmd InsertLeave * setlocal colorcolumn=
    end

    " Fall back to syntax keyword completion.
    if exists('+omnifunc')
        autocmd Filetype *
            \ if ! empty(&omnifunc) && ! exists('*'.&omnifunc) |
            \     silent! runtime autoload/<amatch>complete.vim |
            \ endif |
            \ if empty(&omnifunc) || ! exists('*'.&omnifunc) |
            \     setlocal omnifunc=syntaxcomplete#Complete |
            \ endif
    endif

    " Attempt to set the compiler, if it's not already set.
    autocmd Filetype *
        \ if ! exists('b:current_compiler') |
        \     try | execute 'compiler' &filetype | catch | endtry |
        \ endif

    autocmd BufRead .vimrc setlocal foldmethod=marker
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
    autocmd BufNewFile,BufRead *.t compiler perlprove

    " Custom filetype mappings are defined in ~/.vim/filetype.vim
    autocmd FileType apache setlocal shiftwidth=2 softtabstop=2
    autocmd FileType bzr,cvs,gitcommit,hgcommit,svn
        \ setlocal nowritebackup nolist spell spellcapcheck= wrap textwidth=74 |
        \ if has('persistent_undo') | setlocal noundofile | endif |
        \ let b:no_viminfo = 1
    autocmd FileType html
        \ setlocal equalprg=tidy\ -q\ -i\ --wrap\ 78\ --indent-spaces\ 4
    autocmd FileType javascript setlocal equalprg=js_beautify.pl\ -
    autocmd FileType make setlocal nosmarttab nolist
    autocmd FileType nfo noautocmd edit ++encoding=cp437 | setlocal nolist
    autocmd FileType puppet setlocal shiftwidth=2 softtabstop=2
    autocmd FileType qf setlocal nobuflisted wrap number
    autocmd FileType vim setlocal keywordprg=:help | let g:vim_indent_cont=4
    autocmd FileType xml
        \ setlocal equalprg=tidy\ -q\ -i\ -xml\ --wrap\ 78\ --indent-spaces\ 4
        \     matchpairs+=<:>
    autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2

    autocmd FileType bdb1_hash,epub,pdf,postscr,sqlite
        \ setlocal readonly nolist wrap filetype=text | let b:no_viminfo = 1
    autocmd FileType bdb1_hash
        \ execute 'silent %!perl -MDB_File -e ''tie \%db, DB_File => shift,'
        \    'O_RDONLY; while (($k, $v) = each \%db){ print "$k | $v\n" }'''
        \    shellescape(expand('<afile>'))
    autocmd FileType epub
        \ execute 'silent %!einfo -q -p' shellescape(expand('<afile>'))
        \     '| lynx -stdin -dump -force_html -display_charset=utf-8 -nolist'
    autocmd FileType pdf
        \ execute 'silent %!pdftotext -q' shellescape(expand('<afile>'))
        \     ' - | par w78'
    autocmd FileType postscr
        \ execute 'silent %!ps2ascii' shellescape(expand('<afile>'))
        \     '| par w78'
    autocmd FileType sqlite
        \ execute 'silent %!sqlite3' shellescape(expand('<afile>')) '.dump'
    autocmd FileType bdb1_hash,epub,pdf,postscr,sqlite setlocal nomodifiable

    " Preview window for ref plugin.
    autocmd FileType ref nmap <silent> <buffer> <bs> <Plug>(ref-back)

    augroup end
endif


" Colors ------------------------------------------------------------------{{{1

let g:solarized_termtrans = 1
let g:solarized_termcolors = 256

if has('gui_running') || &t_Co == 256
    colorscheme gentooish
else
    colorscheme jellybeans
endif

" Bug in terminal vim: https://redd.it/22krs1
set background=dark

" GUI ---------------------------------------------------------------------{{{1

if has('gui_running')
    set lines=50
    set columns=85

    set guioptions-=T  " Hide toolbar
    set guioptions+=c  " Use console dialogues instead of popups
    set guioptions+=e  " Show the tabline
    set guioptions-=m  " Hide menubar

    if has('gui_macvim')
        set noantialias
        set transparency=10

        " Use a larger font size for higher resolution screens.
        let s:width = system("osascript -e 'tell application \"Finder\" to get"
            \ . " bounds of window of desktop' | cut -d ' ' -f 4")
        if 800 < s:width
            set guifont=Monaco:h13.00
        else
            set guifont=Monaco:h10.00
        endif
    elseif has('gui_gtk')
        set guifont=Monaco\ 9
    endif

    " Terminal is not fully functional.
    let $PAGER = 'sh -c "col -b -x | more"'
    let $PERLDOC_PAGER = 'sh -c "col -b -x | more" <'
endif
