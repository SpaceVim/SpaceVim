scriptencoding utf-8

let s:LOGGER = SpaceVim#logger#derive('gtags')
call s:LOGGER.start_debug()

if !executable('gtags')
  call s:LOGGER.warn('gtags is not executable, you need to install gnu global!')
  finish
endif

if exists('g:loaded_gtags')
  finish
endif
let s:JOB = SpaceVim#api#import('job')
let s:FILE = SpaceVim#api#import('file')
let s:NOTI = SpaceVim#api#import('notify')

let g:loaded_gtags = 1
let s:version = split(matchstr(split(system('gtags --version'), '\n')[0], '[0-9]\+\.[0-9]\+'), '\.')

""
" Set the global command name. If it is not set, will use $GTAGSGLOBAL, and if
" $GTAGSGLOBAL still is an empty string, then will use 'global'.
let g:gtags_global_command = get(g:, 'gtags_global_command',
      \ empty($GTAGSGLOBAL) ? 'global' : $GTAGSGLOBAL
      \ )

""
" This setting will open the |quickfix| list when adding entries. A value of 2 will
" preserve the cursor position when the |quickfix| window is
" opened. Defaults to 2.
"
" NOTE: when there is only one entry. the quickfix list will not be opened.
let g:gtags_open_list = get(g:, 'gtags_open_list', 2)

" -- ctags-x format
" let Gtags_Result = "ctags-x"
" let Gtags_Efm = "%*\\S%*\\s%l%\\s%f%\\s%m"
"
" -- ctags format
" let Gtags_Result = "ctags"
" let Gtags_Efm = "%m\t%f\t%l"
"
" Gtags_Use_Tags_Format is obsoleted.
if exists('g:Gtags_Use_Tags_Format')
  let g:Gtags_Result = 'ctags'
  let g:Gtags_Efm = "%m\t%f\t%l"
endif
if !exists('g:Gtags_Result')
  let g:Gtags_Result = 'ctags-x'
endif
if !exists('g:Gtags_Efm')
  let g:Gtags_Efm = "%*\\S%*\\s%l%\\s%f%\\s%m"
endif
" Character to use to quote patterns and file names before passing to global.
" (This code was drived from 'grep.vim'.)
if !exists('g:Gtags_Shell_Quote_Char')
  if has('win32') || has('win16') || has('win95')
    let g:Gtags_Shell_Quote_Char = '"'
  else
    let g:Gtags_Shell_Quote_Char = "'"
  endif
endif
if !exists('g:Gtags_Single_Quote_Char')
  if has('win32') || has('win16') || has('win95')
    let g:Gtags_Single_Quote_Char = "'"
    let g:Gtags_Double_Quote_Char = '\"'
  else
    let s:sq = "'"
    let s:dq = '"'
    let g:Gtags_Single_Quote_Char = s:sq . s:dq . s:sq . s:dq . s:sq
    let g:Gtags_Double_Quote_Char = '"'
  endif
endif

"
" Stack Object.
"
function! s:Stack() abort
  let l:this = {}
  let l:this.container = []

  function! l:this.push(item) abort
    call add(self.container, a:item)
  endfunction

  function! l:this.pop() abort
    if len(self.container) <= 0
      throw 'Stack Empty'
    endif

    let l:item = self.container[-1]
    unlet self.container[-1]

    return l:item
  endfunction

  return l:this
endfunction

function! s:Memorize() abort
  let l:data = {
        \'file': expand('%'),
        \'position': getpos('.'),
        \}
  call s:crumbs.push(l:data)
endfunction

function! gtags#remind() abort
  try
    let l:data = s:crumbs.pop()
  catch
    call s:Error(v:exception)
    return
  endtry

  execute 'e ' . l:data.file
  call setpos('.', l:data.position)
endfunction

if ! exists('s:crumbs')
  let s:crumbs = s:Stack()
endif

"
" Display error message.
"
function! s:Error(msg) abort
  " use notify to display error message
  "
  call s:NOTI.notify(a:msg, 'WarningMsg')
endfunction
"
" Extract pattern or option string.
"
function! s:Extract(line, target) abort
  let l:option = ''
  let l:pattern = ''
  let l:force_pattern = 0
  let l:length = strlen(a:line)
  let l:i = 0

  " skip command name.
  if a:line =~# '^Gtags'
    let l:i = 5
  endif
  while l:i < l:length && a:line[l:i] ==# ' '
    let l:i = l:i + 1
  endwhile
  while l:i < l:length
    if a:line[l:i] ==# '-' && l:force_pattern == 0
      let l:i = l:i + 1
      " Ignore long name option like --help.
      if l:i < l:length && a:line[l:i] ==# '-'
        while l:i < l:length && a:line[l:i] !=# ' '
          let l:i = l:i + 1
        endwhile
      else
        let l:c = ''
        while l:i < l:length && a:line[l:i] !=# ' '
          let l:c = a:line[l:i]
          let l:option = l:option . l:c
          let l:i = l:i + 1
        endwhile
        if l:c ==# 'e'
          let l:force_pattern = 1
        endif
      endif
    else
      let l:pattern = ''
      " allow pattern includes blanks.
      while l:i < l:length
        if a:line[l:i] ==# "'"
          let l:pattern = l:pattern . g:Gtags_Single_Quote_Char
        elseif a:line[l:i] ==# '"'
          let l:pattern = l:pattern . g:Gtags_Double_Quote_Char
        else
          let l:pattern = l:pattern . a:line[l:i]
        endif
        let l:i = l:i + 1
      endwhile
      if a:target ==# 'pattern'
        return l:pattern
      endif
    endif
    " Skip blanks.
    while l:i < l:length && a:line[l:i] ==# ' '
      let l:i = l:i + 1
    endwhile
  endwhile
  if a:target ==# 'option'
    return l:option
  endif
  return ''
endfunction

"
" Trim options to avoid errors.
"
function! s:TrimOption(option) abort
  let l:option = ''
  let l:length = strlen(a:option)
  let l:i = 0

  while l:i < l:length
    let l:c = a:option[l:i]
    if l:c !~# '[cenpquv]'
      let l:option = l:option . l:c
    endif
    let l:i = l:i + 1
  endwhile
  return l:option
endfunction

function! s:ExecGlobal(cmd) abort
  call s:LOGGER.debug('$GTAGSROOT is: ' . $GTAGSROOT)
  call s:LOGGER.debug('$GTAGSDBPATH is: ' . $GTAGSDBPATH)
  call s:LOGGER.debug('cmd is: ' . a:cmd)
  let l:result = system(a:cmd)
  if v:shell_error !=# 0
    call s:LOGGER.debug('failed to run, v:shell_error is ' . v:shell_error)
  endif
  return l:result
endfunction

"
" Execute global and load the result into quickfix window.
"
function! s:ExecLoad(option, long_option, pattern) abort
  " Execute global(1) command and write the result to a temporary file.
  let l:isfile = 0
  let l:option = ''
  let l:result = ''

  if a:option =~# 'f'
    let l:isfile = 1
    if filereadable(a:pattern) == 0
      call s:Error('File ' . a:pattern . ' not found.')
      return
    endif
  endif
  if a:long_option !=# ''
    let l:option = a:long_option . ' '
  endif
  " if s:version[0] > 6 || (s:version[0] == 6 && s:version[1] >= 5)
  " let l:option = l:option . '--nearness=' . expand('%:p:h') . ' '
  " endif
  let l:option = l:option . '--result=' . g:Gtags_Result . ' -q'
  let l:option = l:option . s:TrimOption(a:option)
  if l:isfile == 1
    let l:cmd = g:gtags_global_command . ' ' . l:option . ' ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char
  else
    let l:cmd = g:gtags_global_command . ' ' . l:option . 'e ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char
  endif

  let l:result = s:ExecGlobal(l:cmd)

  if v:shell_error != 0
    if v:shell_error == 2
      call s:Error('invalid arguments. (gtags.vim requires GLOBAL 5.7 or later)')
    elseif v:shell_error == 3
      call s:Error('GTAGS not found.')
    else
      call s:Error('global command failed.')
    endif
    return
  endif
  if l:result ==# ''
    if a:option =~# 'f'
      call s:Error('No tags found in ' . a:pattern)
    elseif a:option =~# 'P'
      call s:Error('No path matches found for ' . a:pattern)
    elseif a:option =~# 'g'
      call s:Error('No line matches found for ' . a:pattern)
    else
      call s:Error('No tag matches found for ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char)
    endif
    return
  endif

  call s:Memorize()

  " Parse the output of 'global -x or -t' and show in the quickfix window.
  let l:efm_org = &efm
  let &efm = g:Gtags_Efm

  cgetexpr l:result

  let &efm = l:efm_org

  " If there is only one item, jump to the position.
  if len(getqflist()) ==# 1
    silent cc
  else
    " Open the quickfix list windows only when there multiple results.
    if g:gtags_open_list == 1
      botright copen
    elseif g:gtags_open_list == 2
      call s:save_prev_windows()
      botright copen
      call s:restore_prev_windows()
    endif
  endif
endfunction

let s:prev_windows = []
function! s:save_prev_windows() abort
  let aw = winnr('#')
  let pw = winnr()
  if exists('*win_getid')
    let aw_id = win_getid(aw)
    let pw_id = win_getid(pw)
  else
    let aw_id = 0
    let pw_id = 0
  endif
  call add(s:prev_windows, [aw, pw, aw_id, pw_id])
endfunction

function! s:restore_prev_windows() abort
  let [aw, pw, aw_id, pw_id] = remove(s:prev_windows, 0)
  if winnr() != pw
    " Go back, maintaining the '#' window (CTRL-W_p).
    if pw_id
      let aw = win_id2win(aw_id)
      let pw = win_id2win(pw_id)
    endif
    if pw
      if aw
        exec aw . 'wincmd w'
      endif
      exec pw . 'wincmd w'
    endif
  endif
endfunction

"
" RunGlobal()
"
function! gtags#global(line) abort
  call s:LOGGER.debug('gtags global command: Gtags ' . a:line)
  let l:pattern = s:Extract(a:line, 'pattern')

  if l:pattern ==# '%'
    let l:pattern = expand('%')
  elseif l:pattern ==# '#'
    let l:pattern = expand('#')
  endif
  let l:option = s:Extract(a:line, 'option')
  " If no pattern supplied then get it from user.
  if l:pattern ==# '' && l:option !=# 'P'
    let s:option = l:option
    if l:option =~# 'f'
      let l:line = input('Gtags for file: ', expand('%'), 'file')
    else
      let l:line = input('Gtags for pattern: ', expand('<cword>'), 'custom,gtags#complete')
    endif
    let l:pattern = s:Extract(l:line, 'pattern')
    if l:pattern ==# ''
      call s:Error('Pattern not specified.')
      return
    endif
  endif
  call s:ExecLoad(l:option, '', l:pattern)
endfunction

"
" Execute RunGlobal() depending on the current position.
"
function! gtags#cursor() abort
  let l:pattern = expand('<cword>')
  let l:option = "--from-here=\"" . line('.') . ':' . expand('%') . "\""
  call s:ExecLoad('', l:option, l:pattern)
endfunction

"
" Core Gtags function
"
function! gtags#func(type, pattern) abort
  let l:option = ''
  if a:type ==# 'g'
    let l:option .= ' -x '
  elseif a:type ==# 'r'
    let l:option .= ' -x -r '
  elseif a:type ==# 's'
    let l:option .= ' -x -s '
  elseif a:type ==# 'e'
    let l:option .= ' -x -g '
  elseif a:type ==# 'f'
    let l:option .= ' -x -P '
  endif
  call s:ExecLoad('', l:option, a:pattern)
endfunction

"
" Show the current position on mozilla.
" (You need to execute htags(1) in your source directory.)
"
function! gtags#gozilla() abort
  let l:lineno = line('.')
  let l:filename = expand('%')
  call system('gozilla +' . l:lineno . ' ' . l:filename)
endfunction

"
" Custom completion.
"
function! gtags#complete(lead, line, pos) abort
  let s:option = s:Extract(a:line, 'option')
  return s:GtagsCandidateCore(a:lead, a:line, a:pos)
endfunction

function! s:GtagsCandidateCore(lead, ...) abort
  if s:option ==# 'g'
    return ''
  elseif s:option ==# 'f'
    if isdirectory(a:lead)
      if a:lead =~# '/$'
        let l:pattern = a:lead . '*'
      else
        let l:pattern = a:lead . '/*'
      endif
    else
      let l:pattern = a:lead . '*'
    endif
    return glob(l:pattern)
  else
    let l:cands = s:ExecGlobal(g:gtags_global_command . ' ' . '-c' . s:option . ' ' . a:lead)
    if v:shell_error == 0
      return l:cands
    endif
    return ''
  endif
endfunction

function! gtags#show_lib_path() abort
  echo $GTAGSLIBPATH
endfunction

function! gtags#add_lib(path) abort
  let $GTAGSLIBPATH .= ':'.a:path
  echo $GTAGSLIBPATH
endfunction


function! gtags#update(single_update) abort
  call s:LOGGER.debug('start to update gtags database')
  let dir = s:FILE.unify_path(g:tags_cache_dir) 
        \ . s:FILE.path_to_fname(SpaceVim#plugins#projectmanager#current_root())
  call s:LOGGER.debug('            dir:' . dir)
  call s:LOGGER.debug('         single:' . a:single_update)
  if !isdirectory(dir)
    if !mkdir(dir, 'p')
      call s:LOGGER.debug('failed to create dir:' . dir)
      return
    endif
  endif
  let cmd = ['gtags']
  if !empty(g:gtags_gtagslabel)
    let cmd += ['--gtagslabel=' . g:gtags_gtagslabel]
  endif
  if a:single_update && filereadable(dir . '/GTAGS')
    let cmd += ['--single-update', expand('%:p')]
  else
    let cmd += ['--skip-unreadable']
  endif
  let cmd += ['-O', dir]
  call s:LOGGER.debug('      gtags cmd:' . string(cmd))
  call s:LOGGER.debug('   gtags job id:' . s:JOB.start(cmd, {'on_exit' : funcref('s:on_update_exit')}))
endfunction

function! s:on_update_exit(id, data, event) abort
  if a:data > 0 && !g:gtags_silent
    call s:LOGGER.warn('failed to update gtags, exit data: ' . a:data)
  endif
endfunction

