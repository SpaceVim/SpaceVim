let s:antXmlTemplate = [
      \ '  <target name="vjc-test-conditions">',
      \ '      <condition property="vjc-netbeans-condition">',
      \ '          <isset property="javac.classpath" />',
      \ '      </condition>',
      \ '      <condition property="vjc-project-condition">',
      \ '          <isreference refid="project.classpath"/>',
      \ '      </condition>',
      \ '      <condition property="vjc-classpath-condition">',
      \ '          <isreference refid="classpath"/>',
      \ '      </condition>',
      \ '  </target>',
      \ '  <target name="vjc-netbeans-classpath" depends="vjc-test-conditions" if="vjc-netbeans-condition">',
      \ '      <property name="javavi.classpath" value="${javac.classpath}" />',
      \ '  </target>',
      \ '  <target name="vjc-project-classpath" depends="vjc-test-conditions" if="vjc-project-condition">',
      \ '      <property name="javavi.classpath" refid="project.classpath"/>',
      \ '  </target>',
      \ '  <target name="vjc-classpath" depends="vjc-test-conditions" if="vjc-classpath-condition">',
      \ '      <property name="javavi.classpath" refid="project.classpath"/>',
      \ '  </target>',
      \ '  <target name="vjc-printclasspath" depends="vjc-project-classpath,vjc-netbeans-classpath,vjc-classpath">',
      \ '      <echo message="${javavi.classpath}"/>',
      \ '  </target>']

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[classpath.ant] ". log)
endfunction

function! javacomplete#classpath#ant#IfAnt()
  if executable('ant') && g:JavaComplete_AntPath != ""
    return 1
  endif
  return 0
endfunction

function! javacomplete#classpath#ant#Generate(force) abort
  let g:JavaComplete_ProjectKey = substitute(g:JavaComplete_AntPath, '[\\/:;.]', '_', 'g')
  let path = javacomplete#util#GetBase("classpath". g:FILE_SEP). g:JavaComplete_ProjectKey

  if filereadable(path)
    if a:force == 0 && getftime(path) >= getftime(g:JavaComplete_AntPath)
      call s:Log("get libs from cache file")
      return join(readfile(path), '')
    endif
    call javacomplete#util#RemoveFile(javacomplete#util#GetBase('cache'). g:FILE_SEP. 'class_packages_'. g:JavaComplete_ProjectKey. '.dat')
  endif

  let s:antPath = path
  let s:antOutput = []
  let cmd = "ant -projecthelp -v | grep '^ init\\>'"
  call javacomplete#util#RunSystem(
        \ cmd, "ant check 'init' target process",
        \ "javacomplete#classpath#ant#CheckInitTargetHandler")
  return '.'
endfunction

function! javacomplete#classpath#ant#CheckInitTargetHandler(data, event)
  if a:event == 'exit'
    if a:data == "0"
      let hasInitTarget = !empty(s:antOutput)
      let s:antOutput = []
      call s:BuildAntClasspath(hasInitTarget)
    else
      echohl WarningMsg | echomsg "Failed to check 'init' target" | echohl None
    endif
  elseif a:event == 'stdout'
    for data in filter(a:data,'v:val =~ "^ init\\>.*$"')
      if g:JavaComplete_ShowExternalCommandsOutput
        echomsg data
      endif
      if exists('s:antOutput')
        call add(s:antOutput, data)
      endif
    endfor
  elseif a:event == 'stderr'
    for data in filter(a:data,'v:val !~ "^\\s*$"')
      echoerr data
    endfor
  endif
endfunction

function! s:BuildAntClasspath(hasInitTarget)
  let tmpBuildFile = []
  for line in readfile(g:JavaComplete_AntPath)
    if stridx(line, '</project>') >= 0
      if a:hasInitTarget
        let xmlTemplate = s:antXmlTemplate
        let xmlTemplate[0] = xmlTemplate[0][:-2]. ' depends="init">'
        call extend(tmpBuildFile, xmlTemplate)
      else
        call extend(tmpBuildFile, s:antXmlTemplate)
      endif
    endif
    call add(tmpBuildFile, line)
  endfor
  let s:tmpAntFileName = "vjc-ant-build.xml"
  call writefile(tmpBuildFile, s:tmpAntFileName)

  let s:antOutput = []
  let antCmd = ['ant', '-f', s:tmpAntFileName, '-q', 'vjc-printclasspath']
  call javacomplete#util#RunSystem(
        \ antCmd, "ant classpath build process",
        \ "javacomplete#classpath#ant#BuildClasspathHandler")
endfunction

function! javacomplete#classpath#ant#BuildClasspathHandler(data, event)
  if a:event == 'exit'
    if a:data == "0"
      for line in s:antOutput
        let matches = matchlist(line, '\m^\s\+\[echo\]\s\+\(.*\)')
        if !empty(matches)
          let cp = matches[1]
          break
        endif
      endfor
      if cp != '.'
        call writefile([cp], s:antPath)
      endif

      let g:JavaComplete_LibsPath .= ':'. cp

      call javacomplete#util#RemoveFile(javacomplete#util#GetBase('cache'). g:FILE_SEP. 'class_packages_'. g:JavaComplete_ProjectKey. '.dat')

      call javacomplete#server#UnblockStart()
      call javacomplete#server#Terminate()
      call javacomplete#server#Start()

      echomsg "Ant classpath built successfully"
    else
      echohl WarningMsg | echomsg "Failed to build ant classpath" | echohl None
    endif

    call delete(s:tmpAntFileName)

    unlet s:antOutput
    unlet s:tmpAntFileName

  elseif a:event == 'stdout'
    for data in filter(a:data,'v:val !~ "^\\s*$"')
      if g:JavaComplete_ShowExternalCommandsOutput
        echomsg data
      endif
    endfor
    if exists('s:antOutput')
      call extend(s:antOutput, a:data)
    endif
  elseif a:event == 'stderr'
    for data in filter(a:data,'v:val !~ "^\\s*$"')
      echoerr data
    endfor
  endif
endfunction
" vim:set fdm=marker sw=2 nowrap:
