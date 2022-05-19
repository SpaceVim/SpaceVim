let s:Path = vital#gina#import('System.Filepath')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#cd#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())
  call gina#process#register(s:SCHEME, 1)
  try
    call s:call(a:range, a:args, a:mods)
  finally
    call gina#process#unregister(s:SCHEME, 1)
  endtry
endfunction

function! gina#command#cd#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-' || !empty(args.get(1))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#filename#directory(a:arglead, a:cmdline, a:cursorpos)
endfunction


" Private --------------------------------------------------------------------
function! s:get_options() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '--local',
        \ 'Use "lcd" command instead of "cd" command.',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.local = args.get('--local')
  call gina#core#args#extend_path(a:git, args, args.pop(1, v:null))
  return args.lock()
endfunction

function! s:call(range, args, mods) abort
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)
  let path = gina#util#get(args.params, 'path', '')
  let abspath = gina#core#repo#abspath(git, path)
  let command = args.params.local ? 'lcd' : 'cd'
  execute command gina#util#fnameescape(s:Path.realpath(abspath))
  call gina#core#emitter#emit('command:called', s:SCHEME)
endfunction

