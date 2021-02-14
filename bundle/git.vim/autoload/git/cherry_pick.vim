""
" @section git-cherry-pick, cherry-pick
" @parentsection commands
" This command is to cherry pick commit from other branch.
" >
"   :Git cherry-pick <HashA> <HashB>
" <

let s:JOB = SpaceVim#api#import('job')

function! git#cherry_pick#run(args) abort
  if len(a:args) == 0
    finish
  else
    let cmd = ['git', 'cherry-pick'] + a:args
  endif
  call git#logger#info('git-cherry-pick cmd:' . string(cmd))
  let s:conflict_files = []
  call s:JOB.start(cmd,
        \ {
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )

endfunction

function! s:on_exit(id, data, event) abort
  call git#logger#info('git-cherry-pick exit data:' . string(a:data))
  if a:data ==# 0
    echo 'cherry-pick done!'
  else
    if s:list_conflict_files()
      echo 'you need to resolve all conflicts'
    else
      echo 'cherry-pick failed!'
    endif
  endif
endfunction

function! s:on_stdout(id, data, event) abort
  for data in a:data
    call git#logger#info('git-cherry-pick stdout:' . data)
    if data =~# '^CONFLICT'
      " CONFLICT (content): Merge conflict in test.txt
      let file = data[38:]
      call add(s:conflict_files, file)
    endif
  endfor
endfunction

function! s:on_stderr(id, data, event) abort
  for data in a:data
    call git#logger#info('git-cherry-pick stderr:' . data)
  endfor
  " stderr should not be added to commit buffer
  " let s:lines += a:data
endfunction

function! s:list_conflict_files() abort
  if !empty(s:conflict_files)
    let rst = []
    for file in s:conflict_files
      call add(rst, {
            \ 'filename' : fnamemodify(file, ':p'),
            \ })
    endfor
    if len(rst) >= 1
      call setqflist([], 'r', {'title': ' ' . len(rst) . ' items',
            \ 'items' : rst
            \ })
      botright copen
      return 1
    endif
  endif
endfunction

" usage: git cherry-pick [<options>] [<commit>...]
" or: git cherry-pick --abort
" or: git cherry-pick --continue
"


function! s:args_with_two() abort
  return join([
        \ '--no-commit',
        \ '--continue',
        \ '--abort',
        \ '--quit',
        \ ], "\n")
endfunction

function! s:args_with_one() abort
  return join([
        \ '-x',
        \ ], "\n")

endfunction

function! git#cherry_pick#complete(ArgLead, CmdLine, CursorPos) abort
  if a:ArgLead =~# '^--'
    return s:args_with_two()
  elseif a:ArgLead =~# '^-'
    return s:args_with_one()
  endif

  return join(s:unmerged_branchs(), "\n")

endfunction

function! s:unmerged_branchs() abort
  return map(systemlist('git branch --no-merged'), 'trim(v:val)')
endfunction


