" Vim completion script for java
" Maintainer: artur shaik <ashaihullin@gmail.com>
"
" Everything to work with imports

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[imports] ". log)
endfunction

" Similar with filter(), but returns a new list instead of operating in-place.
" `item` has the value of the current item.
function! s:filter(expr, string)
  if type(a:expr) == type([])
    let result = []
    for item in a:expr
      if eval(a:string)
        call add(result, item)
      endif
    endfor
    return result
  else
    let result = {}
    for item in items(a:expr)
      if eval(a:string)
        let result[item[0]] = item[1]
      endif
    endfor
    return result
  endif
endfu

function! s:GenerateImports()
  let imports = []

  let lnum_old = line('.')
  let col_old = col('.')
  call cursor(1, 1)

  if &ft == 'jsp'
    while 1
      let lnum = search('\<import\s*=\s*[''"]', 'Wc')
      if (lnum == 0)
        break
      endif

      let str = getline(lnum)
      if str =~ '<%\s*@\s*page\>' || str =~ '<jsp:\s*directive.page\>'
        let stat = matchlist(str, '.*import\s*=\s*[''"]\([a-zA-Z0-9_$.*, \t]\+\)[''"].*')
        if !empty(stat)
          for item in stat[1:]
            if !empty(item)
              for i in split(item, ',')
                call add(imports, [substitute(i, '\s', '', 'g'), lnum])
              endfor
            endif
          endfor
        endif
      endif
      call cursor(lnum + 1, 1)
    endwhile
  else
    while 1
      let lnum = search('\<import\>', 'Wc')
      if (lnum == 0)
        break
      elseif !javacomplete#util#InComment(line("."), col(".")-1)
        call search(' \S', 'e')
        " TODO: search semicolon or import keyword, excluding comment
        let stat = matchstr(getline(lnum)[col('.')-1:], '\(static\s\+\)\?\(' .g:RE_QUALID. '\%(\s*\.\s*\*\)\?\)\s*;')
        if !empty(stat)
          call add(imports, [stat[:-2], lnum])
        endif
      else
        let curPos = getpos('.')
        call cursor(curPos[1] + 1, curPos[2])
      endif
    endwhile
  endif

  call cursor(lnum_old, col_old)
  return imports
endfunction

function! javacomplete#imports#GetImports(kind, ...)
  let filekey = a:0 > 0 && !empty(a:1) ? a:1 : javacomplete#GetCurrentFileKey()
  let props = get(g:JavaComplete_Files, filekey, {})
  let props['imports'] = filekey == javacomplete#GetCurrentFileKey() ? s:GenerateImports() : props.unit.imports
  let props['imports_static'] = []
  let props['imports_fqn'] = []
  let props['imports_star'] = ['java.lang.']
  if &ft == 'jsp' || filekey =~ '\.jsp$'
    let props.imports_star += ['javax.servlet.', 'javax.servlet.http.', 'javax.servlet.jsp.']
  endif

  for import in props.imports
    let subs = matchlist(import[0], '^\s*\(static\s\+\)\?\(' .g:RE_QUALID. '\%(\s*\.\s*\*\)\?\)\s*$')
    if !empty(subs)
      let qid = substitute(subs[2] , '\s', '', 'g')
      if !empty(subs[1])
        if qid[-1:] == '*'
          call add(props.imports_static, qid[:-2])
        else
          call add(props.imports_static, qid)
          call add(props.imports_fqn, qid)
        endif
      elseif qid[-1:] == '*'
        call add(props.imports_star, qid[:-2])
      else
        call add(props.imports_fqn, qid)
      endif
    endif
  endfor
  let g:JavaComplete_Files[filekey] = props
  return get(props, a:kind, [])
endfu

" search for name in
" return the fqn matched
function! javacomplete#imports#SearchSingleTypeImport(name, fqns)
  let matches = s:filter(a:fqns, 'item =~# ''\<' . a:name . '$''')
  if len(matches) == 1
    return matches[0]
  elseif !empty(matches)
    echoerr 'Name "' . a:name . '" conflicts between ' . join(matches, ' and ')
    return matches[0]
  endif
  return ''
endfu

" search for name in static imports, return list of members with the same name
" return [types, methods, fields]
function! javacomplete#imports#SearchStaticImports(name, fullmatch)
  let result = [[], [], []]
  let candidates = [] " list of the canonical name
  for item in javacomplete#imports#GetImports('imports_static')
    if item[-1:] == '*' " static import on demand
      call add(candidates, item[:-3])
    elseif item[strridx(item, '.')+1:] ==# a:name
          \ || (!a:fullmatch && item[strridx(item, '.')+1:] =~ '^' . a:name)
      call add(candidates, item[:strridx(item, '.') - 1])
    endif
  endfor
  if empty(candidates)
    return result
  endif

  " read type info which are not in cache
  let commalist = ''
  for typename in candidates
    if !has_key(g:JavaComplete_Cache, typename)
      let res = javacomplete#server#Communicate('-E', typename, 's:SearchStaticImports')
      if res =~ "^{'"
        let dict = eval(res)
        for key in keys(dict)
          let g:JavaComplete_Cache[key] = javacomplete#util#Sort(dict[key])
        endfor
      endif
    endif
  endfor

  " search in all candidates
  for typename in candidates
    let ti = get(g:JavaComplete_Cache, typename, 0)
    if type(ti) == type({}) && get(ti, 'tag', '') == 'CLASSDEF'
      let members = javacomplete#complete#complete#SearchMember(ti, a:name, a:fullmatch, 12, 1, 0)
      if !empty(members[1]) || !empty(members[2])
        call add(result[0], ti)
      endif
      let result[1] += members[1]
      let result[2] += members[2]
    else
      " TODO: mark the wrong import declaration.
    endif
  endfor
  return result
endfu

function! javacomplete#imports#SortImports()
  let imports = javacomplete#imports#GetImports('imports')
  if (len(imports) > 0)
    let beginLine = imports[0][1]
    let lastLine = imports[len(imports) - 1][1]
    let importsList = []
    for import in imports
      call add(importsList, import[0])
    endfor

    call sort(importsList)
    let importsListSorted = s:SortImportsList(importsList)

    if g:JavaComplete_StaticImportsAtTop
      let importsListSorted = s:StaticImportsFirst(importsListSorted)
    endif

    let saveCursor = getpos('.')
    silent execute beginLine.','.lastLine. 'delete _'
    for imp in importsListSorted
      if imp != ''
        if &ft == 'jsp'
          call append(beginLine - 1, '<%@ page import = "'. imp. '" %>')
        else
          call append(beginLine - 1, 'import '. imp. ';')
        endif
      else
        call append(beginLine - 1, '')
      endif
      let beginLine += 1
    endfor
    let saveCursor[1] += beginLine - lastLine - 1
    call setpos('.', saveCursor)
  endif
endfunction

function! s:AddImport(import)
  if exists('g:JavaComplete_ExcludeClassRegex')
    if a:import =~ get(g:, 'JavaComplete_ExcludeClassRegex')
      return
    endif
  endif

  let importPackage = a:import[0:strridx(a:import, '.') - 1]
  if importPackage == javacomplete#collector#GetPackageName()
    return
  endif

  let isStaticImport = a:import =~ "^static.*" ? 1 : 0
  let import = substitute(a:import, "\\$", ".", "g")
  if !isStaticImport
    let importsFqn = javacomplete#imports#GetImports('imports_fqn')
    let importsStar = javacomplete#imports#GetImports('imports_star')
  else
    let importsStar = javacomplete#imports#GetImports('imports_static')
    let importsFqn = importsStar
    let import = import[stridx(import, " ") + 1:]
  endif

  for imp in importsFqn
    if imp == import
      redraw
      echom 'JavaComplete: import for '. import. ' already exists'
      return
    endif
  endfor

  let splittedImport = split(import, '\.')
  let className = splittedImport[-1]
  call remove(splittedImport, len(splittedImport) - 1)
  let importPath = join(splittedImport, '.')
  for imp in importsStar
    if imp == importPath. '.'
      redraw
      echom 'JavaComplete: import for '. import. ' already exists'
      return
    endif
  endfor

  if className != '*'
    if has_key(g:JavaComplete_Cache, className)
      call remove(g:JavaComplete_Cache, className)
    endif
  endif

  let imports = javacomplete#imports#GetImports('imports')
  if empty(imports)
    for i in range(line('$'))
      if getline(i) =~ '^package\s\+.*\;$'
        let insertline = i + 2
        call append(i, '')
        break
      endif
    endfor
    if !exists('insertline')
      let insertline = 1
    endif
    let linesCount = line('$')
    while (javacomplete#util#Trim(getline(insertline)) == '' && insertline < linesCount)
      silent execute insertline. 'delete _'
    endwhile

    let insertline = insertline - 1
    let newline = 1
  else
    let replaceIdx = -1
    let idx = 0
    for i in imports
      if split(i[0], '\.')[-1] == className
        let replaceIdx = idx
        break
      endif
      let idx += 1
    endfor
    let insertline = imports[len(imports) - 1][1] - 1
    let newline = 0
    if replaceIdx >= 0
      let saveCursor = getcurpos()
      silent execute imports[replaceIdx][1]. 'normal! dd'
      call remove(imports, replaceIdx)
      let saveCursor[1] -= 1
      call setpos('.', saveCursor)
    endif
  endif

  if &ft == 'jsp'
    call append(insertline, '<%@ page import = "'. import. '" %>')
  else
    if isStaticImport
      call append(insertline, 'import static '. import. ';')
    else
      call append(insertline, 'import '. import. ';')
    endif
  endif

  if newline
    call append(insertline + 1, '')
  endif

endfunction

function! s:StaticImportsFirst(importsList)
  let staticImportsList = []
  let l_a = copy(a:importsList)
  for imp in l_a
    if imp =~ '^static'
      call remove(a:importsList, index(a:importsList, imp))
      call add(staticImportsList, imp)
    endif
  endfor
  if len(staticImportsList) > 0
    call add(staticImportsList, '')
  endif
  return staticImportsList + a:importsList
endfunction

function! s:SortImportsList(importsList, ...)
  let sortType = a:0 > 0 ? a:1 : g:JavaComplete_ImportSortType
  let importsListSorted = []
  if sortType == 'packageName'
    let beforeWildcardSorted = []
    let afterWildcardSorted = ['']
    let wildcardSeen = 0
    for a in g:JavaComplete_ImportOrder
      if a ==? '*'
        let wildcardSeen = 1
        continue
      endif
      let l_a = filter(copy(a:importsList),"v:val =~? '^" . substitute(a, '\.', '\\.', 'g') . "'")
      if len(l_a) > 0
        for imp in l_a
          call remove(a:importsList, index(a:importsList, imp))
          if wildcardSeen == 0
            call add(beforeWildcardSorted, imp)
          else
            call add(afterWildcardSorted, imp)
          endif
        endfor
        if wildcardSeen == 0
          call add(beforeWildcardSorted, '')
        else
          call add(afterWildcardSorted, '')
        endif
      endif
    endfor
    let importsListSorted = beforeWildcardSorted + a:importsList + afterWildcardSorted
  else
    let response = javacomplete#server#Communicate("-fetch-class-archives", join(a:importsList, ","), "Fetch imports jar archives")
    if response =~ '^['
      let result = sort(eval(response), 's:_SortArchivesByFirstClassName')
      for jar in result
        for classFqn in sort(jar[1])
          let idx = index(a:importsList, classFqn)
          let cf = a:importsList[idx]
          call remove(a:importsList, idx)
          call add(importsListSorted, cf)
        endfor
        call add(importsListSorted, '')
      endfor
    endif
    if len(a:importsList) > 0
      for imp in a:importsList
        call add(importsListSorted, imp)
      endfor
    endif
  endif
  while (len(importsListSorted) > 0) && (importsListSorted[-1] ==? '')
    call remove(importsListSorted, -1)
  endwhile
  return importsListSorted
endfunction

function! s:_SortArchivesByFirstClassName(i1, i2)
  return a:i1[1][0] > a:i2[1][0]
endfunction

function! s:_SortStaticToEnd(i1, i2)
  if stridx(a:i1, '$') >= 0 && stridx(a:i2, '$') < 0
    return 1
  elseif stridx(a:i2, '$') >= 0 && stridx(a:i1, '$') < 0
    return -1
  else
    return a:i1 > a:i2
  endif
endfunction

" a:1 - use smart import if True
function! javacomplete#imports#Add(...)
  call javacomplete#server#Start()

  let i = 0
  let classname = ''
  while empty(classname)
    let offset = col('.') - i
    if offset <= 0
      return
    endif
    let classname = javacomplete#util#GetClassNameWithScope(offset)
    let i += 1
  endwhile

  if classname =~ '^@.*'
    let classname = classname[1:]
  endif
  if index(g:J_KEYWORDS, classname) >= 0
    return
  endif
  if a:0 > 0 && a:1 && index(keys(javacomplete#util#GetRegularClassesDict()), classname) >= 0
    call s:AddImport(javacomplete#util#GetRegularClassesDict()[classname])
    call javacomplete#imports#SortImports()
  else
    let response = javacomplete#server#Communicate("-class-packages", classname, 'Filter packages to add import')
    if response =~ '^['
      let result = eval(response)
      let import = s:ChooseImportOption(result, classname)

      if !empty(import)
        call s:AddImport(import)
        call javacomplete#imports#SortImports()
      endif
    endif
  endif
endfunction

function! javacomplete#imports#getType(...)
  call javacomplete#server#Start()

  let i = 0
  let classname = ''
  while empty(classname)
    let offset = col('.') - i
    if offset <= 0
      return
    endif
    let classname = javacomplete#util#GetClassNameWithScope(offset)
    let i += 1
  endwhile

  if classname =~ '^@.*'
    let classname = classname[1:]
  endif
  if index(keys(javacomplete#util#GetRegularClassesDict()), classname) != -1
    echo javacomplete#util#GetRegularClassesDict()[classname]
  else
  endif
endfunction

function! s:ChooseImportOption(options, classname)
  let import = ''
  let options = a:options
  if len(options) == 0
    echo "JavaComplete: classname '". a:classname. "' not found in any scope."

  elseif len(options) == 1
    let import = options[0]

  else
    call sort(options, 's:_SortStaticToEnd')
    let options = s:SortImportsList(options, 'packageName')
    let index = 0
    let message = ''
    for imp in options
      if len(imp) == 0
        let message .= "\n"
      else
        let message .= "candidate [". index. "]: ". imp. "\n"
      endif
      let index += 1
    endfor
    let message .= "\nselect one candidate [". g:JavaComplete_ImportDefault."]: "
    let userinput = input(message, '')
    if empty(userinput)
      let userinput = g:JavaComplete_ImportDefault
    elseif userinput =~ '^[0-9]*$'
      let userinput = str2nr(userinput)
    else
      let userinput = -1
    endif
    redraw!

    if userinput < 0 || userinput >= len(options)
      echo "JavaComplete: wrong input"
    else
      let import = options[userinput]
      call s:PopulateRegularClasses(a:classname, import)
    endif
  endif
  return import
endfunction

function! s:PopulateRegularClasses(classname, import)
  let s:RegularClassesDict = javacomplete#util#GetRegularClassesDict()
  let s:RegularClassesDict[a:classname] = a:import
  call javacomplete#util#SaveRegularClassesList(s:RegularClassesDict)
endfunction

function! javacomplete#imports#RemoveUnused()
  call javacomplete#highlights#Drop()

  let currentBuf = getline(1,'$')
  let base64Content = javacomplete#util#Base64Encode(join(currentBuf, "\n"))

  let response = javacomplete#server#Communicate('-unused-imports -content', base64Content, 'RemoveUnusedImports')
  if response =~ '^{'
    let response = eval(response)
    if has_key(response, 'imports')
      let saveCursor = getpos('.')
      let unusedImports = response['imports']
      for unusedImport in unusedImports
        let imports = javacomplete#imports#GetImports('imports')
        if stridx(unusedImport, '$') != -1
          let unusedImport = 'static '. substitute(unusedImport, "\\$", ".", "")
        endif
        for import in imports
          if import[0] == unusedImport
            silent execute import[1]. 'delete _'
          endif
        endfor
      endfor
      let saveCursor[1] = saveCursor[1] - len(unusedImports)
      call setpos('.', saveCursor)
    elseif has_key(response, 'parse-problems')
      call javacomplete#highlights#ShowProblems(response['parse-problems'])
    endif
  endif
endfunction

function! javacomplete#imports#AddMissing()
  call javacomplete#highlights#Drop()

  let currentBuf = getline(1,'$')
  let base64Content = javacomplete#util#Base64Encode(join(currentBuf, "\n"))

  let response = javacomplete#server#Communicate('-missing-imports -content', base64Content, 'AddMissingImports')
  if response =~ '^{'
    let response = eval(response)
    if has_key(response, 'imports')
      for import in response['imports']
        let classname = split(import[0], '\(\.\|\$\)')[-1]
        if index(keys(javacomplete#util#GetRegularClassesDict()), classname) < 0
          let result = s:ChooseImportOption(import, classname)
          if !empty(result)
            call s:AddImport(result)
          endif
        else
          call s:AddImport(javacomplete#util#GetRegularClassesDict()[classname])
        endif
      endfor
      call javacomplete#imports#SortImports()
    elseif has_key(response, 'parse-problems')
      call javacomplete#highlights#ShowProblems(response['parse-problems'])
    endif
  else
    echo response
  endif
endfunction

" vim:set fdm=marker sw=2 nowrap:
