let s:String = vital#gina#import('Data.String')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#log#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)
  let bufname = gina#core#buffer#bufname(git, s:SCHEME, {
        \ 'path': args.params.path,
        \ 'params': [
        \   args.params.partial ? '--' : '',
        \ ],
        \ 'noautocmd': !empty(args.params.path),
        \})
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

function! gina#command#log#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-' || !empty(args.get(1))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#filename#any(a:arglead, a:cmdline, a:cursorpos)
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
        \ '--group=',
        \ 'A window group name used for the buffer.',
        \)
  call options.define(
        \ '--follow',
        \ 'Continue listing the history of a file beyond renames',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')
  let args.params.partial = !empty(args.residual())

  call args.set('--color', 'always')
  call args.set('--pretty', "format:\e[32m%h\e[m %s \e[33;1m%cr\e[m \e[35;1m<%an>\e[m\e[36;1m%d\e[m")
  call gina#core#args#extend_treeish(a:git, args, args.pop(1, v:null))
  if args.params.path isnot# v:null
    call args.residual([args.params.path] + args.residual())
  elseif args.params.rev isnot# v:null
    call args.set(1, args.params.rev)
  endif
  return args.lock()
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

  augroup gina_command_log_internal
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
  setlocal filetype=gina-log
endfunction

function! s:get_candidates(fline, lline) abort
  let args = gina#core#meta#get_or_fail('args')
  let path = args.params.path
  let residual = args.residual()
  let candidates = map(
        \ getline(a:fline, a:lline),
        \ 's:parse_record(v:val, path, residual)'
        \)
  return filter(candidates, '!empty(v:val)')
endfunction

function! s:parse_record(record, path, residual) abort
  let record = s:String.remove_ansi_sequences(a:record)
  let rev = matchstr(record, '^[|/\* ]*\s*\zs[a-z0-9]\+')
  return empty(rev) ? {} : {
        \ 'word': record,
        \ 'abbr': a:record,
        \ 'path': a:path,
        \ 'rev': rev,
        \ 'residual': a:residual,
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
