function! SpaceVim#dev#pull#create(branch)
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
    echon 'Pull request #' . respons.number . ' has been created!'
  elseif !empty(respons)
    let msg = get(respons, 'message', '')
    echon 'Failed to update issue ' . issue.number . ':' . msg
  endif
endfunction
" @public
" Create a pull request
"
" Input: >
"    {
"      "title": "Amazing new feature",
"      "body": "Please pull this in!",
"      "head": "octocat:new-feature",
"      "base": "master"
"    }
" <
" or: >
"    {
"      "issue": 5,
"      "head": "octocat:new-feature",
"      "base": "master"
"    }
" <
" Github API : POST /repos/:owner/:repo/pulls
" function! github#api#pulls#create(owner,repo,user,password,pull) abort
