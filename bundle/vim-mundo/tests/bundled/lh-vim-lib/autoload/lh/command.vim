"=============================================================================
" $Id: command.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		autoload/lh/command.vim                               {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	08th Jan 2007
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $ (08th Jan 2007)
"------------------------------------------------------------------------
" Description:	
" 	Helpers to define commands that:
" 	- support subcommands
" 	- support autocompletion
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop it into {rtp}/autoload/lh/
" 	Vim 7+ required.
" History:	
" 	v2.0.0:
" 		Code move from other plugins
" TODO:		«missing features»
" }}}1
"=============================================================================


"=============================================================================
let s:cpo_save=&cpo
set cpo&vim

" ## Debug {{{1
function! lh#command#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#command#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" ## Functions {{{1

" Tool functions {{{2
" Function: lh#command#Fargs2String(aList) {{{3
" @param[in,out] aList list of params from <f-args>
" @see tests/lh/test-Fargs2String.vim
function! lh#command#Fargs2String(aList)
  if empty(a:aList) | return '' | endif

  let quote_char = a:aList[0][0] 
  let res = a:aList[0]
  call remove(a:aList, 0)
  if quote_char !~ '["'."']"
    return res
  endif
  " else
  let end_string = '[^\\]\%(\\\\\)*'.quote_char.'$'
  while !empty(a:aList) && res !~ end_string 
    let res .= ' ' . a:aList[0]
    call remove(a:aList, 0)
  endwhile
  return res
endfunction

"------------------------------------------------------------------------
" ## Experimental Functions {{{1

" Internal functions        {{{2
" Function: s:SaveData({Data})                             {{{3
" @param Data Command definition
" Saves {Data} as s:Data{s:data_id++}. The definition will be used by
" automatically generated commands.
" @return s:data_id
let s:data_id = 0
function! s:SaveData(Data)
  if has_key(a:Data, "command_id")
    " Avoid data duplication
    return a:Data.command_id
  else
    let s:Data{s:data_id} = a:Data
    let id = s:data_id
    let s:data_id += 1
    let a:Data.command_id = id
    return id
  endif
endfunction

" BTWComplete(ArgLead, CmdLine, CursorPos):      Auto-complete {{{3
function! lh#command#complete(ArgLead, CmdLine, CursorPos)
  let tmp = substitute(a:CmdLine, '\s*\S*', 'Z', 'g')
  let pos = strlen(tmp)
  if 0
    call confirm( "AL = ". a:ArgLead."\nCL = ". a:CmdLine."\nCP = ".a:CursorPos
	  \ . "\ntmp = ".tmp."\npos = ".pos
	  \, '&Ok', 1)
  endif

  if     2 == pos
    " First argument: a command
    return s:commands
  elseif 3 == pos
    " Second argument: first arg of the command
    if     -1 != match(a:CmdLine, '^BTW\s\+echo')
      return s:functions . "\n" . s:variables
    elseif -1 != match(a:CmdLine, '^BTW\s\+\%(help\|?\)')
    elseif -1 != match(a:CmdLine, '^BTW\s\+\%(set\|add\)\%(local\)\=')
      " Adds a filter
      " let files =         globpath(&rtp, 'compiler/BT-*')
      " let files = files . globpath(&rtp, 'compiler/BT_*')
      " let files = files . globpath(&rtp, 'compiler/BT/*')
      let files = s:FindFilter('*')
      let files = substitute(files,
	    \ '\(^\|\n\).\{-}compiler[\\/]BTW[-_\\/]\(.\{-}\)\.vim\>\ze\%(\n\|$\)',
	    \ '\1\2', 'g')
      return files
    elseif -1 != match(a:CmdLine, '^BTW\s\+remove\%(local\)\=')
      " Removes a filter
      return substitute(s:FiltersList(), ',', '\n', 'g')
    endif
  endif
  " finally: unknown
  echoerr 'BTW: unespected parameter ``'. a:ArgLead ."''"
  return ''
endfunction

function! s:BTW(command, ...)
  " todo: check a:0 > 1
  if     'set'      == a:command | let g:BTW_build_tool = a:1
    if exists('b:BTW_build_tool')
      let b:BTW_build_tool = a:1
    endif
  elseif 'setlocal'     == a:command | let b:BTW_build_tool = a:1
  elseif 'add'          == a:command | call s:AddFilter('g', a:1)
  elseif 'addlocal'     == a:command | call s:AddFilter('b', a:1)
    " if exists('b:BTW_filters_list') " ?????
    " call s:AddFilter('b', a:1)
    " endif
  elseif 'remove'       == a:command | call s:RemoveFilter('g', a:1)
  elseif 'removelocal'  == a:command | call s:RemoveFilter('b', a:1)
  elseif 'rebuild'      == a:command " wait for s:ReconstructToolsChain()
  elseif 'echo'         == a:command | exe "echo s:".a:1
    " echo s:{a:f1} ## don't support «echo s:f('foo')»
  elseif 'reloadPlugin' == a:command
    let g:force_reload_BuildToolsWrapper = 1
    let g:BTW_BTW_in_use = 1
    exe 'so '.s:sfile
    unlet g:force_reload_BuildToolsWrapper
    unlet g:BTW_BTW_in_use
    return
  elseif a:command =~ '\%(help\|?\)'
    call s:Usage()
    return
  endif
  call s:ReconstructToolsChain()
endfunction

" ##############################################################
" Public functions          {{{2

function! s:FindSubcommand(definition, subcommand)
  for arg in a:definition.arguments
    if arg.name == a:subcommand
      return arg
    endif
  endfor
  throw "NF"
endfunction

function! s:execute_function(definition, params)
    if len(a:params) < 1
      throw "(lh#command) Not enough arguments"
    endif
  let l:Fn = a:definition.action
  echo "calling ".string(l:Fn)
  echo "with ".string(a:params)
  " call remove(a:params, 0)
  call l:Fn(a:params)
endfunction

function! s:execute_sub_commands(definition, params)
  try
    if len(a:params) < 1
      throw "(lh#command) Not enough arguments"
    endif
    let subcommand = s:FindSubcommand(a:definition, a:params[0])
    call remove(a:params, 0)
    call s:int_execute(subcommand, a:params)
  catch /NF.*/
    throw "(lh#command) Unexpected subcommand `".a:params[0]."'."
  endtry
endfunction

function! s:int_execute(definition, params)
  echo "params=".string(a:params)
  call s:execute_{a:definition.arg_type}(a:definition, a:params)
endfunction

function! s:execute(definition, ...)
  try
    let params = copy(a:000)
    call s:int_execute(a:definition, params)
  catch /(lh#command).*/
    echoerr v:exception . " in `".a:definition.name.' '.join(a:000, ' ')."'"
  endtry
endfunction

function! lh#command#new(definition)
  let cmd_name = a:definition.name
  " Save the definition as an internal script variable
  let id = s:SaveData(a:definition)
  exe "command! -nargs=* ".cmd_name." :call s:execute(s:Data".id.", <f-args>)"
endfunction

" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
