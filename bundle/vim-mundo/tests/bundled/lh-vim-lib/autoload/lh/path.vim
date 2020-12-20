"=============================================================================
" $Id: path.vim 237 2010-06-01 00:44:35Z luc.hermitte $
" File:		autoload/lh/path.vim                               {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	23rd Jan 2007
" Last Update:	11th Feb 2008
"------------------------------------------------------------------------
" Description:	
"       Functions related to the handling of pathnames
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop this file into {rtp}/autoload/lh
" 	Requires Vim7+
" History:	
"	v 1.0.0 First Version
" 	(*) Functions moved from searchInRuntimeTime  
" 	v 2.0.1
" 	(*) lh#path#Simplify() becomes like |simplify()| except for trailing
" 	v 2.0.2
" 	(*) lh#path#SelectOne() 
" 	(*) lh#path#ToRelative() 
" 	v 2.0.3
" 	(*) lh#path#GlobAsList() 
" 	v 2.0.4
" 	(*) lh#path#StripStart()
" 	v 2.0.5
" 	(*) lh#path#StripStart() interprets '.' as getcwd()
" 	v 2.2.0
" 	(*) new functions: lh#path#common(), lh#path#to_dirname(),
" 	    lh#path#depth(), lh#path#relative_to(), lh#path#to_regex(),
" 	    lh#path#find()
" 	(*) lh#path#simplify() fixed
" 	(*) lh#path#to_relative() use simplify()
" TODO:
"       (*) Decide what #depth('../../bar') shall return
"       (*) Fix #simplify('../../bar')
" }}}1
"=============================================================================


"=============================================================================
" Avoid global reinclusion {{{1
let s:cpo_save=&cpo
set cpo&vim

"=============================================================================
" ## Functions {{{1
" # Debug {{{2
let s:verbose = 0
function! lh#path#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#path#debug(expr)
  return eval(a:expr)
endfunction

"=============================================================================
" # Public {{{2
" Function: lh#path#simplify({pathname}) {{{3
" Like |simplify()|, but also strip the leading './'
" It seems unable to simplify '..\' when compiled without +shellslash
function! lh#path#simplify(pathname)
  let pathname = simplify(a:pathname)
  let pathname = substitute(pathname, '^\%(\.[/\\]\)\+', '', '')
  let pathname = substitute(pathname, '\([/\\]\)\%(\.[/\\]\)\+', '\1', 'g')
  let pwd = getcwd().'/'
  let pathname = substitute(pathname, '^'.lh#path#to_regex(pwd), '', 'g')
  return pathname
endfunction
function! lh#path#Simplify(pathname)
  return lh#path#simplify(a:pathname)
endfunction

" Function: lh#path#common({pathnames}) {{{3
" Find the common leading path between all pathnames
function! lh#path#common(pathnames)
  " assert(len(pathnames)) > 1
  let common = a:pathnames[0]
  let i = 1
  while i < len(a:pathnames)
    let fcrt = a:pathnames[i]
    " pathnames should not contain @
    let common = matchstr(common.'@@'.fcrt, '^\zs\(.*[/\\]\)\ze.\{-}@@\1.*$')
    if strlen(common) == 0
      " No need to further checks
      break
    endif
    let i += 1
  endwhile
  return common
endfunction

" Function: lh#path#strip_common({pathnames}) {{{3
" Find the common leading path between all pathnames, and strip it
function! lh#path#strip_common(pathnames)
  " assert(len(pathnames)) > 1
  let common = lh#path#common(a:pathnames)
  let l = strlen(common)
  if l == 0
    return a:pathnames
  else
  let pathnames = a:pathnames
  call map(pathnames, 'strpart(v:val, '.l.')' )
  return pathnames
  endif
endfunction
function! lh#path#StripCommon(pathnames)
  return lh#path#strip_common(a:pathnames)
endfunction

" Function: lh#path#is_absolute_path({path}) {{{3
function! lh#path#is_absolute_path(path)
  return a:path =~ '^/'
	\ . '\|^[a-zA-Z]:[/\\]'
	\ . '\|^[/\\]\{2}'
  "    Unix absolute path 
  " or Windows absolute path
  " or UNC path
endfunction
function! lh#path#IsAbsolutePath(path)
  return lh#path#is_absolute_path(a:path)
endfunction

" Function: lh#path#is_url({path}) {{{3
function! lh#path#is_url(path)
  " todo: support UNC paths and other urls
  return a:path =~ '^\%(https\=\|s\=ftp\|dav\|fetch\|file\|rcp\|rsynch\|scp\)://'
endfunction
function! lh#path#IsURL(path)
  return lh#path#is_url(a:path)
endfunction

" Function: lh#path#select_one({pathnames},{prompt}) {{{3
function! lh#path#select_one(pathnames, prompt)
  if len(a:pathnames) > 1
    let simpl_pathnames = deepcopy(a:pathnames) 
    let simpl_pathnames = lh#path#strip_common(simpl_pathnames)
    let simpl_pathnames = [ '&Cancel' ] + simpl_pathnames
    " Consider guioptions+=c is case of difficulties with the gui
    let selection = confirm(a:prompt, join(simpl_pathnames,"\n"), 1, 'Question')
    let file = (selection == 1) ? '' : a:pathnames[selection-2]
    return file
  elseif len(a:pathnames) == 0
    return ''
  else
    return a:pathnames[0]
  endif
endfunction
function! lh#path#SelectOne(pathnames, prompt)
  return lh#path#select_one(a:pathnames, a:prompt)
endfunction

" Function: lh#path#to_relative({pathname}) {{{3
function! lh#path#to_relative(pathname)
  let newpath = fnamemodify(a:pathname, ':p:.')
  let newpath = simplify(newpath)
  return newpath
endfunction
function! lh#path#ToRelative(pathname)
  return lh#path#to_relative(a:pathname)
endfunction

" Function: lh#path#to_dirname({dirname}) {{{3
" todo: use &shellslash
function! lh#path#to_dirname(dirname)
  let dirname = a:dirname . (a:dirname[-1:] =~ '[/\\]' ? '' : '/')
  return dirname
endfunction

" Function: lh#path#depth({dirname}) {{{3
" todo: make a choice about "negative" paths like "../../foo"
function! lh#path#depth(dirname)
  if empty(a:dirname) | return 0 | endif
  let dirname = lh#path#to_dirname(a:dirname)
  let dirname = lh#path#simplify(dirname)
  if lh#path#is_absolute_path(dirname)
    let dirname = matchstr(dirname, '.\{-}[/\\]\zs.*')
  endif
  let depth = len(substitute(dirname, '[^/\\]\+[/\\]', '§', 'g'))
  return depth
endfunction

" Function: lh#path#relative_to({from}, {to}) {{{3
" @param two directories
" @return a directories delta that ends with a '/' (may depends on
" &shellslash)
function! lh#path#relative_to(from, to)
  " let from = fnamemodify(a:from, ':p')
  " let to   = fnamemodify(a:to  , ':p')
  let from = lh#path#to_dirname(a:from)
  let to   = lh#path#to_dirname(a:to  )
  let [from, to] = lh#path#strip_common([from, to])
  let nb_up =  lh#path#depth(from)
  return repeat('../', nb_up).to

  " cannot rely on :cd (as it alters things, and doesn't work with
  " non-existant paths)
  let pwd = getcwd()
  exe 'cd '.a:to
  let res = lh#path#to_relative(a:from)
  exe 'cd '.pwd
  return res
endfunction

" Function: lh#path#glob_as_list({pathslist}, {expr}) {{{3
function! s:GlobAsList(pathslist, expr)
  let sResult = globpath(a:pathslist, a:expr)
  let lResult = split(sResult, '\n')
  " workaround a non feature of wildignore: it does not ignore directories
  for ignored_pattern in split(&wildignore,',')
    if stridx(ignored_pattern,'/') != -1
      call filter(lResult, 'v:val !~ '.string(ignored_pattern))
    endif
  endfor
  return lResult
endfunction

function! lh#path#glob_as_list(pathslist, expr)
  if type(a:expr) == type('string')
    return s:GlobAsList(a:pathslist, a:expr)
  elseif type(a:expr) == type([])
    let res = []
    for expr in a:expr
      call extend(res, s:GlobAsList(a:pathslist, expr))
    endfor
    return res
  else
    throw "Unexpected type for a:expression"
  endif
endfunction
function! lh#path#GlobAsList(pathslist, expr)
  return lh#path#glob_as_list(a:pathslist, a:expr)
endfunction

" Function: lh#path#strip_start({pathname}, {pathslist}) {{{3
" Strip occurrence of paths from {pathslist} in {pathname}
" @param[in] {pathname} name to simplify
" @param[in] {pathslist} list of pathname (can be a |string| of pathnames
" separated by ",", of a |List|).
function! lh#path#strip_start(pathname, pathslist)
  if type(a:pathslist) == type('string')
    " let strip_re = escape(a:pathslist, '\\.')
    " let strip_re = '^' . substitute(strip_re, ',', '\\|^', 'g')
    let pathslist = split(a:pathslist, ',')
  elseif type(a:pathslist) == type([])
    let pathslist = deepcopy(a:pathslist)
  else
    throw "Unexpected type for a:pathname"
  endif

  " apply a realpath like operation
  let nb_paths = len(pathslist) " set before the loop
  let i = 0
  while i != nb_paths
    if pathslist[i] =~ '^\.\%(/\|$\)'
      let path2 = getcwd().pathslist[i][1:]
      call add(pathslist, path2)
    endif
    let i += 1
  endwhile
  " replace path separators by a regex that can match them
  call map(pathslist, 'substitute(v:val, "[\\\\/]", "[\\\\/]", "g")')
  " echomsg string(pathslist)
  " escape .
  call map(pathslist, '"^".escape(v:val, ".")')
  " build the strip regex
  let strip_re = join(pathslist, '\|')
  " echomsg strip_re
  let res = substitute(a:pathname, '\%('.strip_re.'\)[/\\]\=', '', '')
  return res
endfunction
function! lh#path#StripStart(pathname, pathslist)
  return lh#path#strip_start(a:pathname, a:pathslist)
endfunction

" Function: lh#path#to_regex({pathname}) {{{3
function! lh#path#to_regex(path)
  let regex = substitute(a:path, '[/\\]', '[/\\\\]', 'g')
  return regex
endfunction

" Function: lh#path#find({pathname}, {regex}) {{{3
function! lh#path#find(paths, regex)
  let paths = (type(a:paths) == type([]))
	\ ? (a:paths) 
	\ : split(a:paths,',')
  for path in paths
    if match(path ,a:regex) != -1
      return path
    endif
  endfor
  return ''
endfunction
"=============================================================================
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
