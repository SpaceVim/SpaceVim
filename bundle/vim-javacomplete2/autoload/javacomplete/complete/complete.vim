" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" This file contains everything related to completions

let b:dotexpr = ''
let b:incomplete = ''
let b:errormsg = ''

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[complete] ". log)
endfunction

function! s:Init()
  let g:JC_ClassnameCompletedFlag = 0
  let b:dotexpr = ''
  let b:incomplete = ''
  let b:context_type = 0

  let s:et_whole = reltime()
endfunction

function! javacomplete#complete#complete#Complete(findstart, base, is_filter)
  if get(g:, 'JavaComplete_Disabled', 0)
    return
  endif

  call javacomplete#highlights#Drop()

  if a:findstart
    call s:Init()
    return javacomplete#complete#context#FindContext()
  endif

  let base = (a:is_filter) ? a:base :
        \    (a:base =~ '^@') ? a:base[:2] : a:base[:1]
  let result = javacomplete#complete#context#ExecuteContext(base)

  if g:JavaComplete_CompletionResultSort
    call sort(result)
  endif

  if len(result) > 0
    " filter according to b:incomplete
    if a:is_filter && b:incomplete != '' && b:incomplete != '+'
      let result = filter(result,
            \ "type(v:val) == type('') ? v:val =~ '^" . b:incomplete . "' : v:val['word'] =~ '^" . b:incomplete . "'")
    endif

    if exists('s:padding') && !empty(s:padding)
      for item in result
        if type(item) == type("")
          let item .= s:padding
        else
          let item.word .= s:padding
        endif
      endfor
      unlet s:padding
    endif

    if type(result) == type([])
      call s:Log('finish completion' . reltimestr(reltime(s:et_whole)) . 's')
      return result
    endif
  endif

  if len(get(b:, 'errormsg', '')) > 0
    call javacomplete#ClearCache()

    if get(g:, 'JavaComplete_IgnoreErrorMsg', 0) <= 0
      echom 'javacomplete error: ' . b:errormsg
      let b:errormsg = ''
    endif
  endif

  return []
endfunction

function! javacomplete#complete#complete#CompleteAfterOverride()
  call s:Log("complete after override")

  let ti = javacomplete#collector#DoGetClassInfo('this')
  let s = ''
  for i in get(ti, 'extends', [])
    let parentInfo = javacomplete#collector#DoGetClassInfo(i)
    let members = javacomplete#complete#complete#SearchMember(parentInfo, '', 1, 1, 1, 14, 0)
    let s .= s:DoGetMethodList(members[1], 14, 0)
    unlet i
  endfor
  let s = substitute(s, '\<\(abstract\|default\|native\)\s\+', '', 'g')
  let s = javacomplete#util#CleanFQN(s)
  let result = eval('[' . s . ']')
  if !empty(result)
    let g:JC_DeclarationCompletedFlag = 1
  endif
  return result
endfunction

function! javacomplete#complete#complete#CompleteSimilarClasses(base)
  call s:Log("complete similar classes. base: ". a:base)

  let result = []
  if a:base =~ g:RE_ANNOTATION || a:base == '@'
    let response = javacomplete#server#Communicate("-similar-annotations", a:base[1:], 'Filter packages by incomplete class name')
  else
    let b:incomplete = a:base
    let response = javacomplete#server#Communicate("-similar-classes", a:base, 'Filter packages by incomplete class name')
  endif
  if response =~ '^['
    call extend(result, eval(response))
  endif
  if !empty(result)
    let g:JC_ClassnameCompletedFlag = 1
  endif
  return result
endfunction

function! javacomplete#complete#complete#CompleteSimilarClassesAndLocalMembers(base)
  call s:Log("complete similar classes and local fields. base: ". a:base)

  let result =
        \ javacomplete#complete#complete#CompleteSimilarClasses(a:base) +
        \ s:DoGetMemberList(javacomplete#collector#DoGetClassInfo('this'), 7)
  if !empty(result)
    let g:JC_ClassnameCompletedFlag = 1
  endif
  return result
endfunction

function! javacomplete#complete#complete#CompleteAnnotationsParameters(name)
  call s:Log("complete annotation parameters. name: ". a:name)

  let result = []
  let last = split(a:name, '@')[-1]
  let identList = matchlist(last, '\('. g:RE_IDENTIFIER. '\)\((\|$\)')
  if !empty(identList)
    let name = identList[1]
    let ti = javacomplete#collector#DoGetClassInfo(name)
    if has_key(ti, 'methods')
      let methods = []
      for m in ti.methods
        if javacomplete#util#CheckModifier(m.m, g:JC_MODIFIER_ABSTRACT) && m.n !~ '^\(toString\|annotationType\|equals\|hashCode\)$'
          call add(methods, m)
        endif
      endfor
      call extend(result, eval('[' . s:DoGetMethodList(methods, 0, 2) . ']'))
    endif

  endif

  return result
endfunction

" Precondition:	expr must end with '.'
" return members of the value of expression
function! javacomplete#complete#complete#CompleteAfterDot(expr)
  call s:Log("complete after dot. expr: ". a:expr)

  let items = javacomplete#scanner#ParseExpr(a:expr)		" TODO: return a dict containing more than items
  if empty(items)
    return []
  endif


  " 0. String literal
  if items[-1] =~  '\("\|"\.\)$'
    call s:Log('P1. "str".|')
    return s:GetMemberList("java.lang.String")
  endif


  let ti = {}
  let ii = 1		" item index
  let itemkind = 0

  " optimized process
  " search the longest expr consisting of ident
  let i = 1
  let k = i
  while i < len(items) && items[i] =~ '^\s*' . g:RE_IDENTIFIER . '\s*$'
    let ident = substitute(items[i], '\s', '', 'g')
    if ident == 'class' || ident == 'this' || ident == 'super'
      let k = i
      " return when found other keywords
    elseif javacomplete#util#IsKeyword(ident)
      return []
    endif
    let items[i] = substitute(items[i], '\s', '', 'g')
    let i += 1
  endwhile

  if i > 1
    " cases: "this.|", "super.|", "ClassName.this.|", "ClassName.super.|", "TypeName.class.|"
    if items[k] ==# 'class' || items[k] ==# 'this' || items[k] ==# 'super'
      call s:Log('O1. ' . items[k] . ' ' . join(items[:k-1], '.'))
      let ti = javacomplete#collector#DoGetClassInfo(items[k] == 'class' ? 'java.lang.Class' : join(items[:k-1], '.'))
      if !empty(ti)
        let itemkind = items[k] ==# 'this' ? 1 : items[k] ==# 'super' ? 2 : 0
        let ii = k+1
      else
        return []
      endif

      " case: "java.io.File.|"
    else
      let fqn = join(items[:i-1], '.')
      let srcpath = join(s:GetSourceDirs(expand('%:p'), javacomplete#collector#GetPackageName()), ',')
      call s:Log('O2. ' . fqn)
      call javacomplete#collector#FetchClassInfo(fqn)
      if get(get(g:JavaComplete_Cache, fqn, {}), 'tag', '') == 'CLASSDEF'
        let ti = g:JavaComplete_Cache[fqn]
        let itemkind = 11
        let ii = i
      endif
    endif
  else
    if items[0] =~ '^\s*' . g:RE_IDENTIFIER . '\s*('
      call insert(items, 'this', 0)
    endif
  endif

  " first item
  if empty(ti)
    if items[0] =~  '\("\|"\.\)$'
      let items[0] = "new String()"
    endif

    " cases:
    " 1) "int.|", "void.|"	- primitive type or pseudo-type, return `class`
    " 2) "this.|", "super.|"	- special reference
    " 3) "var.|"		- variable or field
    " 4) "String.|" 		- type imported or defined locally
    " 5) "java.|"   		- package
    if items[0] =~ '^\s*' . g:RE_IDENTIFIER . '\s*$'
      let ident = substitute(items[0], '\s', '', 'g')

      if javacomplete#util#IsKeyword(ident)
        " 1)
        call s:Log('F1. "' . ident . '.|"')
        if ident ==# 'void' || javacomplete#util#IsBuiltinType(ident)
          let ti = g:J_PRIMITIVE_TYPE_INFO
          let itemkind = 11

          " 2)
          call s:Log('F2. "' . ident . '.|"')
        elseif ident ==# 'this' || ident ==# 'super'
          let itemkind = ident ==# 'this' ? 1 : ident ==# 'super' ? 2 : 0
          let ti = javacomplete#collector#DoGetClassInfo(ident)
        endif

      else
        " 3)
        let typename = javacomplete#collector#GetDeclaredClassName(ident)
        call s:Log('F3. "' . ident . '.|"  typename: "' . typename . '"')
        if (typename != '')
          if typename[0] == '[' || typename[-1:] == ']'
            let ti = g:J_ARRAY_TYPE_INFO
          elseif typename != 'void' && !javacomplete#util#IsBuiltinType(typename)
            let ti = javacomplete#collector#DoGetClassInfo(typename)
          endif

        else
          " 4)
          call s:Log('F4. "TypeName.|"')
          let ti = javacomplete#collector#DoGetClassInfo(ident)
          let itemkind = 11

          if get(ti, 'tag', '') != 'CLASSDEF' || get(ti, 'name', '') == 'java.lang.Object'
            let tib = ti
            let ti = {}
          endif

          " 5)
          if empty(ti)
            call s:Log('F5. "package.|"')
            unlet ti
            let ti = s:GetMembers(ident)	" s:DoGetPackegInfo(ident)
            if empty(ti)
              unlet ti
              let ti = tib
            else
              let itemkind = 20
            endif
          endif
        endif
      endif

      " array type, return `class`: "int[] [].|", "java.lang.String[].|", "NestedClass[].|"
    elseif items[0] =~# g:RE_ARRAY_TYPE
      call s:Log('array type. "' . items[0] . '"')
      let qid = substitute(items[0], g:RE_ARRAY_TYPE, '\1', '')
      if javacomplete#util#IsBuiltinType(qid) || (!javacomplete#util#HasKeyword(qid) && !empty(javacomplete#collector#DoGetClassInfo(qid)))
        let ti = g:J_PRIMITIVE_TYPE_INFO
        let itemkind = 11
      endif

      " class instance creation expr:	"new String().|", "new NonLoadableClass().|"
      " array creation expr:	"new int[i=1] [val()].|", "new java.lang.String[].|"
    elseif items[0] =~ '^\s*new\s\+'
      let joinedItems = join(items,'.')
      call s:Log('creation expr. "' . joinedItems . '"')
      let subs = split(substitute(joinedItems, '^\s*new\s\+\(' .g:RE_QUALID. '\)\s*\([<([]\|\)', '\1;\2', ''), ';')
      if len(subs) == 1
        let ti = javacomplete#collector#DoGetClassInfo(subs[0])
        if get(ti, 'tag', '') == 'CLASSDEF' && get(ti, 'name', '') != 'java.lang.Object'
          let members = javacomplete#complete#complete#SearchMember(ti, '', 1, itemkind, 1, 0)
          return eval('['. s:DoGetNestedList(members[3]) . ']')
        endif
        return s:GetMembers(subs[0])	" may be a package
      elseif subs[1][0] == '['
        let ti = g:J_ARRAY_TYPE_INFO
      elseif subs[1][0] == '(' || subs[1] =~ '<>(.*'
        let splitted = split(subs[0], '\.')
        if len(splitted) > 1
          let directFqn = javacomplete#imports#SearchSingleTypeImport(splitted[0], javacomplete#imports#GetImports('imports_fqn', javacomplete#GetCurrentFileKey()))
          if empty(directFqn)
            let s = subs[0]
          else
            let s = substitute(subs[0], '\.', '\$', 'g')
          endif
        else
          let s = subs[0]
        endif
        let ti = javacomplete#collector#DoGetClassInfo(s)
        " exclude interfaces and abstract class.  TODO: exclude the inaccessible
        if get(ti, 'flags', '')[-10:-10] || get(ti, 'flags', '')[-11:-11]
          echo 'cannot instantiate the type ' . subs[0]
          let ti = {}
          return []
        endif
      endif

      " casting conversion:	"(Object)o.|"
    elseif items[0] =~ g:RE_CASTING
      call s:Log('Casting conversion. "' . items[0] . '"')
      let subs = split(substitute(items[0], g:RE_CASTING, '\1;\2', ''), ';')
      let ti = javacomplete#collector#DoGetClassInfo(subs[0])

      " array access:	"var[i][j].|"		Note: "var[i][]" is incorrect
    elseif items[0] =~# g:RE_ARRAY_ACCESS
      let subs = split(substitute(items[0], g:RE_ARRAY_ACCESS, '\1;\2', ''), ';')
      if get(subs, 1, '') !~ g:RE_BRACKETS
        let typename = javacomplete#collector#GetDeclaredClassName(subs[0])
        if type(typename) == type([])
          let typename = typename[0]
        endif
        call s:Log('ArrayAccess. "' .items[0]. '.|"  typename: "' . typename . '"')
        if (typename != '')
          let ti = javacomplete#complete#complete#ArrayAccess(typename, items[0])
        endif
      endif
    endif
  endif


  "
  " next items
  "
  while !empty(ti) && ii < len(items)
    " method invocation:	"PrimaryExpr.method(parameters)[].|"
    if items[ii] =~ '^\s*' . g:RE_IDENTIFIER . '\s*('
      let tmp = ti
      unlet ti
      let ti = javacomplete#collector#MethodInvocation(items[ii], tmp, itemkind)
      unlet tmp
      let itemkind = 0
      let ii += 1
      continue


      " expression of selection, field access, array access
    elseif items[ii] =~ g:RE_SELECT_OR_ACCESS
      let subs = split(substitute(items[ii], g:RE_SELECT_OR_ACCESS, '\1;\2', ''), ';')
      let ident = subs[0]
      let brackets = get(subs, 1, '')

      " package members
      if itemkind/10 == 2 && empty(brackets) && !javacomplete#util#IsKeyword(ident)
        let qn = join(items[:ii], '.')
        call s:Log("package members: ". qn)
        if type(ti) == type([])
          let idx = javacomplete#util#Index(ti, ident, 'word')
          if idx >= 0
            if ti[idx].kind == 'P'
              unlet ti
              let ti = s:GetMembers(qn)
              let ii += 1
              continue
            elseif ti[idx].kind == 'C'
              unlet ti
              let ti = javacomplete#collector#DoGetClassInfo(qn)
              let itemkind = 11
              let ii += 1
              continue
            endif
          endif
        endif


        " type members
      elseif itemkind/10 == 1 && empty(brackets)
        if ident ==# 'class' || ident ==# 'this' || ident ==# 'super'
          call s:Log("type members: ". ident)
          let ti = javacomplete#collector#DoGetClassInfo(ident == 'class' ? 'java.lang.Class' : join(items[:ii-1], '.'))
          let itemkind = ident ==# 'this' ? 1 : ident ==# 'super' ? 2 : 0
          let ii += 1
          continue

        elseif !javacomplete#util#IsKeyword(ident) && type(ti) == type({}) && get(ti, 'tag', '') == 'CLASSDEF'
          " accessible static field
          call s:Log("static fields: ". ident)
          let members = javacomplete#complete#complete#SearchMember(ti, ident, 1, itemkind, 1, 0)
          if !empty(members[2])
            let ti = javacomplete#complete#complete#ArrayAccess(members[2][0].t, items[ii])
            let itemkind = 0
            let ii += 1
            continue
          endif

          " accessible nested type
          "if !empty(filter(copy(get(ti, 'classes', [])), 'strpart(v:val, strridx(v:val, ".")) ==# "' . ident . '"'))
          if !empty(members[0])
            let ti = javacomplete#collector#DoGetClassInfo(join(items[:ii], '.'))
            let ii += 1
            continue
          endif

          if !empty(members[3])
            if len(members[3]) > 0
              let found = 0
              for entry in members[3]
                if has_key(entry, 'n') && entry.n == ident && has_key(entry, 'm')
                  let ti = javacomplete#collector#DoGetClassInfo(entry.m)
                  let ii += 1
                  let found = 1
                  break
                endif
              endfor
              if found
                continue
              endif
            endif
          endif
        endif


        " instance members
      elseif itemkind/10 == 0 && !javacomplete#util#IsKeyword(ident)
        if type(ti) == type({}) && get(ti, 'tag', '') == 'CLASSDEF'
          call s:Log("instance members")
          let members = javacomplete#complete#complete#SearchMember(ti, ident, 1, itemkind, 1, 0)
          let itemkind = 0
          if !empty(members[2])
            let ti = javacomplete#complete#complete#ArrayAccess(members[2][0].t, items[ii])
            let ii += 1
            continue
          endif
        endif
      endif
    endif

    return []
  endwhile


  " type info or package info --> members
  if !empty(ti)
    if type(ti) == type({})
      if get(ti, 'tag', '') == 'CLASSDEF'
        if get(ti, 'name', '') == '!'
          return [{'kind': 'f', 'word': 'class', 'menu': 'Class'}]
        elseif get(ti, 'name', '') == '['
          return g:J_ARRAY_TYPE_MEMBERS
        elseif itemkind < 20
          return s:DoGetMemberList(ti, itemkind)
        endif
      elseif get(ti, 'tag', '') == 'PACKAGE'
        " TODO: ti -> members, in addition to packages in dirs
        return s:GetMembers( substitute(join(items, '.'), '\s', '', 'g') )
      endif
    elseif type(ti) == type([])
      return ti
    endif
  endif

  return []
endfunction

function! s:GetSourceDirs(filepath, ...)
  call s:Log("get source dirs. filepath: ". a:filepath)

  let dirs = exists('s:sourcepath') ? s:sourcepath : []

  if !empty(a:filepath)
    let filepath = fnamemodify(a:filepath, ':p:h')

    " get source path according to file path and package name
    let packageName = a:0 > 0 ? a:1 : javacomplete#collector#GetPackageName()
    if packageName != ''
      let path = fnamemodify(substitute(filepath, packageName, '', 'g'), ':p:h')
      if index(dirs, path) < 0
        call add(dirs, path)
      endif
    endif

    " Consider current path as a sourcepath
    if index(dirs, filepath) < 0
      call add(dirs, filepath)
    endif
  endif
  return dirs
endfunction

" return only classpath which are directories
function! s:GetClassDirs()
  let dirs = []
  for path in split(javacomplete#server#GetClassPath(), g:PATH_SEP)
    if isdirectory(path)
      call add(dirs, fnamemodify(path, ':p:h'))
    endif
  endfor
  return dirs
endfunction

function! javacomplete#complete#complete#GetPackageName()
  return javacomplete#collector#GetPackageName()
endfunction

function! javacomplete#complete#complete#ArrayAccess(arraytype, expr)
  call s:Log("array access. typename: ". a:arraytype. ", expr: ". a:expr)

  if a:expr =~ g:RE_BRACKETS	| return {} | endif
  let typename = a:arraytype

  let dims = 0
  if typename[0] == '[' || typename[-1:] == ']' || a:expr[-1:] == ']'
    let dims = javacomplete#util#CountDims(a:expr) - javacomplete#util#CountDims(typename)
    if dims == 0
      let typename = typename[0 : stridx(typename, '[') - 1]
    elseif dims < 0
      return g:J_ARRAY_TYPE_INFO
    else
      "echoerr 'dims exceeds'
    endif
  endif
  if dims == 0
    if typename != 'void' && !javacomplete#util#IsBuiltinType(typename)
      return javacomplete#collector#DoGetClassInfo(typename)
    endif
  endif
  return {}
endfunction

function! s:CanAccess(mods, kind, outputkind, samePackage, isinterface)
  if a:outputkind == 14
    return javacomplete#util#CheckModifier(a:mods, [g:JC_MODIFIER_PUBLIC, g:JC_MODIFIER_PROTECTED, g:JC_MODIFIER_ABSTRACT]) && !javacomplete#util#CheckModifier(a:mods, g:JC_MODIFIER_FINAL)
  endif
  if a:outputkind == 15
    return javacomplete#util#IsStatic(a:mods)
  endif
  return (a:mods[-4:-4] || a:kind/10 == 0)
        \ &&   (a:kind == 1 || a:mods[-1:]
        \	|| (a:mods[-3:-3] && (a:kind == 1 || a:kind == 2 || a:kind == 7 || a:samePackage))
        \	|| (a:mods == 0 && (a:samePackage || a:isinterface))
        \	|| (a:mods[-2:-2] && (a:kind == 1 || a:kind == 7)))
endfunction

function! javacomplete#complete#complete#SearchMember(ci, name, fullmatch, kind, returnAll, outputkind, ...)
  call s:Log("search member. name: ". a:name. ", kind: ". a:kind. ", outputkind: ". a:outputkind)

  let samePackage = javacomplete#complete#complete#GetPackageName() ==
        \ javacomplete#util#GetClassPackage(a:ci.name)
  let result = [[], [], [], []]

  let isinterface = get(a:ci, 'interface', 0)

  if a:kind != 13
    if a:outputkind != 14
      for m in (a:0 > 0 && a:1 ? [] : get(a:ci, 'fields', [])) + ((a:kind == 1 || a:kind == 2 || a:kind == 7) ? get(a:ci, 'declared_fields', []) : [])
        if empty(a:name) || (a:fullmatch ? m.n ==# a:name : m.n =~# '^' . a:name)
          if s:CanAccess(m.m, a:kind, a:outputkind, samePackage, isinterface)
            call add(result[2], m)
          endif
        endif
      endfor
    endif

    for m in (a:0 > 0 && a:1 ? [] : get(a:ci, 'methods', [])) + ((a:kind == 1 || a:kind == 2 || a:kind == 7) ? get(a:ci, 'declared_methods', []) : [])
      if empty(a:name) || (a:fullmatch ? m.n ==# a:name : m.n =~# '^' . a:name)
        if s:CanAccess(m.m, a:kind, a:outputkind, samePackage, isinterface)
          call add(result[1], m)
        endif
      endif
    endfor
  endif

  for c in get(a:ci, 'nested', [])
    let _c = substitute(c, '\$', '.', '')
    if has_key(g:JavaComplete_Cache, _c)
      let nestedClass = g:JavaComplete_Cache[_c]
      if a:kind == 12
        if javacomplete#util#IsStatic(nestedClass.flags)
          call add(result[3], {'n': split(c, '\$')[-1], 'm':c})
        endif
      else
        call add(result[3], {'n': split(c, '\$')[-1], 'm':c})
      endif
    else
      call add(result[3], {'n': split(c, '\$')[-1], 'm':c})
    endif
  endfor

  if a:kind/10 != 0
    let types = get(a:ci, 'classes', [])
    for t in types
      if empty(a:name) || (a:fullmatch ? t[strridx(t, '.')+1:] ==# a:name : t[strridx(t, '.')+1:] =~# '^' . a:name)
        if !has_key(g:JavaComplete_Cache, t) || !has_key(g:JavaComplete_Cache[t], 'flags') || a:kind == 1 || g:JavaComplete_Cache[t].flags[-1:]
          call add(result[0], t)
        endif
      endif
    endfor
  endif

  " key `classpath` indicates it is a loaded class from classpath
  " all public members of a loaded class are stored in current ci
  if !has_key(a:ci, 'classpath') || (a:kind == 1 || a:kind == 2)
    for i in get(a:ci, 'extends', [])
      if type(i) == type("") && i == get(a:ci, 'fqn', '')
        continue
      elseif type(i) == type({}) && i.tag == 'ERRONEOUS'
        continue
      endif
      let ci = javacomplete#collector#DoGetClassInfo(java_parser#type2Str(i))
      if type(ci) == type([])
        let ci = ci[0]
      endif
      if a:outputkind == 15
        let outputkind = 11
      else
        let outputkind = a:outputkind
      endif
      let members = javacomplete#complete#complete#SearchMember(ci, a:name, a:fullmatch, a:kind == 1 ? 2 : a:kind, a:returnAll, outputkind)
      let result[0] += members[0]
      let result[1] += members[1]
      let result[2] += members[2]
      unlet i
    endfor
  endif
  return result
endfunction

function! s:DoGetNestedList(classes)
  let s = ''
  let useFQN = javacomplete#UseFQN()
  for class in a:classes
    if !useFQN
      let fieldType = javacomplete#util#CleanFQN(class.m)
    else
      let fieldType = class.m
    endif
    let s .= "{'kind':'C','word':'". class.n . "','menu':'". fieldType . "','dup':1},"
  endfor

  return s
endfunction

function! s:DoGetFieldList(fields)
  let s = ''
  let useFQN = javacomplete#UseFQN()
  for field in a:fields
    if !has_key(field, 't')
      continue
    endif
    if type(field.t) == type([])
      let fieldType = field.t[0]
      let args = ''
      for arg in field.t[1]
        let args .= arg. ','
      endfor
      if len(args) > 0
        let fieldType .= '<'. args[0:-2]. '>'
      endif
    else
      let fieldType = field.t
    endif
    if !useFQN
      let fieldType = javacomplete#util#CleanFQN(fieldType)
    endif
    let s .= "{'kind':'" . (javacomplete#util#IsStatic(field.m) ? "F" : "f") . "','word':'" . field.n . "','menu':'" . fieldType . "','dup':1},"
  endfor
  return s
endfunction

function! javacomplete#complete#complete#DoGetMethodList(methods, kind, ...)
  return s:DoGetMethodList(a:methods, a:kind, a:000)
endfunction

function! s:DoGetMethodList(methods, kind, ...)
  let paren = a:0 == 0 || !a:1 ? '(' : (a:1 == 2) ? ' = ' : ''

  let abbrEnd = ''
  if b:context_type != g:JC__CONTEXT_METHOD_REFERENCE
    if a:0 == 0 || !a:1
      let abbrEnd = '()'
    endif
  endif

  let methodNames = map(copy(a:methods), 'v:val.n')

  let useFQN = javacomplete#UseFQN()
  let s = ''
  let origParen = paren
  for method in a:methods
    if !useFQN
      let method.d = javacomplete#util#CleanFQN(method.d)
    endif
    let paren = origParen
    if paren == '('
      if count(methodNames, method.n) == 1
        if !has_key(method, 'p')
          let paren = '()'
        endif
      endif
    endif
    let s .= "{'kind':'" . (javacomplete#util#IsStatic(method.m) ? "M" : "m") . "','word':'" . s:GenWord(method, a:kind, paren) . "','abbr':'" . method.n . abbrEnd . "','menu':'" . method.d . "','info':'" . method.d ."','dup':'1'},"
  endfor

  return s
endfunction

function! s:GenWord(method, kind, paren)
  if a:kind == 14

    return javacomplete#util#GenMethodParamsDeclaration(a:method). ' {'
  else
    if b:context_type != g:JC__CONTEXT_METHOD_REFERENCE
      if !empty(a:paren)
        return a:method.n . a:paren
      else
        return a:method.n . '()'
      endif
    endif

    return a:method.n
  endif
endfunction

function! s:UniqDeclaration(members)
  let declarations = {}
  for m in a:members
    let declarations[javacomplete#util#CleanFQN(m.d)] = m
  endfor
  let result = []
  for k in keys(declarations)
    call add(result, declarations[k])
  endfor
  return result
endfunction

" kind:
"	0 - for instance, 1 - this, 2 - super, 3 - class, 4 - array, 5 - method result, 6 - primitive type, 7 - local fields
"	11 - for type, with `class` and static member and nested types.
"	12 - for import static, no lparen for static methods
"	13 - for import or extends or implements, only nested types
"   14 - for public, protected methods of extends/implements. abstract first.
"	20 - for package
function! s:DoGetMemberList(ci, outputkind)
  call s:Log("get member list. outputkind: ". a:outputkind)

  let kind = a:outputkind
  let outputkind = a:outputkind
  if type(a:ci) != type({}) || a:ci == {}
    return []
  endif

  let s = ''
  if b:context_type == g:JC__CONTEXT_METHOD_REFERENCE
    let kind = 0
    if outputkind != 0
      let s = "{'kind': 'M', 'word': 'new', 'menu': 'new'},"
    endif
  endif

  if kind == 11
    let tmp = javacomplete#collector#DoGetClassInfo('this')
    if tmp.name == get(a:ci, 'name', '')
      let outputkind = 15
    endif
  endif

  let members = javacomplete#complete#complete#SearchMember(a:ci, '', 1, kind, 1, outputkind, kind == 2)
  let members[1] = s:UniqDeclaration(members[1])

  let s .= kind == 11 ? "{'kind': 'C', 'word': 'class', 'menu': 'Class'}," : ''

  " add accessible member types
  if kind / 10 != 0
    " Use dup here for member type can share name with field.
    for class in members[0]
      "for class in get(a:ci, 'classes', [])
      let v = get(g:JavaComplete_Cache, class, {})
      if v == {} || v.flags[-1:]
        let s .= "{'kind': 'C', 'word': '" . substitute(class, a:ci.name . '\.', '\1', '') . "','dup':1},"
      endif
    endfor
  endif

  if kind != 13
    let fieldlist = []
    let sfieldlist = []
    for field in members[2]
      "for field in get(a:ci, 'fields', [])
      if javacomplete#util#IsStatic(field['m'])
        if kind != 1
          call add(sfieldlist, field)
        endif
      elseif kind / 10 == 0
        call add(fieldlist, field)
      endif
    endfor

    let methodlist = []
    let smethodlist = []
    for method in members[1]
      if javacomplete#util#IsStatic(method['m'])
        if kind != 1
          call add(smethodlist, method)
        endif
      elseif kind / 10 == 0
        call add(methodlist, method)
      endif
    endfor

    if kind / 10 == 0
      let s .= s:DoGetFieldList(fieldlist)
      let s .= s:DoGetMethodList(methodlist, outputkind)
    endif
    if b:context_type != g:JC__CONTEXT_METHOD_REFERENCE
      let s .= s:DoGetFieldList(sfieldlist)
    endif

    let s .= s:DoGetMethodList(smethodlist, outputkind, kind == 12)
    let s .= s:DoGetNestedList(members[3])

    let s = substitute(s, '\<' . a:ci.name . '\.', '', 'g')
    let s = substitute(s, '\<\(public\|static\|synchronized\|transient\|volatile\|final\|strictfp\|serializable\|native\)\s\+', '', 'g')
  else
    let s .= s:DoGetNestedList(members[3])
  endif
  return eval('[' . s . ']')
endfunction

" interface							{{{2

function! s:GetMemberList(class)
  if javacomplete#util#IsBuiltinType(a:class)
    return []
  endif

  return s:DoGetMemberList(javacomplete#collector#DoGetClassInfo(a:class), 0)
endfunction

function! javacomplete#complete#complete#GetConstructorList(class)
  let ci = javacomplete#collector#DoGetClassInfo(a:class)
  if empty(ci)
    return []
  endif

  let s = ''
  for ctor in get(ci, 'ctors', [])
    let s .= "{'kind': '+', 'word':'". a:class . "(','abbr':'" . ctor.d . "','dup':1},"
  endfor

  let s = substitute(s, '\<java\.lang\.', '', 'g')
  let s = substitute(s, '\<public\s\+', '', 'g')
  return eval('[' . s . ']')
endfunction

" Name can be a (simple or qualified) package name, or a (simple or qualified)
" type name.
function! javacomplete#complete#complete#GetMembers(fqn, ...)
  return s:GetMembers(a:fqn, a:000)
endfunction

function! s:GetMembers(fqn, ...)
  call s:Log("get members. fqn: ". a:fqn)

  let list = []
  let isClass = 0

  if b:context_type == g:JC__CONTEXT_IMPORT_STATIC || b:context_type == g:JC__CONTEXT_IMPORT
    let res = javacomplete#server#Communicate('-E', a:fqn, 's:GetMembers for static')
    if res =~ "^{'"
      let dict = eval(res)
      for key in keys(dict)
        let g:JavaComplete_Cache[substitute(key, '\$', '.', 'g')] = javacomplete#util#Sort(dict[key])
      endfor
    endif
  endif

  call javacomplete#collector#FetchInfoFromServer(a:fqn, '-p')
  let v = get(g:JavaComplete_Cache, a:fqn, {})
  if type(v) == type([])
    let list = v
  elseif type(v) == type({}) && v != {}
    if get(v, 'tag', '') == 'PACKAGE'
      if b:context_type == g:JC__CONTEXT_IMPORT_STATIC || b:context_type == g:JC__CONTEXT_IMPORT
        call add(list, {'kind': 'P', 'word': '*;'})
      endif
      if b:context_type != g:JC__CONTEXT_PACKAGE_DECL
        for c in sort(get(v, 'classes', []))
          call add(list, {'kind': 'C', 'word': c})
        endfor
      endif
      for p in sort(get(v, 'subpackages', []))
        call add(list, {'kind': 'P', 'word': p})
      endfor
    else
      let isClass = 1
      let list += s:DoGetMemberList(v, b:context_type == g:JC__CONTEXT_IMPORT || b:context_type == g:JC__CONTEXT_COMPLETE_CLASSNAME ? 13 : b:context_type == g:JC__CONTEXT_IMPORT_STATIC ? 12 : 11)
    endif
  endif

  if !isClass
    let list += s:DoGetPackageInfoInDirs(a:fqn, b:context_type == g:JC__CONTEXT_PACKAGE_DECL)
  endif

  return list
endfunction

" a:1 - incomplete mode
" return packages in classes directories or source pathes
function! s:DoGetPackageInfoInDirs(package, onlyPackages, ...)
  call s:Log("package info in directories. package: ". a:package)

  let list = []

  let pathes = s:GetSourceDirs(expand('%:p'))
  for path in s:GetClassDirs()
    if index(pathes, path) <= 0
      call add(pathes, path)
    endif
  endfor

  let globpattern  = a:0 > 0 ? a:package . '*' : substitute(a:package, '\.', '/', 'g') . '/*'
  let matchpattern = a:0 > 0 ? a:package : a:package . '[\\/]'
  for f in split(globpath(join(pathes, ','), globpattern), "\n")
    for path in pathes
      let idx = matchend(f, escape(path, ' \') . '[\\/]\?\C' . matchpattern)
      if idx != -1
        let name = (a:0 > 0 ? a:package : '') . strpart(f, idx)
        if f[-5:] == '.java'
          if !a:onlyPackages
            call add(list, {'kind': 'C', 'word': name[:-6]})
          endif
        elseif name =~ '^' . g:RE_IDENTIFIER . '$' && isdirectory(f) && f !~# 'CVS$'
          call add(list, {'kind': 'P', 'word': name})
        endif
      endif
    endfor
  endfor
  return list
endfunction

" vim:set fdm=marker sw=2 nowrap:
