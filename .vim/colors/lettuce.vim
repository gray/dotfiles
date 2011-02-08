" Vim color file
"
"     Patched using https://github.com/KevinGoodsell/vim-color-check
"     Further modified by gray.
"
"     Version:    1.2 2007.08.08
"     Author:     Valyaeff Valentin <hhyperr AT gmail DOT com>
"     License:    GPL
"
" Copyright 2007 Valyaeff Valentin
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name='lettuce'

hi Normal       cterm=none ctermbg=232 ctermfg=189 gui=none guibg=#080808 guifg=#dfdfff
hi StatusLineNC cterm=none ctermbg=236 ctermfg=103 gui=none guibg=#303030 guifg=#8787af
hi VertSplit    cterm=none ctermbg=236 ctermfg=103 gui=none guibg=#303030 guifg=#8787af
hi TabLine      cterm=none ctermbg=236 ctermfg=145 gui=none guibg=#303030 guifg=#afafaf
hi TabLineFill  cterm=none ctermbg=236             gui=none guibg=#303030
hi TabLineSel   cterm=none ctermbg=240 ctermfg=253 gui=none guibg=#585858 guifg=#dadada
hi LineNr       cterm=none             ctermfg=238 gui=none               guifg=#444444
hi NonText      cterm=bold ctermbg=233 ctermfg=241 gui=bold guibg=#121212 guifg=#606060
hi Folded       cterm=none ctermbg=234 ctermfg=136 gui=none guibg=#1c1c1c guifg=#af8700
hi FoldColumn   cterm=none ctermbg=236 ctermfg=103 gui=none guibg=#303030 guifg=#8787af
hi SignColumn   cterm=none ctermbg=236 ctermfg=103 gui=none guibg=#303030 guifg=#8787af
hi CursorColumn cterm=none ctermbg=234             gui=none guibg=#1c1c1c
hi CursorLine   cterm=none ctermbg=234             gui=none guibg=#1c1c1c
hi IncSearch    cterm=bold ctermbg=63  ctermfg=232 gui=bold guibg=#5f5fff guifg=#080808
hi Search       cterm=none ctermbg=36  ctermfg=232 gui=none guibg=#00af87 guifg=#080808
hi Visual       cterm=none ctermbg=24              gui=none guibg=#005f87
hi WildMenu     cterm=bold ctermbg=35  ctermfg=232 gui=bold guibg=#00af5f guifg=#080808
hi ModeMsg      cterm=bold             ctermfg=110 gui=bold               guifg=#87afdf
hi MoreMsg      cterm=bold             ctermfg=121 gui=bold               guifg=#87ffaf
hi Question     cterm=bold             ctermfg=121 gui=bold               guifg=#87ffaf
hi ErrorMsg     cterm=none ctermbg=88  ctermfg=255 gui=none guibg=#870000 guifg=#eeeeee
hi WarningMsg   cterm=none ctermbg=58  ctermfg=255 gui=none guibg=#5f5f00 guifg=#eeeeee
hi SpecialKey   cterm=none             ctermfg=77  gui=none               guifg=#5fdf5f
hi Title        cterm=bold             ctermfg=147 gui=bold               guifg=#afafff
hi Directory                           ctermfg=105                                               guifg=#8787ff
hi DiffAdd      cterm=none ctermbg=18              gui=none guibg=#000087
hi DiffChange   cterm=none ctermbg=58              gui=none guibg=#5f5f00
hi DiffDelete   cterm=none ctermbg=52  ctermfg=58  gui=none guibg=#5f0000 guifg=#5f5f00
hi DiffText     cterm=none ctermbg=53              gui=none guibg=#5f005f
hi Pmenu        cterm=none ctermbg=17  ctermfg=121 gui=none guibg=#00005f guifg=#87ffaf
hi PmenuSel     cterm=none ctermbg=24  ctermfg=121 gui=none guibg=#005f87 guifg=#87ffaf
hi PmenuSbar    cterm=none ctermbg=19              gui=none guibg=#0000af
hi PmenuThumb   cterm=none ctermbg=37              gui=none guibg=#00afaf
hi MatchParen   cterm=bold ctermbg=24              gui=bold guibg=#005f87
hi SpellBad     cterm=none ctermbg=88              gui=none guibg=#870000
hi SpellCap     cterm=none ctermbg=18              gui=none guibg=#000087
hi SpellLocal   cterm=none ctermbg=30              gui=none guibg=#008787
hi SpellRare    cterm=none ctermbg=90              gui=none guibg=#870087

hi Comment    cterm=none             ctermfg=138 gui=none               guifg=#af8787
hi Constant   cterm=none             ctermfg=215 gui=none               guifg=#ffaf5f
hi String     cterm=none ctermbg=235 ctermfg=215 gui=none guibg=#262626 guifg=#ffaf5f
hi Character  cterm=none ctermbg=235 ctermfg=215 gui=none guibg=#262626 guifg=#ffaf5f
hi Number     cterm=none             ctermfg=34  gui=none               guifg=#00af00
hi Float      cterm=none             ctermfg=41  gui=none               guifg=#00df5f
hi Identifier cterm=none             ctermfg=186 gui=none               guifg=#dfdf87
hi Function   cterm=none             ctermfg=210 gui=none               guifg=#ff8787
hi Statement  cterm=bold             ctermfg=63  gui=bold               guifg=#5f5fff
hi Exception  cterm=bold             ctermfg=99  gui=bold               guifg=#875fff
hi Operator   cterm=none             ctermfg=75  gui=none               guifg=#5fafff
hi Label      cterm=none             ctermfg=63  gui=none               guifg=#5f5fff
hi PreProc    cterm=bold             ctermfg=36  gui=bold               guifg=#00af87
hi Type       cterm=bold             ctermfg=71  gui=bold               guifg=#5faf5f
hi Special    cterm=none ctermbg=235 ctermfg=87  gui=none guibg=#262626 guifg=#5fffff
hi Ignore     cterm=bold             ctermfg=235 gui=bold               guifg=#262626
hi Error      cterm=bold ctermbg=52  ctermfg=231 gui=bold guibg=#5f0000 guifg=#ffffff
hi Todo       cterm=bold ctermbg=143 ctermfg=16  gui=bold guibg=#afaf5f guifg=#000000

hi Underlined cterm=underline ctermfg=227 gui=underline guifg=#ffff5f

hi OperatorCurlyBrackets    cterm=bold ctermfg=75 gui=bold guifg=#5fafff
hi rubyGlobalVariable       cterm=none ctermfg=64 gui=none guifg=#5f8700
hi rubyPredefinedIdentifier cterm=bold ctermfg=64 gui=bold guifg=#5f8700
hi! link rubyStringDelimiter String

hi StatusLineNormal cterm=none ctermbg=236 ctermfg=231 gui=none guibg=#303030 guifg=#ffffff
hi StatusLineInsert cterm=none ctermbg=52  ctermfg=231 gui=none guibg=#5f0000 guifg=#ffffff
hi StatusLineCmdwin cterm=none ctermbg=22  ctermfg=231 gui=none guibg=#005f00 guifg=#ffffff
hi! link StatusLine StatusLineNormal

hi User1Normal cterm=bold ctermbg=236 ctermfg=223 gui=bold guibg=#303030 guifg=#ffdfaf
hi User1Insert cterm=bold ctermbg=52  ctermfg=223 gui=bold guibg=#5f0000 guifg=#ffdfaf
hi User1Cmdwin cterm=bold ctermbg=22  ctermfg=223 gui=bold guibg=#005f00 guifg=#ffdfaf
hi User2Normal cterm=none ctermbg=236 ctermfg=240 gui=none guibg=#303030 guifg=#585858
hi User2Insert cterm=none ctermbg=52  ctermfg=240 gui=none guibg=#5f0000 guifg=#585858
hi User2Cmdwin cterm=none ctermbg=22  ctermfg=240 gui=none guibg=#005f00 guifg=#585858
hi! link User1 User1Normal
hi! link User2 User2Normal

function! s:ModeChange(mode)
    exe 'hi! link StatusLine StatusLine' . a:mode
    exe 'hi! link User1 User1' . a:mode
    exe 'hi! link User2 User2' . a:mode
    redrawstatus
endfunction

set background=dark

augroup Lettuce
    au!

    au ColorScheme *
        \ if get(g:, 'colors_name', '') != 'lettuce' |
        \     exec 'au! Lettuce' |
        \ endif

    au Syntax c,cpp,ruby,javascript syn match Operator "[*/%&|!=><^~,.;:?+-]\+" display contains=TOP
    au Syntax c,cpp syn region cParen matchgroup=Operator transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell
    au Syntax c,cpp syn region cCppParen matchgroup=Operator transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cErrInBracket,cParen,cBracket,cString,@Spell
    au Syntax c,cpp syn region cBracket matchgroup=Operator transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@cParenGroup,cErrInParen,cCppParen,cCppBracket,cCppString,@Spell
    au Syntax c,cpp syn region cCppBracket matchgroup=Operator transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@cParenGroup,cErrInParen,cParen,cBracket,cString,@Spell
    au Syntax c,cpp syn region cBlock matchgroup=OperatorCurlyBrackets start="{" end="}" transparent fold
    au Syntax ruby syn match rubyBlockParameter "\%(\%(\<do\>\|{\)\s*\)\@<=|\s*[( ,a-zA-Z0-9_*)]\+\ze\s*|"hs=s+1 display
    au Syntax ruby syn region rubyCurlyBlock matchgroup=Operator start="{" end="}" contains=ALLBUT,@rubyExtendedStringSpecial,rubyTodo fold
    au Syntax ruby syn region rubyParentheses matchgroup=Operator start="(" end=")" contains=ALLBUT,@rubyExtendedStringSpecial,rubyTodo
    au Syntax ruby syn region rubySquareBrackets matchgroup=Operator start="\[" end="\]" contains=ALLBUT,@rubyExtendedStringSpecial,rubyTodo
    au Syntax javascript syn region javascriptCurlyBrackets matchgroup=Operator start="{" end="}" transparent fold
    au Syntax javascript syn region javascriptParentheses matchgroup=Operator start="(" end=")" transparent
    au Syntax javascript syn region javascriptSquareBrackets matchgroup=Operator start="\[" end="\]" transparent

    au InsertEnter             * call s:ModeChange('Insert')
    au CmdwinEnter             * call s:ModeChange('Cmdwin')
    au CmdwinLeave,InsertLeave * call s:ModeChange('Normal')
augroup END
