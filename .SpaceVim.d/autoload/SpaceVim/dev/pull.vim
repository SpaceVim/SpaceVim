function! SpaceVim#dev#pull#create(branch) abort
  let title = input('title:')
  call inputsave()
  let username = input('github username:')
  let password = input('github password:')
  call inputrestore()
  let pull = {
        \ 'title' : title,
        \ 'head' : 'wsdjeg:' . a:branch,
        \ 'base' : 'master'
        \ }
  let respons = github#api#pulls#create('SpaceVim', 'SpaceVim', username, password, pull)
  normal! :
  if !empty(respons) && get(respons, 'number', 0) > 0
    echom 'Pull request #' . respons.number . ' has been created!'
  elseif !empty(respons)
    let msg = get(respons, 'message', '')
    echon 'Failed to create pull request:' . msg
  endif
endfunction


function! SpaceVim#dev#pull#merge(id) abort
  let commit_title = input('commit title:')
  call inputsave()
  let username = input('github username:')
  let password = input('github password:')
  call inputrestore()
  let commit = {
        \ 'commit_title' : commit_title,
        \ 'merge_method' : 'squash'
        \ }
  let respons = github#api#pulls#Merge('SpaceVim', 'SpaceVim', a:id, commit, username, password)
  normal! :
  if !empty(respons) && has_key(respons, 'sha')
    echom 'Pull request #' . a:id . ' has been merged!'
  elseif !empty(respons)
    let msg = get(respons, 'message', '')
    echon 'Failed to merge pull request ' . a:id . ':' . msg
  endif
endfunction
