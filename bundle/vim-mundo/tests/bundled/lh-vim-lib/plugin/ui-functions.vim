"=============================================================================
" File:         plugin/ui-functions.vim                                  {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://code.google.com/p/lh-vim/>
" URL: http://hermitte.free.fr/vim/ressources/vimfiles/plugin/ui-functions.vim
" 
" Version:      2.2.1
" Created:      18th nov 2002
" Last Update:  28th Nov 2007
"------------------------------------------------------------------------
" Description:  Functions for the interaction with a User Interface.
"               The UI can be graphical or textual.
"               At first, this was designed to ease the syntax of
"               mu-template's templates.
"
" Option:       {{{2
"       {[bg]:ui_type} 
"               = "g\%[ui]", 
"               = "t\%[ext]" ; the call must not be |:silent|
"               = "f\%[te]"
" }}}2
"------------------------------------------------------------------------
" Installation: Drop this into one of your {rtp}/plugin/ directories.
" History:      {{{2
"    v0.01 Initial Version
"    v0.02
"       (*) Code "factorisations" 
"       (*) Help on <F1> enhanced.
"       (*) Small changes regarding the parameter accepted
"       (*) Function SWITCH
"    v0.03
"       (*) Small bug fix with INPUT()
"    v0.04
"       (*) New function: WHICH()
"    v0.05
"       (*) In vim7e, inputdialog() returns a trailing '\n'. INPUT() strips the
"           NL character.
"    v0.06
"       (*) :s/echoerr/throw/ => vim7 only
"    v2.2.0
"       (*) menu to switch the ui_type
" 
" TODO:         {{{2
"       (*) Save the hl-User1..9 before using them
"       (*) Possibility other than &statusline:
"           echohl User1 |echon "bla"|echohl User2|echon "bli"|echohl None
"       (*) Wraps too long choices-line (length > term-width)
"       (*) Add to the documentation: "don't use CTRL-C to abort !!"
"       (*) Look if I need to support 'wildmode'
"       (*) 3rd mode: return string for FTE
"       (*) 4th mode: interaction in a scratch buffer
"
" }}}1
"=============================================================================
" Avoid reinclusion {{{1
" 
if exists("g:loaded_ui_functions") && !exists('g:force_reload_ui_functions')
  finish 
endif
let g:loaded_ui_functions = 1
let s:cpo_save=&cpo
set cpo&vim
" }}}1
"------------------------------------------------------------------------
" External functions {{{1
" Function: IF(var, then, else) {{{2
function! IF(var,then, else)
  let o = s:Opt_type() " {{{3
  if     o =~ 'g\%[ui]\|t\%[ext]' " {{{4
    return a:var ? a:then : a:else
  elseif o =~ 'f\%[te]'           " {{{4
    return s:if_fte(a:var, a:then, a:else)
  else                    " {{{4
    throw "UI-Fns::IF(): Unkonwn user-interface style (".o.")"
  endif
  " }}}3
endfunction

" Function: SWITCH(var, case, action [, case, action] [default_action]) {{{2
function! SWITCH(var, ...)
  let o = s:Opt_type() " {{{3
  if     o =~ 'g\%[ui]\|t\%[ext]' " {{{4
    let explicit_def = ((a:0 % 2) == 1)
    let default      = explicit_def ? a:{a:0} : ''
    let i = a:0 - 1 - explicit_def
    while i > 0
      if a:var == a:{i}
        return a:{i+1}
      endif
      let i = i - 2
    endwhile
    return default
  elseif o =~ 'f\%[te]'           " {{{4
    return s:if_fte(a:var, a:then, a:else)
  else                    " {{{4
    throw "UI-Fns::SWITCH(): Unkonwn user-interface style (".o.")"
  endif
  " }}}3
endfunction

" Function: CONFIRM(text [, choices [, default [, type]]]) {{{2
function! CONFIRM(text, ...)
  " 1- Check parameters {{{3
  if a:0 > 4 " {{{4
    throw "UI-Fns::CONFIRM(): too many parameters"
    return 0
  endif
  " build the parameters string {{{4
  let i = 1
  while i <= a:0
    if i == 1 | let params = 'a:{1}'
    else      | let params = params. ',a:{'.i.'}'
    endif
    let i = i + 1
  endwhile
  " 2- Choose the correct way to execute according to the option {{{3
  let o = s:Opt_type()
  if     o =~ 'g\%[ui]'  " {{{4
    exe 'return confirm(a:text,'.params.')'
  elseif o =~ 't\%[ext]' " {{{4
    if !has('gui_running') && has('dialog_con')
      exe 'return confirm(a:text,'.params.')'
    else
      exe 'return s:confirm_text("none", a:text,'.params.')'
    endif
  elseif o =~ 'f\%[te]'  " {{{4
      exe 'return s:confirm_fte(a:text,'.params.')'
  else               " {{{4
    throw "UI-Fns::CONFIRM(): Unkonwn user-interface style (".o.")"
  endif
  " }}}3
endfunction

" Function: INPUT(prompt [, default ]) {{{2
function! INPUT(prompt, ...)
  " 1- Check parameters {{{3
  if a:0 > 4 " {{{4
    throw "UI-Fns::INPUT(): too many parameters"
    return 0
  endif
  " build the parameters string {{{4
  let i = 1 | let params = ''
  while i <= a:0
    if i == 1 | let params = 'a:{1}'
    else      | let params = params. ',a:{'.i.'}'
    endif
    let i = i + 1
  endwhile
  " 2- Choose the correct way to execute according to the option {{{3
  let o = s:Opt_type()
  if     o =~ 'g\%[ui]'  " {{{4
    exe 'return matchstr(inputdialog(a:prompt,'.params.'), ".\\{-}\\ze\\n\\=$")'
  elseif o =~ 't\%[ext]' " {{{4
    exe 'return input(a:prompt,'.params.')'
  elseif o =~ 'f\%[te]'  " {{{4
      exe 'return s:input_fte(a:prompt,'.params.')'
  else               " {{{4
    throw "UI-Fns::INPUT(): Unkonwn user-interface style (".o.")"
  endif
  " }}}3
endfunction

" Function: COMBO(prompt, choice [, ... ]) {{{2
function! COMBO(prompt, ...)
  " 1- Check parameters {{{3
  if a:0 > 4 " {{{4
    throw "UI-Fns::COMBO(): too many parameters"
    return 0
  endif
  " build the parameters string {{{4
  let i = 1
  while i <= a:0
    if i == 1 | let params = 'a:{1}'
    else      | let params = params. ',a:{'.i.'}'
    endif
    let i = i + 1
  endwhile
  " 2- Choose the correct way to execute according to the option {{{3
  let o = s:Opt_type()
  if     o =~ 'g\%[ui]'  " {{{4
    exe 'return confirm(a:prompt,'.params.')'
  elseif o =~ 't\%[ext]' " {{{4
    exe 'return s:confirm_text("combo", a:prompt,'.params.')'
  elseif o =~ 'f\%[te]'  " {{{4
    exe 'return s:combo_fte(a:prompt,'.params.')'
  else               " {{{4
    throw "UI-Fns::COMBO(): Unkonwn user-interface style (".o.")"
  endif
  " }}}3
endfunction

" Function: WHICH(function, prompt, choice [, ... ]) {{{2
function! WHICH(fn, prompt, ...)
  " 1- Check parameters {{{3
  " build the parameters string {{{4
  let i = 1
  while i <= a:0
    if i == 1 | let params = 'a:{1}'
    else      | let params = params. ',a:{'.i.'}'
    endif
    let i = i + 1
  endwhile
  " 2- Execute the function {{{3
  exe 'let which = '.a:fn.'(a:prompt,'.params.')'
  if     0 >= which | return ''
  elseif 1 == which
    return substitute(matchstr(a:{1}, '^.\{-}\ze\%(\n\|$\)'), '&', '', 'g')
  else
    return substitute(
          \ matchstr(a:{1}, '^\%(.\{-}\n\)\{'.(which-1).'}\zs.\{-}\ze\%(\n\|$\)')
          \ , '&', '', 'g')
  endif
  " }}}3
endfunction

" Function: CHECK(prompt, choice [, ... ]) {{{2
function! CHECK(prompt, ...)
  " 1- Check parameters {{{3
  if a:0 > 4 " {{{4
    throw "UI-Fns::CHECK(): too many parameters"
    return 0
  endif
  " build the parameters string {{{4
  let i = 1
  while i <= a:0
    if i == 1 | let params = 'a:{1}'
    else      | let params = params. ',a:{'.i.'}'
    endif
    let i = i + 1
  endwhile
  " 2- Choose the correct way to execute according to the option {{{3
  let o = s:Opt_type()
  if     o =~ 'g\%[ui]'  " {{{4
    exe 'return s:confirm_text("check", a:prompt,'.params.')'
  elseif o =~ 't\%[ext]' " {{{4
    exe 'return s:confirm_text("check", a:prompt,'.params.')'
  elseif o =~ 'f\%[te]'  " {{{4
      exe 'return s:check_fte(a:prompt,'.params.')'
  else               " {{{4
    throw "UI-Fns::CHECK(): Unkonwn user-interface style (".o.")"
  endif
  " }}}3
endfunction

" }}}1
"------------------------------------------------------------------------
" Options setting {{{1
let s:OptionData = {
      \ "variable": "ui_type",
      \ "idx_crt_value": 1,
      \ "values": ['gui', 'text', 'fte'],
      \ "menu": { "priority": '500.2700', "name": '&Plugin.&LH.&UI type'}
      \}

call lh#menu#def_toggle_item(s:OptionData)

" }}}1
"------------------------------------------------------------------------
" Internal functions {{{1
function! s:Option(name, default) " {{{2
  if     exists('b:ui_'.a:name) | return b:ui_{a:name}
  elseif exists('g:ui_'.a:name) | return g:ui_{a:name}
  else                          | return a:default
  endif
endfunction


function! s:Opt_type() " {{{2
  return s:Option('type', 'gui')
endfunction

"
" Function: s:status_line(current, hl [, choices] ) {{{2
"     a:current: current item
"     a:hl     : Generic, Warning, Error
function! s:status_line(current, hl, ...)
  " Highlightning {{{3
  if     a:hl == "Generic"  | let hl = '%1*'
  elseif a:hl == "Warning"  | let hl = '%2*'
  elseif a:hl == "Error"    | let hl = '%3*'
  elseif a:hl == "Info"     | let hl = '%4*'
  elseif a:hl == "Question" | let hl = '%5*'
  else                      | let hl = '%1*'
  endif
  
  " Build the string {{{3
  let sl_choices = '' | let i = 1
  while i <= a:0
    if i == a:current
      let sl_choices = sl_choices . ' '. hl . 
            \ substitute(a:{i}, '&\(.\)', '%6*\1'.hl, '') . '%* '
    else
      let sl_choices = sl_choices . ' ' . 
            \ substitute(a:{i}, '&\(.\)', '%6*\1%*', '') . ' '
    endif
    let i = i + 1
  endwhile
  " }}}3
  return sl_choices
endfunction


" Function: s:confirm_text(box, text [, choices [, default [, type]]]) {{{2
function! s:confirm_text(box, text, ...)
  let help = "/<esc>/<s-tab>/<tab>/<left>/<right>/<cr>/<F1>"
  " 1- Retrieve the parameters       {{{3
  let choices = ((a:0>=1) ? a:1 : '&Ok')
  let default = ((a:0>=2) ? a:2 : (('check' == a:box) ? 0 : 1))
  let type    = ((a:0>=3) ? a:3 : 'Generic')
  if     'none'  == a:box | let prefix = ''
  elseif 'combo' == a:box | let prefix = '( )_'
  elseif 'check' == a:box | let prefix = '[ ]_'
    let help = '/ '.help
  else                    | let prefix = ''
  endif


  " 2- Retrieve the proposed choices {{{3
  " Prepare the hot keys
  let i = 0
  while i != 26
    let hotkey_{nr2char(i+65)} = 0
    let i += 1
  endwhile
  let hotkeys = '' | let help_k = '/'
  " Parse the choices
  let i = 0
  while choices != ""
    let i = i + 1
    let item    = matchstr(choices, "^.\\{-}\\ze\\(\n\\|$\\)")
    let choices = matchstr(choices, "\n\\zs.*$")
    " exe 'anoremenu ]'.a:text.'.'.item.' :let s:choice ='.i.'<cr>'
    if ('check' == a:box) && (strlen(default)>=i) && (1 == default[i-1])
      " let choice_{i} = '[X]' . substitute(item, '&', '', '')
      let choice_{i} = '[X]_' . item
    else
      " let choice_{i} = prefix . substitute(item, '&', '', '')
      let choice_{i} = prefix . item
    endif
    if i == 1
      let list_choices = 'choice_{1}'
    else
      let list_choices = list_choices . ',choice_{'.i.'}'
    endif
    " Update the hotkey.
    let key = toupper(matchstr(choice_{i}, '&\zs.\ze'))
    let hotkey_{key} = i
    let hotkeys = hotkeys . tolower(key) . toupper(key)
    let help_k = help_k . tolower(key)
  endwhile
  let nb_choices = i
  if default > nb_choices | let default = nb_choices | endif

  " 3- Run an interactive text menu  {{{3
  " Note: emenu can not be used through ":exe" {{{4
  " let wcm = &wcm
  " set wcm=<tab>
  " exe ':emenu ]'.a:text.'.'."<tab>"
  " let &wcm = wcm
  " 3.1- Preparations for the statusline {{{4
  " save the statusline
  let sl = &l:statusline
  " Color schemes for selected item {{{5
  :hi User1 term=inverse,bold cterm=inverse,bold ctermfg=Yellow 
        \ guifg=Black guibg=Yellow
  :hi User2 term=inverse,bold cterm=inverse,bold ctermfg=LightRed
        \ guifg=Black guibg=LightRed
  :hi User3 term=inverse,bold cterm=inverse,bold ctermfg=Red 
        \ guifg=Black guibg=Red
  :hi User4 term=inverse,bold cterm=inverse,bold ctermfg=Cyan
        \ guifg=Black guibg=Cyan
  :hi User5 term=inverse,bold cterm=inverse,bold ctermfg=LightYellow
        \ guifg=Black guibg=LightYellow
  :hi User6 term=inverse,bold cterm=inverse,bold ctermfg=LightGray
        \ guifg=DarkRed guibg=LightGray
  " }}}5

  " 3.2- Interactive loop                {{{4
  let help =  "\r-- Keys available (".help_k.help.")"
  " item selected at the start
  let i = ('check' != a:box) ? default : 1
  let direction = 0 | let toggle = 0
  while 1
    if 'combo' == a:box
      let choice_{i} = substitute(choice_{i}, '^( )', '(*)', '')
    endif
    " Colored statusline
    " Note: unfortunately the 'statusline' is a global option, {{{
    " not a local one. I the hope that may change, as it does not provokes any
    " error, I use '&l:statusline'. }}}
    exe 'let &l:statusline=s:status_line(i, type,'. list_choices .')'
    if has(':redrawstatus')
      redrawstatus!
    else
      redraw!
    endif
    " Echo the current selection
    echo "\r". a:text.' '.substitute(choice_{i}, '&', '', '')
    " Wait the user to hit a key
    let key=getchar()
    let complType=nr2char(key)
    " If the key hit matched awaited keys ...
    if -1 != stridx(" \<tab>\<esc>\<enter>".hotkeys,complType) ||
          \ (key =~ "\<F1>\\|\<right>\\|\<left>\\|\<s-tab>")
      if key           == "\<F1>"                       " Help      {{{5
        redraw!
        echohl StatusLineNC
        echo help
        echohl None
        let key=getchar()
        let complType=nr2char(key)
      endif
      " TODO: support CTRL-D
      if     complType == "\<enter>"                    " Validate  {{{5
        break
      elseif complType == " "                           " check box {{{5
        let toggle = 1
      elseif complType == "\<esc>"                      " Abort     {{{5
        let i = -1 | break
      elseif complType == "\<tab>" || key == "\<right>" " Next      {{{5
        let direction = 1
      elseif key =~ "\<left>\\|\<s-tab>"                " Previous  {{{5
        let direction = -1
      elseif -1 != stridx(hotkeys, complType )          " Hotkeys     {{{5
        if '' == complType  | continue | endif
        let direction = hotkey_{toupper(complType)} - i
        let toggle = 1
      " else
      endif
      " }}}5
    endif
    if direction != 0 " {{{5
      if 'combo' == a:box
        let choice_{i} = substitute(choice_{i}, '^(\*)', '( )', '')
      endif
      let i = i + direction
      if     i > nb_choices | let i = 1 
      elseif i == 0         | let i = nb_choices
      endif
      let direction = 0
    endif
    if toggle == 1    " {{{5
      if 'check' == a:box
        let choice_{i} = ((choice_{i}[1] == ' ')? '[X]' : '[ ]') 
              \ . strpart(choice_{i}, 3)
      endif
      let toggle = 0
    endif
  endwhile " }}}4
  " 4- Terminate                     {{{3
  " Clear screen
  redraw!

  " Restore statusline
  let &l:statusline=sl
  " Return
  if (i == -1) || ('check' != a:box)
    return i
  else
    let r = '' | let i = 1
    while i <= nb_choices
      let r = r . ((choice_{i}[1] == 'X') ? '1' : '0')
      let i = i + 1
    endwhile
    return r
  endif
endfunction
" }}}1
"------------------------------------------------------------------------
" Functions that insert fte statements {{{1
" Function: s:if_fte(var, then, else) {{{2
" Function: s:confirm_fte(text, [, choices [, default [, type]]]) {{{2
" Function: s:input_fte(prompt [, default]) {{{2
" Function: s:combo_fte(prompt, choice [, ...]) {{{2
" Function: s:check_fte(prompt, choice [, ...]) {{{2
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
