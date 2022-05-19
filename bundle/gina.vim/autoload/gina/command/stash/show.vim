let s:String = vital#gina#import('Data.String')

let s:SCHEME = 'stash'


function! gina#command#stash#show#call(range, args, mods) abort
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)

  let bufname = gina#core#buffer#bufname(git, s:SCHEME, {
        \ 'rev': args.params.rev,
        \ 'params': ['show'],
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

function! gina#command#stash#show#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead =~# '^-' || !empty(args.get(2))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#stash#any(a:arglead, a:cmdline, a:cursorpos)
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
        \ 'A window group name.',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')
  let args.params.rev = args.get(2, 'stash@{0}')
  call args.set('--numstat', 1)
  call args.set(1, 'show')
  call args.set(2, args.params.rev)
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

  augroup gina_command_stash_show_internal
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
  setlocal filetype=gina-stash-show
endfunction

function! s:get_candidates(fline, lline) abort
  let args = gina#core#meta#get_or_fail('args')
  let rev = args.params.rev
  let candidates = map(
        \ getline(a:fline, a:lline),
        \ 's:parse_record(v:val, rev)'
        \)
  return filter(candidates, '!empty(v:val)')
endfunction

function! s:parse_record(record, rev) abort
  let m = matchlist(
        \ a:record,
        \ '^\(\d\+\)\s\+\(\d\+\)\s\+\(.\+\)$'
        \)
  return empty(m) ? {} : {
        \ 'word': a:record,
        \ 'added': m[1],
        \ 'removed': m[2],
        \ 'path': m[3],
        \ 'rev': a:rev,
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
