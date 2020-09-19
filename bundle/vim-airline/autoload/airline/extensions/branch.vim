" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" Plugin: fugitive, gina, lawrencium and vcscommand
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

" s:vcs_config contains static configuration of VCSes and their status relative
" to the active file.
" 'branch'    - The name of currently active branch. This field is empty iff it
"               has not been initialized yet or the current file is not in
"               an active branch.
" 'untracked' - Cache of untracked files represented as a dictionary with files
"               as keys. A file has a not exists symbol set as its value if it
"               is untracked. A file is present in this dictionary iff its
"               status is considered up to date.
" 'untracked_mark' - used as regexp to test against the output of 'cmd'
let s:vcs_config = {
\  'git': {
\    'exe': 'git',
\    'cmd': 'git status --porcelain -- ',
\    'dirty': 'git status -uno --porcelain --ignore-submodules',
\    'untracked_mark': '??',
\    'exclude': '\.git',
\    'update_branch': 's:update_git_branch',
\    'display_branch': 's:display_git_branch',
\    'branch': '',
\    'untracked': {},
\  },
\  'mercurial': {
\    'exe': 'hg',
\    'cmd': 'hg status -u -- ',
\    'dirty': 'hg status -mard',
\    'untracked_mark': '?',
\    'exclude': '\.hg',
\    'update_branch': 's:update_hg_branch',
\    'display_branch': 's:display_hg_branch',
\    'branch': '',
\    'untracked': {},
\  },
\}

" Initializes b:buffer_vcs_config. b:buffer_vcs_config caches the branch and
" untracked status of the file in the buffer. Caching those fields is necessary,
" because s:vcs_config may be updated asynchronously and s:vcs_config fields may
" be invalid during those updates. b:buffer_vcs_config fields are updated
" whenever corresponding fields in s:vcs_config are updated or an inconsistency
" is detected during update_* operation.
"
" b:airline_head caches the head string it is empty iff it needs to be
" recalculated. b:airline_head is recalculated based on b:buffer_vcs_config.
function! s:init_buffer()
  let b:buffer_vcs_config = {}
  for vcs in keys(s:vcs_config)
    let b:buffer_vcs_config[vcs] = {
          \     'branch': '',
          \     'untracked': '',
          \     'dirty': 0,
          \   }
  endfor
  unlet! b:airline_head
endfunction

let s:head_format = get(g:, 'airline#extensions#branch#format', 0)
if s:head_format == 1
  function! s:format_name(name)
    return fnamemodify(a:name, ':t')
  endfunction
elseif s:head_format == 2
  function! s:format_name(name)
    return pathshorten(a:name)
  endfunction
elseif type(s:head_format) == type('')
  function! s:format_name(name)
    return call(s:head_format, [a:name])
  endfunction
else
  function! s:format_name(name)
    return a:name
  endfunction
endif


" Fugitive special revisions. call '0' "staging" ?
let s:names = {'0': 'index', '1': 'orig', '2':'fetch', '3':'merge'}
let s:sha1size = get(g:, 'airline#extensions#branch#sha1_len', 7)

function! s:update_git_branch()
  call airline#util#ignore_next_focusgain()
  if !airline#util#has_fugitive() && !airline#util#has_gina()
    let s:vcs_config['git'].branch = ''
    return
  endif
  if airline#util#has_fugitive()
    let s:vcs_config['git'].branch = exists("*FugitiveHead") ?
          \ FugitiveHead(s:sha1size) : fugitive#head(s:sha1size)
    if s:vcs_config['git'].branch is# 'master' &&
          \ airline#util#winwidth() < 81
      " Shorten default a bit
      let s:vcs_config['git'].branch='mas'
    endif
  else
    try
      let g:gina#component#repo#commit_length = s:sha1size
      let s:vcs_config['git'].branch = gina#component#repo#branch()
    catch
    endtry
    if s:vcs_config['git'].branch is# 'master' &&
          \ airline#util#winwidth() < 81
      " Shorten default a bit
      let s:vcs_config['git'].branch='mas'
    endif
  endif
endfunction

function! s:display_git_branch()
  " disable FocusGained autocommand, might cause loops because system() causes
  " a refresh, which causes a system() command again #2029
  call airline#util#ignore_next_focusgain()
  let name = b:buffer_vcs_config['git'].branch
  try
    let commit = matchstr(FugitiveParse()[0], '^\x\+')

    if has_key(s:names, commit)
      let name = get(s:names, commit)."(".name.")"
    elseif !empty(commit)
      let ref = fugitive#repo().git_chomp('describe', '--all', '--exact-match', commit)
      if ref !~ "^fatal: no tag exactly matches"
        let name = s:format_name(substitute(ref, '\v\C^%(heads/|remotes/|tags/)=','',''))."(".name.")"
      else
        let name = matchstr(commit, '.\{'.s:sha1size.'}')."(".name.")"
      endif
    endif
  catch
  endtry
  return name
endfunction

function! s:update_hg_branch()
  if airline#util#has_lawrencium()
    let cmd='LC_ALL=C hg qtop'
    let stl=lawrencium#statusline()
    let file=expand('%:p')
    if !empty(stl) && get(b:, 'airline_do_mq_check', 1)
      if g:airline#init#vim_async
        noa call airline#async#get_mq_async(cmd, file)
      elseif has("nvim")
        noa call airline#async#nvim_get_mq_async(cmd, file)
      else
        " remove \n at the end of the command
        let output=system(cmd)[0:-2]
        noa call airline#async#mq_output(output, file)
      endif
    endif
    " do not do mq check anymore
    let b:airline_do_mq_check = 0
    if exists("b:mq") && !empty(b:mq)
      if stl is# 'default'
        " Shorten default a bit
        let stl='def'
      endif
      let stl.=' ['.b:mq.']'
    endif
    let s:vcs_config['mercurial'].branch = stl
  else
    let s:vcs_config['mercurial'].branch = ''
  endif
endfunction

function! s:display_hg_branch()
  return b:buffer_vcs_config['mercurial'].branch
endfunction

function! s:update_branch()
  for vcs in keys(s:vcs_config)
    call {s:vcs_config[vcs].update_branch}()
    if b:buffer_vcs_config[vcs].branch != s:vcs_config[vcs].branch
      let b:buffer_vcs_config[vcs].branch = s:vcs_config[vcs].branch
      unlet! b:airline_head
    endif
  endfor
endfunction

function! airline#extensions#branch#update_untracked_config(file, vcs)
  if !has_key(s:vcs_config[a:vcs].untracked, a:file)
    return
  elseif s:vcs_config[a:vcs].untracked[a:file] != b:buffer_vcs_config[a:vcs].untracked
    let b:buffer_vcs_config[a:vcs].untracked = s:vcs_config[a:vcs].untracked[a:file]
    unlet! b:airline_head
  endif
endfunction

function! s:update_untracked()
  let file = expand("%:p")
  if empty(file) || isdirectory(file) || !empty(&buftype)
    return
  endif

  let needs_update = 1
  let vcs_checks   = get(g:, "airline#extensions#branch#vcs_checks", ["untracked", "dirty"])
  for vcs in keys(s:vcs_config)
    if file =~ s:vcs_config[vcs].exclude
      " Skip check for files that live in the exclude directory
      let needs_update = 0
    endif
    if has_key(s:vcs_config[vcs].untracked, file)
      let needs_update = 0
      call airline#extensions#branch#update_untracked_config(file, vcs)
    endif
  endfor

  if !needs_update
    return
  endif

  for vcs in keys(s:vcs_config)
    " only check, for git, if fugitive is installed
    " and for 'hg' if lawrencium is installed, else skip
    if vcs is# 'git' && (!airline#util#has_fugitive() && !airline#util#has_gina())
      continue
    elseif vcs is# 'mercurial' && !airline#util#has_lawrencium()
      continue
    endif
    let config = s:vcs_config[vcs]
    " Note that asynchronous update updates s:vcs_config only, and only
    " s:update_untracked updates b:buffer_vcs_config. If s:vcs_config is
    " invalidated again before s:update_untracked is called, then we lose the
    " result of the previous call, i.e. the head string is not updated. It
    " doesn't happen often in practice, so we let it be.
    if index(vcs_checks, 'untracked') > -1
      call airline#async#vcs_untracked(config, file, vcs)
    endif
    " Check clean state of repo
    if index(vcs_checks, 'dirty') > -1
      call airline#async#vcs_clean(config.dirty, file, vcs)
    endif
  endfor
endfunction

function! airline#extensions#branch#head()
  if !exists('b:buffer_vcs_config')
    call s:init_buffer()
  endif

  call s:update_branch()
  call s:update_untracked()

  if exists('b:airline_head') && !empty(b:airline_head)
    return b:airline_head
  endif

  let b:airline_head = ''
  let vcs_priority = get(g:, "airline#extensions#branch#vcs_priority", ["git", "mercurial"])

  let heads = []
  for vcs in vcs_priority
    if !empty(b:buffer_vcs_config[vcs].branch)
      let heads += [vcs]
    endif
  endfor

  for vcs in heads
    if !empty(b:airline_head)
      let b:airline_head .= ' | '
    endif
    if len(heads) > 1
      let b:airline_head .= s:vcs_config[vcs].exe .':'
    endif
    let b:airline_head .= s:format_name({s:vcs_config[vcs].display_branch}())
    let additional = b:buffer_vcs_config[vcs].untracked
    if empty(additional) &&
          \ has_key(b:buffer_vcs_config[vcs], 'dirty') &&
          \ b:buffer_vcs_config[vcs].dirty
      let additional = g:airline_symbols['dirty']
    endif
    let b:airline_head .= additional
  endfor

  if empty(heads)
    if airline#util#has_vcscommand()
      noa call VCSCommandEnableBufferSetup()
      if exists('b:VCSCommandBufferInfo')
        let b:airline_head = s:format_name(get(b:VCSCommandBufferInfo, 0, ''))
      endif
    endif
  endif

  if empty(heads)
    if airline#util#has_custom_scm()
      try
        let Fn = function(g:airline#extensions#branch#custom_head)
        let b:airline_head = Fn()
      endtry
    endif
  endif

  if exists("g:airline#extensions#branch#displayed_head_limit")
    let w:displayed_head_limit = g:airline#extensions#branch#displayed_head_limit
    if strwidth(b:airline_head) > w:displayed_head_limit - 1
      let b:airline_head =
            \ airline#util#strcharpart(b:airline_head, 0, w:displayed_head_limit - 1)
            \ . (&encoding ==? 'utf-8' ?  '…' : '.')
    endif
  endif

  return b:airline_head
endfunction

function! airline#extensions#branch#get_head()
  let head = airline#extensions#branch#head()
  let winwidth = get(airline#parts#get('branch'), 'minwidth', 120)
  let minwidth = empty(get(b:, 'airline_hunks', '')) ? 14 : 7
  let head = airline#util#shorten(head, winwidth, minwidth)
  let symbol = get(g:, 'airline#extensions#branch#symbol', g:airline_symbols.branch)
  return empty(head)
        \ ? get(g:, 'airline#extensions#branch#empty_message', '')
        \ : printf('%s%s', empty(symbol) ? '' : symbol.(g:airline_symbols.space), head)
endfunction

function! s:reset_untracked_cache(shellcmdpost)
  " shellcmdpost - whether function was called as a result of ShellCmdPost hook
  if !g:airline#init#vim_async && !has('nvim')
    if a:shellcmdpost
      " Clear cache only if there was no error or the script uses an
      " asynchronous interface. Otherwise, cache clearing would overwrite
      " v:shell_error with a system() call inside get_*_untracked.
      if v:shell_error
        return
      endif
    endif
  endif

  let file = expand("%:p")
  for vcs in keys(s:vcs_config)
    " Dump the value of the cache for the current file. Partially mitigates the
    " issue of cache invalidation happening before a call to
    " s:update_untracked()
    call airline#extensions#branch#update_untracked_config(file, vcs)
    let s:vcs_config[vcs].untracked = {}
  endfor
endfunction

function! airline#extensions#branch#init(ext)
  call airline#parts#define_function('branch', 'airline#extensions#branch#get_head')

  autocmd ShellCmdPost,CmdwinLeave * unlet! b:airline_head b:airline_do_mq_check
  autocmd User AirlineBeforeRefresh unlet! b:airline_head b:airline_do_mq_check
  autocmd BufWritePost * call s:reset_untracked_cache(0)
  autocmd ShellCmdPost * call s:reset_untracked_cache(1)
endfunction
