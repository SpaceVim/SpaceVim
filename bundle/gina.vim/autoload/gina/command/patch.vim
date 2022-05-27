let s:Path = vital#gina#import('System.Filepath')
let s:String = vital#gina#import('Data.String')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))
let s:WORKTREE = '@@'
let s:is_windows = has('win32') || has('win64')


function! gina#command#patch#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())
  call gina#process#register(s:SCHEME, 1)
  try
    call s:call(a:range, a:args, a:mods)
  finally
    call gina#process#unregister(s:SCHEME, 1)
  endtry
endfunction

function! gina#command#patch#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead[0] ==# '-' || !empty(args.get(1))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#filename#tracked(a:arglead, a:cmdline, a:cursorpos)
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
        \ '--group1=',
        \ 'A window group name used for the 1st buffer.',
        \)
  call options.define(
        \ '--group2=',
        \ 'A window group name used for the 2nd buffer.',
        \)
  call options.define(
        \ '--group3=',
        \ 'A window group name used for the 3rd buffer.',
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
        \ '--oneside',
        \ 'Use two buffers instead of three buffers.',
        \)
  call options.define(
        \ '--diffoff',
        \ 'Call diffoff! prior to open buffers.',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.groups = [
        \ args.pop('--group1', ''),
        \ args.pop('--group2', ''),
        \ args.pop('--group3', ''),
        \]
  let args.params.no_group = args.pop('--no-group', 0)
  let args.params.opener = args.pop('--opener', 'tabnew')
  let args.params.oneside = args.pop('--oneside', 0)
  let args.params.diffoff = args.pop('--diffoff')
  call gina#core#args#extend_path(a:git, args, args.pop(1))
  call gina#core#args#extend_line(a:git, args, args.pop('--line'))
  call gina#core#args#extend_col(a:git, args, args.pop('--col'))
  return args.lock()
endfunction

function! s:open(n, mods, opener, rev, params) abort
  if a:rev ==# s:WORKTREE
    execute printf(
          \ '%s Gina edit %s %s %s %s %s %s',
          \ a:mods,
          \ a:params.cmdarg,
          \ gina#util#shellescape(a:opener, '--opener='),
          \ gina#util#shellescape(a:params.groups[a:n], '--group='),
          \ gina#util#shellescape(a:params.line, '--line='),
          \ gina#util#shellescape(a:params.col, '--col='),
          \ gina#util#shellescape(a:params.path),
          \)
  else
    let treeish = gina#core#treeish#build(a:rev, a:params.path)
    execute printf(
          \ '%s Gina show %s %s %s %s %s %s',
          \ a:mods,
          \ a:params.cmdarg,
          \ gina#util#shellescape(a:opener, '--opener='),
          \ gina#util#shellescape(a:params.groups[a:n], '--group='),
          \ gina#util#shellescape(a:params.line, '--line='),
          \ gina#util#shellescape(a:params.col, '--col='),
          \ gina#util#shellescape(treeish),
          \)
  endif
endfunction

function! s:call(range, args, mods) abort
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)
  let mods = gina#util#contain_direction(a:mods)
        \ ? 'keepalt ' . a:mods
        \ : join(['keepalt', 'rightbelow', a:mods])

  if !empty(args.params.diffoff)
    diffoff!
  endif

  let opener1 = args.params.opener
  let opener2 = empty(matchstr(&diffopt, 'vertical'))
        \ ? 'split'
        \ : 'vsplit'

  " Validate if all requirements exist
  call gina#core#treeish#validate(git, ':0', args.params.path, printf(join([
        \ 'The "%s" does not have an index content.',
        \ 'Use "chaperon" instead if you would like to patch on conflicted file',
        \], "\n"), args.params.path))

  if args.params.oneside
    call s:open(1, mods, opener1, ':0', args.params)
    let bufnr2 = bufnr('%')

    call s:open(2, mods, opener2, s:WORKTREE, args.params)
    let bufnr3 = bufnr('%')
  else
    call s:open(0, mods, opener1, 'HEAD', args.params)
    let bufnr1 = bufnr('%')

    call s:open(1, mods, opener2, ':0', args.params)
    let bufnr2 = bufnr('%')

    call s:open(2, mods, opener2, s:WORKTREE, args.params)
    let bufnr3 = bufnr('%')
  endif

  " WORKTREE
  call gina#util#diffthis()
  call s:define_plug_mapping('diffput', bufnr2)
  call s:define_plug_mapping('diffget', bufnr2)
  if g:gina#command#patch#use_default_mappings
    nmap <buffer> dp <Plug>(gina-diffput)
    nmap <buffer> do <Plug>(gina-diffget)
  endif

  " HEAD
  if !args.params.oneside
    execute printf('%dwincmd w', bufwinnr(bufnr1))
    call gina#util#diffthis()
    call s:define_plug_mapping('diffput', bufnr2)
    if g:gina#command#patch#use_default_mappings
      nmap <buffer> dp <Plug>(gina-diffput)
    endif
  endif

  " INDEX
  execute printf('%dwincmd w', bufwinnr(bufnr2))
  call gina#util#diffthis()
  call s:define_plug_mapping('diffput', bufnr3)
  if !args.params.oneside
    call s:define_plug_mapping('diffget', bufnr1, '-l')
  endif
  call s:define_plug_mapping('diffget', bufnr3, '-r')
  if g:gina#command#patch#use_default_mappings
    nmap <buffer> dp <Plug>(gina-diffput)
    if !args.params.oneside
      nmap <buffer> dol <Plug>(gina-diffget-l)
    endif
    nmap <buffer> dor <Plug>(gina-diffget-r)
  endif

  setlocal buftype=acwrite
  setlocal modifiable
  augroup gina_command_patch_internal
    autocmd! * <buffer>
    autocmd BufWriteCmd <buffer> call s:BufWriteCmd()
  augroup END

  call gina#util#diffupdate()
  normal! zm
  call gina#core#emitter#emit('command:called', s:SCHEME)
endfunction

function! s:define_plug_mapping(command, bufnr, ...) abort
  let suffix = a:0 ? a:1 : ''
  let lhs = printf('<Plug>(gina-%s%s)', a:command, suffix)
  let rhs = printf(':<C-u>%s %d<CR>:diffupdate<CR>', a:command, a:bufnr)
  call gina#util#map(lhs, rhs, {
        \ 'mode': 'n',
        \ 'noremap': 1,
        \ 'silent': 1,
        \})
endfunction

function! s:patch(git) abort
  let abspath = gina#core#path#expand('%')
  let path = gina#core#repo#relpath(a:git, abspath)
  call gina#process#call_or_fail(a:git, [
        \ 'add',
        \ '--intent-to-add',
        \ '--',
        \ s:Path.realpath(abspath),
        \])
  let tempfile = tempname()
  let tempfile1 = tempfile . '.index'
  let tempfile2 = tempfile . '.buffer'
  try
    let diff = s:diff(a:git, path, getline(1, '$'), tempfile1, tempfile2)
    let result = s:apply(a:git, diff)
  finally
    silent! call delete(tempfile1)
    silent! call delete(tempfile2)
  endtry
  return result
endfunction

function! s:diff(git, path, buffer, tempfile1, tempfile2) abort
  if writefile(s:index(a:git, a:path), a:tempfile1) == -1
    return ''
  endif
  if writefile(a:buffer, a:tempfile2) == -1
    return ''
  endif
  " NOTE:
  " --no-index force --exit-code option.
  " --exit-code mean that the program exits with 1 if there were differences
  " and 0 means no differences
  let result = gina#process#call(a:git, [
        \ 'diff',
        \ '--no-index',
        \ '--unified=1',
        \ '--',
        \ a:tempfile1,
        \ a:tempfile2,
        \])
  if !result.status
    throw gina#core#revelator#info(
          \ 'No difference between index and buffer'
          \)
  endif
  return s:replace_filenames_in_diff(
        \ result.stdout,
        \ a:tempfile1,
        \ a:tempfile2,
        \ a:path,
        \)
endfunction

function! s:index(git, path) abort
  let result = gina#process#call(a:git, ['show', ':' . a:path])
  if result.status
    return []
  endif
  return result.stdout
endfunction

function! s:replace_filenames_in_diff(content, filename1, filename2, repl) abort
  " replace tempfile1/tempfile2 in the header to a:filename
  "
  "   diff --git a/<tempfile1> b/<tempfile2>
  "   index XXXXXXX..XXXXXXX XXXXXX
  "   --- a/<tempfile1>
  "   +++ b/<tempfile2>
  "
  let src1 = s:String.escape_pattern(a:filename1)
  let src2 = s:String.escape_pattern(a:filename2)
  if s:is_windows
    " NOTE:
    " '\' in {content} from 'git diff' are escaped so double escape is required
    " to substitute such path
    " NOTE:
    " escape(src1, '\') cannot be used while other characters such as '.' are
    " already escaped as well
    let src1 = substitute(src1, '\\\\', '\\\\\\\\', 'g')
    let src2 = substitute(src2, '\\\\', '\\\\\\\\', 'g')
  endif
  let repl = (a:filename1 =~# '^/' ? '/' : '') . a:repl
  let content = copy(a:content)
  let content[0] = substitute(content[0], src1, repl, '')
  let content[0] = substitute(content[0], src2, repl, '')
  let content[2] = substitute(content[2], src1, repl, '')
  let content[3] = substitute(content[3], src2, repl, '')
  return content
endfunction

function! s:apply(git, content) abort
  let tempfile = tempname()
  try
    if writefile(a:content, tempfile) == -1
      return
    endif
    let result = gina#process#call_or_fail(a:git, [
          \ 'apply',
          \ '--verbose',
          \ '--cached',
          \ '--',
          \ tempfile,
          \])
    call gina#core#emitter#emit('command:called:patch')
    return result
  finally
    silent! call delete(tempfile)
  endtry
endfunction

function! s:BufWriteCmd() abort
  let git = gina#core#get_or_fail()
  let result = gina#core#revelator#call(function('s:patch'), [git])
  if !empty(result)
    setlocal nomodified
  endif
  call gina#util#diffupdate()
endfunction


" Event ----------------------------------------------------------------------
function! s:on_command_called_patch(...) abort
  call gina#core#emitter#emit('modified:delay')
endfunction

if !exists('s:subscribed')
  let s:subscribed = 1
  call gina#core#emitter#subscribe(
        \ 'command:called:patch',
        \ function('s:on_command_called_patch')
        \)
endif


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'use_default_mappings': 1,
      \})
