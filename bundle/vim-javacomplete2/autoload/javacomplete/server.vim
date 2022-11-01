" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" Java server bridge initiator and caller

let s:serverStartBlocked = 0
let s:autoRecompileCheckFlag = 0

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[server] ". log)
endfunction

function! javacomplete#server#BlockStart()
  let s:serverStartBlocked = 1
endfunction

function! javacomplete#server#UnblockStart()
  let s:serverStartBlocked = 0
endfunction

function! s:System(cmd, caller)
  let t = reltime()
  let res = system(a:cmd)
  call s:Log(reltimestr(reltime(t)) . 's to exec "' . a:cmd . '" by ' . a:caller)
  return res
endfunction

function! s:Poll()
  let value = 0
JavacompletePy << EOPC
try:
  vim.command("let value = '%d'" % bridgeState.poll())
except:
  # we'll get here if the bridgeState variable was not defined or if it's None.
  # In this case we stop the processing and return the default 0 value.
  pass
EOPC
  return value
endfunction

function! javacomplete#server#Terminate()
  if s:Poll()
    JavacompletePy bridgeState.terminateServer()

    let pid = 0
    JavacompletePy vim.command('let pid = %d' % bridgeState.pid())
    if pid > 1
      if g:JavaComplete_IsWindows
        call system('taskkill /t /pid '. pid)
      else
        call system('kill '. (pid + 1))
      endif
    endif
  endif
endfunction

function! s:ControlServerAppVersion()
  let classpath =
        \ s:GetJavaviClassPath(). g:PATH_SEP.
        \ s:GetJavaviDeps(). g:PATH_SEP
  let s:serverVersionOutput = []
  call javacomplete#util#RunSystem(join(
        \ [
          \ javacomplete#server#GetJVMLauncher(), '-cp', classpath,
          \ 'kg.ash.javavi.Javavi -version'
        \ ]),
        \ 'Javavi server version check',
        \ 'javacomplete#server#CheckServerAccordance')
endfunction

function! javacomplete#server#CheckServerAccordance(data, event)
  if a:event == 'exit'
    if a:data == '0'
      let serverVersion = join(s:serverVersionOutput)
      if !javacomplete#version#CheckServerCompatibility(serverVersion)
        call s:Log("server ". serverVersion. " is outdated, recompile")
        call javacomplete#server#Compile()
      endif
    endif

    unlet s:serverVersionOutput
  elseif a:event == 'stdout'
    call extend(s:serverVersionOutput, a:data)
  endif
endfunction

function! javacomplete#server#Start()
  if s:Poll() == 0 && s:serverStartBlocked == 0
    if get(g:, 'JavaComplete_CheckServerVersionAtStartup', 1)
      call s:ControlServerAppVersion()
    endif

    JavacompletePy import vim
    let file = g:JavaComplete_Home. g:FILE_SEP. "autoload". g:FILE_SEP. "javavibridge.py"
    call s:Log("executing python file: " . file)
    execute "JavacompletePyfile ". file

    let javaProps = []
    if exists('g:JavaComplete_JavaviLogLevel')
      call add(javaProps, '-Dlog.level='. g:JavaComplete_JavaviLogLevel)
    endif
    if !empty(g:JavaComplete_JavaviLogDirectory)
      call add(javaProps, '-Dlog.directory='. g:JavaComplete_JavaviLogDirectory)
    endif
    JavacompletePy vim.command('let port = "%s"' % SERVER[1])
    call add(javaProps, '-Ddaemon.port='. port)
    let log4j2Config = join([g:JavaComplete_Home,'libs', 'javavi', 'target', 'classes', 'log4j2.xml'], g:FILE_SEP)
    call add(javaProps, '-Dlog4j.configurationFile='. log4j2Config)

    let classpath = substitute(javacomplete#server#GetClassPath(), '\\', '\\\\', 'g')
    let sources = []
    if exists('g:JavaComplete_SourcesPath')
      let sources += ['-sources', s:ExpandAllPaths(g:JavaComplete_SourcesPath)]
    endif

    let args = javaProps + ['kg.ash.javavi.Javavi'] + sources
    if g:JavaComplete_ServerAutoShutdownTime > 0
      let args += ['-t', g:JavaComplete_ServerAutoShutdownTime]
    endif
    let args += ['-base', javacomplete#util#GetBase('')]
    let args += ['-compiler', javacomplete#server#GetCompiler()]
    if !empty(g:JavaComplete_ProjectKey)
      let args += ['-project', g:JavaComplete_ProjectKey]
    endif

    call s:Log("server classpath: -cp ". classpath)
    call s:Log("server arguments:". join(args, ' '))

    JavacompletePy bridgeState = JavaviBridge()
    JavacompletePy bridgeState.setupServer(vim.eval('javacomplete#server#GetJVMLauncher()'), vim.eval('args'), vim.eval('classpath'))

  endif
endfunction

function! javacomplete#server#ShowPort()
  if s:Poll()
    JavacompletePy vim.command('echo "Javavi port: %d"' % bridgeState.port())
  endif
endfunction

function! javacomplete#server#ShowPID()
  if s:Poll()
    JavacompletePy vim.command('echo "Javavi pid: %d"' % bridgeState.pid())
  endif
endfunction

function! javacomplete#server#GetCompiler()
  return exists('g:JavaComplete_JavaCompiler') && g:JavaComplete_JavaCompiler !~  '^\s*$' ? g:JavaComplete_JavaCompiler : 'javac'
endfunction

function! javacomplete#server#SetCompiler(compiler)
  let g:JavaComplete_JavaCompiler = a:compiler
endfunction

function! javacomplete#server#GetJVMLauncher()
  return exists('g:JavaComplete_JvmLauncher') && g:JavaComplete_JvmLauncher !~  '^\s*$' ? g:JavaComplete_JvmLauncher : 'java'
endfunction

function! javacomplete#server#SetJVMLauncher(interpreter)
  if javacomplete#server#GetJVMLauncher() != a:interpreter
    let g:JavaComplete_Cache = {}
  endif
  let g:JavaComplete_JvmLauncher = a:interpreter
endfunction

function! javacomplete#server#CompilationJobHandler(data, event)
  if a:event == 'exit'
    if a:data == "0"
      JCserverStart
      echo 'Javavi compilation finished '
    else
      echo 'Failed to compile javavi server'
    endif
    let s:compilationIsRunning = 0
  elseif a:event == 'stderr'
    echomsg join(a:data)
  elseif a:event == 'stdout'
    if g:JavaComplete_ShowExternalCommandsOutput
      echomsg join(a:data)
    endif
  endif
endfunction

function! javacomplete#server#Compile()
  call javacomplete#server#Terminate()

  let javaviDir = g:JavaComplete_Home. g:FILE_SEP. join(['libs', 'javavi'], g:FILE_SEP). g:FILE_SEP
  if isdirectory(javaviDir. join(['target', 'classes'], g:FILE_SEP))
    call javacomplete#util#RemoveFile(javaviDir.join(['target', 'classes'], g:FILE_SEP))
  endif

  let s:compilationIsRunning = 1
  if executable('mvn')
    let command = ['mvn', '-B', '-f', javaviDir. g:FILE_SEP. 'pom.xml', 'compile']
  else
    call mkdir(javaviDir. join(['target', 'classes'], g:FILE_SEP), "p")
    let deps = s:GetJavaviDeps()
    let command = javacomplete#server#GetCompiler()
    let command .= ' -d '. javaviDir. 'target'. g:FILE_SEP. 'classes -classpath '. javaviDir. 'target'. g:FILE_SEP. 'classes'. g:PATH_SEP. deps. ' -sourcepath '. javaviDir. 'src'. g:FILE_SEP. 'main'. g:FILE_SEP. 'java -g -nowarn -target 1.8 -source 1.8 -encoding UTF-8 '. javaviDir. join(['src', 'main', 'java', 'kg', 'ash', 'javavi', 'Javavi.java'], g:FILE_SEP)
  endif
  call javacomplete#util#RunSystem(command, "server compilation", "javacomplete#server#CompilationJobHandler")
endfunction

" Check if Javavi classes exists and return classpath directory.
" If not found, build Javavi library classes with maven or javac.
fu! s:GetJavaviClassPath()
  let javaviDir = g:JavaComplete_Home. join(['', 'libs', 'javavi', ''], g:FILE_SEP)
  if !isdirectory(javaviDir. "target". g:FILE_SEP. "classes")
    call javacomplete#server#Compile()
  endif

  if !empty(javacomplete#util#GlobPathList(javaviDir. 'target'. g:FILE_SEP. 'classes', '**'. g:FILE_SEP. '*.class', 1, 0))
    return javaviDir. "target". g:FILE_SEP. "classes"
  else
    if !get(s:, 'compilationIsRunning', 0)
      echo "No Javavi library classes found, it means that we couldn't compile it. Do you have JDK8+ installed?"
    endif
  endif
endfu

" Function for server communication						{{{2
function! javacomplete#server#Communicate(option, args, log)
  if !s:Poll()
    call javacomplete#server#Start()
  endif

  if s:Poll()
    if !empty(a:args)
      let args = ' "'. substitute(a:args, '"', '\\"', 'g'). '"'
    else
      let args = ''
    endif
    let cmd = a:option. args
    call s:Log("communicate: ". cmd. " [". a:log. "]")
    let result = ""
JavacompletePy << EOPC
vim.command('let result = "%s"' % bridgeState.send(vim.eval("cmd")).replace('"', '\\"'))
EOPC

    call s:Log(result)
    if result =~ '^message:'
      echom result
      return "[]"
    endif

    return result
  endif

  return ""
endfunction

function! javacomplete#server#GetClassPath()
  let jars = s:GetExtraPath()
  let path = s:GetJavaviClassPath() . g:PATH_SEP. s:GetJavaviDeps(). g:PATH_SEP
  let path = path . join(jars, g:PATH_SEP) . g:PATH_SEP

  if &ft == 'jsp'
    let path .= s:GetClassPathOfJsp()
  endif

  if exists('b:classpath') && b:classpath !~ '^\s*$'
    call s:Log(b:classpath)
    return path . b:classpath
  endif

  if exists('s:classpath')
    call s:Log(s:classpath)
    return path . javacomplete#GetClassPath()
  endif

  if exists('g:java_classpath') && g:java_classpath !~ '^\s*$'
    call s:Log(g:java_classpath)
    return path . g:java_classpath
  endif

  if empty($CLASSPATH)
    if g:JAVA_HOME == ''
      let java = javacomplete#server#GetJVMLauncher()
      let javaSettings = split(s:System(java. " -XshowSettings", "Get java settings"), '\n')
      for line in javaSettings
        if line =~ 'java\.home'
          let g:JAVA_HOME = split(line, ' = ')[1]
        endif
      endfor
    endif
    return path. g:JAVA_HOME. g:FILE_SEP. 'lib'
  endif

  return path . $CLASSPATH
endfunction

function! s:ExpandAllPaths(path)
    let result = ''
    let list = javacomplete#util#uniq(sort(split(a:path, g:PATH_SEP)))
    for l in list
      let result = result. substitute(expand(l), '\\', '/', 'g') . g:PATH_SEP
    endfor
    return result
endfunction

function! s:GetJavaviDeps()
  let deps = []
  call add(deps, fnamemodify(g:JavaComplete_Home. join(['', 'libs', 'javaparser-core-3.5.20.jar'], g:FILE_SEP), ":p"))
  call add(deps, fnamemodify(g:JavaComplete_Home. join(['', 'libs', 'javavi_log4j-api.jar'], g:FILE_SEP), ":p"))
  call add(deps, fnamemodify(g:JavaComplete_Home. join(['', 'libs', 'javavi_log4j-core.jar'], g:FILE_SEP), ":p"))
  let path = join(deps, g:PATH_SEP)
  if exists('b:classpath') && b:classpath !~ '^\s*$'
    return path . b:classpath
  endif

  if exists('s:classpath')
    return path . s:GetClassPath()
  endif

  if exists('g:java_classpath') && g:java_classpath !~ '^\s*$'
    return path . g:java_classpath
  endif

  return path
endfunction

function! s:GetExtraPath()
  let jars = []
  let extrapath = ''
  if exists('g:JavaComplete_LibsPath')
    let paths = split(g:JavaComplete_LibsPath, g:PATH_SEP)
    for path in paths
      let exp = s:ExpandPathToJars(path)
      if empty(exp)
        " ex: target/classes
        call extend(jars, [path])
      else
        call extend(jars, exp)
      endif
    endfor
  endif

  return jars
endfunction

function! s:ExpandPathToJars(path, ...)
  if isdirectory(a:path)
    return javacomplete#util#GlobPathList(a:path, "**5/*.jar", 1, 0)
    \ + javacomplete#util#GlobPathList(a:path, "**5/*.zip", 1, 0)
  elseif index(['zip', 'jar'], fnamemodify(a:path, ':e')) != -1
    return [a:path]
  endif
  return []
endfunction

fu! s:GetClassPathOfJsp()
  if exists('b:classpath_jsp')
    return b:classpath_jsp
  endif

  let b:classpath_jsp = ''
  let path = expand('%:p:h')
  while 1
    if isdirectory(path . '/WEB-INF' )
      if isdirectory(path . '/WEB-INF/classes')
        let b:classpath_jsp .= g:PATH_SEP . path . '/WEB-INF/classes'
      endif
      if isdirectory(path . '/WEB-INF/lib')
        let b:classpath_jsp .= g:PATH_SEP . path . '/WEB-INF/lib/*.jar'
        endif
      endif
      return b:classpath_jsp
    endif

    let prev = path
    let path = fnamemodify(path, ":p:h:h")
    if path == prev
      break
    endif
  endwhile
  return ''
endfu

function! s:GetClassPath()
  return exists('s:classpath') ? join(s:classpath, g:PATH_SEP) : ''
endfu

function! s:GetDebugLogPath()
  return javacomplete#server#Communicate('-get-debug-log-path', '', '')
endfunction

function! javacomplete#server#EnableDebug()
  let g:JavaComplete_JavaviLogLevel = "debug"
  if s:Poll()
    JCserverTerminate
    JCserverStart
  endif
endfunction

function! javacomplete#server#EnableTraceDebug()
  let g:JavaComplete_JavaviLogLevel = "trace"
  if s:Poll()
    JCserverTerminate
    JCserverStart
  endif
endfunction

function! javacomplete#server#GetLogContent()
  let bufferName = "__JCServer_Log_Buffer__"
  let n = bufnr(bufferName)
  if n != -1
    execute "bwipeout! ". n
  endif
  let curWin = winnr("#")
  execute 'silent! split '. bufferName
  set modifiable
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nowrap
  setlocal nobuflisted
  execute '.-1read '. s:GetDebugLogPath()
  execute "normal! G"
  set nomodified
  nnoremap <buffer> <silent> q :bwipeout!<CR>
  execute curWin. 'wincmd w'
endfunction

" vim:set fdm=marker sw=2 nowrap:
