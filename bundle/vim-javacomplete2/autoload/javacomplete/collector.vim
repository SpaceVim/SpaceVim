" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" This file contains everything related to collecting source data

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[collector] ". log)
endfunction

" a:1 -	filepath
" a:2 -	package name
function! javacomplete#collector#DoGetClassInfo(class, ...)
  let class = type(a:class) == type({}) ? a:class.name : a:class
  call s:Log("get class info. class: ". class)

  if class != 'this' && class != 'super' && has_key(g:JavaComplete_Cache, class)
    call s:Log("class info from cache")
    return g:JavaComplete_Cache[class]
  endif

  " array type:	TypeName[] or '[I' or '[[Ljava.lang.String;'
  if class[-1:] == ']' || class[0] == '['
    return g:J_ARRAY_TYPE_INFO
  endif

  let filekey = a:0 > 0 && len(a:1) > 0 ? a:1 : javacomplete#GetCurrentFileKey()
  let packagename = a:0 > 1 && len(a:2) > 0 ? a:2 : javacomplete#collector#GetPackageName()

  let unit = javacomplete#parseradapter#Parse(filekey)
  let pos = java_parser#MakePos(line('.') - 1, col('.') - 1)
  let t = get(javacomplete#parseradapter#SearchTypeAt(unit, pos), -1, {})
  if has_key(t, 'extends')
    if type(t.extends) == type([]) && len(t.extends) > 0
      if type(t.extends[0]) == type("")
        let extends = t.extends[0] . '$'. class
      elseif type(t.extends[0]) == type({})
        if has_key(t.extends[0], 'name')
          let className = t.extends[0].name
        elseif has_key(t.extends[0], 'clazz')
          let className = t.extends[0].clazz.name
        else
          let className = ''
        endif
        if !empty(className)
          let imports = javacomplete#imports#GetImports('imports_fqn', filekey)
          let fqn = javacomplete#imports#SearchSingleTypeImport(className, imports)
          let extends = fqn. '$'. a:class
        endif
      else
        let extends = ''
      endif
    else
      let extends = ''
    endif
  else
    let extends = ''
  endif
  if class == 'this' || class == 'super' || (has_key(t, 'fqn') && t.fqn == packagename. '.'. class)
    if &ft == 'jsp'
      let ci = javacomplete#collector#FetchClassInfo('javax.servlet.jsp.HttpJspPage')
      return ci
    endif

    call s:Log('A0. ' . class)
    if !empty(t)
      return javacomplete#util#Sort(s:Tree2ClassInfo(t))
    else
      return {}
    endif
  endif
  for def in get(t, 'defs', [])
    if get(def, 'tag', '') == 'CLASSDEF' && get(def, 'name', '') == class
      return javacomplete#util#Sort(s:Tree2ClassInfo(def))
    endif
  endfor

  let typename = class

  let typeArguments = ''
  let splittedType = s:SplitTypeArguments(typename)
  if type(splittedType) == type([])
    let typename = splittedType[0]
    let typeArguments = splittedType[1]
  endif

  if stridx(typename, '$') > 0
    let sc = split(typename, '\$')
    let typename = sc[0]
    let nested = '$'.sc[1]
  else
    let nested = ''
  endif
  
  let hasKeyword = javacomplete#util#HasKeyword(typename)
  if typename !~ '^\s*' . g:RE_QUALID . '\s*$' || hasKeyword
    call s:Log("no qualid: ". typename)
    return {}
  endif

  let collectedArguments = s:CollectTypeArguments(typeArguments, packagename, filekey)

  let fqns = s:CollectFQNs(typename, packagename, filekey, extends)
  for fqn in fqns
    let fqn = fqn . nested . collectedArguments
    let fqn = substitute(fqn, ' ', '', 'g')
    call javacomplete#collector#FetchClassInfo(fqn)

    let key = s:KeyInCache(fqn)
    if !empty(key)
      return get(g:JavaComplete_Cache[key], 'tag', '') == 'CLASSDEF' ? g:JavaComplete_Cache[key] : {}
    endif
  endfor

  return {}
endfunction

function! javacomplete#collector#GetPackageName()
  let lnum_old = line('.')
  let col_old = col('.')

  call cursor(1, 1)
  let lnum = search('^\s*package[ \t\r\n]\+\([a-zA-Z][a-zA-Z0-9._]*\);', 'w')
  let packageName = substitute(getline(lnum), '^\s*package\s\+\([a-zA-Z][a-zA-Z0-9._]*\);', '\1', '')

  call cursor(lnum_old, col_old)
  return packageName
endfunction

function! javacomplete#collector#FetchClassInfo(fqn)
  call javacomplete#collector#FetchInfoFromServer(a:fqn, '-E')
endfunction

function! javacomplete#collector#FetchInfoFromServer(class, option)
  if has_key(g:JavaComplete_Cache, substitute(a:class, '\$', '.', 'g'))
    return g:JavaComplete_Cache[substitute(a:class, '\$', '.', 'g')]
  endif

  let res = javacomplete#server#Communicate(a:option, a:class, 'collector#FetchInfoFromServer')
  if res =~ "^{'"
    silent! let dict = eval(res)
    if !empty(dict) && type(dict)==type({})
      for key in keys(dict)
        if !has_key(g:JavaComplete_Cache, key)
          if type(dict[key]) == type({})
            let g:JavaComplete_Cache[substitute(key, '\$', '.', '')] = javacomplete#util#Sort(dict[key])
          elseif type(dict[key]) == type([])
            let g:JavaComplete_Cache[substitute(key, '\$', '.', '')] = sort(dict[key])
          endif
        endif
      endfor
    else
      let b:errormsg = dict
    endif
  else
    let b:errormsg = res
  endif
endfunction

function! s:SplitTypeArguments(typename)
  if a:typename =~ g:RE_TYPE_WITH_ARGUMENTS
    let lbridx = stridx(a:typename, '<')
    let typeArguments = a:typename[lbridx + 1 : -2]
    let typename = a:typename[0 : lbridx - 1]
    return [typename, typeArguments]
  endif

  let lbridx = stridx(a:typename, '<')
  if lbridx > 0
    let typename = a:typename[0 : lbridx - 1]
    return [typename, 0]
  endif

  return a:typename
endfunction

function! s:CollectTypeArguments(typeArguments, packagename, filekey)
  let collectedArguments = ''
  if !empty(a:typeArguments)
    let typeArguments = a:typeArguments
    let i = 0
    let lbr = 0
    while i < len(typeArguments)
      let c = typeArguments[i]
      if c == '<'
        let lbr += 1
      elseif c == '>'
        let lbr -= 1
      endif

      if c == ',' && lbr == 0
        let typeArguments = typeArguments[0 : i - 1] . "<_split_>". typeArguments[i + 1 : -1]
        let i += 9
      else
        let i += 1
      endif
    endwhile
    
    for arg in split(typeArguments, "<_split_>")
      let argTypeArguments = ''
      if arg =~ g:RE_TYPE_WITH_ARGUMENTS
        let lbridx = stridx(arg, '<')
        let argTypeArguments = arg[lbridx : -1]
        let arg = arg[0 : lbridx - 1]
      endif

      if arg =~ g:RE_TYPE_ARGUMENT_EXTENDS
        let i = matchend(arg, g:RE_TYPE)
        let arg = arg[i+1 : -1]
      endif

      let fqns = s:CollectFQNs(arg, a:packagename, a:filekey, '')
      let collectedArguments .= ''
      if len(fqns) > 1
        let collectedArguments .= '('
      endif
      for fqn in fqns
        if len(fqn) > 0
          let collectedArguments .= fqn. argTypeArguments. '|'
        endif
      endfor
      if len(fqns) > 1
        let collectedArguments = collectedArguments[0:-2]. '),'
      else
        let collectedArguments = collectedArguments[0:-2]. ','
      endif
    endfor
    if !empty(collectedArguments)
      let collectedArguments = '<'. collectedArguments[0:-2]. '>'
    endif
  endif

  return collectedArguments
endfunction

function! s:Tree2ClassInfo(t)
  let t = a:t

  " fill fields and methods
  let t.fields = []
  let t.methods = []
  let t.ctors = []
  let t.classes = []
  for def in t.defs
    if type(def) == type([]) && len(def) == 1
      let tmp = def[0]
      unlet def
      let def = tmp
      unlet tmp
    endif
    let tag = get(def, 'tag', '')
    if tag == 'METHODDEF'
      call add(def.n == t.name ? t.ctors : t.methods, def)
    elseif tag == 'VARDEF'
      call add(t.fields, def)
    elseif tag == 'CLASSDEF'
      call add(t.classes, t.fqn . '.' . def.name)
    endif
    unlet def
  endfor

  for line in reverse(getline(0, '.'))
    let matches = matchlist(line, g:RE_TYPE_DECL_HEAD. t.name)
    if len(matches)
      if matches[1] == 'interface'
        let t.interface = 1
      elseif matches[1] == 'enum'
        let t.enum = 1
      endif
      break
    endif
  endfor

  " convert type name in extends to fqn for class defined in source files
  if has_key(a:t, 'filepath') && a:t.filepath != javacomplete#GetCurrentFileKey()
    let filepath = a:t.filepath
    let packagename = get(g:JavaComplete_Files[filepath].unit, 'package', '')
  else
    let filepath = expand('%:p')
    let packagename = javacomplete#collector#GetPackageName()
  endif

  if !has_key(a:t, 'extends')
    let a:t.extends = ['java.lang.Object']
  endif

  let extends = a:t.extends
  if has_key(a:t, 'implements')
    let extends += a:t.implements
  endif

  let i = 0
  while i < len(extends)
    if type(extends[i]) == type("") && extends[i] == get(t, 'fqn', '')
      let i += 1
      continue
    elseif type(extends[i]) == type({}) && extends[i].tag == 'ERRONEOUS'
      let i += 1
      continue
    endif
    let type2str = java_parser#type2Str(extends[i])
    let ci = javacomplete#collector#DoGetClassInfo(type2str, filepath, packagename)
    if type(ci) == type([])
      let ci = [0]
    endif
    if has_key(ci, 'fqn')
      let extends[i] = ci.fqn
    endif
    let i += 1
  endwhile
  let t.extends = javacomplete#util#uniq(extends)

  return t
endfunction

function! s:CollectFQNs(typename, packagename, filekey, extends)
  if len(split(a:typename, '\.')) > 1
    return [a:typename]
  endif

  let brackets = stridx(a:typename, '[')
  let extra = ''
  if brackets >= 0
    let typename = a:typename[0 : brackets - 1]
    let extra = a:typename[brackets : -1]
  else
    let typename = a:typename
  endif

  let imports = javacomplete#imports#GetImports('imports_fqn', a:filekey)
  let directFqn = javacomplete#imports#SearchSingleTypeImport(typename, imports)
  if !empty(directFqn)
    return [directFqn. extra]
  endif

  let fqns = []
  call add(fqns, empty(a:packagename) ? a:typename : a:packagename . '.' . a:typename)
  let imports = javacomplete#imports#GetImports('imports_star', a:filekey)
  for p in imports
    call add(fqns, p . a:typename)
  endfor
  if !empty(a:extends)
    call add(fqns, a:extends)
  endif
  if typename != 'Object'
    call add(fqns, 'java.lang.Object')
  endif
  return fqns
endfunction

function! s:KeyInCache(fqn)
  let fqn = substitute(a:fqn, '<', '\\<', 'g')
  let fqn = substitute(fqn, '>', '\\>', 'g')
  let fqn = substitute(fqn, ']', '\\]', 'g')
  let fqn = substitute(fqn, '[', '\\[', 'g')
  let fqn = substitute(fqn, '\$', '.', 'g')

  let keys = keys(g:JavaComplete_Cache)
  let idx = match(keys, '\v'. fqn. '$')
  
  if idx >= 0
    return keys[idx]
  endif

  return ''
endfunction

" a:1 - include related type
function! javacomplete#collector#GetDeclaredClassName(var, ...)
  let var = javacomplete#util#Trim(a:var)
  call s:Log('get declared class name for: "' . var . '"')
  if var =~# '^\(this\|super\)$'
    return var
  endif

  " Special handling for objects in JSP
  if &ft == 'jsp'
    if get(g:J_JSP_BUILTIN_OBJECTS, a:var, '') != ''
      return g:J_JSP_BUILTIN_OBJECTS[a:var]
    endif
    return s:FastBackwardDeclarationSearch(a:var)
  endif

  let result = javacomplete#collector#SearchForName(var, 1, 1)
  let variable = get(result[2], -1, {})
  if get(variable, 'tag', '') == 'VARDEF'
    if has_key(variable, 't')
      let splitted = split(variable.t, '\.')

      if len(splitted) == 1
        let rootClassName = s:SearchForRootClassName(variable)
        if len(rootClassName) > 0
          call insert(splitted, rootClassName)
        endif
      endif

      if len(splitted) > 1
        let directFqn = javacomplete#imports#SearchSingleTypeImport(splitted[0], javacomplete#imports#GetImports('imports_fqn', javacomplete#GetCurrentFileKey()))
        if empty(directFqn) 
          return variable.t
        endif
      else
        return variable.t
      endif
      return substitute(join(splitted, '.'), '\.', '\$', 'g')
    endif
    return java_parser#type2Str(variable.vartype)
  endif

  if has_key(variable, 't')
    return variable.t
  endif

  if a:0 > 0 
    let class = get(result[0], -1, {})
    if get(class, 'tag', '') == 'CLASSDEF'
      if has_key(class, 'name')
        return class.name
      endif
    endif
  endif

  return ''
endfunction

function! s:FastBackwardDeclarationSearch(name)
  let lines = reverse(getline(0, '.'))
  for line in lines
    let splittedLine = split(line, ';')
    for l in splittedLine
      let l = javacomplete#util#Trim(l)
      let matches = matchlist(l, '^\('. g:RE_QUALID. '\)\s\+'. a:name)
      if len(matches) > 0
        return matches[1]
      endif
    endfor
  endfor
  return ''
endfunction

function! s:SearchForRootClassName(variable)
  if has_key(a:variable, 'vartype') && type(a:variable.vartype) == type({})
    if has_key(a:variable.vartype, 'tag') && a:variable.vartype.tag == 'TYPEAPPLY'
      if has_key(a:variable.vartype, 'clazz') && a:variable.vartype.clazz.tag == 'SELECT'
        let clazz = a:variable.vartype.clazz
        if has_key(clazz, 'selected') && has_key(clazz.selected, 'name')
          return clazz.selected.name
        endif
      endif
    endif
  endif

  return ""
endfunction

" first: return at once if found one.
" fullmatch: 1 - equal, 0 - match beginning
" return [types, methods, fields, vars]
function! javacomplete#collector#SearchForName(name, first, fullmatch)
  let result = [[], [], [], []]
  if javacomplete#util#IsKeyword(a:name)
    return result
  endif

  let unit = javacomplete#parseradapter#Parse()
  let targetPos = java_parser#MakePos(line('.')-1, col('.')-1)
  let trees = javacomplete#parseradapter#SearchNameInAST(unit, a:name, targetPos, a:fullmatch)
  for tree in trees
    if tree.tag == 'VARDEF'
      call add(result[2], tree)
    elseif tree.tag == 'METHODDEF'
      call add(result[1], tree)
    elseif tree.tag == 'CLASSDEF'
      call add(result[0], tree.name)
    elseif tree.tag == 'LAMBDA'
      let t = s:DetermineLambdaArguments(unit, tree, a:name)
      if !empty(t)
        call add(result[2], t)
      endif
    endif
  endfor

  if a:first && result != [[], [], [], []]	| return result | endif

  " Accessible inherited members
  let type = get(javacomplete#parseradapter#SearchTypeAt(unit, targetPos), -1, {})
  if !empty(type)
    let members = javacomplete#complete#complete#SearchMember(type, a:name, a:fullmatch, 2, 1, 0, 1)
    let result[0] += members[0]
    let result[1] += members[1]
    let result[2] += members[2]
  endif

  " static import
  let si = javacomplete#imports#SearchStaticImports(a:name, a:fullmatch)
  let result[0] += si[0]
  let result[1] += si[1]
  let result[2] += si[2]

  return result
endfunction

function! s:DetermineLambdaArguments(unit, ti, name)
  let nameInLambda = 0
  let argIdx = 0 " argument index in method declaration
  let argPos = 0
  if type(a:ti.args) == type({})
    if a:name == a:ti.args.name
      let nameInLambda = 1
    endif
  elseif type(a:ti.args) == type([])
    for arg in a:ti.args
      if arg.name == a:name
        let nameInLambda = 1
        let argPos = arg.pos
        break
      endif
      let argIdx += 1
    endfor
  endif

  if !nameInLambda
    return {}
  endif

  let methods = []
  let t = a:ti
  let type = ''
  if has_key(t, 'meth') && !empty(t.meth)
    let result = []
    while 1
      if has_key(t, 'meth')
        let t = t.meth
      elseif t.tag == 'SELECT' && has_key(t, 'selected')
        call add(result, t.name. '()')
        let t = t.selected
      elseif t.tag == 'IDENT'
        call add(result, t.name)
        break
      endif
    endwhile

    let items = reverse(result)
    let typename = javacomplete#collector#GetDeclaredClassName(items[0], 1)
    let ti = {}
    if (typename != '')
      if typename[1] == '[' || typename[-1:] == ']'
        let ti = g:J_ARRAY_TYPE_INFO
      elseif typename != 'void' && !javacomplete#util#IsBuiltinType(typename)
        let ti = javacomplete#collector#DoGetClassInfo(typename)
      endif
    else " it can be static request
      let ti = javacomplete#collector#DoGetClassInfo(items[0])
    endif

    let ii = 1
    while !empty(ti) && ii < len(items) - 1
      " method invocation:	"PrimaryExpr.method(parameters)[].|"
      if items[ii] =~ '^\s*' . g:RE_IDENTIFIER . '\s*('
        let ti = javacomplete#collector#MethodInvocation(items[ii], ti, 0)
      endif
      let ii += 1
    endwhile

    if has_key(ti, 'methods')
      let itemName = split(items[-1], '(')[0]
      for m in ti.methods
        if m.n == itemName
          call add(methods, m)
        endif
      endfor

    endif
  elseif has_key(t, 'stats') && !empty(t.stats)
    if t.stats.tag == 'VARDEF'
      let type = t.stats.t
    elseif t.stats.tag == 'RETURN'
      for ty in a:unit.types
        for def in ty.defs
          if def.tag == 'METHODDEF'
            if t.stats.pos >= def.body.pos && t.stats.endpos <= def.body.endpos
              let type = def.r
            endif
          endif
        endfor
      endfor

    endif
  endif

  for method in methods
    if a:ti.idx < len(method.p)
      let type = method.p[a:ti.idx]
    endif
    let res = s:GetLambdaParameterType(type, a:name, argIdx, argPos)
    if has_key(res, 'tag')
      return res
    endif
  endfor

  return s:GetLambdaParameterType(type, a:name, argIdx, argPos)
endfunction

" type should be FunctionInterface, and it contains only one abstract method
function! s:GetLambdaParameterType(type, name, argIdx, argPos)
  let pType = ''
  if !empty(a:type)
    let matches = matchlist(a:type, '^java.util.function.Function<\(.*\)>')
    if len(matches) > 0
      let types = split(matches[1], ',')
      if !empty(types)
        let type = javacomplete#scanner#ExtractCleanExpr(types[0])
        return {'tag': 'VARDEF', 'name': type, 'type': {'tag': 'IDENT', 'name': type}, 'vartype': {'tag': 'IDENT', 'name': type, 'pos': a:argPos}, 'pos': a:argPos}
      endif
    else
      let functionalMembers = javacomplete#collector#DoGetClassInfo(a:type)
      if has_key(functionalMembers, 'methods')
        for m in functionalMembers.methods
          if javacomplete#util#CheckModifier(m.m, g:JC_MODIFIER_ABSTRACT)
            if a:argIdx < len(m.p)
              let pType = m.p[a:argIdx]
              break
            endif
          endif
        endfor

        if !empty(pType)
          return {'tag': 'VARDEF', 'name': a:name, 'type': {'tag': 'IDENT', 'name': pType}, 'vartype': {'tag': 'IDENT', 'name': pType, 'pos': a:argPos}, 'pos': a:argPos}
        endif
      endif
    endif
  endif
  return {}
endfunction

function! javacomplete#collector#MethodInvocation(expr, ti, itemkind)
  let subs = split(substitute(a:expr, '\s*\(' . g:RE_IDENTIFIER . '\)\s*\((.*\)', '\1;\2', ''), ';')

  " all methods matched
  if empty(a:ti)
    let methods = javacomplete#collector#SearchForName(subs[0], 0, 1)[1]
  elseif type(a:ti) == type({}) && get(a:ti, 'tag', '') == 'CLASSDEF'
    let methods = javacomplete#complete#complete#SearchMember(a:ti, subs[0], 1, a:itemkind, 1, 0, a:itemkind == 2)[1]
  else
    let methods = []
  endif

  let method = s:DetermineMethod(methods, subs[1])
  if !empty(method)
    return javacomplete#complete#complete#ArrayAccess(method.r, subs[0])
  endif
  return {}
endfunction

" determine overloaded method by parameters count
function! s:DetermineMethod(methods, parameters)
  let parameters = substitute(a:parameters, '(\(.*\))', '\1', '')
  let paramsCount = len(split(parameters, ','))
  for m in a:methods
    if len(get(m, 'p', [])) == paramsCount
      return m
    endif
  endfor
  return get(a:methods, -1, {})
endfunction

function! javacomplete#collector#CurrentFileInfo()
  let currentBuf = getline(1,'$')
  let base64Content = javacomplete#util#Base64Encode(join(currentBuf, "\n"))
  let ti = javacomplete#collector#DoGetClassInfo('this')
  if has_key(ti, 'name')
    let package = javacomplete#collector#GetPackageName(). '.'. ti.name

    call javacomplete#server#Communicate('-clear-from-cache', package, 's:CurrentFileInfo')
    let response = javacomplete#server#Communicate('-class-info-by-content -target '. package. ' -content', base64Content, 'CurrentFileInfo')
    if response =~ '^{'
      return eval(response)
    endif
  else
    call s:Log("`this` class parse error [CurrentFileInfo]")
  endif

  return {}
endfunction

" vim:set fdm=marker sw=2 nowrap:
