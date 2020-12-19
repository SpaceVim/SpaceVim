"=============================================================================
" FILE: installer.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:install_info_version = '3.0'

let s:log = []
let s:updates_log = []

function! neobundle#installer#update(bundles) abort "{{{
  if neobundle#util#is_sudo()
    call neobundle#util#print_error(
          \ '"sudo vim" is detected. This feature is disabled.')
    return
  endif

  let all_bundles = neobundle#config#get_enabled_bundles()

  call neobundle#commands#helptags(all_bundles)
  call s:reload(filter(copy(a:bundles),
        \ "v:val.sourced && !v:val.disabled && v:val.rtp != ''"))

  call s:save_install_info(all_bundles)

  let lazy_bundles = filter(copy(all_bundles), 'v:val.lazy')
  call neobundle#util#merge_bundle_files(
        \ lazy_bundles, 'ftdetect')
  call neobundle#util#merge_bundle_files(
        \ lazy_bundles, 'after/ftdetect')

  " For neovim remote plugins
  NeoBundleRemotePlugins
endfunction"}}}

function! neobundle#installer#build(bundle) abort "{{{
  if !empty(a:bundle.build_commands)
        \ && neobundle#config#check_commands(a:bundle.build_commands)
      call neobundle#installer#log(
            \ printf('|%s| ' .
            \        'Build dependencies not met. Skipped', a:bundle.name))
      return 0
  endif

  " Environment check.
  let build = get(a:bundle, 'build', {})
  if type(build) == type('')
    let cmd = build
  elseif neobundle#util#is_windows() && has_key(build, 'windows')
    let cmd = build.windows
  elseif neobundle#util#is_mac() && has_key(build, 'mac')
    let cmd = build.mac
  elseif neobundle#util#is_cygwin() && has_key(build, 'cygwin')
    let cmd = build.cygwin
  elseif !neobundle#util#is_windows() && has_key(build, 'linux')
        \ && !executable('gmake')
    let cmd = build.linux
  elseif !neobundle#util#is_windows() && has_key(build, 'unix')
    let cmd = build.unix
  elseif has_key(build, 'others')
    let cmd = build.others
  else
    return 0
  endif

  call neobundle#installer#log('Building...')

  let cwd = getcwd()
  try
    call neobundle#util#cd(a:bundle.path)

    if !neobundle#util#has_vimproc()
      let result = neobundle#util#system(cmd)

      if neobundle#util#get_last_status()
        call neobundle#installer#error(result)
      else
        call neobundle#installer#log(result)
      endif
    else
      call s:async_system(cmd)
    endif
  catch
    " Build error from vimproc.
    let message = (v:exception !~# '^Vim:')?
          \ v:exception : v:exception . ' ' . v:throwpoint
    call neobundle#installer#error(message)

    return 1
  finally
    call neobundle#util#cd(cwd)
  endtry

  return neobundle#util#get_last_status()
endfunction"}}}

function! neobundle#installer#reinstall(bundles) abort "{{{
  let bundles = neobundle#util#uniq(a:bundles)

  for bundle in bundles
    if bundle.type ==# 'none'
          \ || bundle.local
          \ || bundle.normalized_name ==# 'neobundle'
          \ || (bundle.sourced &&
          \     index(['vimproc', 'unite'], bundle.normalized_name) >= 0)
      call neobundle#installer#error(
            \ printf('|%s| Cannot reinstall the plugin!', bundle.name))
      continue
    endif

    " Reinstall.
    call neobundle#installer#log(
          \ printf('|%s| Reinstalling...', bundle.name))

    " Save info.
    let arg = copy(bundle.orig_arg)

    " Remove.
    call neobundle#commands#clean(1, bundle.name)

    call call('neobundle#parser#bundle', [arg])
  endfor

  call s:save_install_info(neobundle#config#get_neobundles())

  " Install.
  call neobundle#commands#install(0,
        \ join(map(copy(bundles), 'v:val.name')))

  call neobundle#installer#update(bundles)
endfunction"}}}

function! neobundle#installer#get_reinstall_bundles(bundles) abort "{{{
  call neobundle#installer#_load_install_info(a:bundles)

  let reinstall_bundles = filter(copy(a:bundles),
        \ "neobundle#config#is_installed(v:val.name)
        \  && v:val.type !=# 'none'
        \  && !v:val.local
        \  && v:val.path ==# v:val.installed_path
        \  && v:val.uri !=# v:val.installed_uri")
  if !empty(reinstall_bundles)
    call neobundle#util#print_error(
          \ 'Reinstall bundles are detected!')

    for bundle in reinstall_bundles
      echomsg printf('%s: %s -> %s',
            \   bundle.name, bundle.installed_uri, bundle.uri)
    endfor

    let cwd = neobundle#util#substitute_path_separator(getcwd())
    let warning_bundles = map(filter(copy(reinstall_bundles),
        \     'v:val.path ==# cwd'), 'v:val.path')
    if !empty(warning_bundles)
      call neobundle#util#print_error(
            \ 'Warning: current directory is the
            \  reinstall bundles directory! ' . string(warning_bundles))
    endif
    let ret = confirm('Reinstall bundles now?', "yes\nNo", 2)
    redraw
    if ret != 1
      return []
    endif
  endif

  return reinstall_bundles
endfunction"}}}

function! neobundle#installer#get_updated_bundles_message(bundles) abort "{{{
  let msg = ''

  let installed_bundles = filter(copy(a:bundles),
        \ "v:val.old_rev == ''")
  if !empty(installed_bundles)
    let msg .= "\nInstalled bundles:\n".
        \ join(map(copy(installed_bundles),
        \   "'  ' .  v:val.name"), "\n")
  endif

  let updated_bundles = filter(copy(a:bundles),
        \ "v:val.old_rev != ''")
  if !empty(updated_bundles)
    let msg .= "\nUpdated bundles:\n".
        \ join(map(updated_bundles,
        \ "'  ' . v:val.name . (v:val.commit_count == 0 ? ''
        \                     : printf('(%d change%s)',
        \                              v:val.commit_count,
        \                              (v:val.commit_count == 1 ? '' : 's')))
        \    . (v:val.uri =~ '^\\h\\w*://github.com/' ? \"\\n\"
        \      . printf('    %s/compare/%s...%s',
        \        substitute(substitute(v:val.uri, '\\.git$', '', ''),
        \          '^\\h\\w*:', 'https:', ''),
        \        v:val.old_rev, v:val.new_rev) : '')")
        \ , "\n")
  endif

  return msg
endfunction"}}}

function! neobundle#installer#get_errored_bundles_message(bundles) abort "{{{
  if empty(a:bundles)
    return ''
  endif

  let msg = "\nError installing bundles:\n".join(
        \ map(copy(a:bundles), "'  ' . v:val.name"), "\n")
  let msg .= "\n"
  let msg .= "Please read the error message log with the :message command.\n"

  return msg
endfunction"}}}

function! neobundle#installer#get_sync_command(bang, bundle, number, max) abort "{{{
  let type = neobundle#config#get_types(a:bundle.type)
  if empty(type)
    return ['E: Unknown Type', '']
  endif

  let is_directory = isdirectory(a:bundle.path)

  let cmd = type.get_sync_command(a:bundle)

  if cmd == ''
    return ['', 'Not supported sync action.']
  elseif (is_directory && !a:bang
        \ && a:bundle.install_rev ==#
        \      neobundle#installer#get_revision_number(a:bundle))
    return ['', 'Already installed.']
  endif

  let message = printf('(%'.len(a:max).'d/%d): |%s| %s',
        \ a:number, a:max, a:bundle.name, cmd)

  return [cmd, message]
endfunction"}}}

function! neobundle#installer#get_revision_lock_command(bang, bundle, number, max) abort "{{{
  let type = neobundle#config#get_types(a:bundle.type)
  if empty(type)
    return ['E: Unknown Type', '']
  endif

  let cmd = type.get_revision_lock_command(a:bundle)

  if cmd == ''
    return ['', '']
  endif

  return [cmd, '']
endfunction"}}}

function! neobundle#installer#get_revision_number(bundle) abort "{{{
  let cwd = getcwd()
  let type = neobundle#config#get_types(a:bundle.type)

  if !isdirectory(a:bundle.path)
        \ || !has_key(type, 'get_revision_number_command')
    return ''
  endif

  let cmd = type.get_revision_number_command(a:bundle)
  if cmd == ''
    return ''
  endif

  try
    call neobundle#util#cd(a:bundle.path)

    let rev = neobundle#util#system(cmd)

    if type.name ==# 'vba' || type.name ==# 'raw'
      " If rev is ok, the output is the checksum followed by the filename
      " separated by two spaces.
      let pat = '^[0-9a-f]\+  ' . a:bundle.path . '/' .
            \ fnamemodify(a:bundle.uri, ':t') . '$'
      return (rev =~# pat) ? matchstr(rev, '^[0-9a-f]\+') : ''
    else
      " If rev contains spaces, it is error message
      return (rev !~ '\s') ? rev : ''
    endif
  finally
    call neobundle#util#cd(cwd)
  endtry
endfunction"}}}

function! s:get_commit_date(bundle) abort "{{{
  let cwd = getcwd()
  try
    let type = neobundle#config#get_types(a:bundle.type)

    if !isdirectory(a:bundle.path) ||
          \ !has_key(type, 'get_commit_date_command')
      return 0
    endif

    call neobundle#util#cd(a:bundle.path)

    return neobundle#util#system(
          \ type.get_commit_date_command(a:bundle))
  finally
    call neobundle#util#cd(cwd)
  endtry
endfunction"}}}

function! neobundle#installer#get_updated_log_message(bundle, new_rev, old_rev) abort "{{{
  let cwd = getcwd()
  try
    let type = neobundle#config#get_types(a:bundle.type)

    call neobundle#util#cd(a:bundle.path)

    let log_command = has_key(type, 'get_log_command') ?
          \ type.get_log_command(a:bundle, a:new_rev, a:old_rev) : ''
    let log = (log_command != '' ?
          \ neobundle#util#system(log_command) : '')
    return log != '' ? log :
          \            (a:old_rev  == a:new_rev) ? ''
          \            : printf('%s -> %s', a:old_rev, a:new_rev)
  finally
    call neobundle#util#cd(cwd)
  endtry
endfunction"}}}

function! neobundle#installer#sync(bundle, context, is_unite) abort "{{{
  let a:context.source__number += 1

  let num = a:context.source__number
  let max = a:context.source__max_bundles

  let before_one_day = localtime() - 60 * 60 * 24
  let before_one_week = localtime() - 60 * 60 * 24 * 7

  if a:context.source__bang == 1 &&
        \ a:bundle.frozen
    let [cmd, message] = ['', 'is frozen.']
  elseif a:context.source__bang == 1 &&
        \ a:bundle.uri ==# a:bundle.installed_uri &&
        \ a:bundle.updated_time < before_one_week
        \     && a:bundle.checked_time >= before_one_day
    let [cmd, message] = ['', 'Outdated plugin.']
  else
    let [cmd, message] =
          \ neobundle#installer#get_sync_command(
          \ a:context.source__bang, a:bundle,
          \ a:context.source__number, a:context.source__max_bundles)
  endif

  if cmd == ''
    " Skipped.
    call neobundle#installer#log(s:get_skipped_message(
          \ num, max, a:bundle, '', message), a:is_unite)
    return
  elseif cmd =~# '^E: '
    " Errored.

    call neobundle#installer#update_log(
          \ printf('(%'.len(max).'d/%d): |%s| %s',
          \ num, max, a:bundle.name, 'Error'), a:is_unite)
    call neobundle#installer#error(cmd[3:])
    call add(a:context.source__errored_bundles,
          \ a:bundle)
    return
  endif

  call neobundle#installer#log(message, a:is_unite)

  let cwd = getcwd()
  try
    let lang_save = $LANG
    let $LANG = 'C'

    " Cd to bundle path.
    call neobundle#util#cd(a:bundle.path)

    let rev = neobundle#installer#get_revision_number(a:bundle)

    let process = {
          \ 'number' : num,
          \ 'rev' : rev,
          \ 'bundle' : a:bundle,
          \ 'output' : '',
          \ 'status' : -1,
          \ 'eof' : 0,
          \ 'start_time' : localtime(),
          \ }

    if isdirectory(a:bundle.path) && !a:bundle.local
      let rev_save = a:bundle.rev
      try
        " Force checkout HEAD revision.
        " The repository may be checked out.
        let a:bundle.rev = ''

        call neobundle#installer#lock_revision(
              \ process, a:context, a:is_unite)
      finally
        let a:bundle.rev = rev_save
      endtry
    endif

    if has('nvim') && a:is_unite
      " Use neovim async jobs
      let process.proc = jobstart(
            \          iconv(cmd, &encoding, 'char'), {
            \ 'on_stdout' : function('s:job_handler'),
            \ 'on_stderr' : function('s:job_handler'),
            \ 'on_exit' : function('s:job_handler'),
            \ })
    elseif neobundle#util#has_vimproc()
      let process.proc = vimproc#pgroup_open(vimproc#util#iconv(
            \            cmd, &encoding, 'char'), 0, 2)

      " Close handles.
      call process.proc.stdin.close()
      call process.proc.stderr.close()
    else
      let process.output = neobundle#util#system(cmd)
      let process.status = neobundle#util#get_last_status()
    endif
  finally
    let $LANG = lang_save
    call neobundle#util#cd(cwd)
  endtry

  call add(a:context.source__processes, process)
endfunction"}}}

function! neobundle#installer#check_output(context, process, is_unite) abort "{{{
  if has('nvim') && a:is_unite && has_key(a:process, 'proc')
    let is_timeout = (localtime() - a:process.start_time)
          \             >= a:process.bundle.install_process_timeout

    if !has_key(s:job_info, a:process.proc)
      return
    endif

    let job = s:job_info[a:process.proc]

    if !job.eof && !is_timeout
      let output = join(job.candidates[: -2], "\n")
      if output != ''
        let a:process.output .= output
        call neobundle#util#redraw_echo(output)
      endif
      let job.candidates = job.candidates[-1:]
      return
    else
      if is_timeout
        call jobstop(a:process.proc)
      endif
      let output = join(job.candidates, "\n")
      if output != ''
        let a:process.output .= output
        call neobundle#util#redraw_echo(output)
      endif
      let job.candidates = []
    endif

    let status = job.status
  elseif neobundle#util#has_vimproc() && has_key(a:process, 'proc')
    let is_timeout = (localtime() - a:process.start_time)
          \             >= a:process.bundle.install_process_timeout
    let output = vimproc#util#iconv(
          \ a:process.proc.stdout.read(-1, 300), 'char', &encoding)
    if output != ''
      let a:process.output .= output
      call neobundle#util#redraw_echo(output)
    endif
    if !a:process.proc.stdout.eof && !is_timeout
      return
    endif
    call a:process.proc.stdout.close()

    let status = a:process.proc.waitpid()[1]
  else
    let is_timeout = 0
    let status = a:process.status
  endif

  let num = a:process.number
  let max = a:context.source__max_bundles
  let bundle = a:process.bundle

  if bundle.rev != '' || !a:context.source__bang
    " Restore revision.
    let rev_save = bundle.rev
    try
      if !a:context.source__bang && bundle.rev == ''
        " Checkout install_rev revision.
        let bundle.rev = bundle.install_rev
      endif

      call neobundle#installer#lock_revision(
            \ a:process, a:context, a:is_unite)
    finally
      let bundle.rev = rev_save
    endtry
  endif

  let rev = neobundle#installer#get_revision_number(bundle)

  let updated_time = s:get_commit_date(bundle)
  let bundle.checked_time = localtime()

  if is_timeout || status
    let message = printf('(%'.len(max).'d/%d): |%s| %s',
          \ num, max, bundle.name, 'Error')
    call neobundle#installer#update_log(message, a:is_unite)
    call neobundle#installer#error(bundle.path)

    call neobundle#installer#error(
          \ (is_timeout ? 'Process timeout.' :
          \    split(a:process.output, '\n')))

    call add(a:context.source__errored_bundles,
          \ bundle)
  elseif a:process.rev ==# rev
    if updated_time != 0
      let bundle.updated_time = updated_time
    endif

    call neobundle#installer#log(s:get_skipped_message(
          \ num, max, bundle, '', 'Same revision.'), a:is_unite)
  else
    call neobundle#installer#update_log(
          \ printf('(%'.len(max).'d/%d): |%s| %s',
          \ num, max, bundle.name, 'Updated'), a:is_unite)
    if a:process.rev != ''
      let log_messages = split(
            \ neobundle#installer#get_updated_log_message(
            \   bundle, rev, a:process.rev), '\n')
      let bundle.commit_count = len(log_messages)
      call call((!has('vim_starting') ? 'neobundle#installer#update_log'
            \                         : 'neobundle#installer#log'), [
            \  map(log_messages, "printf('|%s| ' .
            \   substitute(v:val, '%', '%%', 'g'), bundle.name)"),
            \  a:is_unite
            \ ])
    else
      let bundle.commit_count = 0
    endif

    if updated_time == 0
      let updated_time = bundle.checked_time
    endif
    let bundle.updated_time = updated_time
    let bundle.installed_uri = bundle.uri
    let bundle.revisions[updated_time] = rev
    let bundle.old_rev = a:process.rev
    let bundle.new_rev = rev
    if neobundle#installer#build(bundle)
          \ && confirm('Build failed. Uninstall "'
          \   .bundle.name.'" now?', "yes\nNo", 2) == 1
      " Remove.
      call neobundle#commands#clean(1, bundle.name)
    else
      call add(a:context.source__synced_bundles, bundle)
    endif
  endif

  let bundle.install_rev = rev

  let a:process.eof = 1
endfunction"}}}

function! neobundle#installer#lock_revision(process, context, is_unite) abort "{{{
  let num = a:process.number
  let max = a:context.source__max_bundles
  let bundle = a:process.bundle

  let bundle.new_rev = neobundle#installer#get_revision_number(bundle)

  let [cmd, message] =
        \ neobundle#installer#get_revision_lock_command(
        \ a:context.source__bang, bundle, num, max)

  if cmd == '' || bundle.new_rev ==# bundle.rev
    " Skipped.
    return 0
  elseif cmd =~# '^E: '
    " Errored.
    call neobundle#installer#error(bundle.path)
    call neobundle#installer#error(cmd[3:])
    return -1
  endif

  if bundle.rev != ''
    call neobundle#installer#log(
          \ printf('(%'.len(max).'d/%d): |%s| %s',
          \ num, max, bundle.name, 'Locked'), a:is_unite)

    call neobundle#installer#log(message, a:is_unite)
  endif

  let cwd = getcwd()
  try
    " Cd to bundle path.
    call neobundle#util#cd(bundle.path)

    let result = neobundle#util#system(cmd)
    let status = neobundle#util#get_last_status()
  finally
    call neobundle#util#cd(cwd)
  endtry

  if status
    call neobundle#installer#error(bundle.path)
    call neobundle#installer#error(result)
    return -1
  endif
endfunction"}}}

function! neobundle#installer#get_release_revision(bundle, command) abort "{{{
  let cwd = getcwd()
  let rev = ''
  try
    call neobundle#util#cd(a:bundle.path)
    let rev = get(neobundle#util#sort_human(
          \ split(neobundle#util#system(a:command), '\n')), -1, '')
  finally
    call neobundle#util#cd(cwd)
  endtry

  return rev
endfunction"}}}

function! s:save_install_info(bundles) abort "{{{
  let s:install_info = {}
  for bundle in filter(copy(a:bundles),
        \ "!v:val.local && has_key(v:val, 'updated_time')")
    " Note: Don't save local repository.
    let s:install_info[bundle.name] = {
          \   'checked_time' : bundle.checked_time,
          \   'updated_time' : bundle.updated_time,
          \   'installed_uri' : bundle.installed_uri,
          \   'installed_path' : bundle.path,
          \   'revisions' : bundle.revisions,
          \ }
  endfor

  call neobundle#util#writefile('install_info',
        \ [s:install_info_version, string(s:install_info)])

  " Save lock file
  call s:save_lockfile(a:bundles)
endfunction"}}}

function! neobundle#installer#_load_install_info(bundles) abort "{{{
  let install_info_path =
        \ neobundle#get_neobundle_dir() . '/.neobundle/install_info'
  if !exists('s:install_info')
    call s:source_lockfile()

    let s:install_info = {}

    if filereadable(install_info_path)
      try
        let list = readfile(install_info_path)
        let ver = list[0]
        sandbox let s:install_info = eval(list[1])
        if ver !=# s:install_info_version
              \ || type(s:install_info) != type({})
          let s:install_info = {}
        endif
      catch
      endtry
    endif
  endif

  call map(a:bundles, "extend(v:val, get(s:install_info, v:val.name, {
        \ 'checked_time' : localtime(),
        \ 'updated_time' : localtime(),
        \ 'installed_uri' : v:val.uri,
        \ 'installed_path' : v:val.path,
        \ 'revisions' : {},
        \}))")

  return s:install_info
endfunction"}}}

function! s:get_skipped_message(number, max, bundle, prefix, message) abort "{{{
  let messages = [a:prefix . printf('(%'.len(a:max).'d/%d): |%s| %s',
          \ a:number, a:max, a:bundle.name, 'Skipped')]
  if a:message != ''
    call add(messages, a:prefix . a:message)
  endif
  return messages
endfunction"}}}

function! neobundle#installer#log(msg, ...) abort "{{{
  let msg = neobundle#util#convert2list(a:msg)
  if empty(msg)
    return
  endif
  call extend(s:log, msg)

  call s:append_log_file(msg)
endfunction"}}}

function! neobundle#installer#update_log(msg, ...) abort "{{{
  let is_unite = get(a:000, 0, 0)

  if !(&filetype == 'unite' || is_unite)
    call neobundle#util#redraw_echo(a:msg)
  endif

  call neobundle#installer#log(a:msg)

  let s:updates_log += neobundle#util#convert2list(a:msg)
endfunction"}}}

function! neobundle#installer#echomsg(msg) abort "{{{
  call neobundle#util#redraw_echomsg(a:msg)

  call neobundle#installer#log(a:msg)

  let s:updates_log += neobundle#util#convert2list(a:msg)
endfunction"}}}

function! neobundle#installer#error(msg) abort "{{{
  let msgs = neobundle#util#convert2list(a:msg)
  if empty(msgs)
    return
  endif
  call extend(s:log, msgs)
  call extend(s:updates_log, msgs)

  call neobundle#util#print_error(msgs)
  call s:append_log_file(msgs)
endfunction"}}}

function! s:append_log_file(msg) abort "{{{
  if g:neobundle#log_filename == ''
    return
  endif

  let msg = a:msg
  " Appends to log file.
  if filereadable(g:neobundle#log_filename)
    let msg = readfile(g:neobundle#log_filename) + msg
  endif

  let dir = fnamemodify(g:neobundle#log_filename, ':h')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  call writefile(msg, g:neobundle#log_filename)
endfunction"}}}

function! neobundle#installer#get_log() abort "{{{
  return s:log
endfunction"}}}

function! neobundle#installer#get_updates_log() abort "{{{
  return s:updates_log
endfunction"}}}

function! neobundle#installer#clear_log() abort "{{{
  let s:log = []
  let s:updates_log = []
endfunction"}}}

function! neobundle#installer#get_progress_message(bundle, number, max) abort "{{{
  return printf('(%'.len(a:max).'d/%d) [%-20s] %s',
          \ a:number, a:max,
          \ repeat('=', (a:number*20/a:max)), a:bundle.name)
endfunction"}}}

function! neobundle#installer#get_tags_info() abort "{{{
  let path = neobundle#get_neobundle_dir() . '/.neobundle/tags_info'
  if !filereadable(path)
    return []
  endif

  return readfile(path)
endfunction"}}}

function! s:save_lockfile(bundles) abort "{{{
  let path = neobundle#get_neobundle_dir() . '/NeoBundle.lock'
  let dir = fnamemodify(path, ':h')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif

  return writefile(sort(map(filter(map(copy(a:bundles),
        \ '[v:val.name, neobundle#installer#get_revision_number(v:val)]'),
        \ "v:val[1] != '' && v:val[1] !~ '\s'"),
        \ "printf('NeoBundleLock %s %s',
        \          escape(v:val[0], ' \'), v:val[1])")), path)
endfunction"}}}

function! s:source_lockfile() abort "{{{
  let path = neobundle#get_neobundle_dir() . '/NeoBundle.lock'
  if filereadable(path)
    execute 'source' fnameescape(path)
  endif
endfunction"}}}

function! s:reload(bundles) abort "{{{
  if empty(a:bundles)
    return
  endif

  call filter(copy(a:bundles), 'neobundle#config#rtp_add(v:val)')

  silent! runtime! ftdetect/**/*.vim
  silent! runtime! after/ftdetect/**/*.vim
  silent! runtime! plugin/**/*.vim
  silent! runtime! after/plugin/**/*.vim

  " Call hooks.
  call neobundle#call_hook('on_post_source', a:bundles)
endfunction"}}}

let s:job_info = {}
function! s:job_handler(job_id, data, event) abort "{{{
  if !has_key(s:job_info, a:job_id)
    let s:job_info[a:job_id] = {
          \ 'candidates' : [],
          \ 'eof' : 0,
          \ 'status' : -1,
          \ }
  endif

  let job = s:job_info[a:job_id]

  if a:event ==# 'exit'
    let job.eof = 1
    let job.status = a:data
    return
  endif

  let lines = a:data

  let candidates = job.candidates
  if !empty(lines) && lines[0] != "\n" && !empty(job.candidates)
    " Join to the previous line
    let candidates[-1] .= lines[0]
    call remove(lines, 0)
  endif

  let candidates += map(lines, "iconv(v:val, 'char', &encoding)")
endfunction"}}}

function! s:async_system(cmd) abort "{{{
  let proc = vimproc#pgroup_open(a:cmd)

  " Close handles.
  call proc.stdin.close()

  while !proc.stdout.eof
    if !proc.stderr.eof
      " Print error.
      call neobundle#installer#error(proc.stderr.read_lines(-1, 100))
    endif

    call neobundle#util#redraw_echo(proc.stdout.read_lines(-1, 100))
  endwhile

  if !proc.stderr.eof
    " Print error.
    call neobundle#installer#error(proc.stderr.read_lines(-1, 100))
  endif

  call proc.waitpid()
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
