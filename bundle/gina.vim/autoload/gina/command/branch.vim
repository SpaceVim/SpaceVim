let s:Path = vital#gina#import('System.Filepath')
let s:String = vital#gina#import('Data.String')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#branch#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())

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

function! gina#command#branch#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-' || !empty(args.get(1))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#commit#branch(a:arglead, a:cmdline, a:cursorpos)
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
  call options.define(
        \ '-d|--delete',
        \ 'Delete a branch.',
        \)
  call options.define(
        \ '-D',
        \ 'Shortcut for --delete --force.',
        \)
  call options.define(
        \ '-l|--create-reflog',
        \ 'Create the branch''s reflog.',
        \)
  call options.define(
        \ '-f|--force',
        \ 'Operate forcedly.',
        \)
  call options.define(
        \ '-m|--move',
        \ 'Move/rename a branch and the corresponding reflog.',
        \)
  call options.define(
        \ '-M',
        \ 'Shortcut for --move --force.',
        \)
  call options.define(
        \ '-i|--ignore-case',
        \ 'Sorting and filtering branches are case insensitive.',
        \)
  call options.define(
        \ '-r|--remotes',
        \ 'List or delete (if used with -d) the remote-tracking branches.',
        \)
  call options.define(
        \ '-a|--all',
        \ 'List both remote-tracking branches and local branches.',
        \)
  call options.define(
        \ '--list',
        \ 'Activate the list mode. Mainly for <pattern> match.',
        \)
  call options.define(
        \ '-v|--verbose',
        \ 'Show sha1 and commit subject line for each head.'
        \)
  call options.define(
        \ '-q|--quiet',
        \ 'Be more quiet when creating or deleting a branch.',
        \)
  call options.define(
        \ '-t|--track',
        \ 'Set up a branch.<name>.remote and branch.<name>.merge config.',
        \)
  call options.define(
        \ '--no-track',
        \ 'Do not set up "upstream" config.',
        \)
  call options.define(
        \ '--set-upstream',
        \ 'Set up a "upstream" as like --track for non existing branch.',
        \)
  call options.define(
        \ '-u|--set-upstream-to=',
        \ 'Set up "upstream" to <upstream>.',
        \ function('gina#complete#commit#branch'),
        \)
  call options.define(
        \ '--unset-upstream',
        \ 'Remove the upstream information.',
        \)
  call options.define(
        \ '--contains=',
        \ 'Only list branches which contain the specified commit.',
        \ function('gina#complete#commit#any')
        \)
  call options.define(
        \ '--merged=',
        \ 'Only list branches whose tips are reachable from the specified commit.',
        \ function('gina#complete#commit#any')
        \)
  call options.define(
        \ '--no-merged=',
        \ 'Only list branches whose tips are not reachable from the specified commit.',
        \ function('gina#complete#commit#any')
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
  if a:args.get('--list')
    return 0
  elseif !empty(a:args.get('-u|--set-upstream-to', ''))
    return 1
  elseif a:args.get('--unset-upstream')
    return 1
  elseif a:args.get('-m|--move') || a:args.get('-M')
    return 1
  elseif a:args.get('-d|--delete') || a:args.get('-D')
    return 1
  endif
  return !empty(a:args.get(1))
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

  augroup gina_command_branch_internal
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
  setlocal filetype=gina-branch
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
  let m = matchlist(record, '\(\*\|\s\) \([^ ]\+\)\%( -> \([^ ]\+\)\)\?')
  let remote = matchstr(m[2], '^remotes/\zs[^ /]\+')
  let rev = matchstr(m[2], '^\%(remotes/\)\?\zs[^ ]\+')
  let branch = matchstr(rev, printf('^\%%(%s/\)\?\zs[^ ]\+', remote))
  return {
        \ 'word': record,
        \ 'abbr': a:record,
        \ 'sign': m[1],
        \ 'alias': m[3],
        \ 'remote': remote,
        \ 'rev': rev,
        \ 'branch': branch,
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
