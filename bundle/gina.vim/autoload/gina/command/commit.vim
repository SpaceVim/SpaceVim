let s:String = vital#gina#import('Data.String')
let s:Git = vital#gina#import('Git')

let s:SCHEME = gina#command#scheme(expand('<sfile>'))
let s:messages = {}


function! gina#command#commit#call(range, args, mods) abort
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

function! gina#command#commit#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead =~# '^\%(-C\|--reuse-message=\|-c\|--reedit-message=\|--fixup=\|--squash=\)'
    let leading = matchstr(
          \ a:arglead,
          \ '^\%(-C\|--reuse-message=\|-c\|--reedit-message\|--fixup=\|--squash=\)'
          \)
    let candidates = gina#complete#commit#any(
          \ matchstr(a:arglead, '^' . leading . '\zs.*'),
          \ a:cmdline, a:cursorpos,
          \)
    return map(candidates, 'leading . v:val')
  elseif a:arglead[0] ==# '-' || !empty(args.get(1))
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  elseif a:cmdline !~# '\s--\s'
    return gina#complete#filename#any(a:arglead, a:cmdline, a:cursorpos)
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
        \ '--group=',
        \ 'A window group name used for a buffer.',
        \)
  call options.define(
        \ '--restore',
        \ 'Restore the previous buffer when the window is closed.',
        \)
  call options.define(
        \ '-a|--all',
        \ 'Commit all changed files',
        \)
  call options.define(
        \ '-C|--reuse-message=',
        \ 'Reuse message from specified commit',
        \)
  call options.define(
        \ '-c|--reedit-message=',
        \ 'Reuse and edit message from specified commit',
        \)
  call options.define(
        \ '--fixup=',
        \ 'Use autosquash formatted message to fixup specified commit',
        \)
  call options.define(
        \ '--squash=',
        \ 'Use autosquash formatted message to squash specified commit',
        \)
  call options.define(
        \ '--reset-author',
        \ 'The commit is authored by me now (used with -C/-c/--amend)',
        \)
  call options.define(
        \ '-F|--file=',
        \ 'Read message from file',
        \)
  call options.define(
        \ '--author=',
        \ 'Override the commit author',
        \)
  call options.define(
        \ '--date=',
        \ 'Override the author date used in the commit',
        \)
  call options.define(
        \ '-m|--message=',
        \ 'Use the given message as the commit message',
        \)
  call options.define(
        \ '-t|--template=',
        \ 'Read message from file and use it as a template',
        \)
  call options.define(
        \ '-s|--signoff',
        \ 'Add Signed-off-by:',
        \)
  call options.define(
        \ '--allow-empty',
        \ 'Allow empty commit',
        \)
  call options.define(
        \ '--allow-empty-message',
        \ 'Allow empty commit message',
        \)
  call options.define(
        \ '--cleanup=',
        \ 'How to strip spaces and #comments from message',
        \ ['strip', 'whitespace', 'verbatim', 'scissors', 'default'],
        \)
  call options.define(
        \ '-e|--edit',
        \ 'Force edit of commit',
        \)
  call options.define(
        \ '--no-edit',
        \ 'Use the selected commit message without editing',
        \)
  call options.define(
        \ '--amend',
        \ 'Replace the tip of the current branch by creating a new commit',
        \)
  call options.define(
        \ '-i|--include',
        \ 'Add specified files to index for commit',
        \)
  call options.define(
        \ '-o|--only',
        \ 'Commit only specified files',
        \)
  call options.define(
        \ '-u|--untracked-files=',
        \ 'Show untracked files, optional modes: all, normal, no (Default: all)',
        \ ['no', 'normal', 'all'],
        \)
  call options.define(
        \ '-v|--verbose',
        \ 'Show unified diff between the HEAD commit and what would be committed',
        \)
  call options.define(
        \ '-q|--quiet',
        \ 'Suppress commit summary message',
        \)
  call options.define(
        \ '--dry-run',
        \ 'Do not create a commit, but show a list of paths that are to be committed',
        \)
  call options.define(
        \ '--status',
        \ 'Include status in commit message template',
        \)
  call options.define(
        \ '--no-status',
        \ 'Do not include status in commit message template',
        \)
  call options.define(
        \ '-S|--gpg-sign',
        \ 'GPG sign commit',
        \)
  call options.define(
        \ '--no-gpg-sign',
        \ 'Do not GPG sign commit',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')
  let args.params.restore = args.pop(
        \ '--restore',
        \ empty(args.params.opener) || args.params.opener ==# 'edit',
        \)
  let args.params.amend = args.get('--amend')
  call gina#core#args#extend_diff(a:git, args, '')
  return args.lock()
endfunction

function! s:is_raw_command(args) abort
  if a:args.get('-e|--edit')
    return 0
  elseif a:args.get('--no-edit')
    return 1
  elseif a:args.get('--dry-run')
    return 1
  elseif !empty(a:args.get('-C|--reuse-message', ''))
    return 1
  elseif !empty(a:args.get('-c|--reedit-message', ''))
    return 0
  elseif a:args.get('-F|--file')
    return 1
  elseif !empty(a:args.get('-m|--message', ''))
    return 1
  elseif a:args.get('-t|--template')
    return 0
  elseif !empty(a:args.get('--fixup', ''))
    return 1
  endif
  return 0
endfunction

function! s:init(args) abort
  call gina#core#meta#set('args', a:args)
  silent! unlet b:gina_QuitPre
  silent! unlet b:gina_BufWriteCmd

  if exists('b:gina_initialized')
    return
  endif
  let b:gina_initialized = 1

  setlocal nobuflisted
  setlocal buftype=acwrite
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal modifiable

  augroup gina_command_commit_internal
    autocmd! * <buffer>
    autocmd BufReadCmd <buffer> call s:BufReadCmd()
    autocmd BufWriteCmd <buffer> call s:BufWriteCmd()
    autocmd QuitPre  <buffer> call s:QuitPre()
    autocmd WinLeave <buffer> call s:WinLeave()
    autocmd WinEnter <buffer> silent! unlet! b:gina_QuitPre
  augroup END

  nnoremap <silent><buffer> <Plug>(gina-commit-amend)
        \ :<C-u>call <SID>toggle_amend()<CR>

  if a:args.get('-v|--verbose')
    nnoremap <buffer><silent> <Plug>(gina-diff-jump)
          \ :<C-u>call gina#core#diffjump#jump()<CR>
    nnoremap <buffer><silent> <Plug>(gina-diff-jump-split)
          \ :<C-u>call gina#core#diffjump#jump('split')<CR>
    nnoremap <buffer><silent> <Plug>(gina-diff-jump-vsplit)
          \ :<C-u>call gina#core#diffjump#jump('vsplit')<CR>
    if g:gina#command#commit#use_default_mappings
      nmap <buffer> <CR> <Plug>(gina-diff-jump)
    endif
  endif
endfunction

function! s:BufReadCmd() abort
  let git = gina#core#get_or_fail()
  let args = gina#core#meta#get_or_fail('args')
  if v:cmdbang
    let content = s:get_commitmsg_template(git, args)
  else
    let content = s:get_commitmsg(git, args)
  endif
  call gina#core#buffer#assign_cmdarg()
  call gina#core#writer#replace('%', 0, -1, content)
  call gina#core#emitter#emit('command:called', s:SCHEME)
  setlocal filetype=gina-commit
endfunction

function! s:BufWriteCmd() abort
  let b:gina_BufWriteCmd = 1
  let git = gina#core#get_or_fail()
  let args = gina#core#meta#get_or_fail('args')
  call gina#core#revelator#call(
        \ function('s:set_commitmsg'),
        \ [git, args, getline(1, '$')]
        \)
  setlocal nomodified
endfunction

function! s:QuitPre() abort
  " Restore the previous buffer if 'restore' is specified
  let args = gina#core#meta#get('args', v:null)
  if args isnot# v:null && get(args.params, 'restore')
    let win_id = win_getid()
    if !empty(bufname('#')) && bufnr('#') isnot# -1
      silent keepalt keepjumps 1split #
    else
      silent keepalt keepjumps 1new
    endif
    call win_gotoid(win_id)
  endif
  " Do not perform commit when user hit :q!
  if histget('cmd', -1) !~# '^q\%[uit]!'
    let b:gina_QuitPre = 1
    " If this is a last window, open a new window to prevent quit
    if tabpagenr('$') == 1 && winnr('$') == 1
      let win_id = win_getid()
      silent keepalt keepjumps 1new
      call win_gotoid(win_id)
    endif
  endif
  " Clear the flag set by :w but keep it when user hit :wq
  if histget('cmd', -1) !~# '^\(wq\|x\%[it]\|exi\%[t]\)'
    silent! unlet b:gina_BufWriteCmd
  endif
endfunction

" NOTE:
" :w      -- BufWriteCmd
" <C-w>p  -- WinLeave
" :wq     -- QuitPre -> BufWriteCmd -> WinLeave (-8.2.2899)
"            BufWriteCmd -> QuitPre -> WinLeave (8.2.2900-)
" :q      -- QuitPre -> WinLeave
function! s:WinLeave() abort
  if exists('b:gina_QuitPre')
    let git = gina#core#get_or_fail()
    let args = gina#core#meta#get_or_fail('args')
    if exists('b:gina_BufWriteCmd')
      " User execute 'wq' so do not confirm
      call gina#core#revelator#call(
            \ function('s:commit_commitmsg'),
            \ [git, args]
            \)
    else
      " User execute 'q' so confirm if commit message is written
      if !empty(s:get_cached_commitmsg(git, args))
        call gina#core#revelator#call(
              \ function('s:commit_commitmsg_confirm'),
              \ [git, args]
              \)
      else
        redraw | echo ''
      endif
    endif
  endif
endfunction

function! s:toggle_amend() abort
  let args = gina#core#meta#get_or_fail('args')
  let args = args.clone()
  if args.get('--amend')
    call args.pop('--amend')
  else
    call args.set('--amend', 1)
  endif
  call gina#core#meta#set('args', args)
  edit
endfunction

function! s:get_cleanup(git, args) abort
  let config = gina#core#repo#config(a:git)
  if a:args.get('--cleanup')
    return a:args.get('--cleanup')
  endif
  return get(config, 'commit.cleanup', 'strip')
endfunction

function! s:get_commitmsg(git, args) abort
  let content = s:get_cached_commitmsg(a:git, a:args)
  if empty(content)
    return s:get_commitmsg_template(a:git, a:args)
  else
    call gina#core#console#debug('Use a cached commit message:')
    return s:get_commitmsg_cleanedup(a:git, a:args, content)
  endif
endfunction

function! s:get_commitmsg_template(git, args) abort
  let args = a:args.clone()
  let filename = s:Git.resolve(a:git, 'COMMIT_EDITMSG')
  let previous_content = filereadable(filename)
        \ ? readfile(filename)
        \ : []
  try
    " Build a new commit message template
    call args.pop('--no-edit')
    call args.set('-e|--edit', 1)
    let result = gina#process#call(a:git, args)
    if !result.status || (
          \ match(result.stderr, 'error: unable to start editor') is# -1 &&
          \ match(result.stderr, 'error: There was a problem with the editor') is# -1
          \)
      " While git is executed with '-c core.editor=false', the command above
      " should fail after that create a COMMIT_EDITMSG for the current
      " situation
      throw gina#process#errormsg(result)
    endif
    " Get a built commitmsg template
    return readfile(filename)
  finally
    " Restore the content
    call writefile(previous_content, filename)
  endtry
endfunction

" Note:
" Commit the cached messate temporary to build a correct COMMIT_EDITMSG
" This hacky implementation is required due to the lack of cleanup command.
" https://github.com/lambdalisue/gina.vim/issues/37#issuecomment-281661605
" Note:
" It is not possible to remove diff content when user does
"   1. Gina commit --verbose
"   2. Save content
"   3. Gina commit
"   4. The diff part is cached so shown and no chance to remove that
" This is a bit anoyying but I don't have any way to remove that so I just
" ended up. PRs for this issue is welcome.
" https://github.com/lambdalisue/gina.vim/issues/37#issuecomment-281687325
function! s:get_commitmsg_cleanedup(git, args, content) abort
  let args = a:args.clone()
  let filename = s:Git.resolve(a:git, 'COMMIT_EDITMSG')
  let previous_content = readfile(filename)
  let tempfile = tempname()
  try
    call writefile(a:content, tempfile)
    call args.set('--cleanup', s:get_cleanup(a:git, args))
    call args.set('-F|--file', tempfile)
    call args.set('--no-edit', 1)
    call args.set('--allow-empty', 1)
    call args.set('--allow-empty-message', 1)
    call args.pop('-C|--reuse-message')
    call args.pop('-m|--message')
    call args.pop('-e|--edit')
    call gina#process#call_or_fail(a:git, args)
    " Reset the temporary commit and remove all logs
    call gina#process#call_or_fail(a:git, ['reset', '--soft', 'HEAD@{1}'])
    call gina#process#call_or_fail(a:git, ['reflog', 'delete', 'HEAD@{0}'])
    call gina#process#call_or_fail(a:git, ['reflog', 'delete', 'HEAD@{0}'])
    " Get entire content of commitmsg
    return readfile(filename)
  finally
    call delete(tempfile)
    call writefile(previous_content, filename)
  endtry
endfunction

function! s:set_commitmsg(git, args, content) abort
  call s:set_cached_commitmsg(a:git, a:args, a:content)
endfunction

function! s:commit_commitmsg(git, args) abort
  let args = a:args.clone()
  let content = s:get_cached_commitmsg(a:git, args)
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    call args.set('--no-edit', 1)
    call args.set('--cleanup', s:get_cleanup(a:git, args))
    call args.set('-F|--file', tempfile)
    call args.pop('-C|--reuse-message')
    call args.pop('-m|--message')
    call args.pop('-e|--edit')
    let result = gina#process#call(a:git, args)
    call gina#process#inform(result)
    call s:remove_cached_commitmsg(a:git)
    call gina#core#emitter#emit('command:called:commit')
    bwipeout
  finally
    call delete(tempfile)
  endtry
endfunction

function! s:commit_commitmsg_confirm(git, args) abort
  if gina#core#console#confirm('Do you want to commit changes?', 'y')
    call s:commit_commitmsg(a:git, a:args)
  else
    redraw | echo ''
  endif
endfunction

function! s:get_cached_commitmsg(git, args) abort
  let wname = a:git.worktree
  let cname = a:args.get('--amend') ? 'amend' : '_'
  let s:messages[wname] = get(s:messages, wname, {})
  return get(s:messages[wname], cname, [])
endfunction

function! s:set_cached_commitmsg(git, args, commitmsg) abort
  let wname = a:git.worktree
  let cname = a:args.get('--amend') ? 'amend' : '_'
  let s:messages[wname] = get(s:messages, wname, {})
  let s:messages[wname][cname] = a:commitmsg
endfunction

function! s:remove_cached_commitmsg(git) abort
  let cname = a:git.worktree
  let s:messages[cname] = {}
endfunction


" Event ----------------------------------------------------------------------
function! s:on_command_called_commit(...) abort
  call gina#core#emitter#emit('modified:delay')
endfunction

if !exists('s:subscribed')
  let s:subscribed = 1
  call gina#core#emitter#subscribe(
        \ 'command:called:commit',
        \ function('s:on_command_called_commit')
        \)
endif


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'use_default_mappings': 1,
      \})
