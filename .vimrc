" Files, Backup -----------------------------------------------------------{{{1

set history=1000    " Size of command/search history
set viminfo='1000   " Save marks for N files
set viminfo+=<1000  " Save N lines for each register
set viminfo+=h      " Disable hlsearch at startup

set cpoptions+=W    " Do not overwrite readonly files
set cpoptions+=>    " Separate register items by line breaks

set modelines=0     " Trust no one

set autochdir       " Switch to the directory of the current file.
set autoread        " Reload file if externally, but not internally modified
set autowrite       " Write file if modified
set writebackup     " Make a temporary backup file before overwriting
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp


" Display, Messages, Terminal ---------------------------------------------{{{1

set numberwidth=1     " Make line number column as narrow as possible
set lazyredraw        " Don't redraw while executing macros
set ttyfast           " Indicates a fast terminal connection
set title             " Set descriptive window/terminal title
set report=1          " Always report the number of lines changed
set display=lastline  " Show as much of the last line as possible

set noerrorbells      " Error bells are annoying
set visualbell t_vb=  " No visual bell

set printoptions=paper:letter

set shortmess=a       " Use abbreviated messages
set shortmess+=T      " Truncate messages in the middle if too long
set shortmess+=I      " Disable intro message
set shortmess+=t      " Truncate filename at start if too long
set shortmess+=o      " Do not prompt to overwrite file
set shortmess+=O      " Message for reading file overwrites previous

if $TERM_PROGRAM == "iTerm.app"
    " Fixes arrow keys
    set term=linux
    set t_Co=256
elseif &term =~ "xterm"
    set t_Co=16
endif

set encoding=utf-8
if &termencoding == ""
    set termencoding=utf-8
endif
if &termencoding == "utf-8"
    let &showbreak = nr2char(8618) . " "
endif

set nowrap            " Don't wrap long lines
set linebreak         " Wrap lines at convenient points
set list              " Visually display tabs and trailing spaces
let &listchars = "tab:".nr2char(187).nr2char(183).",trail:".nr2char(183)

set ttimeoutlen=50    " Reduce delay for key codes


" Statusline, Messages ----------------------------------------------------{{{1

set showcmd       " Display the command in the last line
set showmode      " Display the current mode in the last line
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

if has("eval")
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

set formatoptions-=t  " Don't auto-wrap text
set formatoptions+=c  " Auto-wrap comments
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=o  " Insert comment leader after o/O
set formatoptions+=r  " Insert comment leader after <cr> in insert mode.
set formatoptions+=q  " Allow formatting of comments with 'gq'
set formatoptions+=1  " Break a line before, not after, a one-letter word

set foldclose=all     " Close folds at startup


" Matching, Searching, Substituting ---------------------------------------{{{1

set incsearch        " Show search matches as you type
set ignorecase       " Ignore case when searching
set smartcase        " Override 'ignorecase' when needed
set hlsearch         " Highlight search results
set showmatch        " Show matching bracket
set matchtime=2      " (for only .2 seconds)

" Extended matching with '%'
runtime macros/matchit.vim


" Menus, Completion -------------------------------------------------------{{{1

set complete+=k            " Use dictionary files for completion
set completeopt=longest    " Insert longest completion match
set completeopt+=menu      " Use popup menu with completions
set completeopt+=menuone   " Show popup even with one match
"set completeopt=menu,preview,longest,menuone
set infercase              " Try to adjust insert completions for case

set wildmenu               " Enable wildmenu for completion
set wildmode=longest       " Complete longest common string,
set wildmode+=list,full    " list alternatives, then each full match
set wildignore=*~,*.swp,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.jpg,*.png,*.gif
set wildignore+=CVS,SVN,.git,.bzr,.hg

set tags=tags;/  " Search for a ctags file
set showfulltag


" Highlighting, Colors ----------------------------------------------------{{{1

if has("syntax") && !&diff
    syntax on
endif

set background=dark
let g:inkpot_black_background = 1

colorscheme ir_black


" Buffers, Windows, Tabs --------------------------------------------------{{{1

set hidden             " Allow edit buffers to be hidden

set mouse=a            " Enable the mouse for all modes
set mousehide          " Hide mouse while typing
set mousemodel=popup   " Use popup menu for right mouse button

set noequalalways      " Don't resize windows to the same size
set splitright         " When splitting vertically, split to the right
set splitbelow         " When splitting horizontally, split below

set tabpagemax=128     " Maximum number of tabs open


" Functions ---------------------------------------------------------------{{{1

command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction
" TODO: change above to use this and then clear
" let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
" let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
" :call matchdelete(w:m1)
" :call matchdelete(w:m2)


" Commands ----------------------------------------------------------------{{{1

" Show unsaved changes to current buffer
" TODO: if window size can be changed, double it and make new window vertical,
"     else make new window horizontal.
command! DiffBuff vertical new | let t:diff_bufnr = bufnr("$") |
    \ setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile filetype= |
    \ r # | 0d_ | diffthis | wincmd p | diffthis |
    \ if exists("b:current_syntax") | let b:orig_syntax = b:current_syntax |
    \ endif | syntax clear

" Close DiffBuff's diff window and reset syntax
command! DiffOff execute "bwipeout " . t:diff_bufnr | diffoff |
    \ if exists("b:orig_syntax") | let &l:syntax = b:orig_syntax | endif


" Plugin Settings ---------------------------------------------------------{{{1

let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplModSelTarget = 1

map <c-w><c-t> :WMToggle<cr>
"let g:SuperTabDefaultCompletionType = "context"
"let g:SuperTabDefaultCompletionTypeDiscovery = [
"    \ "&completefunc:<c-x><c-u>",
"    \ "&omnifunc:<c-x><c-o>", ]

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

let g:netrw_dirhistmax = 0


" Mappings ----------------------------------------------------------------{{{1

let maplocalleader = ","
let mapleader = ","

" Use ,, to work around , as leader
noremap ,, ,

nnoremap <f2> :set invpaste paste?<cr>
imap <f2> <c-o><f2>
set pastetoggle=<f2>

" Save current buffer with root permissions.
cnoremap <silent> w!! %w !sudo tee % > /dev/null

" Insert a single character.
noremap <localleader>i i<space><esc>r

" Preserve undo history.
inoremap <c-u> <c-g>u<c-u>

" Position search matches in the middle of the screen and open any
" containing folds.
noremap n nzzzv
noremap N Nzzzv

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

" Yank to end of line
nnoremap Y y$

" Return to visual mode after indenting
vnoremap < <gv
vnoremap > >gv

inoremap <s-down> <esc>v<down>
inoremap <s-up> <esc>v<up>
nnoremap <s-down> v<down>
nnoremap <s-up> v<up>
vnoremap <s-down> <down>
vnoremap <s-up> <up>

" Select last pasted text
nnoremap <localleader>v `[v`]

" Paragraph formatting
nnoremap Q gqap
vnoremap Q gq

" Avoid accidentally calling up the command history
nnoremap q: <silent>

" Pressing return selects the menu choice
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

" Toggle various plugins
noremap <silent> <localleader>nt :NERDTreeToggle<cr>
noremap <silent> <localleader>tl :TlistToggle<cr>
noremap <localleader>fff :FuzzyFinderFile<cr>
noremap <localleader>ffb :FuzzyFinderBookmark<cr>
noremap <localleader>ffa :FuzzyFinderAddBookmark<cr>
noremap <localleader>ffd :FuzzyFinderDir<cr>
noremap <localleader>ffm :FuzzyFinderMruFile<cr>
noremap <localleader>fft :FuzzyFinderTag<cr>

" Zoom in on the current window
nmap <localleader>z <plug>ZoomWin

" cnoremap <silent> <tab> <c-\>esherlock#completeForward()<cr>


" Autocommands ------------------------------------------------------------{{{1

if has("autocmd")
    augroup vimrc
    autocmd!

    " GUI startup resets the visual bell; turn it back off
    autocmd GUIEnter * set visualbell t_vb=

    " Restore cursor position.
    autocmd BufReadPost *
        \ if !&diff && line("'\"") > 1 && line("'\"") <= line("$") |
        \     execute "normal! g`\"" |
        \ endif

    " Make new scripts executable
    autocmd BufNewFile * let b:isa_new = 1
    autocmd BufWritePost,FileWritePost *
        \ if exists("b:isa_new") |
        \     unlet b:isa_new |
        \     if getline(1) =~ "^#!.*/bin/" |
        \          silent! execute "!chmod +x <afile>" |
        \     endif |
        \ endif

    " Highlight text approaching and over 80 columns.
    " TODO: only do this if wrap is on
    " TODO: this doesn't work on split windows
    autocmd BufNewFile,BufRead *
        \ let w:m1 = matchadd("MatchParen", '\%<81v.\%>77v', -1) |
        \ let w:m2 = matchadd("ErrorMsg", '\%>80v.\+', -1)

    " Turn off highlighting when idle.
    autocmd CursorHold * nohlsearch | redraw

    " Set 'updatetime' to 15 seconds when in insert mode.
    au InsertEnter * let updaterestore=&updatetime | set updatetime=15000
    au InsertLeave * let &updatetime=updaterestore
    " Turn off insert mode when idle.
    autocmd CursorHoldI * stopinsert

    " Automatically unset paste mode
    autocmd InsertLeave * setlocal nopaste

    autocmd BufRead .vimrc setlocal foldmethod=marker
    autocmd BufNewFile,BufRead *.t compiler perlprove
    autocmd BufRead quickfix setlocal nobuflisted wrap number

    " Custom filetype mapping is defined in ~/.vim/filetype.vim
    autocmd FileType apache,puppet setlocal shiftwidth=2 softtabstop=2
    autocmd FileType help setlocal wrap nonumber keywordprg=:help
    autocmd FileType make setlocal noexpandtab nolist
    autocmd FileType svn setlocal nobackup
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType xml setlocal matchpairs+=<:>

    " Use syntax highlighting keywords for keyword completion
    "if exists("+omnifunc")
    "    autocmd Filetype *
    "        \ if &omnifunc == "" |
    "        \     setlocal omnifunc=syntaxcomplete#Complete |
    "        \ endif
    "endif

    augroup end
endif


" GUI ---------------------------------------------------------------------{{{1

if has("gui_running")
    colorscheme darkdevel

    set lines=40
    set columns=85

    set guioptions-=T  " Hide toolbar
    set guioptions+=a  " Use system clipboard for visual selections
    set guioptions+=e  " Show the tabline
    set guioptions-=m  " Hide menubar

    if has("gui_macvim")
        set guifont=Monaco:h10.00
        set noantialias
        set transparency=10
    elseif has("gui_gtk")
        set guifont=Monaco\ 9
    endif
endif
