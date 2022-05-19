let s:Path = vital#gina#import('System.Filepath')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#edit#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())
  call gina#process#register(s:SCHEME, 1)
  try
    call s:call(a:range, a:args, a:mods)
  finally
    call gina#process#unregister(s:SCHEME, 1)
  endtry
endfunction

function! gina#command#edit#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-'
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
        \ '--line',
        \ 'An initial line number.',
        \)
  call options.define(
        \ '--col',
        \ 'An initial column number.',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')
  call gina#core#args#extend_path(a:git, args, args.pop(1))
  call gina#core#args#extend_line(a:git, args, args.pop('--line'))
  call gina#core#args#extend_col(a:git, args, args.pop('--col'))
  return args.lock()
endfunction

function! s:call(range, args, mods) abort
  let git = gina#core#get()
  let args = s:build_args(git, a:args)
  let abspath = gina#core#repo#abspath(git, args.params.path)
  let bufname = s:Path.realpath(abspath)
  call gina#core#buffer#open(bufname, {
        \ 'mods': a:mods,
        \ 'group': args.params.group,
        \ 'opener': args.params.opener,
        \ 'cmdarg': args.params.cmdarg,
        \ 'line': args.params.line,
        \ 'col': args.params.col,
        \})
  call gina#core#emitter#emit('command:called', s:SCHEME)
endfunction
