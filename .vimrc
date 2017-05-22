" Initialize --------------------------------------------------------------{{{1

set nocompatible  " Explicitly set in case Vim was started with the -u flag

" Adds .vim/bundle/* to runtimepath.
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()


" Security ----------------------------------------------------------------{{{1

" Discourage editing by superuser; enable minimal features.
if ! empty($SUDO_USER)
    set noswapfile nowritebackup
    if has('viminfo') | set viminfo= | endif
    finish
endif

set modelines=0  " Trust no one


" Files, Backup -----------------------------------------------------------{{{1

set autoread        " Reload file if externally, but not internally modified
set autowrite       " Write file if modified
set directory=~/.vim/tmp/swap//
set writebackup     " Default, but vim might be comiled without feature
set backupdir=~/.vim/tmp/backup/

set cpoptions+=W    " Do not overwrite readonly files
set cpoptions+=>    " Separate register items by line breaks
set history=1000    " Size of command/search history

if has('viminfo')
    set viminfo='1000   " Save marks for 1,000 files
    set viminfo+=/1000  " Save last 1,000 search patterns
    set viminfo+=:1000  " Save last 1,000 commands
    set viminfo+=<1000  " Save 1,000 lines for each register
    set viminfo+=s1000  " Save only registers of less than 1MB size
    set viminfo+=!      " Save global variables
    set viminfo+=h      " Disable hlsearch at startup
    " Disable viminfo for tmp directories
    for s:dir in ['/tmp', '/var/tmp', $TMPDIR]
        if ! empty(s:dir) | let &viminfo .= ',r' . resolve(s:dir) | endif
    endfor
    set viminfo+=n~/.vim/tmp/.viminfo  " Save the viminfo file elsewhere
endif

if has('persistent_undo')
    set undofile
    set undodir=~/.vim/tmp/undo/
endif


" Display, Terminal -------------------------------------------------------{{{1

set lazyredraw         " Don't redraw while executing macros
set ttimeoutlen=50     " Reduce delay for key codes
if exists('+belloff')
    set belloff=all    " Disable all bell notifications
else
    set noerrorbells   " Disable bell notifications for errors
    set visualbell     " Enable visual bell
    set t_vb=          " Make visual bell invisible
endif

if has('title')
    set title          " Set descriptive window/terminal title
endif
set display=lastline   " Show as much of the last line as possible
set nowrap             " Don't wrap long lines
if has('folding')
    set foldclose=all  " Close folds at startup
endif

set list               " Visually display tabs and trailing spaces
let &listchars = "tab:> ,trail:-,extends:>,precedes:<"

if has('linebreak')
    set linebreak      " Wrap lines at convenient points
    let &showbreak = '> '
    set numberwidth=1  " Minimize line number column
endif
if exists('+breakindent')
    set breakindent    " Visually indent wrapped lines
endif

if &term =~ '256-\?color'
    set t_Co=256
elseif &term == 'xterm-color'
    set t_Co=16
elseif &term =~ 'xterm'
    set t_Co=8
endif

let s:ok_termguicolors = has('termguicolors') && &t_Co == 256
    \ && ($TERM_PROGRAM != 'Apple_Terminal' || ! empty($TMUX))
    \ && (empty($SSH_CLIENT) || ! empty($TMUX))
if s:ok_termguicolors
    let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
endif

if has('multi_byte')
    set encoding=utf-8
    if empty(&termencoding) | set termencoding=utf-8 | endif

    let &listchars = "tab:\ubb\ub7,trail:\ub7,extends:\ubb,precedes:\uab"
    if has('linebreak') | let &showbreak = "\u21aa" | endif
endif


" Messages, Statusline ----------------------------------------------------{{{1

set shortmess+=a      " Use abbreviated messages
set shortmess+=I      " Disable intro message
if has('patch-7.4.314')
    set shortmess+=c  " Disable insert completion messages
endif

if has('cmdline_info')
    set showcmd       " Display the command in the last line
    set ruler         " Display info on current position
endif
set showmode          " Display the current mode in the last line
set report=1          " Always report the number of lines changed
set laststatus=2      " Always show status line
if has('statusline')
    set statusline=Editing:\ %r%t%m\ %=Location:\ Line\ %l/%L\ \ Col:\ %c\ (%p%%)
endif


" Cursor movement ---------------------------------------------------------{{{1

set backspace=indent,eol,start  " Allow backspacing over these
set whichwrap+=h,l,<,>,[,]      " h l <left> <right> can also change lines
if has('virtualedit')
    set virtualedit=block       " Select a rectangle in visual mode
endif
set scrolloff=2      " Lines visible above/below cursor when scrolling
set sidescrolloff=2  " Lines visible left/right of cursor when scrolling
set sidescroll=1     " Smoother scrolling when reaching end of screen
set nostartofline    " Keep the cursor in the same column


" Text-Formatting, Identing, Tabbing --------------------------------------{{{1

if has('autocmd') && ! &diff
    filetype plugin indent on
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
set nrformats-=octal  " Don't recognize octal numbers for CTRL-A/X

set formatoptions-=t  " Don't auto-wrap text
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=r  " Insert comment leader after newline in insert mode.
set formatoptions+=1  " Don't break a line after a one-letter word
if v:version + has('patch541') >= 704
    set formatoptions+=j  " Remove comment leader when joining lines
endif

if has('printer')
    set printoptions=paper:letter
endif


" Matching, Searching, Substituting ---------------------------------------{{{1

set showmatch        " Show matching bracket
set matchtime=2      " (for only .2 seconds)

if has('extra_search') && has('reltime')
    set incsearch    " Show search matches as you type
    set hlsearch     " Highlight search results
endif
set ignorecase       " Ignore case when searching
set smartcase        " Override 'ignorecase' when needed

set gdefault         " Apply substitution to all matches


" Menus, Completion -------------------------------------------------------{{{1

set complete-=i                 " Don't scan included files
set complete-=t                 " Don't scan tags
if has('insert_expand')
    set completeopt-=preview    " Don't show extra information
    set completeopt+=longest    " Insert longest completion match
    set completeopt+=menuone    " Show menu with even one match
endif
set infercase                   " Try to adjust insert completions for case

if has('wildmenu')
    set wildmenu                " Enable wildmenu for completion
endif
set wildmode=list:longest,full  " Complete longest common string
if has('wildignore')
    set wildignore+=*~,*.swo,*.swp,*/.vim/tmp/*,tags
    set wildignore+=*.a,*.class,*.la,*.mo,*.o,*.obj,*.pyc,*.pyo,*.so
    set wildignore+=.DS_Store,*.gif,*.jpg,*.png
    set wildignore+=**/CVS/*,**/.bzr/*,**/.git/*,**/.hg/*,**/.svn/*,blib
endif
if exists('+wildignorecase')
    set wildignorecase          " Ignore case when completing file names
endif

set tags=tags;/                 " Search for a ctags file
set showfulltag


" Buffers, Windows, Tabs --------------------------------------------------{{{1

set hidden                    " Allow edit buffers to be hidden
set switchbuf=useopen,usetab  " Jump to first open window or tab with buffer

if has('clipboard') && empty($SSH_CLIENT)
    set clipboard^=unnamed    " Use system clipboard
endif

if has('mouse')
    set mouse=a            " Enable the mouse for all modes
    set mousehide          " Hide mouse while typing
    set mousemodel=popup   " Use popup menu for right mouse button
endif

set noequalalways      " Don't resize windows to the same size
if has('vertsplit')
    set splitright     " When splitting vertically, split to the right
endif
if has('windows')
    set splitbelow     " When splitting horizontally, split below
    set tabpagemax=128 " Maximum number of tabs open
endif


" Syntax Highlighting -----------------------------------------------------{{{1

" NOTE: enabling syntax clears any pre-existing Syntax autocommands.
let s:ok_syntax = has('syntax') && ! exists('g:syntax_on')
    \ && (&t_Co > 2 || has('gui_running')) && ! &diff
if s:ok_syntax
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
    if empty(l:bg) || l:bg == -1 | return | endif

    " If the background color is dark, set it to black.
    " TODO: also force the background of comments, strings, etc.
    if has('gui_running') || s:ok_termguicolors
        " Calculate the perceived brightness.
        let [l:r, l:g, l:b] = map([1,3,5], 'str2nr(l:bg[v:val : 1+v:val], 16)')
        let l:light = sqrt(0.241 * l:r*l:r + 0.691 * l:g*l:g + 0.068 * l:b*l:b)
        let l:dark = l:light < 130 ? 1 : 0
    else
        let l:dark_range = range(7) + [8] + range(16, 32) + range(52, 67)
            \ + range(88, 99) + range(124, 134) + range(160, 165)
            \ + [196, 197] + range(232, 244)
        let l:dark = index(l:dark_range, str2nr(l:bg)) >= 0 ? 1 : 0
    endif
    if ! l:dark | return | endif

    " Vim resets the colors to default if the ctermbg for the Normal group is
    " set without first unsetting g:colors_name and setting g:syntax_cmd to an
    " invalid value.
    if exists('g:colors_name')
        let l:colors_name = g:colors_name | unlet g:colors_name
    endif
    if exists('g:syntax_cmd') | let l:syntax_cmd = g:syntax_cmd | endif
    let g:syntax_cmd = 'do not reset to default colors'

    highlight Normal ctermbg=black guibg=black

    " Vim resets the background to light if a colorscheme sets the Normal
    " group's ctermbg to a value greater than 8.
    if &t_Co == 256 | set background=dark | endif

    if exists('l:colors_name') | let g:colors_name = l:colors_name | endif
    unlet g:syntax_cmd
    if exists('l:syntax_cmd') | let g:syntax_cmd = l:syntax_cmd | endif
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
command! DiffOff silent! execute 'bwipeout' t:diff_bufnr | diffoff |
    \ if exists('b:saved_syntax') | let &l:syntax = b:saved_syntax | endif |
    \ execute 'normal! zv'

command! -range=% -bar StripWhitespace call s:StripWhitespace(<line1>, <line2>)


" Plugin Settings ---------------------------------------------------------{{{1

let g:SuperTabDefaultCompletionType = 'context'
let g:delimitMate_expand_cr = 1

if executable('ag')
    let g:ackprg = 'ag --vimgrep --hidden'
    let &grepprg = 'ag --vimgrep --hidden'
    set grepformat=%f:%l:%c:%m
endif

let g:ctrlp_map = '<leader>ff'
let g:ctrlp_cache_dir = '~/.vim/tmp/cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_extensions = [ 'tag', 'buffertag', 'dir', 'line', 'rtscript' ]

let g:NERDSpaceDelims = 1
let g:NERDTreeShowHidden = 1

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
let g:openbrowser_format_message = ''
if has('macunix')
    let g:openbrowser_browser_commands = [{
        \ 'name': 'open',
        \ 'args': ['{browser}', '-g', '{uri}']
        \ }]
endif

let g:LargeFile = 50

let g:targets_aiAI = 'ai  '
let g:wordmotion_prefix = '<leader>'
let g:asterisk#keeppos = 1

let g:zipPlugin_ext = '*.zip'

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
if has('multi_byte')
    let g:airline_symbols.branch = "\u2387 "
    let g:airline_left_sep = "\u25b6"
    let g:airline_right_sep = "\u25c0"
endif
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

" Move search direction consistent.
noremap <expr> n 'Nn'[v:searchforward].'zv'
noremap <expr> N 'nN'[v:searchforward].'zv'

map *  <Plug>(asterisk-z*)zv
map #  <Plug>(asterisk-z#)zv
map g* <Plug>(asterisk-gz*)zv
map g# <Plug>(asterisk-gz#)zv

" Make it easier to navigate displayed lines when lines wrap.
noremap <expr> j v:count ? 'j' : 'gj'
noremap <expr> k v:count ? 'k' : 'gk'
noremap <expr> gj v:count ? 'gj' : 'j'
noremap <expr> gk v:count ? 'gk' : 'k'
inoremap <down> <c-o>gj
inoremap <up> <c-o>gk

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

" Redraw screen after updating highlighting.
nnoremap <silent> <c-l> :nohlsearch <bar> :setlocal list! <bar>
    \ :silent <c-r>=has('diff') ? '<bar> diffupdate' : ''<cr> <bar>
    \ :normal! <c-l><cr>
imap <c-l> <c-o><c-l>
xmap <c-l> <esc><c-l>gv
smap <c-l> <esc><c-l>gv<c-g>

" Make repeat command operate on visually selected lines.
xnoremap <silent> . :normal .<cr>

" Return to visual mode after indenting.
xnoremap < <gv
xnoremap > >gv

" Select last pasted text.
nnoremap gV `[v`]

" Paragraph formatting.
nnoremap Q gqap
xnoremap Q gq

" Avoid accidentally calling up the command history.
nnoremap q: <nop>

" Avoid accidentally deleting selection when using NerdCommenter mappings.
xnoremap <leader>c <nop>

" Toggle various plugins.
nnoremap <silent> <leader>fb :CtrlPBuffer<cr>
nnoremap <silent> <leader>fr :CtrlPMRU<cr>
nnoremap <silent> <leader>fv :CtrlPRTS<cr>
nnoremap <silent> <leader>nt :NERDTreeToggle<cr>
nnoremap <silent> <leader>tb :TagbarToggle<cr>
nnoremap <silent> <leader>ut :UndotreeToggle<cr>
nnoremap <silent> <leader>hw :Histwin<cr>
nnoremap <silent> <leader>ss :SplitjoinSplit<cr>
nnoremap <silent> <leader>sj :SplitjoinJoin<cr>

nmap gx <plug>(openbrowser-open)
xmap gx <plug>(openbrowser-open)gv


" Autocommands ------------------------------------------------------------{{{1

if has('autocmd')
    augroup vimrc
    autocmd!

    " GUI startup resets the visual bell terminal code; disable it again.
    if ! exists('+belloff')
        autocmd GUIEnter * set t_vb=
    endif

    autocmd GUIEnter,ColorScheme * call s:AdjustColorScheme()
    autocmd ColorScheme,Syntax * runtime after/syntax/syncolor.vim

    " Disable undo files for tmp directories.
    if has('persistent_undo')
        autocmd BufNewFile,BufRead /tmp/*,/var/tmp/* setlocal noundofile
        if ! empty($TMPDIR)
            autocmd BufNewFile,BufRead $TMPDIR/* setlocal noundofile
        endif
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
        autocmd FileType *
            \ if ! empty(&omnifunc) && ! exists('*'.&omnifunc) |
            \     silent! runtime autoload/<amatch>complete.vim |
            \ endif |
            \ if empty(&omnifunc) || ! exists('*'.&omnifunc) |
            \     setlocal omnifunc=syntaxcomplete#Complete |
            \ endif
    endif

    " Attempt to set the compiler, if it's not already set.
    autocmd FileType *
        \ if ! empty(&filetype) && ! exists('b:current_compiler') |
        \     silent! execute 'compiler' &filetype |
        \ endif

    if has('folding')
        autocmd BufRead .vimrc setlocal foldmethod=marker
    endif
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
    autocmd BufNewFile,BufRead *.t compiler perlprove

    " Custom filetype mappings are defined in ~/.vim/filetype.vim
    autocmd FileType crontab setlocal backupcopy=yes
    autocmd FileType bzr,cvs,gitcommit,hgcommit,svn
        \ setlocal nolist spell textwidth=72 |
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
        \     '| lynx -stdin -dump -assume_charset=utf-8 -nolist'
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
    autocmd FileType ref nmap <silent> <buffer> <bs> <plug>(ref-back)

    augroup end
endif


" Colors ------------------------------------------------------------------{{{1

if s:ok_termguicolors
    set termguicolors
endif

set background=dark

if has('gui_running') || &t_Co == 256
    colorscheme gentooish
else
    colorscheme jellybeans
endif


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
