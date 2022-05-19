let s:Dict = vital#gina#import('Data.Dict')
let s:Group = vital#gina#import('Vim.Buffer.Group')
let s:Opener = vital#gina#import('Vim.Buffer.Opener')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#blame#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())
  call gina#process#register(s:SCHEME, 1)
  try
    call s:call(a:range, a:args, a:mods)
  finally
    call gina#process#unregister(s:SCHEME, 1)
  endtry
endfunction

function! gina#command#blame#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-' || !empty(args.get(1))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#common#treeish(a:arglead, a:cmdline, a:cursorpos)
endfunction


" Private --------------------------------------------------------------------
function! s:get_options() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '--opener=',
        \ 'A Vim command to open a new buffer.',
        \ ['edit', 'split', 'vsplit', 'tabedit', 'pedit'],
        \)
  call options.define(
        \ '--line=',
        \ 'An initial line number.',
        \)
  call options.define(
        \ '--col=',
        \ 'An initial column number.',
        \)
  call options.define(
        \ '--group1=',
        \ 'A window group name used for a blame body buffer.',
        \)
  call options.define(
        \ '--group2=',
        \ 'A window group name used for a blame navigation buffer.',
        \)
  call options.define(
        \ '--width=',
        \ 'A window width used for a blame navigation buffer.',
        \)
  call options.define(
        \ '--format=',
        \ 'Format string used to construct the navi line.',
        \)
  call options.define(
        \ '--root',
        \ 'Do not treat root commits as boundaries.',
        \)
  call options.define(
        \ '-L',
        \ 'Annotate only the given line range. May be specified multiple times.',
        \)
  call options.define(
        \ '--reverse=',
        \ 'Walk history forward instead of backward.',
        \ function('gina#complete#range#any'),
        \)
  call options.define(
        \ '--encoding=',
        \ 'Specifies the encoding used to output.',
        \)
  call options.define(
        \ '--content=', join([
        \   'This flag makes the command pretend as if the working tree copy',
        \   'has the contents of the named file.',
        \   'Works only when {rev} is not specified.'
        \ ]),
        \ function('gina#complete#filename#any'),
        \)
  call options.define(
        \ '-M',
        \ 'Detect moved or copied lines within a file.',
        \)
  call options.define(
        \ '-C',
        \ 'In addition to -M, detect lines moved or copied from other files.',
        \)
  call options.define(
        \ '-w',
        \ 'Ignore whitespace when comparing.',
        \)
  return options
endfunction

function! s:build_args(git, args, range) abort
  let args = a:args.clone()
  let args.params.groups = [
        \ args.pop('--group1', 'blame-body'),
        \ args.pop('--group2', 'blame-navi'),
        \]
  let args.params.opener = args.pop('--opener', 'tabnew')
  let args.params.width = args.pop('--width', v:null)
  let args.params.format = args.pop('--format', v:null)

  " Warn deperecated feature
  if args.pop('--use-author-instead')
    call gina#core#console#warn(
          \ '--use-author-instead option is removed. Use --format instead.'
          \)
  endif

  call gina#core#args#extend_treeish(a:git, args, args.pop(1, ':'))
  call gina#core#args#extend_line(a:git, args, args.pop('--line'))
  if empty(args.params.path)
    throw gina#core#revelator#warning(printf(
          \ 'No filename is specified. Did you mean "Gina blame %s:"?',
          \ args.params.rev,
          \))
  endif

  if !(a:range[0] == 1 && a:range[1] == line('$'))
    " Apply visual range
    call args.set('-L', join(a:range, ','))
  endif

  call args.pop('--porcelain')
  call args.pop('--line-porcelain')
  call args.set('--incremental', 1)
  call args.set(1, substitute(args.params.rev, '^:0$', '', ''))
  call args.residual([args.params.path])

  " Check no unknown options are specified
  call s:validate(args)

  return args.lock()
endfunction

function! s:validate(args) abort
  " Remove all known options
  let args = a:args.clone()
  let options = s:get_options()
  for option in values(options._options)
    for name in option.names
      call args.pop(name)
    endfor
  endfor
  call args.pop('--incremental')
  " Get remaining
  let unknown = args.get('^-')
  if !empty(unknown)
    throw gina#core#revelator#error(printf(
          \ 'Unknwon options %s has specified',
          \ string(unknown)
          \))
  endif
endfunction

function! s:call(range, args, mods) abort
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args, a:range)
  let mods = gina#util#contain_direction(a:mods)
        \ ? 'keepalt ' . a:mods
        \ : join(['keepalt', 'rightbelow', a:mods])
  let group = s:Group.new({
        \ 'on_close_fail': function('s:on_close_fail'),
        \})

  " Content
  call s:open(mods, args.params.opener, args.params)
  call group.add()
  call gina#util#windo('setlocal noscrollbind')
  setlocal scrollbind nowrap nofoldenable
  augroup gina_command_blame_internal
    autocmd! * <buffer>
    autocmd WinLeave <buffer> call s:WinLeave()
    autocmd WinEnter <buffer> call s:WinEnter()
  augroup END
  " Navi
  let bufname = gina#core#buffer#bufname(git, 'blame', {
        \ 'treeish': args.params.treeish,
        \ 'noautocmd': 1,
        \})
  call gina#core#buffer#open(bufname, {
        \ 'mods': 'leftabove',
        \ 'group': args.params.groups[1],
        \ 'opener': (args.params.width ? args.params.width : g:gina#command#blame#default_navi_width) . 'vsplit',
        \ 'cmdarg': args.params.cmdarg,
        \ 'width': args.params.width,
        \ 'line': args.params.line,
        \ 'callback': {
        \   'fn': function('s:init'),
        \   'args': [args],
        \ }
        \})
  call group.add()
  setlocal scrollbind
  call gina#util#syncbind()
  call gina#core#emitter#emit('command:called', s:SCHEME)
endfunction

function! s:on_close_fail(winnr, member) abort dict
  let bufname = bufname(winbufnr(a:winnr))
  let abspath = gina#core#repo#abspath(
        \ gina#core#get_or_fail(),
        \ gina#core#buffer#param(bufname, 'path')
        \)
  echomsg abspath
  if filereadable(abspath)
    execute printf('edit %s', fnameescape(abspath))
  else
    enew
  endif
endfunction

function! s:open(mods, opener, params) abort
  if s:Opener.is_preview_opener(a:opener)
    throw gina#core#revelator#warning(printf(
          \ 'An opener "%s" is not allowed.',
          \ a:opener,
          \))
  endif
  let treeish = gina#core#treeish#build(a:params.rev, a:params.path)
  execute printf(
        \ '%s Gina show %s %s %s %s %s',
        \ a:mods,
        \ a:params.cmdarg,
        \ gina#util#shellescape(a:opener, '--opener='),
        \ gina#util#shellescape(a:params.groups[0], '--group='),
        \ gina#util#shellescape(a:params.line, '--line='),
        \ gina#util#shellescape(treeish),
        \)
endfunction

function! s:init(args) abort
  call gina#core#meta#set('args', a:args)

  if exists('b:gina_initialized')
    return
  endif
  let b:gina_initialized = 1

  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nomodifiable
  " While navi must be vertical, set winfixwidth
  setlocal winfixwidth

  " Attach modules
  call gina#action#attach(function('s:get_candidates'))

  " Mapping
  nnoremap <buffer><silent> <Plug>(gina-blame-redraw)
        \ :<C-u>call <SID>redraw_content()<CR>
  nnoremap <buffer><silent> <Plug>(gina-blame-C-L)
        \ :<C-u>call <SID>redraw_content()<CR>:execute "normal! \<C-L>"<CR>

  augroup gina_command_blame_internal
    autocmd! * <buffer>
    autocmd WinLeave <buffer> call s:redraw_content_if_necessary()
    autocmd WinEnter <buffer> call s:redraw_content_if_necessary()
    autocmd VimResized <buffer> call s:redraw_content_if_necessary()
    autocmd WinLeave <buffer> call s:WinLeave()
    autocmd WinEnter <buffer> call s:WinEnter()
    autocmd BufReadCmd <buffer>
          \ call gina#core#revelator#call(function('s:BufReadCmd'), [])
  augroup END
endfunction

function! s:WinLeave() abort
  let git = gina#core#get_or_fail()
  let params = gina#core#buffer#parse('%')
  if params.scheme ==# 'blame'
    let alternate = gina#core#buffer#bufname(git, 'show', {
          \ 'params': params.params,
          \ 'treeish': params.treeish,
          \})
  else
    let alternate = gina#core#buffer#bufname(git, 'blame', {
          \ 'params': params.params,
          \ 'treeish': params.treeish,
          \})
  endif
  if bufwinnr(alternate) != -1
    call setbufvar(alternate, 'gina_syncbind_line', line('.'))
  endif
endfunction

function! s:WinEnter() abort
  if exists('b:gina_syncbind_line')
    call setpos('.', [0, b:gina_syncbind_line, col('.'), 0])
    unlet b:gina_syncbind_line
  endif
  syncbind
endfunction

function! s:BufReadCmd() abort
  let git = gina#core#get_or_fail()
  let args = gina#core#meta#get_or_fail('args')
  let pipe = gina#command#blame#pipe#incremental()
  let job = gina#process#open(git, args, pipe)
  let status = job.wait()
  if status
    throw gina#process#errormsg({
          \ 'args': job.args,
          \ 'status': status,
          \ 'content': pipe._stderr,
          \})
  endif
  call gina#core#meta#set('chunks', job.chunks)
  call gina#core#meta#set('revisions', job.revisions)
  call s:redraw_content()
  call gina#util#syncbind()
  setlocal filetype=gina-blame
endfunction

function! s:redraw_content() abort
  let args = gina#core#meta#get_or_fail('args')
  let chunks = gina#core#meta#get_or_fail('chunks')
  let revisions = gina#core#meta#get_or_fail('revisions')
  let formatter = gina#command#blame#formatter#new(
        \ gina#util#winwidth(0),
        \ args.params.rev,
        \ revisions,
        \ {
        \   'format': args.params.format,
        \ }
        \)
  let content = []
  call map(copy(chunks), 'extend(content, formatter.format(v:val))')
  call gina#core#writer#replace('%', 0, -1, content)
  call gina#util#syncbind()
  let b:gina_previous_winwidth = winwidth(0)
endfunction

function! s:redraw_content_if_necessary() abort
  if exists('b:gina_previous_winwidth') && b:gina_previous_winwidth != winwidth(0)
    call s:redraw_content()
  endif
endfunction

function! s:get_candidates(fline, lline) abort
  let args = gina#core#meta#get_or_fail('args')
  let chunks = gina#core#meta#get_or_fail('chunks')
  if empty(chunks)
    return []
  endif
  let revisions = gina#core#meta#get_or_fail('revisions')
  let fidx = s:binary_search(chunks, a:fline, 0, len(chunks) - 1)
  let lidx = s:binary_search(chunks, a:lline, 0, len(chunks) - 1)
  let candidates = map(
        \ range(fidx, lidx),
        \ 's:translate_candidate(args.params.rev, chunks[v:val], revisions)'
        \)
  return candidates
endfunction

function! s:binary_search(chunks, lnum, imin, imax) abort
  if a:imax < a:imin
    return v:null
  endif
  let imid = a:imin + (a:imax - a:imin) / 2
  let chunk = a:chunks[imid]
  if chunk.lnum > a:lnum
    return s:binary_search(a:chunks, a:lnum, a:imin, imid - 1)
  elseif (chunk.lnum + chunk.nlines - 1) < a:lnum
    return s:binary_search(a:chunks, a:lnum, imid + 1, a:imax)
  else
    return imid
  endif
endfunction

function! s:translate_candidate(rev, chunk, revisions) abort
  let chunk = copy(a:chunk)
  call extend(chunk, s:Dict.omit(a:revisions[chunk.revision], [
        \ 'lnum_from', 'lnum', 'nlines',
        \]))
  let rev = chunk.revision
  let path = chunk.filename
  let line = chunk.lnum_from
  return extend(chunk, {
        \ 'rev': rev,
        \ 'path': path,
        \ 'line': line,
        \})
endfunction


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'use_default_aliases': 1,
      \ 'use_default_mappings': 1,
      \ 'writer_threshold': 0,
      \ 'default_navi_width': 50,
      \})
