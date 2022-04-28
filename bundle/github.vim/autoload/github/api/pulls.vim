""
" @public
" List all the PRs of a repo.
"
" Github API : GET /repos/:owner/:repo/pulls
function! github#api#pulls#ListAllPRs(owner,repo) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'pulls'], '/'), [])
endfunction

""
" @public
" Get a single pull request
"
" Github API : GET /repos/:owner/:repo/pulls/:number
function! github#api#pulls#Get(owner,repo,number) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'pulls', a:number], '/'), [])
endfunction

""
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
function! github#api#pulls#create(owner,repo,user,password,pull) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'pulls'], '/'),
                \ ['-X', 'POST',
                \ '-d', json_encode(a:pull),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Update a pull request
"
" Input: >
"    {
"      "title": "new title",
"      "body": "updated body",
"      "state": "open"
"    }
" <
" Github API : PATCH /repos/:owner/:repo/pulls/:number
function! github#api#pulls#update(owner,repo,number,pull,user,password) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'pulls', a:number], '/'),
                \ ['-X', 'PATCH',
                \ '-d', json_encode(a:pull),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" List commits on a pull request
"
" Github API : GET /repos/:owner/:repo/pulls/:number/commits
function! github#api#pulls#ListCommits(owner,repo,number) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'pulls', a:number, 'commits'], '/'), [])
endfunction

""
" @public
" List pull requests files
"
" Github API : GET /repos/:owner/:repo/pulls/:number/files
function! github#api#pulls#ListFiles(owner,repo,number) abort
    let page_key = '?page='
    let issues = []
    for i in range(1,github#api#util#GetLastPage(join(['repos', a:owner, a:repo, 'pulls', a:number, 'files'], '/')))
        let iss = github#api#util#Get(join(['repos', a:owner, a:repo, 'pulls', a:number, 'files'], '/') . page_key . i, [])
        if !empty(iss) && type(iss) == 3
            call extend(issues, iss)
        endif
    endfor
    return issues
endfunction

""
" @public
" Get if a pull request has been merged
"
" Github API : GET /repos/:owner/:repo/pulls/:number/merge
function! github#api#pulls#CheckMerged(owner,repo,number) abort
    return github#api#util#GetStatus(join(['repos', a:owner, a:repo , 'pulls', a:number, 'merge'], '/'), []) == 204
endfunction

""
" @public
" Merge a pull request (Merge Button)
"
" Github API : PUT /repos/:owner/:repo/pulls/:number/merge
function! github#api#pulls#Merge(owner,repo,number,msg,user,password) abort
   return github#api#util#Get(join(['repos', a:owner, a:repo, 'pulls', a:number, 'merge'], '/'),
               \ ['-X', 'PUT',
               \ '-d', json_encode(a:msg),
               \ '-u', a:user . ':' . a:password])
endfunction
