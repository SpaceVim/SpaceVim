""
" @public
" List all labels for this repository
"
" Github API : GET /repos/:owner/:repo/labels
function! github#api#labels#GetAll(owner,repo) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'labels'], '/'), ['-H', 'Accept: application/vnd.github.symmetra-preview+json'])
endfunction

""
" @public
" Get a single label
"
" Github API : GET /repos/:owner/:repo/labels/:name
function! github#api#labels#Get(owner,repo,name) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'labels', a:name], '/'), [])
endfunction

""
" @public
" Create a label
"
" Input: >
"   {
"       "name": "bug",
"       "color": "f29513"
"   }
" <
" Github API : POST /repos/:owner/:repo/labels
function! github#api#labels#Create(owner,repo,user,password,label) abort
    return github#api#util#GetStatus(join(['repos', a:owner, a:repo, 'labels'], '/'),
                \ ['-X', 'POST',
                \ '-d', json_encode(a:label),
                \ '-u', a:user . ':' . a:password]) == 201
endfunction

""
" @public
" Update a label
"
" Input: >
"   {
"       "name": "bug",
"       "color": "f29513"
"   }
" <
" Github API : PATCH /repos/:owner/:repo/labels/:name
function! github#api#labels#Update(owner,repo,user,password,label) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'labels'], '/'),
                \ ['-X', 'PATCH',
                \ '-d', json_encode(a:label),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Delete a label
"
" Github API : DELETE /repos/:owner/:repo/labels/:name
function! github#api#labels#Delete(owner,repo,name,user,password) abort
    return github#api#util#GetStatus(join(['repos', a:owner, a:repo, 'labels', a:name], '/'),
                \ ['-X', 'DELETE',
                \ '-u', a:user . ':' . a:password]) == 204
endfunction

""
" @public
" List labels on an issue
"
" Github API : GET /repos/:owner/:repo/issues/:number/labels
function! github#api#labels#List(owner,repo,num) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'issues', a:num, 'labels'], '/'), [])
endfunction

""
" @public
" Add labels to an issue
"
" Input: >
"   [
"       "Label1",
"       "Label2"
"   ]
" <
" Github API : POST /repos/:owner/:repo/issues/:number/labels
function! github#api#labels#Add(owner,repo,num,labels,user,password) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'issues', a:num, 'labels'], '/'),
                \ ['-X', 'POST', '-d', json_encode(a:labels),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Remove a label from an issue
"
" Github API : DELETE /repos/:owner/:repo/issues/:number/labels/:name
function! github#api#labels#Remove(owner,repo,num,name,user,password) abort
    return github#api#util#GetStatus(join(['repos', a:owner, a:repo, 'issues', a:num, 'labels', a:name], '/'),
                \ [ '-X', 'DELETE',
                \ '-u', a:user . ':' . a:password]) == 204
endfunction

""
" @public
" Replace all labels for an issue
"
" Input: >
"   [
"       "Label1",
"       "Label2"
"   ]
" <
" Github API : PUT /repos/:owner/:repo/issues/:number/labels
function! github#api#labels#Replace(owner,repo,num,labels,user,password) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'issues', a:num, 'labels'], '/'),
                \ ['-X', 'PUT', '-d', json_encode(a:labels),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Remove all label from an issue
"
" Github API : DELETE /repos/:owner/:repo/issues/:number/labels
function! github#api#labels#RemoveAll(owner,repo,num,user,password) abort
    return github#api#util#GetStatus(join(['repos', a:owner, a:repo, 'issues', a:num, 'labels'], '/'),
                \ [ '-X', 'DELETE',
                \ '-u', a:user . ':' . a:password]) == 204
endfunction

""
" @public
" Get labels for every issue in a milestone
"
" Github API : GET /repos/:owner/:repo/milestones/:number/labels
function! github#api#labels#ListAllinMilestone(owner,repo,num) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'milestones', a:num, 'labels'], '/'), [])
endfunction


