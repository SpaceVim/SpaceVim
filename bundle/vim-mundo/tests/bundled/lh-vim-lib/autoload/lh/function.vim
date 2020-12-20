"=============================================================================
" $Id: function.vim 161 2010-05-07 01:04:44Z luc.hermitte $
" File:		autoload/lh/function.vim                               {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.0
" Created:	03rd Nov 2008
" Last Update:	$Date: 2010-05-06 21:04:44 -0400 (Thu, 06 May 2010) $
"------------------------------------------------------------------------
" Description:	
" 	Implements:
" 	- lh#function#bind()
" 	- lh#function#execute()
" 	- lh#function#prepare()
" 	- a binded function type
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop it into {rtp}/autoload/lh/
" 	Vim 7+ required.
" History:	
" v2.2.0: first implementation
" TODO:		«missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------

" ## Functions {{{1
" # Debug {{{2
function! lh#function#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#function#debug(expr)
  return eval(a:expr)
endfunction

" # Function: s:Join(arguments...) {{{2
function! s:Join(args)
  let res = ''
  if len(a:args) > 0
    let res = string(a:args[0])
    let i = 1
    while i != len(a:args)
      let res.=','.string(a:args[i])
      let i += 1
    endwhile
  endif
  return res
endfunction

" # Function: s:DoBindList(arguments...) {{{2
function! s:DoBindList(formal, real)
  let args = []
  for arg in a:formal
    if type(arg)==type('string') && arg =~ '^v:\d\+_$'
      let new = a:real[matchstr(arg, 'v:\zs\d\+\ze_')-1]
    elseif type(arg)==type('string')
      let new = eval(s:DoBindEvaluatedString(arg, a:real))
    else
      let new = arg
    endif
    call add(args, new)
    unlet new
    unlet arg
  endfor
  return args
endfunction

" # Function: s:DoBindString(arguments...) {{{2
function! s:DoBindString(expr, real)
  let expr = substitute(a:expr, '\<v:\(\d\+\)_\>', a:real.'[\1-1]', 'g')
  return expr
endfunction

function! s:ToString(expr)
  return  type(a:expr) != type('')
	\ ? string(a:expr)
	\ : (a:expr)
endfunction

function! s:DoBindEvaluatedString(expr, real)
  let expr = a:expr
  let p = 0
  while 1
    let p = match(expr, '\<v:\d\+_\>', p)
    if -1 == p | break | endif
    let e = matchend(expr, '\<v:\d\+_\>', p)
    let n = eval(expr[p+2 : e-2])
    " let new = (type(a:real[n-1])==type('') && a:real[n-1]=~ '\<v:\d\+_\>')
	  " \ ? a:real[n-1]
	  " \ : string(a:real[n-1])
    let new = s:ToString(a:real[n-1])
    " let new = string(a:real[n-1]) " -> bind_counpound vars
    let expr = ((p>0) ? (expr[0:p-1]) : '') . new . expr[e : -1]
    " echo expr
    let p += len(new)
    " silent! unlet new
  endwhile

  return expr
endfunction

" # Function: s:Execute(arguments...) {{{2
function! s:Execute(args) dict
  if type(self.function) == type(function('exists'))
    let args = s:DoBindList(self.args, a:args)
    " echomsg '##'.string(self.function).'('.join(args, ',').')'
    let res = eval(string(self.function).'('.s:Join(args).')')
  elseif type(self.function) == type('string')
    let expr = s:DoBindString(self.function, 'a:args')
    let res = eval(expr)
  elseif type(self.function) == type({})
    return self.function.execute(a:args)
  else
    throw "lh#functor#execute: unpected function type: ".type(self.function)
  endif
  return res
endfunction

" # Function: lh#function#prepare(function, arguments_list) {{{2
function! lh#function#prepare(Fn, arguments_list)
  if     type(a:Fn) == type(function('exists'))
    let expr = string(a:Fn).'('.s:Join(a:arguments_list).')'
    return expr
  elseif type(a:Fn) == type('string')
    if a:Fn =~ '^[a-zA-Z0-9_#]\+$'
      let expr = string(function(a:Fn)).'('.s:Join(a:arguments_list).')'
      return expr
    else
      let expr = s:DoBindString(a:Fn, 'a:000')
      return expr
    endif
  else
    throw "lh#function#prepare(): {Fn} argument of type ".type(a:Fn). " is unsupported"
  endif
endfunction

" # Function: lh#function#execute(function, arguments...) {{{2
function! lh#function#execute(Fn, ...)
  if type(a:Fn) == type({}) && has_key(a:Fn, 'execute')
    return a:Fn.execute(a:000)
  else
    let expr = lh#function#prepare(a:Fn, a:000)
    return eval(expr)
  endif
endfunction

" # Function: lh#function#bind(function, arguments...) {{{2
function! lh#function#bind(Fn, ...)
  let args = copy(a:000)
  if type(a:Fn) == type('string') && a:Fn =~ '^[a-zA-Z0-9_#]\+$'
	\ && exists('*'.a:Fn)
    let Fn = function(a:Fn)
  elseif type(a:Fn) == type({})
    " echo string(a:Fn).'('.string(a:000).')'
    " Rebinding another binded function
    " TASSERT has_key(a:Fn, 'function')
    " TASSERT has_key(a:Fn, 'execute')
    " TASSERT has_key(a:Fn, 'args')
    let Fn = a:Fn.function
    let N = len(a:Fn.args)
    if N != 0 " args to rebind
      let i = 0
      let t_args = [] " necessary to avoid type changes
      while i != N
	silent! unlet arg
	let arg = a:Fn.args[i]
	if arg =~ 'v:\d\+_$'
	  let arg2 = eval(s:DoBindString(arg, string(args)))
	  " echo arg."-(".string(args).")->".string(arg2)
	  unlet arg
	  let arg = arg2
	  unlet arg2
	endif
	call add(t_args, arg)
	let i += 1
      endwhile
      unlet a:Fn.args
      let a:Fn.args = t_args
    else " expression to fix
      " echo Fn
      " echo s:DoBindString(Fn, string(args))
      " echo eval(string(s:DoBindString(Fn, string(args))))
      let Fn = (s:DoBindEvaluatedString(Fn, args))
    endif
    let args = a:Fn.args
  else
    let Fn = a:Fn
  endif

  let binded_fn = {
	\ 'function': Fn,
	\ 'args':     args,
	\ 'execute':  function('s:Execute')
	\}
  return binded_fn
endfunction

" }}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
" Vim: let g:UTfiles='tests/lh/function.vim'
