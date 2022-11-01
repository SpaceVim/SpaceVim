" Vim completion script for java
" Maintainer: artur shaik <ashaihullin@gmail.com>
"
" Source code generators

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[generators] ". log)
endfunction

let g:JavaComplete_Templates = {}
let g:JavaComplete_Generators = {}

let g:JavaComplete_Templates['setter'] = 
  \ "$modifiers void $funcname($type $varname) {\n" .
    \ "$accessor.$varname = $varname;\n" .
  \ "}"

let g:JavaComplete_Templates['getter'] = 
  \ "$modifiers $type $funcname() {\n" .
    \ "return $varname;\n" .
  \ "}"

let g:JavaComplete_Templates['abstractDeclaration'] =
  \ "@Override\n" .
  \ "$declaration {\n" .
    \ "throw new UnsupportedOperationException();\n" .
  \ "}"

function! s:CollectVars()
  let currentFileVars = []
  for d in s:ti.defs
    if d.tag == 'VARDEF'
      let var = s:GetVariable(s:ti.name, d)
      call add(currentFileVars, var)
    endif
  endfor
  return currentFileVars
endfunction

function! javacomplete#generators#GenerateClass(options, ...)
  let template = a:0 > 0 && !empty(a:1) ? '_'. a:1 : ''
  let classCommand = {'template': 'class'. template, 'options': a:options, 'position_type' : 1}
  call <SID>generateByTemplate(classCommand)
endfunction

function! javacomplete#generators#GenerateConstructor(default)
  let defaultConstructorCommand = {'key': '1', 'desc': 'generate default constructor', 'call': '<SID>generateByTemplate', 'template': 'constructor', 'replace': {'type': 'same'}, 'options': {'default': 1}}
  if a:default == 0
    let commands = [
          \ defaultConstructorCommand,
          \ {'key': '2', 'desc': 'generate constructor', 'call': '<SID>generateByTemplate', 'template': 'constructor', 'replace': {'type': 'same'}}
          \ ]
    call s:FieldsListBuffer(commands)
  else
    let s:ti = javacomplete#collector#DoGetClassInfo('this')
    let s:savedCursorPosition = getpos('.')
    call <SID>generateByTemplate(defaultConstructorCommand)
  endif
endfunction

function! javacomplete#generators#GenerateEqualsAndHashCode()
  let commands = [
        \ {'key': '1', 'desc': 'generate `equals` method', 'call': '<SID>generateByTemplate', 'template': 'equals', 'replace': {'type': 'similar'}},
        \ {'key': '2', 'desc': 'generate `hashCode` method', 'call': '<SID>generateByTemplate', 'template': 'hashCode', 'replace': {'type': 'similar'}},
        \ {'key': '3', 'desc': 'generate `equals` and `hashCode` methods', 'call': '<SID>generateByTemplate', 'template': ['hashCode', 'equals'], 'replace': {'type': 'similar'}}
        \ ]
  call s:FieldsListBuffer(commands)
endfunction

function! javacomplete#generators#GenerateToString()
  let commands = [
        \ {'key': '1', 'desc': 'generate `toString` method using concatination', 'call': '<SID>generateByTemplate', 'template': 'toString_concat', 'replace': {'type': 'similar'}},
        \ {'key': '2', 'desc': 'generate `toString` method using StringBuilder', 'call': '<SID>generateByTemplate', 'template': 'toString_StringBuilder', 'replace': {'type': 'similar'}}
        \ ]
  call s:FieldsListBuffer(commands)
endfunction

function! s:FieldsListBuffer(commands)
  let s:ti = javacomplete#collector#DoGetClassInfo('this')
  let s:savedCursorPosition = getpos('.')
  let contentLine = s:CreateBuffer("__FieldsListBuffer__", "remove unnecessary fields", a:commands)

  let b:currentFileVars = s:CollectVars()

  let lines = ""
  let idx = 0
  while idx < len(b:currentFileVars)
    let var = b:currentFileVars[idx]
    let lines = lines. "\n". "f". idx. " --> ". var.type . " ". var.name
    let idx += 1
  endwhile
  silent put = lines

  call cursor(contentLine + 1, 0)
endfunction

function! javacomplete#generators#GenerateByTemplate(command)
  call <SID>generateByTemplate(a:command)
endfunction

" a:1 - method declaration to replace
function! <SID>generateByTemplate(command)
  let command = a:command
  if !has_key(command, 'fields')
    let command['fields'] = []
  endif

  if bufname('%') == "__FieldsListBuffer__"
    call s:Log("generate method with template: ". string(command.template))

    let currentBuf = getline(1,'$')
    for line in currentBuf
      if line =~ '^f[0-9]\+.*'
        let cmd = line[0]
        let idx = line[1:stridx(line, ' ')-1]
        let var = b:currentFileVars[idx]
        call add(command['fields'], var)
      endif
    endfor

    execute "bwipeout!"
  endif

  let result = []
  let templates = type(command.template) != type([]) ? [command.template] : command.template
  let class = {}
  if has_key(s:, 'ti')
    let class['name'] = s:ti.name
  endif
  let class['fields'] = command['fields']
  for template in templates
    call s:CheckAndLoadTemplate(template)
    if has_key(g:JavaComplete_Generators, template)
      call s:Log(g:JavaComplete_Generators[template]['data'])
      execute g:JavaComplete_Generators[template]['data']

      let arguments = [class]
      if has_key(command, 'options')
        call add(arguments, command.options)
      endif
      let TemplateFunction = function('s:__'. template)
      for line in split(call(TemplateFunction, arguments), '\n')
        call add(result, line)
      endfor
      call add(result, '')
    endif
  endfor

  if len(result) > 0
    if has_key(command, 'replace')
      let toReplace = []
      if command.replace.type == 'same'
        let defs = s:GetNewMethodsDefinitions(result)
        for def in defs
          call add(toReplace, def.d)
        endfor
      elseif command.replace.type == 'similar'
        let defs = s:GetNewMethodsDefinitions(result)
        for def in defs
          let m = s:FindMethod(s:ti.methods, def)
          if !empty(m)
            call add(toReplace, m.d)
          endif
        endfor
      endif

      let idx = 0
      while idx < len(s:ti.defs)
        let def = s:ti.defs[idx]
        if get(def, 'tag', '') == 'METHODDEF' 
          \ && index(toReplace, get(def, 'd', '')) > -1
          \ && has_key(def, 'body') && has_key(def.body, 'endpos')

          let startline = java_parser#DecodePos(def.pos).line
          if !empty(getline(startline))
            let startline += 1
          endif
          let endline = java_parser#DecodePos(def.body.endpos).line + 1
          silent! execute startline.','.endline. 'delete _'

          call setpos('.', s:savedCursorPosition)
          let s:ti = javacomplete#collector#DoGetClassInfo('this')
          let idx = 0
        else
          let idx += 1
        endif
      endwhile
    endif
    if has_key(command, 'position_type')
      call s:InsertResults(result, command['position_type'])
    else
      call s:InsertResults(result)
    endif
    if has_key(s:, 'savedCursorPosition')
      call setpos('.', s:savedCursorPosition)
    endif
  endif
endfunction

function! s:CheckAndLoadTemplate(template)
  let filenames = []
  if isdirectory(g:JavaComplete_CustomTemplateDirectory)
    call add(filenames, expand(g:JavaComplete_CustomTemplateDirectory). '/gen__'. a:template. '.tpl')
  endif
  call add(filenames, g:JavaComplete_Home. '/plugin/res/gen__'. a:template. '.tpl')
  for filename in filenames
    if filereadable(filename)
      if has_key(g:JavaComplete_Generators, a:template)
        if getftime(filename) > g:JavaComplete_Generators[a:template]['file_time']
          let g:JavaComplete_Generators[a:template]['data'] = join(readfile(filename), "\n")
          let g:JavaComplete_Generators[a:template]['file_time'] = getftime(filename)
        endif
      else
        let g:JavaComplete_Generators[a:template] = {}
        let g:JavaComplete_Generators[a:template]['data'] = join(readfile(filename), "\n")
        let g:JavaComplete_Generators[a:template]['file_time'] = getftime(filename)
      endif
      break
    endif
  endfor
endfunction

function! javacomplete#generators#AbstractDeclaration()
  let s:ti = javacomplete#collector#DoGetClassInfo('this')
  if get(s:ti, 'interface', 0) == 1
    return
  endif
  let s = ''
  let abstractMethods = []
  let implementedMethods = []
  for i in get(s:ti, 'extends', [])
    let parentInfo = javacomplete#collector#DoGetClassInfo(i)
    let members = javacomplete#complete#complete#SearchMember(parentInfo, '', 1, 1, 1, 14, 0)
    for m in members[1]
      if javacomplete#util#CheckModifier(m.m, [g:JC_MODIFIER_ABSTRACT])
        call add(abstractMethods, m)
      elseif javacomplete#util#CheckModifier(m.m, [g:JC_MODIFIER_PUBLIC]) 
        call add(implementedMethods, m)
      endif
    endfor
    unlet i
  endfor

  let result = []
  let method = g:JavaComplete_Templates['abstractDeclaration']
  for m in abstractMethods
    if !empty(s:CheckImplementationExistense(s:ti, implementedMethods, m))
      continue
    endif
    let declaration = javacomplete#util#GenMethodParamsDeclaration(m)
    let declaration = substitute(declaration, '\<\(abstract\|default\|native\)\s\+', '', 'g')
    let declaration = javacomplete#util#CleanFQN(declaration)

    call add(result, '')
    for line in split(substitute(method, '$declaration', declaration, 'g'), '\n')
      call add(result, line)
    endfor

    call add(implementedMethods, m)
  endfor

  call s:InsertResults(result)
endfunction

" ti - this class info
" implementedMethods - implemented methods from parent class
" method - method to check
function! s:CheckImplementationExistense(ti, implementedMethods, method) 
  let methods = a:ti.methods
  call extend(methods, a:implementedMethods)
  return s:FindMethod(methods, a:method)
endfunction

function! s:GetParams(params)
  let params = []
  for param in a:params
    if type(param) == type({}) && has_key(param, 'type') 
      if has_key(param.type, 'name')
        call add(params, javacomplete#util#CleanFQN(param.type.name))
      elseif has_key(param.type, 'clazz') && has_key(param.type.clazz, 'name')
        let name = javacomplete#util#CleanFQN(param.type.clazz.name)
        if has_key(param.type, 'arguments')
          let args = []
          for arg in param.type.arguments
            if type(arg) == type({})
              if len(arg.name) == 1
                call add(params, '\('. g:RE_TYPE_ARGUMENT_EXTENDS. '\|'. g:RE_TYPE. '\)')
              else
                call add(params, arg.name)
              endif
            else
              call add(params, '?')
            endif
          endfor
          let name .= '<'. join(args, ',\s*'). '>'
        endif
        call add(params, name)
      elseif has_key(param.type, 'typetag')
        call add(params, param.type.typetag)
      elseif has_key(param.type, 'tag') && param.type.tag == 'TYPEARRAY'
        if has_key(param.type, 'elementtype') && has_key(param.type.elementtype, 'name')
          call add(params, param.type.elementtype.name . '[]')
        endif
      endif
    endif
  endfor
  return params
endfunction

function! s:FindMethod(methods, method)
  let searchMethodParamList = []
  if has_key(a:method, 'p')
    for p in a:method.p
      call add(searchMethodParamList, javacomplete#util#CleanFQN(p))
    endfor
  elseif has_key(a:method, 'params')
    call extend(searchMethodParamList, s:GetParams(a:method.params))
  endif

  let methodDeclaration = javacomplete#util#CleanFQN(a:method.r . ' '. a:method.n)
  for method in a:methods
    if methodDeclaration ==# javacomplete#util#CleanFQN(method.r . ' '. method.n)
      let methodParamList = []
      if has_key(method, 'params')
        call extend(methodParamList, s:GetParams(method.params))
      elseif has_key(method, 'p')
        for param in method.p
          if type(param) == type("")
            call add(methodParamList, javacomplete#util#CleanFQN(param))
          endif
        endfor
      endif

      " compare parameters need to be done with regexp because of separator of
      " arguments if paramater has generic arguments
      let i = 0
      let _continue = 0
      for p in searchMethodParamList
        if i < len(methodParamList)
          if p !~ methodParamList[i]
            let _continue = 1
            break
          endif
        else
          let _continue = 1
          break
        endif
        let i += 1
      endfor
      if _continue == 1
        continue
      endif
      return method
    endif
  endfor
  return {}
endfunction

function! s:CreateBuffer(name, title, commands)
  let n = bufwinnr(a:name)
  if n != -1
      execute "bwipeout!"
  endif
  exec 'silent! split '. a:name

  " Mark the buffer as scratch
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nowrap
  setlocal nobuflisted

  nnoremap <buffer> <silent> q :bwipeout!<CR>

  syn match Comment "^\".*"
  put = '\"-----------------------------------------------------'
  put = '\" '. a:title
  put = '\" '
  put = '\" q                      - close this window'
  for command in a:commands
    put = '\" '. command.key . '                      - '. command.desc
    if has_key(command, 'call')
      exec "nnoremap <buffer> <silent> ". command.key . " :call ". command.call . "(". string(command). ")<CR>"
    endif
  endfor
  put = '\"-----------------------------------------------------'

  return line(".") + 1
endfunction

function! javacomplete#generators#Accessors()
  let s:ti = javacomplete#collector#DoGetClassInfo('this')

  let commands = [{'key': 's', 'desc': 'generate accessors', 'call': '<SID>generateAccessors'}]
  let contentLine = s:CreateBuffer("__AccessorsBuffer__", "remove unnecessary accessors", commands)

  let b:currentFileVars = s:CollectVars()

  let lines = ""
  let idx = 0
  while idx < len(b:currentFileVars)
    let var = b:currentFileVars[idx]
    let varName = toupper(var.name[0]). var.name[1:]
    let lines = lines. "\n". "g". idx. " --> ". var.type . " get". varName . "()"
    if !var.final
      let lines = lines. "\n". "s". idx. " --> ". "set". varName . "(". var.type . " ". var.name. ")"
    endif
    let lines = lines. "\n"

    let idx += 1
  endwhile
  silent put = lines

  call cursor(contentLine + 1, 0)

endfunction

function! javacomplete#generators#Accessor(...)
  let s:ti = javacomplete#collector#DoGetClassInfo('this')
  call <SID>generateAccessors(a:000)
endfunction

function! s:AddAccessor(map, result, var, declaration, type)
  let method = g:JavaComplete_Templates[a:type]

  let mods = "public"
  if a:var.static
    let mods = mods . " static"
    let accessor = a:var.className
  else
    let accessor = 'this'
  endif

  let method = substitute(method, '$type', a:var.type, 'g')
  let method = substitute(method, '$varname', a:var.name, 'g')
  let method = substitute(method, '$funcname', a:declaration, 'g')
  let method = substitute(method, '$modifiers', mods, 'g')
  let method = substitute(method, '$accessor', accessor, 'g')

  let begin = len(a:result)
  call add(a:result, '')
  for line in split(method, '\n')
    call add(a:result, line)
  endfor
  let end = len(a:result)
  call add(a:map, [begin, end])
endfunction

function! s:GetVariable(className, def)
  let var = {
    \ 'name': a:def.name, 
    \ 'type': a:def.t, 
    \ 'className': a:className, 
    \ 'static': javacomplete#util#IsStatic(a:def.m),
    \ 'final': javacomplete#util#CheckModifier(a:def.m, g:JC_MODIFIER_FINAL),
    \ 'isArray': a:def.t =~# g:RE_ARRAY_TYPE}

  let varName = toupper(var.name[0]). var.name[1:]
  for def in get(s:ti, 'defs', [])
    if get(def, 'tag', '') == 'METHODDEF'
      if stridx(get(def, 'd', ''), var.type. ' get'. varName. '()') > -1
        let var.getter = 'get'. varName. '()'
        break
      endif
    endif
  endfor
  return var
endfunction

function! s:CreateAccessors(map, result, var, cmd)
  let varName = toupper(a:var.name[0]). a:var.name[1:]
  if !a:var.final && stridx(a:cmd, 's') > -1
    call s:AddAccessor(a:map, a:result, a:var, "set". varName, 'setter')
  endif
  if stridx(a:cmd, 'g') > -1
    call s:AddAccessor(a:map, a:result, a:var, "get". varName, 'getter')
  endif
endfunction

function! <SID>generateAccessors(...)
  let result = []
  let locationMap = []
  if bufname('%') == "__AccessorsBuffer__"
    call s:Log("generate accessor for selected fields")
    let currentBuf = getline(1,'$')
    for line in currentBuf
      if line =~ '^\(g\|s\)[0-9]\+.*'
        let cmd = line[0]
        let idx = line[1:stridx(line, ' ')-1]
        let var = b:currentFileVars[idx]
        call s:CreateAccessors(locationMap, result, var, cmd)
      endif
    endfor

    execute "bwipeout!"
  else
    call s:Log("generate accessor for fields under cursor")
    if mode() == 'n'
      let currentLines = [line('.') - 1]
    elseif mode() == 'v'
      let [lnum1, col1] = getpos("'<")[1:2]
      let [lnum2, col2] = getpos("'>")[1:2]
      let currentLines = range(lnum1 - 1, lnum2 - 1)
    else
      let currentLines = []
    endif
    for d in get(s:ti, 'defs', [])
      if get(d, 'tag', '') == 'VARDEF'
        let line = java_parser#DecodePos(d.pos).line
        if has_key(d, 'endpos')
          let endline = java_parser#DecodePos(d.endpos).line
        else
          let endline = line
        endif
        for l in currentLines
          if l >= line && l <= endline
            let cmd = len(a:1) > 0 ? a:1[0] : 'sg'
            let var = s:GetVariable(s:ti.name, d)
            call s:CreateAccessors(locationMap, result, var, cmd)
          endif
        endfor
      endif
    endfor

  endif

  call s:InsertResults(s:FilterExistedMethods(locationMap, result))
endfunction

function! s:FilterExistedMethods(locationMap, result)
  let resultMethods = []
  for def in s:GetNewMethodsDefinitions(a:result)
    if !empty(s:CheckImplementationExistense(s:ti, [], def))
      continue
    endif
    for m in a:locationMap 
      if m[0] <= def.beginline && m[1] >= def.endline
        call extend(resultMethods, a:result[m[0] : m[1] -1])
        break
      endif
    endfor
  endfor

  return resultMethods
endfunction

" create temporary buffer with class declaration, then parse it to get new 
" methods definitions.
function! s:GetNewMethodsDefinitions(declarations)
  let n = bufwinnr("__tmp_buffer__")
  if n != -1
      execute "bwipeout!"
  endif
  silent! split __tmp_buffer__
  let result = ['class Tmp {']
  call extend(result, a:declarations)
  call add(result, '}')
  call append(0, result)
  let tmpClassInfo = javacomplete#collector#DoGetClassInfo('this', '__tmp_buffer__')
  let defs = []
  for def in get(tmpClassInfo, 'defs', [])
    if get(def, 'tag', '') == 'METHODDEF'
      let def.beginline = java_parser#DecodePos(def.pos).line
      let def.endline = java_parser#DecodePos(def.body.endpos).line
      call add(defs, def)
    endif
  endfor
  execute "bwipeout!"

  return defs
endfunction

function! s:InsertResults(result, ...)
  if len(a:result) > 0
    let positionType = a:0 > 0 && len(a:1) > 0 ? a:1 : 'END'
    if positionType == 'END'
      call s:InsertAtTheEndOfTheClass(a:result)
      return
    endif

    call s:Log(a:result)
    call append(0, a:result)
    silent execute "normal! dd"
    silent execute "normal! =G"
  endif
endfunction

function! s:InsertAtTheEndOfTheClass(result)
  let result = a:result
  let t = javacomplete#collector#CurrentFileInfo()
  let contentLine = line('.')
  let currentCol = col('.')
  let posResult = {}
  for clazz in values(t)
    if contentLine > clazz.pos[0] && contentLine <= clazz.endpos[0]
      let posResult[clazz.endpos[0] - clazz.pos[0]] = clazz.endpos
    endif
  endfor

  let saveCursor = getpos('.')
  call s:Log(posResult)
  if len(posResult) > 0
    let pos = posResult[min(keys(posResult))]
    let endline = pos[0]
    if pos[1] > 1 && !empty(javacomplete#util#Trim(getline(pos[0])[:pos[1] - 2]))
      let endline += 1
      call cursor(pos[0], pos[1])
      execute "normal! i\r"
    endif
  elseif has_key(s:, 'ti') && has_key(s:ti, 'endpos')
    let endline = java_parser#DecodePos(s:ti.endpos).line
  else
    call s:Log("cannot find `endpos` [InsertResult]")
    return
  endif

  if empty(javacomplete#util#Trim(getline(endline - 1))) 
    if empty(result[0])
      let result = result[1:]
    endif
  elseif !empty(result[0])
    call insert(result, '', 0)
  endif

  call append(endline - 1, result)
  call cursor(endline - 1, 1)
  silent execute "normal! =G"
  if has('saveCursor')
    call setpos('.', saveCursor)
  endif
endfunction

" vim:set fdm=marker sw=2 nowrap:
