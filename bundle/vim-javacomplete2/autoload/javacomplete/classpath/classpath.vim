function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[classpath] ". log)
endfunction

function! javacomplete#classpath#classpath#BuildClassPath()
  call s:BuildClassPath(0)
endfunction

function! javacomplete#classpath#classpath#RebuildClassPath()
  call s:BuildClassPath(1)
endfunction

function! s:BuildClassPath(force)
  if !g:JavaComplete_MavenRepositoryDisabled
    if empty('g:JavaComplete_PomPath')
      let g:JavaComplete_PomPath = javacomplete#util#FindFile('pom.xml')
      if g:JavaComplete_PomPath != ""
        let g:JavaComplete_PomPath = fnamemodify(g:JavaComplete_PomPath, ':p')
        call s:Log("found maven file: ". g:JavaComplete_PomPath)
      endif
    endif
  endif

  if !get(g:, 'JavaComplete_GradleRepositoryDisabled', 0)
    if !exists('g:JavaComplete_GradlePath')
      if filereadable(getcwd(). g:FILE_SEP. "build.gradle")
        let g:JavaComplete_GradlePath = getcwd(). g:FILE_SEP. "build.gradle"
      else
        let g:JavaComplete_GradlePath = javacomplete#util#FindFile('build.gradle', '**3')
      endif
      if g:JavaComplete_GradlePath != ""
        let g:JavaComplete_GradlePath = fnamemodify(g:JavaComplete_GradlePath, ':p')
        call s:Log("found gradle file: ". g:JavaComplete_GradlePath)
      endif
    endif
  endif

  if !get(g:, 'JavaComplete_AntRepositoryDisabled', 0)
    if !exists('g:JavaComplete_AntPath')
      if filereadable(getcwd(). g:FILE_SEP. "build.xml")
        let g:JavaComplete_AntPath = getcwd(). g:FILE_SEP. "build.xml"
      else
        let g:JavaComplete_AntPath = javacomplete#util#FindFile('build.xml', '**3')
      endif
      if g:JavaComplete_AntPath != ""
        let g:JavaComplete_AntPath = fnamemodify(g:JavaComplete_AntPath, ':p')
        call s:Log("found ant file: ". g:JavaComplete_AntPath)
      endif
    endif
  endif

  let g:JavaComplete_LibsPath .= s:FindClassPath(a:force)

  call s:Log("libs found: ". g:JavaComplete_LibsPath)
endfunction

function! s:ReadClassPathFile(classpathFile)
  let cp = ''
  let file = g:JavaComplete_Home. join(['', 'autoload', 'classpath.py'], g:FILE_SEP)
  execute "JavacompletePyfile" file
  JavacompletePy import vim
  JavacompletePy vim.command("let cp = '%s'" % os.pathsep.join(ReadClasspathFile(vim.eval('a:classpathFile'))).replace('\\', '/'))
  return cp
endfunction

function! s:UseEclipse(force)
  if has('python') || has('python3')
    let classpathFile = fnamemodify(findfile('.classpath', escape(expand('.'), '*[]?{}, ') . ';'), ':p')
    if !empty(classpathFile) && filereadable(classpathFile)
      return s:ReadClassPathFile(classpathFile)
    endif
  endif

  return ""
endf

function! s:UseMaven(force)
  if javacomplete#classpath#maven#IfMaven()
    return javacomplete#classpath#maven#Generate(a:force)
  endif

  return ""
endf

function! s:UseGradle(force)
  if javacomplete#classpath#gradle#IfGradle()
    return javacomplete#classpath#gradle#Generate(a:force)
  endif

  return ""
endf

function! s:UseAnt(force)
  if javacomplete#classpath#ant#IfAnt()
    return javacomplete#classpath#ant#Generate(a:force)
  endif

  return ""
endf

function! s:FindClassPath(force) abort
  for classpathSourceType in g:JavaComplete_ClasspathGenerationOrder
    try
      let cp = ''
      exec "let cp .= s:Use". classpathSourceType. "(". a:force. ")"
      if !empty(cp)
        call s:Log("found ". classpathSourceType. " project")
        return '.' . g:PATH_SEP . cp
      endif
    catch
    endtry
  endfor

  return '.'
endfunction

" vim:set fdm=marker sw=2 nowrap:
