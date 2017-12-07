function! s:body() abort
  return 'SpaceVim development (pre-release:' . g:spacevim_version . ') build.'
endfunction
function! SpaceVim#dev#releases#open() abort
  let username = input('github username:')
  let password = input('github password:')
  let is_dev = g:spacevim_version =~ 'dev'
  let releases = {
        \ 'tag_name': (is_dev ? 'nightly' : g:spacevim_version),
        \ 'target_commitish': 'dev',
        \ 'name': (is_dev ? 'nightly' : 'SpaceVim v' . g:spacevim_version),
        \ 'body': (is_dev ? s:body() : SpaceVim#dev#releases#content()),
        \ 'draft': v:false,
        \ 'prerelease': (is_dev ? v:true : v:false)
        \ }
  let response = github#api#repos#releases#Create('SpaceVim', 'SpaceVim',
        \ username, password, releases)
  if !empty(response)
    echomsg 'releases successed! ' . response.url
  else
    echom 'releases failed!'
  endif
endfunction

function! List(owner, repo, page) abort
  return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues?state=closed&page=' . a:page , [])
endfunction

" v0.4.0 is released at https://github.com/SpaceVim/SpaceVim/pull/768
" v0.5.0 is released at https://github.com/SpaceVim/SpaceVim/pull/966
function! s:get_list_of_PRs() abort
  let prs = []
  for i in range(1, 10)
    let issues = List('SpaceVim','SpaceVim', i)
    call extend(prs, filter(issues, 'v:val["number"] > 768 && v:val["number"] < 966'))
  endfor
  return filter(prs, 'has_key(v:val, "pull_request")')
endfunction

function! s:pr_to_list(pr) abort
  return '- ' . a:pr.title . ' [#' . a:pr.number . '](' . a:pr.html_url . ')'
endfunction
let g:wsd = []
function! SpaceVim#dev#releases#content()
  let md = [
        \ '### SpaceVim release ' . g:spacevim_version
        \ ]
  let adds = []
  let changes = []
  let fixs = []
  let others = []
  if g:wsd == []
    let g:wsd =s:get_list_of_PRs() 
  endif
  for pr in g:wsd
    if pr.title =~? '^ADD'
      call add(adds, s:pr_to_list(pr))
    elseif pr.title =~? '^CHANGE'
      call add(changes, s:pr_to_list(pr))
    elseif pr.title =~? '^FIX'
      call add(fixs, s:pr_to_list(pr))
    else
      call add(others, s:pr_to_list(pr))
    endif
  endfor
  if !empty(adds)
    call add(md, '')
    call add(md, '#### New Features')
    call add(md, '')
    call extend(md, adds)
    call add(md, '')
  endif
  if !empty(changes)
    call add(md, '')
    call add(md, '#### Feature Changes')
    call add(md, '')
    call extend(md, changes)
    call add(md, '')
  endif
  if !empty(fixs)
    call add(md, '')
    call add(md, '#### Bug Fixs')
    call add(md, '')
    call extend(md, fixs)
    call add(md, '')
  endif
  if !empty(others)
    call add(md, '')
    call add(md, '#### Unmarked PRs')
    call add(md, '')
    call extend(md, others)
    call add(md, '')
  endif
  return join(md, "\n")

endfunction
