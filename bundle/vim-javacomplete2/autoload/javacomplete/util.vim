" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" Utility functions

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[util] ". log)
endfunction

" TODO: search pair used in string, like
" 	'create(ao.fox("("), new String).foo().'
function! javacomplete#util#GetMatchedIndexEx(str, idx, one, another)
  let pos = a:idx
  while 0 <= pos && pos < len(a:str)
    let pos = match(a:str, '['. a:one . escape(a:another, ']') .']', pos+1)
    if pos != -1
      if a:str[pos] == a:one
        let pos = javacomplete#util#GetMatchedIndexEx(a:str, pos, a:one, a:another)
      elseif a:str[pos] == a:another
        break
      endif
    endif
  endwhile
  return 0 <= pos && pos < len(a:str) ? pos : -3
endfunction

" set string literal empty, remove comments, trim begining or ending spaces
" test case: ' 	sb. /* block comment*/ append( "stringliteral" ) // comment '
function! javacomplete#util#Prune(str, ...)
  if a:str =~ '^\s*$' | return '' | endif

  let str = substitute(a:str, '"\(\\\(["\\''ntbrf]\)\|[^"]\)*"', '""', 'g')
  let str = substitute(str, '\/\/.*', '', 'g')
  let str = javacomplete#util#RemoveBlockComments(str)
  let str = javacomplete#util#Trim(str)
  return a:0 > 0 ? str : str . ' '
endfunction

" Given argument, replace block comments with spaces of same number
function! javacomplete#util#RemoveBlockComments(str, ...)
  let result = a:str
  let ib = match(result, '\/\*')
  let ie = match(result, '\*\/')
  while ib != -1 && ie != -1 && ib < ie
    let result = strpart(result, 0, ib) . (a:0 == 0 ? ' ' : repeat(' ', ie-ib+2)) . result[ie+2: ]
    let ib = match(result, '\/\*')
    let ie = match(result, '\*\/')
  endwhile
  return result
endfunction

function! javacomplete#util#Trim(str)
  let str = substitute(a:str, '^\s*', '', '')
  return substitute(str, '\s*$', '', '')
endfunction

fu! javacomplete#util#SplitAt(str, index)
  return [strpart(a:str, 0, a:index+1), strpart(a:str, a:index+1)]
endfu

function! javacomplete#util#SearchPairBackward(str, idx, one, another)
  let idx = a:idx
  let n = 0
  while idx >= 0
    let idx -= 1
    if a:str[idx] == a:one
      if n == 0
        break
      endif
      let n -= 1
    elseif a:str[idx] == a:another  " nested
      let n += 1
    endif
  endwhile
  return idx
endfunction

function! javacomplete#util#CountDims(str)
  if match(a:str, '[[\]]') == -1
    return 0
  endif

  " int[] -> [I, String[] ->
  let dims = len(matchstr(a:str, '^[\+'))
  if dims == 0
    let idx = len(a:str)-1
    while idx >= 0 && a:str[idx] == ']'
      let dims += 1
      let idx = javacomplete#util#SearchPairBackward(a:str, idx, '[', ']')-1
    endwhile
  endif
  return dims
endfu

function! javacomplete#util#Index(list, expr, key)
  let i = 0
  while i < len(a:list)
    if get(a:list[i], a:key, '') == a:expr
      return i
    endif
    let i += 1
  endwhile
  return -1
endfunction

function! javacomplete#util#KeepCursor(cmd)
  let lnum_old = line('.')
  let col_old = col('.')
  exe a:cmd
  call cursor(lnum_old, col_old)
endfunction

function! javacomplete#util#InCommentOrLiteral(line, col)
  if has("syntax") && &ft != 'jsp'
    return synIDattr(synID(a:line, a:col, 1), "name") =~? '\(Comment\|String\|Character\)'
  endif
endfunction

function! javacomplete#util#InComment(line, col)
  if has("syntax") && &ft != 'jsp'
    return synIDattr(synID(a:line, a:col, 1), "name") =~? 'comment'
  endif
endfunction

fu! javacomplete#util#GotoUpperBracket()
  let searched = 0
  while (!searched)
    call search('[{}]', 'bW')
    if getline('.')[col('.')-1] == '}'
      normal! %
    else
      let searched = 1
    endif
  endwhile
endfu

function! javacomplete#util#GetClassNameWithScope(...)
  let offset = a:0 > 0 ? a:1 : col('.')
  let curline = getline('.')
  let word_l = offset - 1
  while curline[word_l - 1] =~ '[\.:@A-Za-z0-9_]'
    let word_l -= 1
    if curline[word_l] == '@'
      break
    endif
  endwhile
  let word_r = word_l
  while curline[word_r] =~ '[@A-Za-z0-9_]'
    let word_r += 1
  endwhile

  return curline[word_l : word_r - 1]
endfunction

function! s:MemberCompare(m1, m2)
  return a:m1['n'] == a:m2['n'] ? 0 : a:m1['n'] > a:m2['n'] ? 1 : -1
endfunction

function! javacomplete#util#Sort(ci)
  let ci = a:ci
  if has_key(ci, 'fields')
    call sort(ci['fields'], 's:MemberCompare')
  endif
  if has_key(ci, 'methods')
    call sort(ci['methods'], 's:MemberCompare')
  endif
  return ci
endfunction

function! javacomplete#util#CleanFQN(fqnDeclaration)
  let start = 0
  let fqnDeclaration = a:fqnDeclaration
  let result = matchlist(fqnDeclaration, '\<'. g:RE_IDENTIFIER. '\%(\s*\.\s*\('. g:RE_IDENTIFIER. '\)\)*', start)
  while !empty(result)

    if len(result[1]) > 0
      if result[0][-1:-1] == '$'
        let result[0] = result[0][:-2]. '\$'
      endif
      let fqnDeclaration = substitute(fqnDeclaration, result[0], result[1], '')
      let shift = result[1]
    else
      let shift = result[0]
    endif
    if shift[-1:-1] == '$'
      let shift = shift[:-2]. '\$'
    endif
    let start = match(fqnDeclaration, shift, start) + len(shift)

    let result = matchlist(fqnDeclaration, '\<'. g:RE_IDENTIFIER. '\%(\s*\.\s*\('. g:RE_IDENTIFIER. '\)\)*', start)
  endwhile

  return fqnDeclaration
endfunction

function! javacomplete#util#FindFile(what, ...) abort
  let direction = a:0 > 0 ? a:1 : ';'
  let old_suffixesadd = &suffixesadd
  try
    let &suffixesadd = ''
    return findfile(a:what, escape(expand('.'), '*[]?{}, ') . direction)
  finally
    let &suffixesadd = old_suffixesadd
  endtry
endfunction

function! javacomplete#util#GlobPathList(path, pattern, suf, depth)
  if v:version > 704 || v:version == 704 && has('patch279')
    let pathList = globpath(a:path, a:pattern, a:suf, 1)
  else
    let pathList = split(globpath(a:path, a:pattern, a:suf), "\n")
  endif
  if a:depth > 0
    let depths = []
    for i in range(1, a:depth)
      call add(depths, repeat("*".g:FILE_SEP, i))
    endfor
    for i in depths
      call extend(pathList, javacomplete#util#GlobPathList(a:path, i. a:pattern, 0, 0))
    endfor
  endif
  return pathList
endfunction

function! javacomplete#util#IsWindows() abort
  return has("win32") || has("win64") || has("win16") || has("dos32") || has("dos16")
endfunction

function! s:JobVimOnCloseHandler(channel)
  let job = s:asyncJobs[s:ChannelId(a:channel)]
  let info = job_info(job['job'])
  let Handler = function(job['handler'])
  call call(Handler, [info['exitval'], 'exit'])
endfunction

function! s:JobVimOnErrorHandler(channel, text)
  let job = s:asyncJobs[s:ChannelId(a:channel)]
  let Handler = function(job['handler'])
  call call(Handler, [[a:text], 'stderr'])
endfunction

function! s:JobVimOnCallbackHandler(channel, text)
  let job = s:asyncJobs[s:ChannelId(a:channel)]
  let Handler = function(job['handler'])
  call call(Handler, [[a:text], 'stdout'])
endfunction

function! s:JobNeoVimResponseHandler(jobId, data, event)
  let job = s:asyncJobs[a:jobId]
  let Handler = function(job['handler'])
  call call(Handler, [a:data, a:event])
endfunction

function! s:ChannelId(channel)
  return matchstr(a:channel, '\d\+')
endfunction

function! s:NewJob(id, handler)
  let s:asyncJobs = get(s:, 'asyncJobs', {})
  let s:asyncJobs[a:id] = {}
  let s:asyncJobs[a:id]['handler'] = a:handler
endfunction

function! javacomplete#util#RunSystem(command, shellName, handler)
  call s:Log("running command: ". string(a:command))
  if has('nvim')
    if exists('*jobstart')
      let callbacks = {
        \ 'on_stdout': function('s:JobNeoVimResponseHandler'),
        \ 'on_stderr': function('s:JobNeoVimResponseHandler'),
        \ 'on_exit': function('s:JobNeoVimResponseHandler')
        \ }
      let jobId = jobstart(a:command, extend({'shell': a:shellName}, callbacks))
      call s:NewJob(jobId, a:handler)
      return
    endif
  elseif exists('*job_start')
    let options = {
      \ 'out_cb' : function('s:JobVimOnCallbackHandler'),
      \ 'err_cb' : function('s:JobVimOnErrorHandler'),
      \ 'close_cb' : function('s:JobVimOnCloseHandler')
      \ }
    if has('win32') && type(a:command) == 3
      let a:command[0] = exepath(a:command[0])
    endif
    let job = job_start(a:command, options)
    let jobId = s:ChannelId(job_getchannel(job))
    call s:NewJob(jobId, a:handler)
    let s:asyncJobs[jobId]['job'] = job
    return
  endif

  if type(a:command) == type([])
    let ret = system(join(a:command, " "))
  else
    let ret = system(a:command)
  endif
  for l in split(ret, "\n")
    call call(a:handler, [[l], "stdout"])
  endfor
  call call(a:handler, ["0", "exit"])
endfunction

function! javacomplete#util#Base64Encode(str)
  JavacompletePy import base64
  JavacompletePy import vim
  JavacompletePy content = vim.eval('a:str') if sys.version_info.major == 2 else bytes(vim.eval('a:str'), 'utf-8')
  JavacompletePy b64 = base64.b64encode(content)
  JavacompletePy vim.command("let base64 = '%s'" % (b64 if sys.version_info.major == 2 else b64.decode('utf-8')))
  return base64
endfunction

function! javacomplete#util#RemoveFile(file)
  if filewritable(a:file)
    if g:JavaComplete_IsWindows
      silent exe '!rmdir /s /q "'. a:file. '"'
    else
      silent exe '!rm -r "'. a:file. '"'
    endif
    silent redraw!
  endif
endfunction

if exists('*uniq')
  function! javacomplete#util#uniq(list) abort
    return uniq(a:list)
  endfunction
else
  function! javacomplete#util#uniq(list) abort
    let i = len(a:list) - 1
    while 0 < i
      if a:list[i] ==# a:list[i - 1]
        call remove(a:list, i)
        let i -= 2
      else
        let i -= 1
      endif
    endwhile
    return a:list
  endfunction
endif

function! javacomplete#util#GetBase(extra)
  let base = expand(g:JavaComplete_BaseDir. g:FILE_SEP. "javacomplete2". g:FILE_SEP. a:extra)
  if !isdirectory(base)
    call mkdir(base, "p")
  endif

  return base
endfunction

function! javacomplete#util#RemoveEmptyClasses(classes)
  return filter(a:classes, 'v:val !~ "^$"')
endfunction

function! javacomplete#util#GetRegularClassesDict()
  if exists('s:RegularClassesDict')
    return s:RegularClassesDict
  endif
  let path = javacomplete#util#GetBase('cache'). g:FILE_SEP. 'regular_classes_'. g:JavaComplete_ProjectKey. '.dat'
  if filereadable(path)
    let classes = readfile(path)
  else
    let classes = []
  endif
  let classes = javacomplete#util#RemoveEmptyClasses(javacomplete#util#uniq(sort(extend(classes, g:JavaComplete_RegularClasses))))
  let dict = {}
  for class in classes
    call extend(dict, {split(class,'\.')[-1] : class})
  endfor
  let s:RegularClassesDict = dict
  return s:RegularClassesDict
endfunction

function! javacomplete#util#SaveRegularClassesList(classesDict)
    let path = javacomplete#util#GetBase('cache'). g:FILE_SEP. 'regular_classes_'. g:JavaComplete_ProjectKey. '.dat'
    call writefile(values(a:classesDict), path)
    unlet s:RegularClassesDict
endfunction

function! javacomplete#util#IsStatic(modifier)
  return a:modifier[strlen(a:modifier)-4]
endfunction

function! javacomplete#util#IsBuiltinType(name)
  return index(g:J_PRIMITIVE_TYPES, a:name) >= 0
endfunction

function! javacomplete#util#IsKeyword(name)
  return index(g:J_KEYWORDS, a:name) >= 0
endfunction

function! javacomplete#util#HasKeyword(name)
  return a:name =~# g:RE_KEYWORDS
endfunction

function! javacomplete#util#CheckModifier(modifier, condition)
  if type(a:condition) == type([])
    for condition in a:condition
      if condition <= len(a:modifier)
        if a:modifier[-condition : -condition] == '1'
          return 1
        endif
      endif
    endfor
    return 0
  else
    if a:condition <= len(a:modifier)
      return a:modifier[-a:condition : -a:condition] == '1'
    endif
    return 0
  endif
endfunction

function! javacomplete#util#GenMethodParamsDeclaration(method)
  if has_key(a:method, 'p')
    let match = matchlist(a:method.d, '^\(.*(\)')
    if len(match) > 0
      let d = match[1]
      let match = matchlist(a:method.d, '.*)\(.*\)$')
      let throws = len(match) > 0 ?  substitute(match[1], ',', ', ', 'g') : ''

      let ds = []
      let paramNames = []
      for p in a:method.p
        let repeats = count(a:method.p, p) > 1 ? 1 : 0
        if index(g:J_PRIMITIVE_TYPES, p) >= 0
          let var = p[0]
        else
          let p = javacomplete#util#CleanFQN(p)
          let var = tolower(p[0]). p[1:]
        endif
        let match = matchlist(var, '^\([a-zA-Z0-9]\+\)\A*')
        let countVar = count(paramNames, match[1]) + repeats
        call add(paramNames, match[1])
        call add(ds, p. ' '. match[1]. (countVar > 0 ? countVar : ""))
      endfor
      return d. join(ds, ', '). ')'. throws
    endif
  endif
  return a:method.d
endfunction

function! javacomplete#util#GetClassPackage(class)
  let lastDot = strridx(a:class, '.')
  if lastDot > 0
    return a:class[0:lastDot - 1]
  endif
  return a:class
endfunction

" vim:set fdm=marker sw=2 nowrap:
