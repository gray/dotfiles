" Initialize --------------------------------------------------------------{{{1

set nocompatible  " Explicitly set in case Vim was started with the -u flag

" Adds .vim/bundle/* to runtimepath
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
silent! call pathogen#infect()
silent! call pathogen#helptags()


" Files, Backup -----------------------------------------------------------{{{1

set history=1000    " Size of command/search history
set viminfo='1000   " Save marks for N files
set viminfo+=<1000  " Save N lines for each register
set viminfo+=h      " Disable hlsearch at startup

set cpoptions+=W    " Do not overwrite readonly files
set cpoptions+=>    " Separate register items by line breaks

set modelines=0     " Trust no one

" Switch to the directory of the current file.
if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif

set autoread        " Reload file if externally, but not internally modified
set autowrite       " Write file if modified
set writebackup     " Make a temporary backup file before overwriting
set directory=~/.vim/tmp//
set backupdir=~/.vim/tmp


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
    execute "set t_kb=\<c-h>"
elseif &term =~ '256-\?color'
    set t_Co=256
elseif &term =~ 'xterm'
    set t_Co=8
endif

set encoding=utf-8
if &termencoding == ''
    set termencoding=utf-8
endif
if &termencoding == 'utf-8'
    let &showbreak = nr2char(8618) . ' '
endif

set nowrap            " Don't wrap long lines
set linebreak         " Wrap lines at convenient points
set list              " Visually display tabs and trailing spaces
let &listchars = 'tab:'      . nr2char(187) . nr2char(183) . ',' .
               \ 'trail:'    . nr2char(183) . ',' .
               \ 'extends:'  . nr2char(187) . ',' .
               \ 'precedes:' . nr2char(171)

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
set nostartofline    " Keep the cursor in the same column


" Text-Formatting, Identing, Tabbing --------------------------------------{{{1

if ! &diff && has('eval')
    filetype plugin on
    filetype indent on
endif

set textwidth=76
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

" Extended matching with '%'
runtime macros/matchit.vim

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
set wildignore+=*~,*.swo,*.swp
set wildignore+=*.a,*.class,*.la,*.mo,*.o,*.obj,*.pyc,*.pyo,*.so
set wildignore+=*.gif,*.jpg,*.png
set wildignore+=CVS,SVN,.bzr,.git,.hg

set tags=tags;/  " Search for a ctags file
set showfulltag


" Buffers, Windows, Tabs --------------------------------------------------{{{1

set hidden                    " Allow edit buffers to be hidden
set switchbuf=useopen,usetab  " Jump to first open window or tab with buffer

set clipboard+=unnamed " Use system clipboard

set mouse=a            " Enable the mouse for all modes
set mousehide          " Hide mouse while typing
set mousemodel=popup   " Use popup menu for right mouse button

set noequalalways      " Don't resize windows to the same size
set splitright         " When splitting vertically, split to the right
set splitbelow         " When splitting horizontally, split below

set tabpagemax=128     " Maximum number of tabs open


" Syntax Highlighting -----------------------------------------------------{{{1

" NOTE: enabling syntax clears any pre-existing Syntax autocommands.
if ! &diff && has('syntax')
    syntax enable

    if exists('+colorcolumn')
        set colorcolumn=80
    endif
endif

" For sh syntax; most shells are POSIX-compliant.
let g:is_posix = 1


" Functions ---------------------------------------------------------------{{{1

" Search with * or # for current visual selection.
function! s:VisualSearch (direction) range
    let l:saved_reg = @"
    execute 'normal! vgvy'
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, '\n$', '', '')
    execute 'normal ' . ('b' == a:direction ? '?' : '/') . l:pattern
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Must pass the line numbers as arguments instead of using a range because
" calling this function from a ranged-command triggers a bug that resets
" the cursor position to 1,1 before the function is called; so the cursor
" position could not be restored.
function! s:StripWhitespace (line1, line2)
    let l:orig_pos = getpos('.')
    let l:orig_search = @/
    execute 'silent! keepjumps ' . a:line1 . ',' . a:line2 . 's/\s\+$//e'
    call setpos('.', l:orig_pos)
    let @/ = l:orig_search
endfunction

function! GetCurrentSyntax ()
    return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

function! s:AdjustColorScheme ()
    highlight Search cterm=NONE ctermfg=yellow ctermbg=blue
    highlight Search gui=NONE guifg=yellow guibg=blue
    highlight CursorLine term=reverse cterm=reverse gui=reverse
    highlight CursorColumn term=reverse cterm=reverse gui=reverse
    highlight SpellBad ctermbg=red ctermfg=white guibg=red guifg=white

    let l:bg = synIDattr(hlID('Normal'), 'bg#')
    if l:bg == '' || l:bg == -1
        return
    endif

    if has('gui_running')
        let l:r = str2nr(l:bg[1:2], 16)
        let l:g = str2nr(l:bg[3:4], 16)
        let l:b = str2nr(l:bg[5:6], 16)
        let l:light = sqrt(0.241 * l:r*l:r + 0.691 * l:g*l:g + 0.068 * l:b*l:b)
        let l:bg_is_dark = l:light < 130
    else
        let l:dark_range = range(7) + [8] + range(16, 32) + range(52, 67)
            \ + range(88, 99) + range(124, 134) + range(160, 165)
            \ + [196, 197] + range(232, 244)
        let l:bg_is_dark = index(l:dark_range, str2nr(l:bg)) >= 0

        " Vim resets the background to light if a colorscheme sets the
        " Normal group's ctermbg to a value greater than 8.
        if &t_Co == 256 && l:bg_is_dark
            set background=dark
        endif
    endif
    if l:bg_is_dark
        " All dark backgrounds should be black.
        highlight Normal ctermbg=black guibg=black
    endif
endfunction

function! s:ExtendSyntaxHighlighting ()
    syntax keyword myTodo containedin=.*Comment,perlPOD contained
        \ BUG FIXME HACK NOTE README TBD TODO WARNING XXX
    highlight default link myTodo Todo
endfunction


" Commands ----------------------------------------------------------------{{{1

" Show unsaved changes to current buffer
" TODO: if window size can be changed, double it and make new window vertical,
"     else make new window horizontal.
command! DiffBuff vertical new | let t:diff_bufnr = bufnr('$') |
    \ setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile filetype= |
    \ r # | 0d_ | diffthis | wincmd p | diffthis |
    \ if exists('b:current_syntax') | let b:orig_syntax = b:current_syntax |
    \ endif | syntax clear

" Close DiffBuff's diff window and reset syntax
command! DiffOff execute 'bwipeout ' . t:diff_bufnr | diffoff |
    \ if exists('b:orig_syntax') | let &l:syntax = b:orig_syntax | endif

command! -range=% -bar StripWhitespace call s:StripWhitespace(<line1>, <line2>)


" Plugin Settings ---------------------------------------------------------{{{1

let g:yankring_history_dir = '~/.vim/tmp'

let delimitMate_expand_cr = 1
" let delimitMate_smart_matchpairs = '^\%([^\s\!\#]\)'

let g:SuperTabCrMapping = 0
let g:SuperTabLeadingSpaceCompletion = 0
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
    \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

let g:NERDSpaceDelims = 1
let g:NERDTreeShowHidden = 1

let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Show_One_File = 1
let Tlist_Auto_Highlight_Tag = 1
let Tlist_Auto_Update = 1
let Tlist_Highlight_Tag_On_BufEnter = 1
let tlist_make_settings = 'make;t:targets;m:macros'
let tlist_perl_settings = 'perl;p:packages;c:constants;l:labels;s:subroutines'
let tlist_xs_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;' .
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

let g:netrw_dirhistmax = 0

let g:manpageview_winopen = 'hsplit='
let g:manpageview_pgm_pl = 'cpandoc'
let g:manpageview_options_pl = ';-f;-q'

let g:LargeFile = 50


" Mappings ----------------------------------------------------------------{{{1

let maplocalleader = ','
let mapleader = ','

inoremap jj <esc>

" Use ,, to work around , as leader
noremap ,, ,

nnoremap <f1> :set invpaste paste?<cr>
inoremap <f1> <c-o>:set invpaste paste?<cr>
set pastetoggle=<f1>

" Save current buffer with root permissions.
cnoremap <silent> w!! write !sudo tee % >/dev/null<cr>:edit!<cr><cr><cr>

" Insert a single character.
noremap <localleader>i i<space><esc>r

" Preserve undo history.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Position search matches in the middle of the screen and open any
" containing folds.
noremap n nzvzz
noremap N Nzvzz
noremap * *zvzz
noremap # #zvzz
noremap g* g*zvzz
noremap g# g#zvzz

" Make it easier to navigate displayed lines when lines wrap
inoremap <down> <c-o>gj
inoremap <up> <c-o>gk
noremap j  gj
noremap k  gk
noremap gj j
noremap gk k

" Saner paging behaviour.
noremap <silent> <space> <c-d><c-d>
noremap <silent> - <c-u><c-u>
noremap <silent> <pagedown> <c-d><c-d>
noremap <silent> <pageup> <c-u><c-u>
inoremap <silent> <pagedown> <c-\><c-o><c-d><c-\><c-o><c-d>
inoremap <silent> <pageup> <c-\><c-o><c-u><c-\><c-o><c-u>

" Maximize current window (width and height)
nmap <silent> <localleader>mw <c-w>_<c-w><bar>

cnoremap <c-a> <home>
inoremap <c-a> <home>
inoremap <c-f> <right>
inoremap <c-b> <left>

map <localleader>tn :tabnew %<cr>
map <localleader>tc :tabclose<cr>
map <localleader>tm :tabmove

" Buffer navigation
nmap gn :bnext<cr>
nmap gp :bprev<cr>

" Quickfix navigation
nmap gN :cnext<cr>
nmap gP :cprev<cr>

" Redraw screen, remove search highlighting, sync syntax, show list.
nnoremap <c-l> <esc>:nohlsearch<cr>:syntax sync fromstart<cr>:setlocal list!<cr><c-l>
inoremap <c-l> <esc>:nohlsearch<cr>:syntax sync fromstart<cr>:setlocal list!<cr><c-l>a

function! YRRunAfterMaps()
    " Yank to end of line
    nnoremap <silent> Y :<c-u>YRYankCount 'y$'<cr>
endfunction

" Return to visual mode after indenting
vnoremap < <gv
vnoremap > >gv

" Select last pasted text
nnoremap gV `[v`]

" Paragraph formatting
nnoremap Q gqap
vnoremap Q gq

" Avoid accidentally calling up the command history
nnoremap q: <silent>

" Toggle various plugins
noremap <silent> <localleader>nt :NERDTreeToggle<cr>
noremap <silent> <localleader>tl :TlistToggle<cr>
noremap <silent> <localleader>tb :TagbarToggle<cr>
noremap <localleader>fff :FufFile<cr>
noremap <localleader>ffb :FufBookmark<cr>
noremap <localleader>ffa :FufAddBookmark<cr>
noremap <localleader>ffd :FufDir<cr>
noremap <localleader>ffm :FufMruFile<cr>
noremap <localleader>fft :FufTag<cr>

" Zoom in on the current window
nmap <localleader>z <plug>ZoomWin

" cnoremap <silent> <tab> <c-\>esherlock#completeForward()<cr>

vnoremap <silent> * :call s:VisualSearch('f')<cr>
vnoremap <silent> # :call s:VisualSearch('b')<cr>


" Autocommands ------------------------------------------------------------{{{1

if has('autocmd')
    augroup vimrc
    autocmd!

    " GUI startup resets the visual bell; turn it back off
    autocmd GUIEnter * set visualbell t_vb=

    autocmd GUIEnter,ColorScheme * call s:AdjustColorScheme()
    autocmd Syntax * call s:ExtendSyntaxHighlighting()

    " Restore the cursor position.
    autocmd BufRead *
        \ if ! &diff && line("'\"") > 0 && line("'\"") <= line('$') |
        \     execute 'normal! g`"' |
        \     let b:restored_pos = 1 |
        \ endif
    " Reset the cursor position for commit messages.
    autocmd BufEnter *
        \ if index(['gitcommit', 'svn', 'bzr'], &filetype) >= 0 |
        \     call cursor(1, 1) |
        \ endif
    " Open any containing folds when restoring cursor position.
    autocmd BufWinEnter *
        \ if exists('b:restored_pos') |
        \     execute 'normal! zv' |
        \     unlet b:restored_pos |
        \ endif

    " Make new scripts executable
    autocmd BufNewFile * let b:isa_new = 1
    autocmd BufWritePost,FileWritePost *
        \ if exists('b:isa_new') |
        \     unlet b:isa_new |
        \     if getline(1) =~ '^#!.*/bin/' |
        \          silent! execute '!chmod +x <afile>' |
        \     endif |
        \ endif

    " Turn off highlighting when idle.
    autocmd CursorHold * nohlsearch | redraw

    " Set 'updatetime' to 15 seconds when in insert mode.
    autocmd InsertEnter * let b:orig_updatetime = &l:updatetime |
        \ setlocal updatetime=15000
    autocmd InsertLeave * let &l:updatetime = b:orig_updatetime

    " Disable fold detection while in insert mode.
    autocmd InsertEnter *
        \ if ! exists('w:saved_foldmethod') |
        \     let w:saved_foldmethod = &foldmethod |
        \     setlocal foldmethod=manual |
        \ endif
    autocmd InsertLeave,WinLeave *
        \ if exists('w:saved_foldmethod') |
        \     let &l:foldmethod = w:saved_foldmethod |
        \     unlet w:saved_foldmethod |
        \ endif

    " Turn off insert mode when idle.
    autocmd CursorHoldI * stopinsert

    " Make the cursor easier to find when idle.
    autocmd CursorHold * setlocal cursorline cursorcolumn
    autocmd CursorMoved,InsertEnter *
        \ if &l:cursorline | setlocal nocursorline nocursorcolumn | endif

    " Automatically unset paste mode
    autocmd InsertLeave * setlocal nopaste

    autocmd BufRead .vimrc setlocal foldmethod=marker
    autocmd BufNewFile,BufRead *.t compiler perlprove

    " Custom filetype mappings are defined in ~/.vim/filetype.vim
    autocmd FileType apache setlocal shiftwidth=2 softtabstop=2
    autocmd FileType bdb1_hash
        \ setlocal readonly nolist |
        \ silent %!perl -MDB_File -e 'tie \%db, DB_File => shift, O_RDONLY;
        \     while (($k, $v) = each \%db) { print "$k | $v\n" }' '%'
    autocmd FileType crontab setlocal backupcopy=yes
    autocmd FileType epub,pdf,ps setlocal readonly filetype=text
    autocmd FileType epub silent %!einfo -q -p '%'
        \ | lynx -stdin -dump -force_html -display_charset=utf-8 -nolist
    autocmd FileType gitcommit,svn,bzr setlocal nobackup nolist spell wrap
    autocmd FileType help setlocal wrap nonumber keywordprg=:help
    autocmd FileType html
        \ setlocal equalprg=tidy\ -q\ -i\ --wrap\ 78\ --indent-spaces\ 4
    autocmd FileType javascript setlocal equalprg=js_beautify.pl\ -
    autocmd FileType make setlocal nosmarttab nolist
    autocmd FileType nfo edit ++enc=cp437 | setlocal nolist
    autocmd FileType pdf silent %!pdftotext -q -nopgbrk '%' - | fmt -sw78
    autocmd FileType ps silent %!ps2ascii '%' | fmt -sw78
    autocmd FileType puppet setlocal shiftwidth=2 softtabstop=2
    autocmd FileType qf setlocal nobuflisted wrap number
    autocmd FileType sqlite
        \ setlocal readonly nolist | silent %!sqlite3 '%' .dump
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType xml
        \ setlocal equalprg=tidy\ -q\ -i\ -xml\ --wrap\ 78\ --indent-spaces\ 4
        \     matchpairs+=<:>
    autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2

    " Use syntax highlighting keywords for keyword completion
    "if exists('+omnifunc')
    "    autocmd Filetype *
    "        \ if &omnifunc == '' |
    "        \     setlocal omnifunc=syntaxcomplete#Complete |
    "        \ endif
    "endif

    augroup end
endif


" Colors ------------------------------------------------------------------{{{1

set background=dark

let g:solarized_termtrans = 1
let g:solarized_termcolors = 256

if has('gui_running') || &t_Co == 256
    colorscheme gentooish
else
    colorscheme ir_black
    highlight! link NonText SpecialKey
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
        set guifont=Monaco:h10.00
        set noantialias
        set transparency=10
    elseif has('gui_gtk')
        set guifont=Monaco\ 9
    endif

    " Terminal is not fully functional.
    let $PAGER = 'sh -c "col -b -x | more"'
    let $PERLDOC_PAGER = 'sh -c "col -b -x | more" <'
endif
