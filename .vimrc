" Initialize --------------------------------------------------------------{{{1

set nocompatible  " Explicitly set in case Vim was started with the -u flag

" Adds .vim/bundle/* to runtimepath.
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()


" Security ----------------------------------------------------------------{{{1

" Discourage editing by superuser; enable minimal features.
if exists('$SUDO_USER')
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


" Terminal ----------------------------------------------------------------{{{1

if &term =~ '256-\?color'
    set t_Co=256
elseif &term == 'xterm-color'
    set t_Co=16
elseif &term =~ 'xterm'
    set t_Co=8
endif

function! s:IsMosh ()
    if ! exists('$SSH_CLIENT') | return | endif
    let l:parents = {}
    " ps is a standard utility and POSIX compliant.
    for l:line in split(system('ps -Ao pid=,ppid=,comm='), '\n')
        let l:fields = split(line, ' \+')
        let l:parents[l:fields[0]]= [l:fields[1], join(l:fields[2:-1], ' ')]
    endfor
    if v:shell_error || ! len(l:parents) | return | endif
    let l:pid = getpid()
    while 1 < l:pid
        let l:parent = l:parents[l:pid]
        if l:parent[-1] =~# 'mosh-server' | return 1 | endif
        let l:pid = l:parent[0]
    endwhile
    return
endfunction

let s:ok_termguicolors = has('termguicolors') && &t_Co == 256
if s:ok_termguicolors
    if s:IsMosh() && ! exists('$TMUX')
        let s:ok_termguicolors = 0
    elseif $TERM_PROGRAM ==# 'iTerm.app'
        if ! exists('$TERM_PROGRAM_VERSION') | let s:ok_termguicolors = 0 | endif
    elseif $TERM_PROGRAM ==# 'Apple_Terminal' || ! exists('$SSH_CLIENT')
        if ! exists('$TMUX') | let s:ok_termguicolors = 0 | endif
    endif
endif
if s:ok_termguicolors
    let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
endif


" Display -----------------------------------------------------------------{{{1

set lazyredraw         " Don't redraw while executing macros
set ttimeoutlen=50     " Reduce delay for key codes
if exists('+belloff')
    set belloff=all    " Disable all bell notifications
else
    set noerrorbells   " Disable bell notifications for errors
    set visualbell     " Enable visual bell
    set t_vb=          " Make visual bell invisible
endif

if has('multi_byte')
    if empty(&termencoding)
        let &termencoding = &encoding
    endif
    set encoding=utf-8
endif

if has('title')
    set title          " Set descriptive window/terminal title
endif
set display=lastline   " Show as much of the last line as possible
set nowrap             " Don't wrap long lines
if has('folding')
    set nofoldenable
    set foldclose=all  " Close all folds not under the cursor
endif
if has('linebreak')
    set numberwidth=1  " Minimize line number column
    let &showbreak = has('multi_byte') ? "\u21b3 " : "\ubb "
endif
if exists('+breakindent')
    set breakindent    " Visually indent wrapped lines
endif
set list               " Visually display tabs and trailing spaces
let &listchars = has('multi_byte')
    \ ? "tab:\u27a4\u22ef,trail:\ub7,extends:\ubb,precedes:\uab"
    \ : "tab:\ubb\ub7,trail:\ub7,extends:\ubb,precedes:\uab"


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


" Text-Formatting, Indenting, Tabbing -------------------------------------{{{1

if has('autocmd')
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

let g:vim_indent_cont = &shiftwidth


" Matching, Searching, Substituting ---------------------------------------{{{1

set showmatch        " Show matching bracket
set matchtime=2      " Display for only 0.2 seconds

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

set hidden                  " Allow edit buffers to be hidden
set switchbuf+=useopen      " Jump to first open window with buffer
set switchbuf+=usetab       " Check other tabs for the buffer

if has('clipboard') && ! exists('$SSH_CLIENT')
    set clipboard^=unnamed  " Use system clipboard
endif

if has('mouse')
    set mouse=a             " Enable the mouse for all modes
    set mousehide           " Hide mouse while typing
    set mousemodel=popup    " Use popup menu for right mouse button
endif

set noequalalways           " Don't resize windows to the same size
if has('vertsplit')
    set splitright          " When splitting vertically, split to the right
endif
if has('windows')
    set splitbelow          " When splitting horizontally, split below
    set tabpagemax=128      " Maximum number of tabs open
endif


" Syntax Highlighting -----------------------------------------------------{{{1

" NOTE: enabling syntax clears any pre-existing Syntax autocommands.
let s:ok_syntax = has('syntax') && ! exists('g:syntax_on')
    \ && (&t_Co > 2 || has('gui_running'))
if s:ok_syntax
    syntax enable
endif

let g:is_posix = 1
let g:perl_fold = 1

" Functions ---------------------------------------------------------------{{{1

" Calling a function from a ranged-command triggers a bug that resets the
" cursor position to 1,1 before the function is called. To avoid this, pass in
" the line numbers as arguments instead of using a range.
function! s:StripWhitespace (line1, line2)
    let l:saved_pos = getpos('.')
    let l:saved_search = @/
    silent! execute 'keepjumps' a:line1 . ',' . a:line2 . 's/\s\+$//e'
    call setpos('.', l:saved_pos)
    let @/ = l:saved_search
endfunction

function! s:AdjustColorScheme ()
    " Set termguicolors only if the colorscheme supports gui colors.
    let l:ok_guicolors = ! empty(synIDattr(hlID('Normal'), 'fg#', 'gui'))
    let &termguicolors = s:ok_termguicolors && l:ok_guicolors

    " If the background color is dark, set it to black for higher contrast.
    " TODO: also force the background of comments, strings, etc.
    let l:bg = synIDattr(hlID('Normal'), 'bg#')
    if empty(l:bg) || l:bg == -1 | return | endif
    if has('gui_running') || l:ok_guicolors && s:ok_termguicolors
        let [l:r, l:g, l:b] = map([1,3,5], 'str2nr(l:bg[v:val : 1+v:val], 16)')
        if ! max([l:r, l:g, l:b]) | return | endif
        " Calculate the perceived brightness.
        let l:light = sqrt(0.241 * l:r*l:r + 0.691 * l:g*l:g + 0.068 * l:b*l:b)
        let l:dark = l:light < 130 ? 1 : 0
    else
        if ! l:bg || l:bg == 16 | return | endif
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

if executable('rg')
    let [&grepprg, g:ackprg] =
        \ repeat(['rg --vimgrep --hidden --smart-case --no-heading '], 2)
    set grepformat=%f:%l:%c:%m
    let g:ctrlp_user_command = 'rg --files --hidden %s'
    let g:ctrlp_use_caching = 0
elseif executable('ag')
    let [&grepprg, g:ackprg] = repeat(['ag --vimgrep --hidden'], 2)
    set grepformat=%f:%l:%c:%m
    let g:ctrlp_user_command = 'ag -g "" --hidden %s'
    let g:ctrlp_use_caching = 0
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

let g:netrw_errorlvl = 2
let g:netrw_use_errorwindow = 0
let g:netrw_silent = 1
if has('macunix')
    let g:netrw_browsex_viewer = 'open -g'
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

let g:go_version_warning = 0


" Mappings ----------------------------------------------------------------{{{1

let mapleader = ','
let maplocalleader = ','

inoremap jj <esc>l

" Use ,, to work around , as leader.
noremap ,, ,

" Save current buffer with root permissions.
cnoreabbrev <expr> w!! getcmdtype() == ':' && getcmdpos() == 4 && v:char == "\r"
    \ ? 'SudoWrite' : 'w!!'

" Insert a single character.
noremap <leader>i i<space><esc>r

" Make this consistent with C and D operators.
nnoremap Y y$

" Preserve undo history.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-@> <c-g>u<c-@>
inoremap <c-a> <c-g>u<c-a>
inoremap <c-w> <c-g>u<c-w>

" Make search direction consistent.
noremap <expr> n 'Nn'[v:searchforward].'zv'
noremap <expr> N 'nN'[v:searchforward].'zv'

map * <plug>(asterisk-z*)zv
map # <plug>(asterisk-z#)zv
map g* <plug>(asterisk-gz*)zv
map g# <plug>(asterisk-gz#)zv

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
nnoremap <silent> <c-l> :nohlsearch <bar>
    \ :silent <c-r>=has('diff') ? '<bar> diffupdate' : ''<cr> <bar>
    \ :normal! <c-l><cr>
imap <c-l> <c-o><c-l>
xmap <c-l> <esc><c-l>gv
smap <c-l> <esc><c-l>gv<c-g>

" Make repeat command operate on visually selected lines.
xnoremap <silent> . :normal .<cr>

" The default commands don't trigger the OptionSet event for &foldenable
if exists('##OptionSet')
    nnoremap zn :set nofoldenable<cr>
    nnoremap zN :set foldenable<cr>
    nnoremap zi :set invfoldenable<cr>
endif

" Return to visual mode after indenting.
xnoremap < <gv
xnoremap > >gv

" Select last pasted text.
nnoremap <expr> gV '`[' . getregtype()[0] . '`]'

" Avoid accidentally calling up the command history.
nnoremap q: <nop>

" Paragraph formatting.
nnoremap Q gwap
xnoremap Q gw

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
        for s:dir in ['/tmp', '/var/tmp', $TMPDIR]
            if ! empty(s:dir)
                execute 'autocmd BufNewFile,BufRead' resolve(s:dir).'/*'
                    \ 'setlocal noundofile'
            endif
        endfor
    endif

    " Restore the cursor position.
    autocmd BufRead *
        \ if line("'\"") > 0 && line("'\"") <= line('$') && ! exists('b:no_viminfo') |
        \     execute 'normal! g`"zz' |
        \ endif

    " Create the parent directory if it does not already exist.
    autocmd BufWritePre,FileWritePre *
        \ if ! isdirectory(expand('<afile>:p:h')) |
        \     silent! call mkdir(fnameescape(expand('<afile>:p:h')), 'p') |
        \ endif

    " Prevent the current line from shifting screen position when a hidden
    " buffer is displayed again.
    autocmd BufHidden * let b:saved_winview = winsaveview()
    autocmd BufWinEnter *
        \ if exists('b:saved_winview') |
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

    " Avoid inserting anything when an unmapped function key is pressed.
    autocmd VimEnter *
        \ for s:n in range(1, 12) |
        \     silent! execute 'map! <f' . s:n . '> <nop>' |
        \ endfor

    " Work around an old bug in scripts.vim which resets 'cpoptions' after the
    " ftplugin has made changes to it.
    if ! has('patch-8.2.4372')
        autocmd BufEnter *
            \ redir => s:vft | silent verbose set filetype? | redir END |
            \ if exists('b:did_ftplugin') && s:vft =~# '/scripts.vim line \d\+$' |
            \     let &filetype = &filetype |
            \ endif
    endif

    " Only highlight nonAscii when `list` option is set.
    if has('syntax')
        autocmd VimEnter,BufNewFile,BufRead *
            \ if &list |
            \     syntax match nonAscii '[^\t -~]\+' containedin=ALL |
            \ endif
        if exists('##OptionSet')
            autocmd OptionSet list
                \ if v:option_new && ! v:option_old |
                \     syntax match nonAscii '[^\t -~]\+' containedin=ALL |
                \ elseif ! v:option_new && v:option_old |
                \     silent! syntax clear nonAscii |
                \ endif
        endif
    endif

    if has('folding') && exists('##OptionSet')
        autocmd OptionSet foldenable
            \ if v:option_new != v:option_old |
            \     set foldenable? |
            \ endif |
            \ if v:option_new && ! v:option_old |
            \     execute 'normal! zv' |
            \ endif
    endif

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

    " Custom filetype mappings are defined in ~/.vim/filetype.vim
    autocmd FileType crontab setlocal backupcopy=yes
    autocmd FileType bzr,cvs,gitcommit,hgcommit,svn
        \ setlocal nolist spell textwidth=72 |
        \ if has('persistent_undo') | setlocal noundofile | endif |
        \ let b:no_viminfo = 1
    autocmd FileType go setlocal shiftwidth=0 nolist
    autocmd FileType html
        \ let &l:formatprg = 'tidy -qi -xml --wrap ' . &textwidth
        \     . ' --indent-spaces ' . &shiftwidth
    autocmd FileType javascript setlocal formatprg=js_beautify.pl\ -
    autocmd FileType json let &l:formatprg = 'jq --indent ' . &shiftwidth . ' .'
    autocmd FileType make setlocal shiftwidth=0 nolist
    autocmd FileType man setlocal nolist
    autocmd FileType nfo noautocmd edit ++encoding=cp437 | setlocal nolist
    autocmd FileType puppet setlocal shiftwidth=2 softtabstop=2
    autocmd FileType qf setlocal nobuflisted wrap number
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType xml setlocal matchpairs+=<:> |
        \ let &l:formatprg = 'tidy -qi -xml -utf8 --wrap ' . &textwidth
        \     . ' --indent-spaces ' . &shiftwidth
    autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2

    autocmd FileType bdb1_hash,epub,postscr,sqlite
        \ setlocal readonly nolist wrap filetype=text | let b:no_viminfo = 1
    autocmd FileType bdb1_hash
        \ silent! execute '%!perl -MDB_File -e ''tie \%db, DB_File => shift,'
        \    'O_RDONLY; while (($k, $v) = each \%db){ print "$k | $v\n" }'''
        \    shellescape(expand('<afile>'), 1)
    autocmd FileType epub
        \ silent! execute '%!einfo -q -p' shellescape(expand('<afile>'), 1)
        \     '| lynx -stdin -dump -assume_charset=utf-8 -nolist | par w'
        \     . &textwidth
    autocmd FileType postscr
        \ silent! execute '%!ps2ascii' shellescape(expand('<afile>'), 1)
        \     '| par w' . &textwidth
    autocmd FileType sqlite
        \ silent! execute '%!sqlite3' shellescape(expand('<afile>'), 1) '.dump'
    autocmd FileType bdb1_hash,epub,postscr,sqlite setlocal nomodifiable

    " Preview window for ref plugin.
    autocmd FileType ref setlocal nolist |
        \ nmap <silent> <buffer> <bs> <plug>(ref-back)

    autocmd BufRead ~/.flexget/*.yml setlocal makeprg=flexget\ check
        \ errorformat=0

    augroup end
endif


" Colors ------------------------------------------------------------------{{{1

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
