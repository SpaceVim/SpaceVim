"=============================================================================
" $Id: menu.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		autoload/lh/menu.vim                               {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	13th Oct 2006
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $ (28th Aug 2007)
"------------------------------------------------------------------------
" Description:	
" 	Defines the global function lh#menu#def_menu
" 	Aimed at (ft)plugin writers.
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop this file into {rtp}/autoload/lh/
" 	Requires Vim 7+
" History:	
" 	v2.0.0:	Moving to vim7
" 	v2.0.1:	:ToggleXxx echoes the new value
" 	v2.2.0: Support environment variables
" 	        Only one :Toggle command is defined.
" TODO:		
" 	Should the argument to :Toggle be simplified to use the variable
" 	name instead ?
" }}}1
"=============================================================================


"=============================================================================
let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Internal Variables {{{1
let s:k_Toggle_cmd = 'Toggle'
if !exists('s:toggle_commands')
  let s:toggle_commands = {}
endif

"------------------------------------------------------------------------
" ## Functions {{{1
" # Debug {{{2
function! lh#menu#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#menu#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" # Common stuff       {{{2
" Function: lh#menu#text({text})                             {{{3
" @return a text to be used in menus where "\" and spaces have been escaped.
function! lh#menu#text(text)
  return escape(a:text, '\ ')
endfunction

" # Toggling menu item {{{2
" Function: s:Fetch({Data},{key})                          {{{3
" @param[in] Data Menu-item definition
" @param[in] key  Table table from which the result will be fetched
" @return the current value, or text, whose index is Data.idx_crt_value.
function! s:Fetch(Data, key)
  let len = len(a:Data[a:key])
  if a:Data.idx_crt_value >= len | let a:Data.idx_crt_value = 0 | endif
  let value = a:Data[a:key][a:Data.idx_crt_value]
  return value
endfunction

" Function: s:Search({Data},{value})                       {{{3
" Searches for the index of {value} in {Data.values} list. Return 0 if not
" found.
function! s:Search(Data, value)
  let idx = 0
  while idx != len(a:Data.values)
    if a:value == a:Data.values[idx]
      " echo a:Data.variable . "[".idx."] == " . a:value
      return idx
    endif
    let idx = idx + 1
  endwhile
  " echo a:Data.variable . "[".-1."] == " . a:value
  return 0 " default is first element
endfunction

" Function: s:Set({Data})                                  {{{3
" @param[in,out] Data Menu item definition
"
" Sets the global variable associated to the menu item according to the item's
" current value.
function! s:Set(Data)
  let value = a:Data.values[a:Data.idx_crt_value]
  let variable = a:Data.variable
  if variable[0] == '$' " environment variabmes
    exe "let ".variable." = ".string(value)
  else
    let g:{variable} = value
  endif
  if has_key(a:Data, "actions")
    let l:Action = a:Data.actions[a:Data.idx_crt_value]
    if type(l:Action) == type(function('tr'))
      call l:Action()
    else
      exe l:Action
    endif
  endif
  return value
endfunction

" Function: s:MenuKey({Data})                              {{{3
" @return the table name from which the current value name (to dsplay in the
" menu) must be fetched. 
" Priority is given to the optional "texts" table over the madatory "values" table.
function! s:MenuKey(Data)
  if has_key(a:Data, "texts")
    let menu_id = "texts"
  else
    let menu_id = "values"
  endif
  return menu_id
endfunction

" Function: s:NextValue({Data})                            {{{3
" Change the value of the variable to the next in the list of value.
" The menu, and the variable are updated in consequence.
function! s:NextValue(Data)
  " Where the texts for values must be fetched
  let labels_key = s:MenuKey(a:Data)
  " Fetch the old current value 
  let old = s:Fetch(a:Data, labels_key)

  " Remove the entry from the menu
  call s:ClearMenu(a:Data.menu, old)

  " Cycle/increment the current value
  let a:Data.idx_crt_value += 1
  " Fetch it
  let new = s:Fetch(a:Data,labels_key)
  " Add the updated entry in the menu
  call s:UpdateMenu(a:Data.menu, new, a:Data.command)
  " Update the binded global variable
  let value = s:Set(a:Data)
  echo a:Data.variable.'='.value
endfunction

" Function: s:ClearMenu({Menu}, {text})                    {{{3
" Removes a menu item
"
" @param[in] Menu.priority Priority of the new menu-item
" @param[in] Menu.name     Name of the new menu-item
" @param[in] text          Text of the previous value of the variable binded
function! s:ClearMenu(Menu, text)
  if has('gui_running')
    let name = substitute(a:Menu.name, '&', '', 'g')
    let cmd = 'unmenu '.lh#menu#text(name.'<tab>('.a:text.')')
    silent! exe cmd
  endif
endfunction

" Function: s:UpdateMenu({Menu}, {text}, {command})        {{{3
" Adds a new menu item, with the text associated to the current value in
" braces.
"
" @param[in] Menu.priority Priority of the new menu-item
" @param[in] Menu.name     Name of the new menu-item
" @param[in] text          Text of the current value of the variable binded to
"                          the menu-item
" @param[in] command       Toggle command to execute when the menu-item is selected
function! s:UpdateMenu(Menu, text, command)
  if has('gui_running')
    let cmd = 'nnoremenu <silent> '.a:Menu.priority.' '.
	  \ lh#menu#text(a:Menu.name.'<tab>('.a:text.')').
	  \ ' :silent '.s:k_Toggle_cmd.' '.a:command."\<cr>"
    silent! exe cmd
  endif
endfunction

" Function: s:SaveData({Data})                             {{{3
" @param Data Menu-item definition
" Saves {Data} as s:Data{s:data_id++}. The definition will be used by
" automatically generated commands.
" @return s:data_id
let s:data_id = 0
function! s:SaveData(Data)
  let s:Data{s:data_id} = a:Data
  let id = s:data_id
  let s:data_id += 1
  return id
endfunction

" Function: lh#menu#def_toggle_item({Data})                  {{{3
" @param Data.idx_crt_value
" @param Data.definitions == [ {value:, menutext: } ]
" @param Data.menu        == { name:, position: }
"
" Sets a toggle-able menu-item defined by {Data}.
"
function! lh#menu#def_toggle_item(Data)
  " Save the menu data as an internal script variable
  let id = s:SaveData(a:Data)

  " If the index of the current value hasn't been set, fetch it from the
  " associated variable
  if !has_key(a:Data, "idx_crt_value")
    " Fetch the value of the associated variable
    let value = lh#option#get(a:Data.variable, 0, 'g')
    " echo a:Data.variable . " <- " . value
    " Update the index of the current value
    let a:Data.idx_crt_value  = s:Search(a:Data, value)
  endif

  " Name of the auto-matically generated toggle command
  let cmdName = substitute(a:Data.menu.name, '[^a-zA-Z_]', '', 'g')
  " Lazy definition of the command
  if 2 != exists(':'.s:k_Toggle_cmd) 
    exe 'command! -nargs=1 -complete=custom,lh#menu#_toggle_complete '
	  \ . s:k_Toggle_cmd . ' :call s:Toggle(<f-args>)'
  endif
  " silent exe 'command! -nargs=0 '.cmdName.' :call s:NextValue(s:Data'.id.')'
  let s:toggle_commands[cmdName] = eval('s:Data'.id)
  let a:Data["command"] = cmdName

  " Add the menu entry according to the current value
  call s:UpdateMenu(a:Data.menu, s:Fetch(a:Data, s:MenuKey(a:Data)), cmdName)
  " Update the associated global variable
  call s:Set(a:Data)
endfunction


"------------------------------------------------------------------------
function! s:Toggle(cmdName)
  if !has_key(s:toggle_commands, a:cmdName)
    throw "toggle-menu: unknown toggable variable ".a:cmdName
  endif
  let data = s:toggle_commands[a:cmdName]
  call s:NextValue(data)
endfunction

function! lh#menu#_toggle_complete(ArgLead, CmdLine, CursorPos)
  return join(keys(s:toggle_commands),"\n")
endfunction

"------------------------------------------------------------------------
" # IVN Menus          {{{2
" Function: s:CTRL_O({cmd})                                {{{3
" Build the command (sequence of ':ex commands') to be executed from
" INSERT-mode.
function! s:CTRL_O(cmd)
  return substitute(a:cmd, '\(^\|<CR>\):', '\1\<C-O>:', 'g')
endfunction

" Function: lh#menu#is_in_visual_mode()                    {{{3
function! lh#menu#is_in_visual_mode()
  return exists('s:is_in_visual_mode') && s:is_in_visual_mode
endfunction

" Function: lh#menu#_CMD_and_clear_v({cmd})                 {{{3
" Internal function that executes the command and then clears the @v buffer
" todo: save and restore @v, 
function! lh#menu#_CMD_and_clear_v(cmd)
  try 
    let s:is_in_visual_mode = 1
    exe a:cmd
  finally
    let @v=''
    silent! unlet s:is_in_visual_mode
  endtry
endfunction

" Function: s:Build_CMD({prefix},{cmd})                    {{{3
" build the exact command to execute regarding the mode it is dedicated
function! s:Build_CMD(prefix, cmd)
  if a:cmd[0] != ':' | return ' ' . a:cmd
  endif
  if     a:prefix[0] == "i"  | return ' ' . <SID>CTRL_O(a:cmd)
  elseif a:prefix[0] == "n"  | return ' ' . a:cmd
  elseif a:prefix[0] == "v" 
    if match(a:cmd, ":VCall") == 0
      return substitute(a:cmd, ':VCall', ' :call', ''). "\<cr>gV"
      " gV exit select-mode if we where in it!
    else
      return
	    \ " \"vy\<C-C>:call lh#menu#_CMD_and_clear_v('" . 
	    \ substitute(a:cmd, "<CR>$", '', '') ."')\<cr>"
    endif
  elseif a:prefix[0] == "c"  | return " \<C-C>" . a:cmd
  else                       | return ' ' . a:cmd
  endif
endfunction

" Function: lh#menu#map_all({map_type}, [{map args}...)   {{{3
" map the command to all the modes required
function! lh#menu#map_all(map_type,...)
  let nore   = (match(a:map_type, '[aincv]*noremap') != -1) ? "nore" : ""
  let prefix = matchstr(substitute(a:map_type, nore, '', ''), '[aincv]*')
  if a:1 == "<buffer>" | let i = 3 | let binding = a:1 . ' ' . a:2
  else                 | let i = 2 | let binding = a:1
  endif
  let binding = '<silent> ' . binding
  let cmd = a:{i}
  let i +=  1
  while i <= a:0
    let cmd .=  ' ' . a:{i}
    let i +=  1
  endwhile
  let build_cmd = nore . 'map ' . binding
  while strlen(prefix)
    if prefix[0] == "a" | let prefix = "incv"
    else
      execute prefix[0] . build_cmd . <SID>Build_CMD(prefix[0],cmd)
      let prefix = strpart(prefix, 1)
    endif
  endwhile
endfunction

" Function: lh#menu#make({prefix},{code},{text},{binding},...) {{{3
" Build the menu and map its associated binding to all the modes required
function! lh#menu#make(prefix, code, text, binding, ...)
  let nore   = (match(a:prefix, '[aincv]*nore') != -1) ? "nore" : ""
  let prefix = matchstr(substitute(a:prefix, nore, '', ''), '[aincv]*')
  let b = (a:1 == "<buffer>") ? 1 : 0
  let i = b + 1 
  let cmd = a:{i}
  let i += 1
  while i <= a:0
    let cmd .=  ' ' . a:{i}
    let i += 1
  endwhile
  let build_cmd = nore . "menu <silent> " . a:code . ' ' . lh#menu#text(a:text) 
  if strlen(a:binding) != 0
    let build_cmd .=  '<tab>' . 
	  \ substitute(lh#menu#text(a:binding), '&', '\0\0', 'g')
    if b != 0
      call lh#menu#map_all(prefix.nore."map", ' <buffer> '.a:binding, cmd)
    else
      call lh#menu#map_all(prefix.nore."map", a:binding, cmd)
    endif
  endif
  if has("gui_running")
    while strlen(prefix)
      execute <SID>BMenu(b).prefix[0].build_cmd.<SID>Build_CMD(prefix[0],cmd)
      let prefix = strpart(prefix, 1)
    endwhile
  endif
endfunction

" Function: s:BMenu({b})                                   {{{3
" If <buffermenu.vim> is installed and the menu should be local, then the
" apropriate string is returned.
function! s:BMenu(b)
  let res = (a:b && exists(':Bmenu') 
	\     && (1 == lh#option#get("want_buffermenu_or_global_disable", 1, "bg"))
	\) ? 'B' : ''
  " call confirm("BMenu(".a:b.")=".res, '&Ok', 1)
  return res
endfunction

" Function: lh#menu#IVN_make(...)                          {{{3
function! lh#menu#IVN_make(code, text, binding, i_cmd, v_cmd, n_cmd, ...)
  " nore options
  let nore_i = (a:0 > 0) ? ((a:1 != 0) ? 'nore' : '') : ''
  let nore_v = (a:0 > 1) ? ((a:2 != 0) ? 'nore' : '') : ''
  let nore_n = (a:0 > 2) ? ((a:3 != 0) ? 'nore' : '') : ''
  " 
  call lh#menu#make('i'.nore_i,a:code,a:text, a:binding, '<buffer>', a:i_cmd)
  call lh#menu#make('v'.nore_v,a:code,a:text, a:binding, '<buffer>', a:v_cmd)
  if strlen(a:n_cmd) != 0
    call lh#menu#make('n'.nore_n,a:code,a:text, a:binding, '<buffer>', a:n_cmd)
  endif
endfunction

"
" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
