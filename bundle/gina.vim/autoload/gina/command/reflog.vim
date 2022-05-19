let s:String = vital#gina#import('Data.String')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#reflog#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options_show())

  if s:is_raw_command(a:args)
    " Remove non git options
    let args = a:args.clone()
    call args.pop('--group')
    call args.pop('--opener')
    " Call raw git command
    return gina#command#_raw#call(a:range, args, a:mods)
  endif

  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)
  let bufname = gina#core#buffer#bufname(git, s:SCHEME)
  call gina#core#buffer#open(bufname, {
        \ 'mods': a:mods,
        \ 'group': args.params.group,
        \ 'opener': args.params.opener,
        \ 'cmdarg': args.params.cmdarg,
        \ 'callback': {
        \   'fn': function('s:init'),
        \   'args': [args],
        \ }
        \})
endfunction

function! gina#command#reflog#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if args.get(1) =~# '^\%(show\|\)$'
    if a:arglead =~# '^-'
      let options = s:get_options_show()
      return options.complete(a:arglead, a:cmdline, a:cursorpos)
    endif
  elseif args.get(1) ==# 'expire'
    if a:arglead =~# '^-'
      let options = s:get_options_expire()
      return options.complete(a:arglead, a:cmdline, a:cursorpos)
    else
      return gina#complete#commit#any(a:arglead, a:cmdline, a:cursorpos)
    endif
  elseif args.get(1) ==# 'delete'
    if a:arglead =~# '^-'
      let options = s:get_options_delete()
      return options.complete(a:arglead, a:cmdline, a:cursorpos)
    else
      return gina#complete#commit#any(a:arglead, a:cmdline, a:cursorpos)
    endif
  elseif args.get(1) ==# 'exists'
    return gina#complete#commit#any(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#util#filter(a:arglead, [
        \ 'show',
        \ 'expire',
        \ 'delete',
        \ 'exists',
        \])
endfunction


" Private --------------------------------------------------------------------
function! s:get_options_show() abort
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
        \ '--group=',
        \ 'A window group name used for the buffer.',
        \)
  call options.define(
        \ '--follow',
        \ 'Continue listing the history of a file beyond renames',
        \)
  return options
endfunction

function! s:get_options_expire() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '--expire=',
        \ 'Prune entries older than the specified time.',
        \)
  call options.define(
        \ '--expire-unreachable=',
        \ 'Prune entries older than the specified time that are not reachable.',
        \)
  call options.define(
        \ '--rewrite',
        \ 'Adjust old SHA-1 to be equal to the new SHA-1',
        \)
  call options.define(
        \ '--updateref',
        \ 'Update the reference to the value of the top reflog entry',
        \)
  call options.define(
        \ '--stale-fix',
        \ 'Prune broken commit reflog entries',
        \)
  call options.define(
        \ '-n|--dry-run',
        \ 'Do not actually prune any entries',
        \)
  call options.define(
        \ '--verbose',
        \ 'Print extra information',
        \)
  return options
endfunction

function! s:get_options_delete() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '--rewrite',
        \ 'Adjust old SHA-1 to be equal to the new SHA-1',
        \)
  call options.define(
        \ '--updateref',
        \ 'Update the reference to the value of the top reflog entry',
        \)
  call options.define(
        \ '-n|--dry-run',
        \ 'Do not actually prune any entries',
        \)
  call options.define(
        \ '--verbose',
        \ 'Print extra information',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')

  call args.set('--color', 'always')
  return args.lock()
endfunction

function! s:is_raw_command(args) abort
  if a:args.get(1) =~# '^\%(show\|\)$'
    return 0
  elseif a:args.get(1) ==# 'expire'
    return 1
  elseif a:args.get(1) ==# 'delete'
    return 1
  elseif a:args.get(1) ==# 'exists'
    return 1
  endif
  return 0
endfunction

function! s:init(args) abort
  call gina#core#meta#set('args', a:args)

  if exists('b:gina_initialized')
    return
  endif
  let b:gina_initialized = 1

  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nomodifiable

  " Attach modules
  call gina#core#locator#attach()
  call gina#action#attach(function('s:get_candidates'))

  augroup gina_command_reflog_internal
    autocmd! * <buffer>
    autocmd BufReadCmd <buffer>
          \ call gina#core#revelator#call(function('s:BufReadCmd'), [])
  augroup END
endfunction

function! s:BufReadCmd() abort
  let git = gina#core#get_or_fail()
  let args = gina#core#meta#get_or_fail('args')
  let pipe = gina#process#pipe#stream(s:writer)
  call gina#core#buffer#assign_cmdarg()
  call gina#process#open(git, args, pipe)
  setlocal filetype=gina-reflog
endfunction

function! s:get_candidates(fline, lline) abort
  let candidates = map(
        \ getline(a:fline, a:lline),
        \ 's:parse_record(v:val)'
        \)
  return filter(candidates, '!empty(v:val)')
endfunction

function! s:parse_record(record) abort
  let record = s:String.remove_ansi_sequences(a:record)
  let rev = matchstr(record, '^[a-z0-9]\+')
  return {
        \ 'word': record,
        \ 'abbr': a:record,
        \ 'rev': rev,
        \}
endfunction


" Writer ---------------------------------------------------------------------
function! s:_writer_on_exit() abort dict
  call call(s:original_writer.on_exit, [], self)
  call gina#core#emitter#emit('command:called', s:SCHEME)
endfunction

let s:original_writer = gina#process#pipe#stream_writer()
let s:writer = extend(deepcopy(s:original_writer), {
      \ 'on_exit': function('s:_writer_on_exit'),
      \})


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'use_default_aliases': 1,
      \ 'use_default_mappings': 1,
      \})
