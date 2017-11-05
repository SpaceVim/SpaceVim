function! SpaceVim#dev#releases#open() abort
    let username = input('github username:')
    let password = input('github password:')
    let releases = {
                \ 'tag_name': g:spacevim_version,
                \ 'target_commitish': 'dev',
                \ 'name': 'SpaceVim v' . g:spacevim_version,
                \ 'body': SpaceVim#dev#releases#content(),
                \ 'draft': v:false,
                \ 'prerelease': v:false
                \ }
    let response = github#api#repos#releases#Create('SpaceVim', 'SpaceVim',
                \ username, password, releases)
    if !empty(response)
        echomsg 'releases successed! ' . response.url
    else
        echom 'releases failed!'
    endif
endfunction

function! s:get_list_of_PRs() abort
  let prs = github#api#issues#List_All_for_Repo('SpaceVim', 'SpaceVim',
        \ {
        \ 'state' : 'closed',
        \ 'since' : s:time_of_last_release(),
        \ })
  return filter(prs, 'has_key(v:val, "pull_request")')
endfunction

function! s:time_of_last_release() abort
  let last_release = github#api#repos#releases#latest('SpaceVim', 'SpaceVim')
  if has_key(last_release, 'created_at')
    return last_release.created_at
  else
    return ''
  endif
endfunction

function! s:pr_to_list(pr) abort
  return '- ' . a:pr.title . ' [#' . a:pr.number . '](' . a:pr.html_url . ')'
endfunction

function! SpaceVim#dev#releases#content()
  let md = [
        \ '### SpaceVim release ' . g:spacevim_version
        \ ]
  let adds = []
  let changes = []
  let fixs = []
  let others = []
  for pr in s:get_list_of_PRs()
    if pr.title =~ '^ADD:'
      call add(adds, s:pr_to_list(pr))
    elseif pr.title =~ '^CHANGE:'
      call add(changes, s:pr_to_list(pr))
    elseif pr.title =~ '^FIX:'
      call add(fixs, s:pr_to_list(pr))
    else
      call add(others, s:pr_to_list(pr))
    endif
  endfor
  if !empty(adds)
    call add(md, '')
    call add(md, '#### New Features')
    call add(md, '')
  endif
  if !empty(changes)
    call add(md, '')
    call add(md, '#### Feature Changes')
    call add(md, '')
  endif
  if !empty(fixs)
    call add(md, '')
    call add(md, '#### Bug Fixs')
    call add(md, '')
  endif
  if !empty(others)
    call add(md, '')
    call add(md, '#### Unmarked PRs')
    call add(md, '')
  endif
  return join(md, "\n")

endfunction
