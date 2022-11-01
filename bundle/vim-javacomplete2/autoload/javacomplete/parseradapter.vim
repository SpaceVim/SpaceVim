" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" Methods that calling internal parser

function! javacomplete#parseradapter#Parse(...)
  let filename = a:0 == 0 ? '%' : a:1
  let currentFilename = javacomplete#GetCurrentFileKey()

  let changed = 0
  if filename == '%' || currentFilename == filename
    let props = get(g:JavaComplete_Files, currentFilename, {})
    if get(props, 'changedtick', -1) != b:changedtick
      let changed = 1
      let props.changedtick = b:changedtick
      let lines = getline('^', '$')
    endif
  else
    let props = get(g:JavaComplete_Files, filename, {})
    if get(props, 'modifiedtime', 0) != getftime(filename)
      let changed = 1
      let props.modifiedtime = getftime(filename)
      if filename =~ '^__'
        let lines = getline('^', '$')
      else
        let lines = readfile(filename)
      endif
    endif
  endif

  if changed
    call java_parser#InitParser(lines)
    call java_parser#SetLogLevel(0)
    let props.unit = java_parser#compilationUnit()

    if &ft == 'jsp'
      return props
    endif

    let package = has_key(props.unit, 'package') ? props.unit.package . '.' : ''
    call s:UpdateFQN(props.unit, package)
  endif
  if filename !~ '^__'
    let g:JavaComplete_Files[filename] = props
  endif
  return props.unit
endfunction

" update fqn for toplevel types or nested types. 
" not for local type or anonymous type
function! s:UpdateFQN(tree, qn)
  if a:tree.tag == 'TOPLEVEL'
    for def in a:tree.types
      call s:UpdateFQN(def, a:qn)
    endfor
  elseif a:tree.tag == 'CLASSDEF'
    let a:tree.fqn = a:qn . a:tree.name
    for def in a:tree.defs
      if type(def) != type([])
        unlet def
        continue
      endif
      if def.tag == 'CLASSDEF'
        call s:UpdateFQN(def, a:tree.fqn . '.')
      endif
    endfor
  endif
endfunction

" TreeVisitor						{{{2
" parent argument exist for lambdas only
function! s:visitTree(tree, param, parent) dict
  if type(a:tree) == type({})
    exe get(self, get(a:tree, 'tag', ''), '')
  elseif type(a:tree) == type([])
    for tree in a:tree
      call self.visit(tree, a:param, a:parent)
      unlet tree
    endfor
  endif
endfunction

" we need to return to parent leafs to get lambda's arguments declaration
function! s:lambdaMeth(tree)
  if a:tree.tag == 'APPLY'
    return {'meth': a:tree.meth, 'stats': {}}
  elseif a:tree.tag == 'VARDEF'
    return {'stats': {'tag': a:tree.tag, 't': a:tree.t, 'name': a:tree.name, 'endpos': a:tree.endpos, 'n': a:tree.n, 'pos': a:tree.pos, 'm': a:tree.m}, 'meth': {}}
  elseif a:tree.tag == 'RETURN'
    return {'stats': {'tag': a:tree.tag, 'endpos': a:tree.endpos, 'pos': a:tree.pos}, 'meth': {}}
  endif
  return {'meth': {}, 'stats': {}}
endfunction

let s:TreeVisitor = {'visit': function('s:visitTree'),
      \ 'lambdameth': function('s:lambdaMeth'),
      \ 'TOPLEVEL'	: 'call self.visit(a:tree.types, a:param, a:tree)',
      \ 'BLOCK'	: 'let stats = a:tree.stats | if stats == [] | call java_parser#GotoPosition(a:tree.pos) | let stats = java_parser#block().stats | endif | call self.visit(stats, a:param, a:tree)',
      \ 'DOLOOP'	: 'call self.visit(a:tree.body, a:param, a:tree) | call self.visit(a:tree.cond, a:param, a:tree)',
      \ 'WHILELOOP'	: 'call self.visit(a:tree.cond, a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree)',
      \ 'FORLOOP'	: 'call self.visit(a:tree.init, a:param, a:tree) | call self.visit(a:tree.cond, a:param, a:tree) | call self.visit(a:tree.step, a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree)',
      \ 'FOREACHLOOP'	: 'call self.visit(a:tree.var, a:param, a:tree)  | call self.visit(a:tree.expr, a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree)',
      \ 'LABELLED'	: 'call self.visit(a:tree.body, a:param, a:tree)',
      \ 'SWITCH'	: 'call self.visit(a:tree.selector, a:param, a:tree) | call self.visit(a:tree.cases, a:param, a:tree)',
      \ 'CASE'	: 'call self.visit(a:tree.pat,  a:param, a:tree) | call self.visit(a:tree.stats, a:param, a:tree)',
      \ 'SYNCHRONIZED': 'call self.visit(a:tree.lock, a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree)',
      \ 'TRY'		: 'call self.visit(a:tree.params, a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree) | call self.visit(a:tree.catchers, a:param, a:tree) | call self.visit(a:tree.finalizer, a:param, a:tree) ',
      \ 'RARROW'		: 'call self.visit(a:tree.body, a:param, a:tree)',
      \ 'CATCH'	: 'call self.visit(a:tree.param,a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree)',
      \ 'CONDEXPR'	: 'call self.visit(a:tree.cond, a:param, a:tree) | call self.visit(a:tree.truepart, a:param, a:tree) | call self.visit(a:tree.falsepart, a:param, a:tree)',
      \ 'IF'		: 'call self.visit(a:tree.cond, a:param, a:tree) | call self.visit(a:tree.thenpart, a:param, a:tree) | if has_key(a:tree, "elsepart") | call self.visit(a:tree.elsepart, a:param, a:tree) | endif',
      \ 'EXEC'	: 'call self.visit(a:tree.expr, a:param, a:tree)',
      \ 'APPLY'	: 'call self.visit(a:tree.meth, a:param, a:tree) | call self.visit(a:tree.args, a:param, a:tree)',
      \ 'NEWCLASS'	: 'call self.visit(a:tree.def, a:param, a:tree)',
      \ 'RETURN'	: 'if has_key(a:tree, "expr") | call self.visit(a:tree.expr, a:param, a:tree) | endif',
      \ 'LAMBDA'	: 'call extend(a:tree, self.lambdameth(a:parent)) | call self.visit(a:tree.meth, a:param, a:tree) | call self.visit(a:tree.stats, a:param, a:tree) | call self.visit(a:tree.args, a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree)'
      \}

let s:TV_CMP_POS = 'a:tree.pos <= a:param.pos && a:param.pos <= get(a:tree, "endpos", -1)'
let s:TV_CMP_POS_BODY = 'has_key(a:tree, "body") && a:tree.body.pos <= a:param.pos && a:param.pos <= get(a:tree.body, "endpos", -1)'

" Return a stack of enclosing types (including local or anonymous classes).
" Given the optional argument, return all (toplevel or static member) types besides enclosing types.
function! javacomplete#parseradapter#SearchTypeAt(tree, targetPos, ...)
  let s:TreeVisitor.CLASSDEF	= 'if a:param.allNonLocal || ' . s:TV_CMP_POS . ' | call add(a:param.result, a:tree) | call self.visit(a:tree.defs, a:param, a:tree) | endif'
  let s:TreeVisitor.METHODDEF	= 'if ' . s:TV_CMP_POS_BODY . ' | call self.visit(a:tree.body, a:param, a:tree) | endif'
  let s:TreeVisitor.VARDEF	= 'if has_key(a:tree, "init") && !a:param.allNonLocal && ' . s:TV_CMP_POS . ' | call self.visit(a:tree.init, a:param, a:tree) | endif'
  let s:TreeVisitor.IDENT = ''

  let result = []
  call s:TreeVisitor.visit(a:tree, {'result': result, 'pos': a:targetPos, 'allNonLocal': a:0 == 0 ? 0 : 1}, {})
  return result
endfunction

" a:1		match beginning
" return	a stack of matching name
function! javacomplete#parseradapter#SearchNameInAST(tree, name, targetPos, fullmatch)
  let comparator = a:fullmatch ? '==#' : '=~# "^" .'
  let cmd = 'if a:tree.name ' .comparator. ' a:param.name | call add(a:param.result, a:tree) | endif'
  let cmdPos = 'if a:tree.name ' .comparator. ' a:param.name && a:tree.pos <= a:param.pos | call add(a:param.result, a:tree) | endif'
  let s:TreeVisitor.CLASSDEF	= 'if ' . s:TV_CMP_POS . ' | ' . cmd . ' | call self.visit(a:tree.defs, a:param, a:tree) | endif'
  let s:TreeVisitor.METHODDEF	= cmd . ' | if ' . s:TV_CMP_POS_BODY . ' | call self.visit(a:tree.params, a:param, a:tree) | call self.visit(a:tree.body, a:param, a:tree) | endif'
  let s:TreeVisitor.VARDEF	= cmdPos . ' | if has_key(a:tree, "init") && ' . s:TV_CMP_POS . ' | call self.visit(a:tree.init, a:param, a:tree) | endif'
  let s:TreeVisitor.IDENT = 'if a:parent.tag == "LAMBDA" && a:parent.body.pos <= a:param.pos | call add(a:param.result, a:parent) | endif'

  let result = []
  call s:TreeVisitor.visit(a:tree, {'result': result, 'pos': a:targetPos, 'name': a:name}, {})
  return result
endfunction

" vim:set fdm=marker sw=2 nowrap:
