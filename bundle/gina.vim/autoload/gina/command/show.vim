let s:Buffer = vital#gina#import('Vim.Buffer')
let s:Path = vital#gina#import('System.Filepath')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#show#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())

  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)
  let bufname = gina#core#buffer#bufname(git, s:SCHEME, {
        \ 'treeish': args.params.treeish,
        \ 'params': [
        \   args.params.partial ? '--' : '',
        \ ],
        \})
  call gina#core#buffer#open(bufname, {
        \ 'mods': a:mods,
        \ 'group': args.params.group,
        \ 'opener': args.params.opener,
        \ 'cmdarg': args.params.cmdarg,
        \ 'line': args.params.line,
        \ 'col': args.params.col,
        \ 'callback': {
        \   'fn': function('s:init'),
        \   'args': [args],
        \ }
        \})
endfunction

function! gina#command#show#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead =~# '^-'
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
  let args.params.partial = !empty(args.residual())
  let args.params.cached = 0
  let args.params.R = args.get('-R')

  call gina#core#args#extend_treeish(a:git, args, args.pop(1))
  call gina#core#args#extend_diff(a:git, args, args.params.rev)

  " Enable --line/--col only when a path has specified
  if args.params.path isnot# v:null
    call gina#core#args#extend_line(a:git, args, args.pop('--line'))
    call gina#core#args#extend_col(a:git, args, args.pop('--col'))
  else
    call args.pop('--line')
    call args.pop('--col')
    let args.params.line = v:null
    let args.params.col = v:null
  endif
  return args.lock()
endfunction

function! s:init(args) abort
  call gina#core#meta#set('args', a:args)

  if exists('b:gina_initialized')
    return
  endif
  let b:gina_initialized = 1

  setlocal buftype=nowrite
  setlocal noswapfile
  setlocal nomodifiable
  if a:args.params.partial
    setlocal bufhidden=wipe
  else
    setlocal bufhidden&
  endif

  augroup gina_command_show_internal
    autocmd! * <buffer>
    autocmd BufReadCmd <buffer>
          \ call gina#core#revelator#call(function('s:BufReadCmd'), [])
    autocmd BufWinEnter <buffer> call setbufvar(str2nr(expand('<abuf>')), '&buflisted', 1)
    autocmd BufWinLeave <buffer> call setbufvar(str2nr(expand('<abuf>')), '&buflisted', 0)
  augroup END

  if a:args.params.path is# v:null
    nnoremap <buffer><silent> <Plug>(gina-diff-jump)
          \ :<C-u>call gina#core#diffjump#jump()<CR>
    nnoremap <buffer><silent> <Plug>(gina-diff-jump-split)
          \ :<C-u>call gina#core#diffjump#jump('split')<CR>
    nnoremap <buffer><silent> <Plug>(gina-diff-jump-vsplit)
          \ :<C-u>call gina#core#diffjump#jump('vsplit')<CR>
    if g:gina#command#show#use_default_mappings
      nmap <buffer> <CR> <Plug>(gina-diff-jump)
    endif
  endif
endfunction

function! s:reassign_rev(git, args) abort
  let rev = gina#core#treeish#resolve(a:git, a:args.params.rev)
  let treeish = gina#core#treeish#build(rev, a:args.params.path)
  call a:args.set(1, substitute(treeish, '^:0', '', ''))
  return a:args
endfunction

function! s:BufReadCmd() abort
  let git = gina#core#get_or_fail()
  let args = gina#core#meta#get_or_fail('args')
  let args = s:reassign_rev(git, args.clone())
  let result = gina#process#call_or_fail(git, args)
  call gina#core#buffer#assign_cmdarg()
  call gina#core#writer#replace('%', 0, -1, result.stdout)
  call gina#core#emitter#emit('command:called', s:SCHEME)
  if args.params.path is# v:null
    setlocal nomodeline
    setfiletype git
  else
    call gina#util#doautocmd('BufRead')
  endif
endfunction


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'use_default_mappings': 1,
      \})
