" Location:     autoload/dispatch.vim

if exists('g:autoloaded_dispatch')
  finish
endif

let g:autoloaded_dispatch = 1

" Section: Utility

function! dispatch#tempname() abort
  let temp = tempname()
  if has('win32')
    return fnamemodify(fnamemodify(temp, ':h'), ':p').fnamemodify(temp, ':t')
  endif
  return temp
endfunction

function! dispatch#uniq(list) abort
  let i = 0
  let seen = {}
  while i < len(a:list)
    if (a:list[i] ==# '' && exists('empty')) || has_key(seen,a:list[i])
      call remove(a:list,i)
    elseif a:list[i] ==# ''
      let i += 1
      let empty = 1
    else
      let seen[a:list[i]] = 1
      let i += 1
    endif
  endwhile
  return a:list
endfunction

function! dispatch#fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  elseif a:file ==# '-'
    return '\-'
  else
    return substitute(escape(a:file, " \t\n*?[{`$\\%#'\"|!<"), '^[+>]', '\\&', '')
  endif
endfunction

function! dispatch#shellescape(...) abort
  let args = []
  for arg in a:000
    if arg =~# '^[A-Za-z0-9_/.-]\+$'
      let args += [arg]
    elseif &shell =~# 'c\@<!sh'
      let args += [substitute(shellescape(arg), '\\\n', '\n', 'g')]
    else
      let args += [shellescape(arg)]
    endif
  endfor
  return join(args, ' ')
endfunction

let s:var = '\%(<\%(cword\|cWORD\|cexpr\|cfile\|sfile\|slnum\|afile\|abuf\|amatch' . (has('clientserver') ? '\|client' : '') . '\)>\|%\|#<\=\d\+\|##\=\)'
function! dispatch#escape(string) abort
  return substitute(a:string, s:var, '\\&', 'g')
endfunction

function! dispatch#bang(string) abort
  return '!' . substitute(a:string, '!\|' . s:var, '\\&', 'g')
endfunction

function! s:expand(expr, dispatch_opts) abort
  if a:expr =~# '^\\\+`[-+]\=='
    return a:expr[1:-1]
  elseif a:expr =~# '^`='
    sandbox let v = eval(a:expr[2:-2])
    return v
  elseif a:expr =~# '^`[-+]='
    return ''
  endif
  call extend(l:, a:dispatch_opts)
  sandbox let v = expand(substitute(a:expr, ':S$', '', ''))
  if has('win32') && a:expr =~# '^\\[%#]' && v =~# '^\\[%#]'
    let v = v[1:-1]
  endif
  if a:expr =~# ':S$'
    let v = shellescape(v)
  endif
  if len(v) && len(expand(matchstr(a:expr, '^[%#][^:]*\%(:p:h\)\=\|^[^:]\+')))
    return v
  else
    return a:expr
  endif
endfunction

let s:flags = '<\=\%(:[p8~.htre]\|:g\=s\(.\).\{-\}\1.\{-\}\1\)*\%(:S\)\='
let s:expandable = '\C\\*\%(`[+-]\==[^`]*`\|' . s:var . s:flags . '\)'
function! dispatch#expand(string, ...) abort
  let opts = {}
  if a:0 && a:1 > 0
    let opts['l#'] = a:1
    let opts._l = a:1
  endif
  let lnum = v:lnum
  try
    let v:lnum = get(opts, 'l#', 0)
    let string = substitute(a:string, s:expandable, '\=s:expand(submatch(0), opts)', 'g')
  finally
    let v:lnum = lnum
  endtry
  return string
endfunction

function! s:command_lnum(string, lnum) abort
  return a:lnum > 0 ? substitute(a:string, '^:[%0]\=\ze\a', ':' . a:lnum, '') : a:string
endfunction

function! s:build_make(program, args) abort
  if a:program =~# '\$\*'
    return substitute(a:program, '\$\*', a:args, 'g')
  elseif empty(a:args)
    return a:program
  else
    return a:program . ' ' . a:args
  endif
endfunction

function! s:efm_query(key, format) abort
  let matches = []
  let efm = ',' . a:format
  let pattern = '\c,%\\&\(' . substitute(
        \ type(a:key) == type('') ? a:key : join(a:key, '\|'), '_', '_\=', 'g') .
        \ '\)=\(\%(\\.\|[^\,]\)*\)'
  let pos = 0
  while 1
    let match = matchlist(efm, pattern, pos)
    let pos = matchend(efm, pattern, pos)
    if pos < 0
      return matches
    endif
    call add(matches, [match[1], substitute(match[2], '\\\ze[\,]', '', 'g')])
  endwhile
endfunction

function! s:efm_literal(key, format, ...) abort
  let subs = {'%': '%', 'f': '%:S'}
  for [key, raw] in s:efm_query(a:key, a:format)
    let value = substitute(raw, '%\(.\)', '\=get(subs,submatch(1),"\030")', 'g')
    if len(value) && value !~# "\030"
      return value
    endif
  endfor
  return ''
endfunction

function! s:efm_to_regexp(pattern) abort
  return '\c^\%(' . substitute(a:pattern,
        \ '\(%\=\)\([%*\\.#^$[~]\)',
        \ '\=empty(submatch(1)) ? "\\".submatch(2) : submatch(2)==#"#"?"*":submatch(2)',
        \ 'g') . '\)$'
endfunction

function! s:efm_regexps(key, ...) abort
  let matches = s:efm_query(a:key, a:0 ? a:1 : &errorformat)
  call map(matches, '[v:val[0], s:efm_to_regexp(v:val[1])]')
  return matches
endfunction

function! s:escape_path(path) abort
  return substitute(dispatch#fnameescape(a:path), '^\\\~', '\~', '')
endfunction

function! dispatch#dir_opt(...) abort
  let dir = fnamemodify(a:0 ? a:1 : getcwd(), ':p:~:s?[^:]\zs[\\/]$??')
  return '-dir=' . s:escape_path(dir) . ' '
endfunction

function! s:cd_command() abort
  return exists('*haslocaldir') && haslocaldir() ? 'lcd' : exists(':tcd') && haslocaldir(-1) ? 'tcd' : 'cd'
endfunction

function! dispatch#cd_helper(dir) abort
  let back = s:cd_command() . ' ' . dispatch#fnameescape(getcwd())
  return 'let g:dispatch_back = '.string(back).'|lcd '.dispatch#fnameescape(a:dir)
endfunction

function! s:wrapcd(dir, cmd) abort
  if a:dir ==# getcwd()
    return a:cmd
  endif
  return 'try|execute dispatch#cd_helper('.string(a:dir).')|execute '.string(a:cmd).'|finally|execute remove(g:, "dispatch_back")|endtry'
endfunction

function! dispatch#slash() abort
  return !exists("+shellslash") || &shellslash ? '/' : '\'
endfunction

function! dispatch#shellpipe(file) abort
  if &shellpipe =~# '%s'
    return ' ' . printf(&shellpipe, dispatch#shellescape(a:file))
  else
    return ' ' . &shellpipe . ' ' . dispatch#shellescape(a:file)
  endif
endfunction

function! dispatch#vim_executable() abort
  if !exists('s:vim')
    if has('win32')
      let roots = [fnamemodify($VIMRUNTIME, ':8') . dispatch#slash(),
                  \ fnamemodify($VIM, ':8') . dispatch#slash()]
    elseif has('gui_macvim')
      let roots = [fnamemodify($VIM, ':h:h') . '/MacOS/']
    else
      let roots = [fnamemodify($VIM, ':h:h') . '/bin/']
    endif
    for root in roots
      if executable(root . v:progname)
        let s:vim = root . v:progname
        break
      endif
    endfor
    if !exists('s:vim')
      if executable(v:progname)
        let s:vim = v:progname
      else
        let s:vim = 'vim'
      endif
    endif
  endif
  return s:vim
endfunction

function! dispatch#has_callback() abort
  if has('clientserver') && !empty(v:servername)
    return 1
  elseif !exists('*job_start') && !exists('*jobstart') || !get(g:, 'dispatch_fifo_callback', 1)
    return 0
  endif
  if !exists('s:has_temp_fifo')
    let fifo = tempname()
    call system('mkfifo ' . dispatch#shellescape(fifo))
    let s:has_temp_fifo = (getftype(fifo) ==# 'fifo')
    call delete(fifo)
  endif
  return s:has_temp_fifo
endfunction

function! dispatch#callback(request) abort
  let request = s:request(a:request)
  if !has_key(request, 'id') || !dispatch#has_callback()
    return ''
  endif
  if has('clientserver') && !empty(v:servername)
    return dispatch#shellescape(dispatch#vim_executable()) .
          \ ' --servername ' . dispatch#shellescape(v:servername) .
          \ ' --remote-expr "' . 'DispatchComplete(' . request.id . ')' . '"'
  endif
  call system('mkfifo ' . dispatch#shellescape(request.file . '.callback'))
  let cmd = ['head', '-1', request.file . '.callback']
  let Cb = { ... -> dispatch#complete(request.id) }
  if exists('*job_start')
    call job_start(cmd, {'exit_cb': Cb})
  elseif exists('*jobstart')
    call jobstart(cmd, {'on_exit': Cb})
  else
    return ''
  endif
  return 'echo > ' . request.file . '.callback'
endfunction

function! dispatch#autowrite() abort
  if &autowrite || &autowriteall
    try
      if &confirm
        let reconfirm = 1
        setglobal noconfirm
      endif
      silent! wall
    finally
      if exists('reconfirm')
        setglobal confirm
      endif
    endtry
  endif
  return ''
endfunction

function! dispatch#status_var() abort
  if &shellxquote ==# '"'
    return '%ERRORLEVEL%'
  elseif &shell =~# 'csh\|fish'
    return '$status'
  else
    return '$?'
  endif
endfunction

function! s:subshell(cmds) abort
  if &shell =~# 'fish'
    return 'begin; ' . a:cmds . '; end'
  else
    return '(' . a:cmds . ')'
  endif
endfunction

function! dispatch#prepare_start(request, ...) abort
  let status = dispatch#status_var()
  let exec = 'echo ' . (&shell =~# 'fish' ? '%self' : '$$') . ' > ' . a:request.file . '.pid; '
  if executable('perl')
    let exec .= 'sync; perl -e "select(undef,undef,undef,0.1)" 2>/dev/null; '
  else
    let exec .= 'sleep 1; '
  endif
  let exec .= a:0 ? a:1 : a:request.expanded
  let wait = a:0 > 1 ? a:2 : get(a:request, 'wait', 'error')
  let pause = s:subshell("printf '\e[1m--- Press ENTER to continue ---\e[0m\\n'; exec head -1")
  if wait ==# 'always'
    let exec .= '; ' . pause
  elseif wait !=# 'never' && wait !=# 'make'
    let exec .= "; test ".status." = 0 -o ".status." = 130" .
          \ (&shell =~# 'fish' ? '; or ' : ' || ') . pause
  endif
  if wait !=# 'make'
    let exec .= '; touch ' .a:request.file . '.complete'
  endif
  let callback = dispatch#callback(a:request)
  return exec . (empty(callback) ? '' : '; ' . callback)
endfunction

function! dispatch#prepare_make(request, ...) abort
  let exec = a:0 ? a:1 : s:subshell(a:request.expanded . '; echo ' .
        \ dispatch#status_var() . ' > ' . a:request.file . '.complete') .
        \ dispatch#shellpipe(a:request.file)
  return dispatch#prepare_start(a:request, exec, 'make')
endfunction

function! dispatch#set_title(request) abort
  return dispatch#shellescape('printf',
        \ '\033]1;%s\007\033]2;%s\007',
        \ a:request.title,
        \ a:request.expanded)
endfunction

function! dispatch#isolate(request, keep, ...) abort
  let keep = ['SHELL', 'HOME'] + a:keep
  let command = ['cd ' . shellescape(getcwd())]
  for line in split(system('env'), "\n")
    let var = matchstr(line, '^\w\+\ze=')
    if !empty(var) && var !~# '^\%(_\|SHLVL\|PWD\|VIM\|VIMRUNTIME\|MYG\=VIMRC\)$' && index(keep, var) < 0
      if &shell =~# 'csh'
        let command += split('setenv '.var.' '.shellescape(eval('$'.var)), "\n")
      else
        let command += split('export '.var.'='.dispatch#shellescape(eval('$'.var)), "\n")
      endif
    endif
  endfor
  let command += a:000
  let temp = type(a:request) == type({}) ? a:request.file . '.dispatch' : dispatch#tempname()
  call writefile(command, temp)
  return 'env -i ' . join(map(copy(keep), 'v:val."=". dispatch#shellescape(eval("$".v:val))." "'), '') . &shell . ' ' . temp
endfunction

function! s:current_compiler(...) abort
  return get((empty(&l:makeprg) ? g: : b:), 'current_compiler', a:0 ? a:1 : '')
endfunction

function! s:set_current_compiler(name) abort
  if empty(a:name)
    unlet! b:current_compiler
  else
    let b:current_compiler = a:name
  endif
endfunction

function! s:postfix(request) abort
  let pid = dispatch#pid(a:request)
  return '(' . a:request.handler.'/'.(!empty(pid) ? pid : '?') . ')'
endfunction

function! s:echo_truncated(left, right) abort
  if exists('v:echospace')
    let max_len = (&cmdheight - 1) * &columns + v:echospace
  else
    let max_len = &cmdheight * &columns - 1
    let last_has_status = (&laststatus == 2 || (&laststatus == 1 && winnr('$') != 1))

    if &ruler && !last_has_status
      if empty(&rulerformat)
        " Default ruler is 17 chars wide.
        let max_len -= 17
      elseif exists('g:rulerwidth')
        " User specified width of custom ruler.
        let max_len -= g:rulerwidth
      else
        " Don't know width of custom ruler, make a conservative guess.
        let max_len -= &columns / 2
      endif
      let max_len -= 1
    endif
    if &showcmd
      let max_len -= 10
      if !&ruler || last_has_status
        let max_len -= 1
      endif
    endif
  endif
  let msg = a:left . a:right
  if len(substitute(msg, '.', '.', 'g')) > max_len
    let msg = a:left . '<' . matchstr(a:right, '\v.{'.(max_len - len(substitute(a:left, '.', '.', 'g')) - 1).'}$')
  endif
  echo msg
endfunction

function! s:dispatch(request) abort
  for handler in g:dispatch_handlers
    if get(g:, 'dispatch_no_' . handler . '_' . get(a:request, 'action')) ||
          \ get(g:, 'dispatch_no_' . handler . '_' . (get(a:request, 'action') ==# 'start' ? 'spawn' : 'dispatch'))
      continue
    endif
    let response = call('dispatch#'.handler.'#handle', [a:request])
    if !empty(response)
      let a:request.handler = handler

      " Display command, avoiding hit-enter prompt.
      redraw
      let msg = ':!'
      let suffix = s:postfix(a:request)
      let cmd = a:request.expanded . ' ' . suffix
      call s:echo_truncated(':!', a:request.expanded . ' ' . s:postfix(a:request))
      return response
    endif
  endfor
  return 0
endfunction

function! s:extract_opts(command, ...) abort
  let command = a:command
  let opts = {}
  while command =~# '^\%(-\|++\)\%(\w\+\)\%([= ]\|$\)'
    let opt = matchstr(command, '\zs\w\+')
    if command =~# '^\%(-\|++\)\w\+='
      let val = matchstr(command, '\w\+=\zs\%(\\.\|\S\)*')
    else
      let val = 1
    endif
    if opt ==# 'dir' || opt ==# 'directory'
      let opts.directory = fnamemodify(expand(val), ':p:s?[^:]\zs[\\/]$??')
    elseif index(['compiler', 'title', 'wait'], opt) >= 0
      let opts[opt] = substitute(val, '\\\(\s\)', '\1', 'g')
    endif
    let command = substitute(command, '^\%(-\|++\)\w\+\%(=\%(\\.\|\S\)*\)\=\s*', '', '')
  endwhile
  return [command, extend(opts, a:0 ? a:1 : {})]
endfunction

function! s:default_args(args, count, ...) abort
  let args = matchstr(a:args, '\s\+\zs.*')
  let format = a:0 ? a:1 : &errorformat
  if a:count >= 0
    let prefix = s:efm_literal('buffer', format, a:count)
    if len(prefix)
      let args = prefix . substitute(args, '^\ze.', ' ', '')
    endif
  endif
  if empty(args)
    let args = s:efm_literal('default', format, a:count)
  endif
  return args
endfunction

function! s:make_focus(count) abort
  return s:build_make(&makeprg, s:default_args('', a:count))
endfunction

" Section: :Start, :Spawn

function! s:focus(count) abort
  if type(get(b:, 'dispatch')) == type('')
    return b:dispatch
  else
    return s:make_focus(a:count)
  endif
endfunction

function! dispatch#spawn_command(bang, command, count, mods, ...) abort
  let [command, opts] = s:extract_opts(a:command)
  if empty(command) && a:count >= 0
    let command = s:focus(a:count)
    call extend(opts, {'wait': 'always'}, 'keep')
    let [command, opts] = s:extract_opts(command, opts)
  endif
  let opts.background = a:bang
  let opts.mods = a:mods ==# '<mods>' ? '' : a:mods
  call dispatch#spawn(command, opts, a:count)
  return ''
endfunction

function! s:doautocmd(event) abort
  if v:version >= 704 || (v:version == 703 && has('patch442'))
    return 'doautocmd <nomodeline> ' . a:event
  elseif &modelines == 0 || !&modeline
    return 'doautocmd ' . a:event
  else
    return 'try|set modelines=0|doautocmd ' . a:event . '|finally|set modelines=' . &modelines . '|endtry'
  endif
endfunction

function! s:compiler_getcwd() abort
  try
    exe s:doautocmd('QuickFixCmdPre dispatch-make-complete')
    return getcwd()
  finally
    exe s:doautocmd('QuickFixCmdPost dispatch-make-complete')
  endtry
endfunction

function! s:parse_start(command, count) abort
  let [command, opts] = s:extract_opts(a:command)
  if empty(command) && a:count >= 0
    let command = s:focus(a:count)
    call extend(opts, {'wait': 'always'}, 'keep')
    let [command, opts] = s:extract_opts(command, opts)
  endif
  if empty(command) && type(get(b:, 'start')) == type('')
    let command = b:start
    let [command, opts] = s:extract_opts(command, opts)
  elseif empty(command) && len(s:efm_literal(['start', 'default_start'], &errorformat))
    let task = s:efm_literal(['start', 'default_start'], &errorformat)
    let command = &makeprg . ' ' . task
    if !has_key(opts, 'title') && task =~# '^\w\S\{,19\}$'
      let opts.title = s:current_compiler('make') . ' ' . task
    endif
    if !has_key(opts, 'directory')
      let opts.directory = s:compiler_getcwd()
    endif
  endif
  return [command, opts]
endfunction

function! dispatch#start_command(bang, command, count, mods, ...) abort
  let [command, opts] = s:parse_start(a:command, a:count)
  let opts.background = get(opts, 'background') || a:bang
  let opts.mods = a:mods ==# '<mods>' ? '' : a:mods
  if command =~# '^:\S'
    unlet! g:dispatch_last_start
    return s:wrapcd(get(opts, 'directory', getcwd()),
          \ substitute(command, '\>', get(opts, 'background', 0) ? '!' : '', ''))
  endif
  call dispatch#start(command, opts, a:count)
  return ''
endfunction

if type(get(g:, 'DISPATCH_STARTS')) != type({})
  unlet! g:DISPATCH_STARTS
  let g:DISPATCH_STARTS = {}
endif

function! dispatch#start(command, ...) abort
  return dispatch#spawn(a:command, extend({'manage': 1}, a:0 ? a:1 : {}), a:0 > 1 ? a:2 : -1)
endfunction

function! dispatch#spawn(command, ...) abort
  let command = empty(a:command) ? &shell : a:command
  let request = extend({
        \ 'action': 'start',
        \ 'background': 0,
        \ 'command': command,
        \ 'directory': getcwd(),
        \ 'title': '',
        \ 'mods': '',
        \ }, a:0 ? a:1 : {})
  if empty(a:command)
    call extend(request, {'wait': 'never'}, 'keep')
  endif
  let g:dispatch_last_start = request
  if empty(request.title)
    let request.title = substitute(fnamemodify(matchstr(request.command, '\%(\\.\|\S\)\+'), ':t:r'), '\\\(\s\)', '\1', 'g')
  endif
  let cd = s:cd_command()
  try
    if request.directory !=# getcwd()
      let cwd = getcwd()
      execute cd dispatch#fnameescape(request.directory)
    endif
    let request.expanded = dispatch#expand(request.command, a:0 > 1 ? a:2 : -1)
    if get(request, 'manage')
      let key = request.directory."\t".substitute(request.expanded, '\s*$', '', '')
      let i = 0
      while i < len(get(g:DISPATCH_STARTS, key, []))
        let [handler, pid] = split(g:DISPATCH_STARTS[key][i], '[@/]')
        if !s:running(pid, handler)
          call remove(g:DISPATCH_STARTS[key], i)
          continue
        endif
        try
          if request.background || dispatch#{handler}#activate(pid)
            let request.handler = handler
            let request.pid = pid
            return request
          endif
        catch
        endtry
        let i += 1
      endwhile
    endif
    call dispatch#autowrite()
    let request.file = dispatch#tempname()
    let s:files[request.file] = request
    if exists('cwd')
      execute cd dispatch#fnameescape(request.directory)
    endif
    if s:dispatch(request)
      if get(request, 'manage')
        if !has_key(g:DISPATCH_STARTS, key)
          let g:DISPATCH_STARTS[key] = []
        endif
        call add(g:DISPATCH_STARTS[key], request.handler.'/'.dispatch#pid(request))
      endif
    else
      let request.handler = 'sync'
      execute dispatch#bang(request.expanded)
    endif
  finally
    if exists('cwd')
      execute cd dispatch#fnameescape(cwd)
    endif
  endtry
  return request
endfunction

" Section: :Dispatch, :Make

let g:dispatch_compilers = get(g:, 'dispatch_compilers', {})

function! s:compiler_split(args) abort
  let remove = keys(filter(copy(g:dispatch_compilers), 'empty(v:val)'))
  let pattern = '\%('.join(map(remove, 'substitute(escape(v:val, ".*^$~[]\\"), "\\w\\zs$", " ", "")'), '\s*\|').'\)'
  let args = substitute(a:args, '\s\+', ' ', 'g')
  let prefix = matchstr(args, '^\s*'.pattern.'*')
  let args = substitute(args, '^\s*'.pattern.'*', '', '')
  let rtp = escape(&runtimepath, ' ')
  for [command, plugin] in items(g:dispatch_compilers)
    if strpart(args.' ', 0, len(command)+1) ==# command.' ' && !empty(plugin)
          \ && !empty(findfile('compiler/'.plugin.'.vim', rtp))
      return [plugin, prefix, command, args[len(command) : -1]]
    endif
  endfor
  let program = matchstr(args, '\S\+')
  let rest = matchstr(args, '\s.*')
  if fnamemodify(program, ':t') ==# 'make'
    return ['make', prefix, program, rest]
  endif
  let plugins = map(reverse(split(globpath(rtp, 'compiler/*.vim'), "\n")), '[fnamemodify(v:val, ":t:r"), readfile(v:val)]')
  for [plugin, lines] in plugins
    for line in lines
      let full = substitute(substitute(
            \ matchstr(line, '\<CompilerSet\s\+makeprg=\zs\a\%(\\.\|[^[:space:]"]\)*'),
            \ '\\\(.\)', '\1', 'g'),
            \ ' \=["'']\=\%(%\|\$\*\|--\w\@!\).*', '', '')
      if !empty(full) && strpart(args.' ', 0, len(full)+1) ==# full.' '
        return [plugin, prefix, full, args[len(full) : -1]]
      endif
    endfor
  endfor
  for [plugin, lines] in plugins
    for line in lines
      if matchstr(line, '\<CompilerSet\s\+makeprg=\zs[[:alnum:]_.-]\+') ==# fnamemodify(program, ':t')
        return [plugin, prefix, program, rest]
      endif
    endfor
  endfor
  return ['', prefix, program, rest]
endfunction

function! dispatch#compiler_for_program(args) abort
  return get(s:compiler_split(a:args), 0, '')
endfunction

function! dispatch#compiler_options(compiler) abort
  let current_compiler = get(b:, 'current_compiler', '')
  let makeprg = &l:makeprg
  let efm = &l:efm
  if empty(a:compiler)
    return {}
  endif

  try
    if a:compiler ==# 'make'
      if &makeprg !=# 'make'
        setlocal errorformat<
      endif
      return {'program': 'make', 'format': &errorformat}
    endif
    let &l:makeprg = ''
    try
      execute 'compiler' dispatch#fnameescape(a:compiler)
    catch /^Vim(compiler):E666:/
      return {}
    endtry
    let options = {'format': &errorformat}
    if !empty(&l:makeprg)
      let options.program = &l:makeprg
    endif
    return options
  finally
    let &l:makeprg = makeprg
    let &l:efm = efm
    call s:set_current_compiler(current_compiler)
  endtry
endfunction

function! s:completion_filter(results, query) abort
  if type(get(g:, 'completion_filter')) == type({})
    return g:completion_filter.Apply(a:results, a:query)
  else
    return filter(a:results, 'strpart(v:val, 0, len(a:query)) ==# a:query')
  endif
endfunction

function! s:file_complete(A) abort
  return map(split(glob(substitute(a:A, '.\@<=\ze[\\/]\|$', '*', 'g')), "\n"),
        \ 'dispatch#fnameescape(isdirectory(v:val) ? v:val . dispatch#slash() : v:val)')
endfunction

function! s:compiler_complete(format, compiler, A, L, P) abort
  let compiler = empty(a:compiler) ? 'make' : a:compiler

  let fn = s:efm_literal('completion', a:format)
  if empty(fn)
    let fn = s:efm_literal('complete', a:format)
  endif
  if empty(fn)
    for file in findfile('compiler/'.compiler.'.vim', escape(&runtimepath, ' '), -1)
      for line in readfile(file)
        let fn = matchstr(line, '\C-complete=\zscustom\%(list\)\=,\%(s:\)\@!\S\+')
        if !empty(fn)
          break
        endif
      endfor
    endfor
  endif
  let fn = substitute(fn, '\C^custom\%(list\)\=,', '', '')

  if fn =~# '[#A-Z]' && exists('*' . fn)
    let results = call(fn, [a:A, a:L, a:P])
  elseif exists('*CompilerComplete_' . compiler)
    let results = call('CompilerComplete_' . compiler, [a:A, a:L, a:P])
  else
    let results = -1
  endif

  if type(results) == type([])
    return results
  elseif type(results) != type('')
    unlet! results
    let results = join(s:file_complete(a:A), "\n")
  endif

  return s:completion_filter(split(results, "\n"), a:A)
endfunction

function! dispatch#command_complete(A, L, P) abort
  let L = strpart(a:L, 0, a:P)
  let args = matchstr(L, '\s\zs.*')
  let [cmd, opts] = s:extract_opts(args)
  let P = a:P + len(cmd) - len(L)
  let len = matchend(cmd, '\S\+\s')
  if len >= 0 && P >= 0
    let cd = s:cd_command()
    try
      if get(opts, 'directory', getcwd()) !=# getcwd()
        let cwd = getcwd()
        execute cd dispatch#fnameescape(opts.directory)
      endif
      if has_key(opts, 'compiler')
        let compiler = opts.compiler
        let efm = get(dispatch#compiler_options(compiler), 'format', '')
      elseif cmd !~# '^--\S\@!'
        let compiler = dispatch#compiler_for_program(cmd)
        let efm = get(dispatch#compiler_options(compiler), 'format', '')
      else
        let compiler = s:current_compiler()
        let efm = &errorformat
      endif
      return s:compiler_complete(efm, compiler, a:A, 'Make '.strpart(cmd, len), P+5)
    finally
      if exists('cwd')
        execute cd dispatch#fnameescape(cwd)
      endif
    endtry
  elseif a:A =~# '^-dir='
    let results = map(filter(s:file_complete(a:A[5:-1]), 'isdirectory(v:val)'), '"-dir=".v:val')
  elseif a:A =~# '^-compiler='
    let results = map(reverse(split(globpath(escape(&runtimepath, ' '), 'compiler/*.vim'), "\n")), '"-compiler=".fnamemodify(v:val, ":t:r")')
  elseif a:A =~# '^-'
    let as = {'dir': 'directory'}
    let results = filter(['-compiler=', '-dir='],
          \ '!has_key(opts, get(as, v:val[1:-2], v:val[1:-2]))')
  elseif a:A =~# '^:' && exists('*getcompletion')
    let matches = matchlist(a:A, '^:\([.$]\|\d\+\)\=\(\a.*\)')
    if len(matches)
      let results = map(getcompletion(matches[2], 'command'), '":".matches[1].v:val')
    else
      let results = []
    endif
  elseif a:A =~# '[\/]'
    let results = s:file_complete(a:A)
  else
    let results = []
    for dir in split($PATH, has('win32') ? ';' : ':')
      let results += map(split(glob(dir.'/'.substitute(a:A, '.', '*&', 'g').'*'), "\n"), 'v:val[strlen(dir)+1 : -1]')
    endfor
  endif
  return s:completion_filter(sort(dispatch#uniq(results)), a:A)
endfunction

function! dispatch#make_complete(A, L, P) abort
  try
    exe s:doautocmd('QuickFixCmdPre dispatch-make-complete')
    return s:compiler_complete(&errorformat, s:current_compiler(), a:A, a:L, a:P)
  finally
    exe s:doautocmd('QuickFixCmdPost dispatch-make-complete')
  endtry
endfunction

if !exists('s:makes')
  let s:makes = []
  let s:files = {}
endif

function! dispatch#compile_command(bang, args, count, mods, ...) abort
  let [args, request] = s:extract_opts(a:args, {'mods': a:mods ==# '<mods>' ? '' : a:mods})

  if empty(args)
    let default_dispatch = 1
    if type(get(b:, 'dispatch')) == type('')
      unlet! default_dispatch
      let args = b:dispatch
    endif
    for vars in a:count < 0 ? [g:, t:, w:, b:] : []
      if type(get(vars, 'Dispatch')) == type('')
        unlet! default_dispatch
        let args = vars.Dispatch
      endif
    endfor
    let [args, request] = s:extract_opts(args, request)
  endif
  if empty(args)
    let args = '--'
  endif

  if args =~# '^!'
    return 'Start' . (a:bang ? '!' : '') . ' ' . args[1:-1]
  endif

  if args =~# '^:\S'
    call dispatch#autowrite()
    let args = s:command_lnum(args, a:count)
    return s:wrapcd(get(request, 'directory', getcwd()),
          \ substitute(args[1:-1], '\>', (a:bang ? '!' : ''), ''))
  endif

  let executable = matchstr(args, '\S\+')

  call extend(request, {
        \ 'action': 'make',
        \ 'background': a:bang,
        \ 'format': '%+I%.%#'
        \ }, 'keep')

  if executable ==# '_' || executable ==# '--'
    if !empty(get(request, 'compiler', ''))
      let compiler_options = dispatch#compiler_options(request.compiler)
      if !has_key(compiler_options, 'format')
        return 'compiler ' . dispatch#fnameescape(request.compiler)
      endif
      call extend(request, compiler_options)
    else
      let request.compiler = s:current_compiler()
      let request.program = &makeprg
      let request.format = &errorformat
    endif
    let request.args = s:default_args(args, exists('default_dispatch') && a:count < 0 ? 0 : a:count, request.format)
    let request.command = s:build_make(get(request, 'program', get(request, 'compiler', '--')), request.args)
  else
    let [compiler, prefix, program, rest] = s:compiler_split(args)
    let request.compiler = get(request, 'compiler', compiler)
    if !empty(request.compiler)
      let compiler_options = dispatch#compiler_options(request.compiler)
      if !has_key(compiler_options, 'format')
        return 'compiler ' . dispatch#fnameescape(request.compiler)
      endif
      call extend(request, compiler_options)
      if request.compiler ==# compiler
        let request.program = prefix . program
        let request.args = rest[1:-1]
      endif
    endif
    let request.command = args
  endif
  let request.format = substitute(request.format, ',%-G%\.%#\%($\|,\@=\)', '', '')

  for [key, regexp] in s:efm_regexps(['terminal', 'force_start', 'force_spawn'], request.format)
    if has_key(request, 'args') && request.args =~# regexp
      let title = request.compiler
      if regexp =~# '\\\@<!\\ze'
        let title .= ' ' . matchstr(request.args, regexp)
      endif
      let title = get(request, 'title', title)
      return (key =~? 'spawn' ? 'Spawn' : 'Start') . (a:bang ? '!' : '') .
            \ ' -title=' . escape(title, '\ ') .
            \ ' ' . request.command
    endif
  endfor

  if empty(request.compiler)
    unlet request.compiler
  endif
  let request.title = get(request, 'title', get(request, 'compiler', 'make'))

  call dispatch#autowrite()
  if winnr('$') > 1
    cclose
  endif
  let request.file = dispatch#tempname()
  let &errorfile = request.file

  let lnum = v:lnum
  let efm = &l:efm
  let makeprg = &l:makeprg
  let compiler = get(b:, 'current_compiler', '')
  let after = ''
  let cd = s:cd_command()
  try
    call s:set_current_compiler(get(request, 'compiler', ''))
    let v:lnum = a:count > 0 ? a:count : 0
    let &l:efm = request.format
    let &l:makeprg = request.command
    exe s:doautocmd('QuickFixCmdPre dispatch-make')
    let request.directory = get(request, 'directory', getcwd())
    if request.directory !=# getcwd()
      let cwd = getcwd()
      execute cd dispatch#fnameescape(request.directory)
    endif
    let request.expanded = dispatch#expand(request.command, a:count)
    call extend(s:makes, [request])
    let request.id = len(s:makes)
    let s:files[request.file] = request

    call writefile([], request.file)

    if exists(':chistory')
      let result = s:dispatch(request)
    else
      let result = 0
    endif
    if result
      if !get(request, 'background')
        call s:cgetfile(request, '')
        if result is 2
          exe 'botright copen' get(g:, 'dispatch_quickfix_height', '')
          wincmd p
        endif
      endif
    else
      let request.handler = 'sync'
      let after = 'call dispatch#complete('.request.id.',0)'
      redraw!
      let sp = dispatch#shellpipe(request.file)
      let dest = request.file . '.complete'
      if !exists(':chistory') && request.background
        echohl WarningMsg
        echo "Asynchronous dispatch requires Vim 8 or higher\n"
        echohl NONE
      endif
      if &shellxquote ==# '"'
        silent execute dispatch#bang(request.expanded . ' ' . sp . ' & echo %ERRORLEVEL% > ' . dest)
      else
        silent execute dispatch#bang('(' . request.expanded . '; echo ' .
              \ dispatch#status_var() . ' > ' . dest . ')' . ' ' . sp)
      endif
      redraw!
    endif
  finally
    exe s:doautocmd('QuickFixCmdPost dispatch-make')
    let v:lnum = lnum
    let &l:efm = efm
    let &l:makeprg = makeprg
    call s:set_current_compiler(compiler)
    if exists('cwd')
      execute cd dispatch#fnameescape(cwd)
    endif
  endtry
  execute after
  return ''
endfunction

" Section: :FocusDispatch

function! dispatch#focus(...) abort
  let haslnum = a:0 && a:1 >= 0
  if exists('b:Dispatch') && !haslnum
    let [what, why] = [b:Dispatch, 'Buffer local focus']
  elseif exists('w:Dispatch') && !haslnum
    let [what, why] = [w:Dispatch, 'Window local focus']
  elseif exists('t:Dispatch') && !haslnum
    let [what, why] = [t:Dispatch, 'Tab local focus']
  elseif exists('g:Dispatch') && !haslnum
    let [what, why] = [g:Dispatch, 'Global focus']
  elseif exists('b:dispatch')
    let [what, why] = [b:dispatch, 'Buffer default']
  else
    let [what, why] = ['--', (len(&l:makeprg) ? 'Buffer' : 'Global') . ' default']
    let default = 1
  endif
  if what =~# '^--\S\@!'
    let args = s:default_args(what[2:-1], haslnum ? a:1 : exists('default') ? 0 : -1)
    let what = len(args) ? '-- ' . args : args
  endif
  if haslnum
    let [what, opts] = s:extract_opts(what)
    if what =~# '^:'
      let what = s:command_lnum(what, a:1)
    else
      let what = dispatch#expand(what, a:1)
    endif
    if a:0 > 1
      return [what, extend(opts, a:2)]
    endif
    if has_key(opts, 'compiler') && opts.compiler !=# dispatch#compiler_for_program(what)
      let what = '-compiler=' . opts.compiler . ' ' . what
    endif
    if has_key(opts, 'directory') && opts.directory !=# getcwd()
      let what = '-dir=' .
            \ s:escape_path(fnamemodify(opts.directory, ':~:.')) .
            \ ' ' . what
    endif
  endif
  if what =~# '^--\S\@!'
    return [':Make' . what[2:-1], why]
  elseif what =~# '^!'
    return [':Start ' . what[1:-1], why]
  elseif what =~# '^:\S'
    return [what, why]
  else
    return [':Dispatch ' . what, why]
  endif
endfunction

function! dispatch#focus_command(bang, args, count, ...) abort
  let [args, opts] = s:extract_opts(a:args)
  if args =~# '^:[.$%]Dispatch$'
    let [args, opts] = dispatch#focus(line(a:args[1]), opts)
  elseif args =~# '^:\d*Dispatch$'
    let [args, opts] = dispatch#focus(+matchstr(a:args, '\d\+'), opts)
  elseif args =~# '^--\S\@!' && !has_key(opts, 'compiler')
    let args = s:default_args(args, -1)
    let args = s:build_make(&makeprg, args)
    let args = dispatch#expand(args, 0)
  else
    let args = args =~# '^:' ? args : dispatch#expand(args, -1)
  endif
  let args = dispatch#escape(args)
  if has_key(opts, 'compiler')
    let args = '-compiler=' . opts.compiler . ' ' . args
  endif
  if has_key(opts, 'directory')
    let args = dispatch#dir_opt(opts.directory) . args
  endif
  if empty(a:args) && a:bang
    unlet! b:Dispatch w:Dispatch t:Dispatch g:Dispatch
    let [what, why] = dispatch#focus(a:count)
    echo 'Reverted default to ' . what
  elseif empty(a:args)
    let [what, why] = dispatch#focus(a:count)
    echo a:count < 0 ? printf('%s is %s', why, what) : what
  elseif a:count >= 0
    let b:Dispatch = args
    let [what, why] = dispatch#focus()
    echo 'Set buffer local focus to ' . what
  elseif a:0 && a:1 =~# '\<tab\>'
    let t:Dispatch = args
    unlet! b:Dispatch w:Dispatch
    let [what, why] = dispatch#focus(a:count)
    echo 'Set tab local focus to ' . what
  elseif a:bang || a:0 && a:1 =~# '\<vert\>'
    let w:Dispatch = args
    unlet! b:Dispatch
    let [what, why] = dispatch#focus(a:count)
    echo 'Set window local focus to ' . what
  else
    let g:Dispatch = args
    unlet! b:Dispatch w:Dispatch t:Dispatch
    let [what, why] = dispatch#focus(a:count)
    echo 'Set global focus to ' . what
  endif
  return ''
endfunction

function! dispatch#make_focus(count) abort
  let cmd = s:make_focus(a:count)
  if a:count >= 0
    return dispatch#expand(cmd, a:count)
  else
    return cmd
  endif
endfunction

function! dispatch#spawn_focus(count) abort
  if a:count < 0
    return &shell
  else
    return dispatch#expand(s:focus(a:count), a:count)
  endif
endfunction

function! dispatch#start_focus(count) abort
  let [command, opts] = s:parse_start('', a:count)
  if a:count >= 0
    let command = dispatch#expand(command, a:count)
  endif
  if empty(command)
    let command = &shell
  endif
  if get(opts, 'wait', 'error') !=# 'error'
    let command = '-wait=' . escape(opts.wait, '\ ') . ' ' . command
  endif
  if has_key(opts, 'title')
    let command = '-title=' . escape(opts.title, '\ ') . ' ' . command
  endif
  if has_key(opts, 'directory') && opts.directory !=# getcwd()
    let command = '-dir=' .
            \ s:escape_path(fnamemodify(opts.directory, ':~:.')) . ' ' .
            \ command
  endif
  return command
endfunction

" Section: Requests

function! s:file(request) abort
  if type(a:request) == type('')
    return a:request
  elseif type(a:request) == type({})
    return get(a:request, 'file', '')
  else
    return get(get(s:makes, a:request-1, {}), 'file', '')
  endif
endfunction

function! s:request(request) abort
  if type(a:request) == type({})
    return a:request
  elseif type(a:request) == type(0) && a:request >= 0
    return get(s:makes, a:request-1, {})
  elseif type(a:request) == type('') && a:request =~# '^\w\+/\d\+$'
    let i = len(s:makes)
    while i
      let i -= 1
      if get(s:makes[i], 'handler') . '/' . dispatch#pid(s:makes[i]) ==# a:request
        return s:makes[i]
      endif
    endwhile
    return {}
  elseif type(a:request) == type('') && !empty(a:request)
    let id = matchstr(a:request, '^:noautocmd cgetfile \zs.*\|^:Dispatch.*(\zs\w\+/\d\+\ze)$')
    if empty(id)
      return get(s:files, a:request, {})
    else
      return s:request(id)
    endif
  else
    return {}
  endif
endfunction

function! dispatch#request(...) abort
  return s:request(a:0 ? a:1 : 0)
endfunction

function! s:running(pid, ...) abort
  if empty(a:pid)
    return 0
  elseif a:0 && exists('*dispatch#'.a:1.'#running')
    return dispatch#{a:1}#running(a:pid)
  elseif has('win32')
    let tasklist_cmd = 'tasklist /fi "pid eq '.a:pid.'"'
    if &shellxquote ==# '"'
      let tasklist_cmd = substitute(tasklist_cmd, '"', "'", "g")
    endif
    return system(tasklist_cmd) =~# '==='
  else
    call system('kill -0 '.a:pid)
    return !v:shell_error
  endif
endfunction

function! dispatch#pid(request) abort
  let request = s:request(a:request)
  if !has_key(request, 'pid')
    if has('win32') && !executable('wmic')
      let request.pid = 0
      return 0
    endif
    let file = request.file
    for i in range(50)
      if getfsize(file.'.pid') > 0 || filereadable(file.'.complete')
        break
      endif
      sleep 10m
    endfor
    try
      let request.pid = +readfile(file.'.pid')[0]
    catch
      let request.pid = 0
    endtry
  endif
  return request.pid
endfunction

function! dispatch#completed(request) abort
  return get(s:request(a:request), 'completed', 0)
endfunction

function! dispatch#complete(file, ...) abort
  if !dispatch#completed(a:file)
    let request = s:request(a:file)
    let request.completed = 1
    try
      let status = readfile(request.file . '.complete', 1)[0]
    catch
      let status = -1
      call writefile([-1], request.file . '.complete')
    endtry
    if !a:0
      silent doautocmd ShellCmdPost
    endif
    if !request.background && !get(request, 'aborted')
      call s:cwindow(request, 0, status, '', 'make')
      redraw!
    endif
    if has_key(request, 'aborted')
      echohl DispatchAbortedMsg
      let label = 'Aborted:'
    elseif status > 0
      echohl DispatchFailureMsg
      let label = 'Failure:'
    elseif status == 0
      echohl DispatchSuccessMsg
      let label = 'Success:'
    else
      echohl DispatchCompleteMsg
      let label = 'Complete:'
    endif
    call s:echo_truncated(label . ' !', request.expanded . ' ' . s:postfix(request))
    echohl NONE
    if !a:0
      checktime
    endif
  endif
  return ''
endfunction

" Section: :AbortDispatch

function! dispatch#abort_command(bang, query, ...) abort
  if !exists(':chistory')
    return 'echoerr ' .string('Asynchronous dispatch requires Vim 8 or higher')
  endif
  let i = len(s:makes) - 1
  while i >= 0
    let request = s:makes[i]
    if strpart(request.command, 0, len(a:query)) ==# a:query
      break
    endif
    let i -= 1
  endwhile
  if i < 0
    return 'echomsg '.string('No running dispatch found')
  endif
  let request.aborted = 1
  let pid = dispatch#pid(request)
  if !pid
    return 'echoerr '.string('No pid file')
  endif
  if exists('*dispatch#'.get(request, 'handler').'#kill')
    call dispatch#{request.handler}#kill(pid, a:bang)
  elseif has('win32')
    call system('taskkill /PID ' . (a:bang ? '/F ' : '') . pid)
  else
    call system('kill -' . (a:bang ? 'KILL' : 'HUP') . ' ' . pid)
  endif
  return 'call dispatch#complete('.request.id.')'
endfunction

" Section: Quickfix window

function! dispatch#copen(bang, mods, ...) abort
  if empty(s:makes)
    return 'echoerr ' . string('No dispatches yet')
  endif
  let request = dispatch#request()
  if !dispatch#completed(request) && filereadable(request.file . '.complete')
    let request.completed = 1
  endif
  call s:cwindow(request, a:bang, -2, a:mods ==# '<mods>' ? '' : a:mods, 'cgetfile')
endfunction

function! s:is_quickfix(...) abort
  let nr = a:0 ? a:1 : winnr()
  return getwinvar(nr, '&buftype') ==# 'quickfix' && empty(getloclist(nr))
endfunction

function! s:cgetfile(request, event, ...) abort
  let request = s:request(a:request)
  if !has_key(request, 'handler')
    throw 'Bad request ' . string(request)
  endif
  let efm = &l:efm
  let makeprg = &l:makeprg
  let compiler = get(b:, 'current_compiler', '')
  let cd = s:cd_command()
  let dir = getcwd()
  try
    call s:set_current_compiler(get(request, 'compiler', ''))
    exe cd dispatch#fnameescape(request.directory)
    if a:0 && a:1
      let &l:efm = '%+G%.%#'
    else
      let &l:efm = request.format
    endif
    let &l:makeprg = dispatch#escape(request.expanded)
    let title = ':Dispatch '.dispatch#escape(request.expanded) . ' ' . s:postfix(request)
    if len(a:event)
      exe s:doautocmd('QuickFixCmdPre ' . a:event)
    endif
    if exists(':chistory') && get(getqflist({'title': 1}), 'title', '') ==# title
      call setqflist([], 'r')
      execute 'noautocmd caddfile' dispatch#fnameescape(request.file)
    else
      execute 'noautocmd cgetfile' dispatch#fnameescape(request.file)
    endif
    if exists(':chistory')
      call setqflist([], 'r', {'title': title})
    endif
    if len(a:event)
      exe s:doautocmd('QuickFixCmdPost ' . a:event)
    endif
  finally
    exe cd dispatch#fnameescape(dir)
    let &l:efm = efm
    let &l:makeprg = makeprg
    call s:set_current_compiler(compiler)
  endtry
endfunction

function! s:cwindow(request, all, copen, mods, event) abort
  call s:cgetfile(a:request, a:event, a:all)
  let height = get(g:, 'dispatch_quickfix_height', 10)
  if height <= 0
    return
  endif
  let was_qf = s:is_quickfix()
  let mods = a:mods
  if mods !~# 'aboveleft\|belowright\|leftabove\|rightbelow\|topleft\|botright'
    let mods = 'botright ' . mods
  endif
  if a:copen
    execute (mods) 'copen' height
  elseif !was_qf || winnr('$') > 1
    execute (mods) 'cwindow' height
  endif
  if !was_qf && s:is_quickfix() && a:copen !=# -2
    wincmd p
  endif
endfunction

function! dispatch#quickfix_init() abort
  let request = s:request(w:quickfix_title)
  if empty(request)
    return
  endif
  let w:quickfix_title = ':Dispatch ' . dispatch#escape(request.expanded) .
        \ ' ' . s:postfix(request)
  let b:dispatch = dispatch#dir_opt(request.directory) .
        \ dispatch#escape(request.expanded)
  if has_key(request, 'compiler')
    let b:dispatch = '-compiler=' . request.compiler . ' ' . b:dispatch
  endif
  if has_key(request, 'program')
    let &l:efm = request.format
    let &l:makeprg = request.program
    if has_key(request, 'compiler')
      let b:current_compiler = request.compiler
    else
      unlet! b:current_compiler
    endif
  endif
  exe 'lcd' dispatch#fnameescape(request.directory)
endfunction

" Section: End
