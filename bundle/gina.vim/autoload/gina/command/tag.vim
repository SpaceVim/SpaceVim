let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#tag#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())

  if s:is_edit_command(a:args)
    return gina#command#tag#edit#call(a:range, a:args, a:mods)
  elseif s:is_raw_command(a:args)
    " Remove non git options
    let args = a:args.clone()
    call args.pop('--group')
    call args.pop('--opener')
    call args.pop('--restore')
    " Call raw git command
    return gina#command#_raw#call(a:range, args, a:mods)
  endif

  " list
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

function! gina#command#tag#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-'
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  elseif s:is_edit_command(args)
    return gina#complete#commit#any(a:arglead, a:cmdline, a:cursorpos)
  elseif s:is_raw_command(args)
    return gina#complete#tag#any(a:arglead, a:cmdline, a:cursorpos)
  endif
  return []
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
        \ '--restore',
        \ 'Restore the previous buffer when the window is closed.',
        \)
  call options.define(
        \ '-a|--annotate',
        \ 'Make an unsigned, annotated tag object',
        \)
  call options.define(
        \ '-s|--sign',
        \ 'Make a GPG-signed tag, using the default e-mail address key',
        \)
  call options.define(
        \ '-U|--local-user=',
        \ 'Make a GPG-signed tag, using the given key',
        \)
  call options.define(
        \ '-f|--force',
        \ 'Replace an existing tag with the given name',
        \)
  call options.define(
        \ '-d|--delete',
        \ 'Delete existing tags with the given name',
        \)
  call options.define(
        \ '-n',
        \ 'Print <n> lines from the annotation when using -l',
        \)
  call options.define(
        \ '-l|--list=',
        \ 'List tags with names that match the given pattern',
        \)
  call options.define(
        \ '--sort=',
        \ 'Sort based on the key given',
        \)
  call options.define(
        \ '--contains=',
        \ 'Only listtags which contains the specified commit',
        \)
  call options.define(
        \ '--points-at=',
        \ 'Only list tags of the given object',
        \)
  call options.define(
        \ '-m|--message=',
        \ 'Use the given tag message',
        \)
  call options.define(
        \ '-F|--file=',
        \ 'Take thetag message from the given file',
        \)
  call options.define(
        \ '--cleanup=',
        \ 'Set how thetag message is cleaned up',
        \)
  call options.define(
        \ '--create-reflog',
        \ 'Createa reflog for the tag',
        \)
  call options.define(
        \ '--merged=',
        \ 'Only list tags whose tips are reachable from the given commit',
        \)
  call options.define(
        \ '--no-merged=',
        \ 'Only list tags whose tips are not reachable from the given commit',
        \)
  return options
endfunction

function! s:is_edit_command(args) abort
  if a:args.get('-a|--annotate')
    return 1
  elseif a:args.get('-s|--sign')
    return 1
  elseif !empty(a:args.get('-u|--local-user'))
    return 1
  endif
  return 0
endfunction

function! s:is_raw_command(args) abort
  if a:args.get('-l|--list')
    return 0
  elseif a:args.get('-d|--delete')
    return 1
  elseif a:args.get('-v|--verify')
    return 1
  elseif a:args.get('-m|--message')
    " -a/--annotate is implied
    return 1
  elseif a:args.get('-f|--file')
    " -a/--annotate is implied
    return 1
  elseif !empty(a:args.get(1))
    " lightweight tag
    return 1
  endif
  return 0
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')
  " Remove unused option
  call args.pop('--restore')

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
  setlocal autoread

  " Attach modules
  call gina#core#locator#attach()
  call gina#action#attach(function('s:get_candidates'), {
        \ 'markable': 1,
        \})

  augroup gina_command_tag_list_internal
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
  setlocal filetype=gina-tag
endfunction

function! s:get_candidates(fline, lline) abort
  let candidates = map(
        \ getline(a:fline, a:lline),
        \ 's:parse_record(v:val)'
        \)
  return filter(candidates, '!empty(v:val)')
endfunction

function! s:parse_record(record) abort
  return {
        \ 'word': a:record,
        \ 'branch': a:record,
        \ 'rev': a:record,
        \ 'tag': a:record,
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
