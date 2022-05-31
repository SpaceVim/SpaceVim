let s:HTTP = SpaceVim#api#import('web#http')


""
" @public
" Get all users
"
" Github API : GET /users
function! github#api#users#GetAllUsers() abort
  return github#api#util#Get('users', [])
endfunction


function! github#api#users#starred(user, page) abort
  let result = s:HTTP.get('https://api.github.com/users/' .
        \ a:user . '/starred' . '?page=' . a:page)
  if result.status ==# 200
    return json_decode(result.content)
  endif
  " if the command run failed, return empty list
  return []
endfunction

function! github#api#users#starred_pages(user) abort
  let result = s:HTTP.get('https://api.github.com/users/' . a:user . '/starred')
  if result.status ==# 200
    let i = filter(result.header, 'v:val =~# "^Link"')[0]
    return split(matchstr(i,'=\d\+',0,2),'=')[0]
  endif
  return 0
endfunction

function! github#api#users#GetStarred(user) abort
  let rel = []
  let pages = github#api#users#starred_pages(a:user)
  for page in range(1,pages)
    let repos = github#api#users#starred(a:user, page)
    for repo in repos
      call add(rel, repo)
    endfor
  endfor
  return rel
endfunction

" get a single user
" GET /users/:username
function! github#api#users#GetUser(username) abort
  return github#api#util#Get('users/' . a:username, [])
endfunction

"List followers of a user
"GET /users/:username/followers
function! github#api#users#ListFollowers(username) abort
  let followers = []
  for i in range(1,github#api#util#GetLastPage('users/' . a:username . '/followers'))
    call extend(followers,github#api#util#Get('users/' . a:username . '/followers?page=' . i, []))
  endfor
  return followers
endfunction

"List users followed by another user
"GET /users/:username/following
function! github#api#users#ListFollowing(username) abort
  let following = []
  for i in range(1,github#api#util#GetLastPage('users/' . a:username . '/following'))
    call extend(following,github#api#util#Get('users/' . a:username . '/following?page=' . i, []))
  endfor
  return following
endfunction

""
" @public
" List orgs of a specified user.
"
" Github API : /users/:username/orgs
function! github#api#users#ListAllOrgs(user) abort
  return github#api#util#Get(join(['users', a:user, 'orgs'], '/'))
endfunction

""
" @public
" Check if one user follows another
"
" Github API : GET /users/:username/following/:target_user
function! github#api#users#CheckTargetFollow(username,target) abort
  return github#api#util#GetStatus(join(['users', a:username, 'following', a:target], '/'),[])
endfunction
