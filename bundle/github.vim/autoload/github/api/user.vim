"List who the authenticated user is following:
"GET /user/following
function! github#api#user#ListFollowing(auth) abort
   let following = []
   for i in range(1,github#api#util#GetLastPage('user/following'))
       call extend(following,github#api#util#Get('user/following?page=' . i, ['-H', 'Authorization:' . a:auth]))
   endfor
   return following
endfunction

""
" @public
" List the authenticated user's followers:
"
" Github API : GET /user/followers
function! github#api#user#GetFollowers(user,password) abort
    return github#api#util#Get(join(['user', 'followers'], '/'),
                \ ['-u', a:user . ':' . a:password])
endfunction

""
" @public
" Check if you are following a user
"
" Github API : GET /user/following/:username
function! github#api#user#CheckFollowing(username,user,password) abort
    return github#api#util#GetStatus(join(['user', 'following', a:username], '/'),
                \ ['-u', a:user . ':' . a:password]) == 204
endfunction

""
" @public
" follow a user
"
" Github API :  PUT /user/following/:username
function! github#api#user#Follow(username,user,password) abort
    return github#api#util#GetStatus(join(['user', 'following', a:username], '/'),
                \ ['-X', 'PUT',
                \ '-u', a:user . ':' .a:password]) == 204
endfunction

""
" @public
" List all orgs for the auth user.
"
" Github API : GET /user/orgs
function! github#api#user#ListOrgs(auth) abort
    return github#api#util#Get(join(['user', 'orgs'], '/'),
                \ ['-H', 'Authorization:' . a:auth])
endfunction

""
" @public
" Get your organization membership
"
" Github API : GET /user/memberships/orgs/:org
function! github#api#user#GetOrgMembership(user,password,org) abort
    return github#api#util#Get(join(['user', 'memberships', 'orgs', a:org], '/'),
                \ ['-u', a:user . ':' . a:password])
endfunction

""
" @public
" Edit your organization membership
"
" Input: >
"    {
"      "state": "active"
"    }
" <
" Github API : PATCH /user/memberships/orgs/:org
function! github#api#user#EditOrgMembership(org,state,user,password) abort
    return github#api#util#Get(join(['user', 'memberships', 'org', a:org], '/'),
                \ ['-X', 'PATCH',
                \ '-d', json_encode(a:state),
                \ '-u', a:user . ':' . a:password])
endfunction

"Get the authenticated user
"GET /user
function! github#api#user#GetUser(username,password) abort
    return github#api#util#Get('user' , ['-u', a:username . ':' . a:password])
endfunction

""
" @public
" Update the authenticated user
"
" Input >
"    {
"    "name": "monalisa octocat",
"    "email": "octocat@github.com",
"    "blog": "https://github.com/blog",
"    "company": "GitHub",
"    "location": "San Francisco",
"    "hireable": true,
"    "bio": "There once..."
"    }
" <
" Github API : PATCH /user
function! github#api#user#UpdateUser(data,user,password) abort
    return github#api#util#Get('user', ['-X', 'PATCH', '-d', a:data, '-u', a:user . ':' . a:password])
endfunction

""
" @public
" List emails for a user
"
" Github API : GET /user/emails
function! github#api#user#ListEmails(user,password) abort
    return github#api#util#Get(join(['user', 'emails'], '/'),
                \ ['-u', a:user . ':' . a:password])
endfunction

""
" @public
" Add email address(es)
"
" Github API : POST /user/emails
function! github#api#user#AddEmails(user,password,emails) abort
    return github#api#util#Get(join(['user', 'emails'], '/'),
                \ ['-X', 'POST',
                \ '-d', json_encode(a:emails),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Delete email address(es)
"
" Github API : DELETE /user/emails
function! github#api#user#DeleteEmails(user,password,emails) abort
    return github#api#util#Get(join(['user', 'emails'], '/'),
                \ ['-X', 'DELETE',
                \ '-d', json_encode(a:emails),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Unfollow a user
"
" Github API : DELETE /user/following/:username
function! github#api#user#UnFollow(username,user,password) abort
    return github#api#util#GetStatus(join(['user', 'following', a:username], '/'),
                \ ['-u', a:user . ':' . a:password]) == 204
endfunction
