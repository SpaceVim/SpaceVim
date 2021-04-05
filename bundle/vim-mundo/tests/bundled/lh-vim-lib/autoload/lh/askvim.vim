"=============================================================================
" $Id: askvim.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		autoload/lh/askvim.vim                                    {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	17th Apr 2007
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $ (17th Apr 2007)
"------------------------------------------------------------------------
" Description:	
" 	Defines functions that asks vim what it is relinquish to tell us
" 	- menu
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop it into {rtp}/autoload/lh/
" 	Vim 7+ required.
" History:	
" 	v2.0.0:
" TODO:		«missing features»
" }}}1
"=============================================================================


"=============================================================================
let s:cpo_save=&cpo
set cpo&vim

"------------------------------------------------------------------------
" ## Functions {{{1
" # Debug {{{2
function! lh#askvim#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#askvim#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" # Public {{{2
" Function: lh#askvim#exe(command) {{{3
function! lh#askvim#Exe(command)
  echomsg 'lh#askvim#Exe() is deprecated, use lh#askvim#exe()'
  return lh#askvim#exe(a:command)
endfunction

function! lh#askvim#exe(command)
  let save_a = @a
  try 
    silent! redir @a
    silent! exe a:command
    redir END
  finally
    " Always restore everything
    let res = @a
    let @a = save_a
    return res
  endtry
endfunction


" Function: lh#askvim#menu(menuid) {{{3
function! s:AskOneMenu(menuact, res)
  let sKnown_menus = lh#askvim#exe(a:menuact)
  let lKnown_menus = split(sKnown_menus, '\n')
  " echo string(lKnown_menus)

  " 1- search for the menuid
  " todo: fix the next line to correctly interpret "stuff\.stuff" and
  " "stuff\\.stuff".
  let menuid_parts = split(a:menuact, '\.')

  let simplifiedKnown_menus = deepcopy(lKnown_menus)
  call map(simplifiedKnown_menus, 'substitute(v:val, "&", "", "g")')
  " let idx = lh#list#match(simplifiedKnown_menus, '^\d\+\s\+'.menuid_parts[-1])
  let idx = match(simplifiedKnown_menus, '^\d\+\s\+'.menuid_parts[-1])
  if idx == -1
    " echo "not found"
    return
  endif
  " echo "l[".idx."]=".lKnown_menus[idx]

  if empty(a:res)
    let a:res.priority = matchstr(lKnown_menus[idx], '\d\+\ze\s\+.*')
    let a:res.name     = matchstr(lKnown_menus[idx], '\d\+\s\+\zs.*')
    let a:res.actions  = {}
  " else
  "   what if the priority isn't the same?
  endif

  " 2- search for the menu definition
  let idx += 1
  while idx != len(lKnown_menus)
    echo "l[".idx."]=".lKnown_menus[idx]
    " should not happen
    if lKnown_menus[idx] =~ '^\d\+' | break | endif

    " :h showing-menus
    " -> The format of the result of the call to Exe() seems to be:
    "    ^ssssMns-sACTION$
    "    s == 1 whitespace
    "    M == mode (inrvcs)
    "    n == noremap(*)/script(&)
    "    - == disable(-)/of not
    let act = {}
    let menu_def = matchlist(lKnown_menus[idx],
	  \ '^\s*\([invocs]\)\([&* ]\) \([- ]\) \(.*\)$')
    if len(menu_def) > 4
      let act.mode        = menu_def[1]
      let act.nore_script = menu_def[2]
      let act.disabled    = menu_def[3]
      let act.action      = menu_def[4]
    else
      echomsg string(menu_def)
      echoerr "lh#askvim#menu(): Cannot decode ``".lKnown_menus[idx]."''"
    endif
    
    let a:res.actions["mode_" . act.mode] = act

    let idx += 1
  endwhile

  " n- Return the result
  return a:res
endfunction

function! lh#askvim#menu(menuid, modes)
  let res = {}
  let i = 0
  while i != strlen(a:modes)
    call s:AskOneMenu(a:modes[i].'menu '.a:menuid, res)
    let i += 1
  endwhile
  return res
endfunction
" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
