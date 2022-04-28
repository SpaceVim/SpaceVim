" List organization repositories
" GET /orgs/:org/repos
function! github#api#orgs#ListRepos(org) abort
   let repos = []
   for i in range(1,github#api#util#GetLastPage('orgs/' . a:org . '/repos'))
       call extend(repos,github#api#util#Get('orgs/' . a:org . '/repos?page=' . i,[]))
   endfor
   return repos
endfunction

""
" @public
" Get an organization
"
" Github API : GET /orgs/:org
function! github#api#orgs#Get(org) abort
    return github#api#util#Get(join(['orgs', a:org], '/'), [])
endfunction

""
" @public
" Edit an organization
"
" Input: >
"    {
"      "billing_email": "support@github.com",
"      "blog": "https://github.com/blog",
"      "company": "GitHub",
"      "email": "support@github.com",
"      "location": "San Francisco",
"      "name": "github",
"      "description": "GitHub, the company."
"    }
" <
" Github API : PATCH /orgs/:org
function! github#api#orgs#Edit(org,orgdata,user,password) abort
    return github#api#util#Get(join(['orgs', a:org], '/'),
                \ ['-X', 'PATCH', '-d', json_encode(a:orgdata),
                \ '-u', a:user .':'. a:password])
endfunction

""
" @public
" List all users who are members of an organization.
"
"   {filter}Filter members returned in the list. Can be one of:
"   * 2fa_disabled: Members without two-factor authentication enabled. Available for organization owners.
"   * all: All members the authenticated user can see.
"   * Default: all.
"
"   {role}Filter members returned by their role. Can be one of:
"   * all: All members of the organization, regardless of role.
"   * admin: Organization owners.
"   * member: Non-owner organization members.
"   * Default: all.
"
" Github API : GET /orgs/:org/members
function! github#api#orgs#ListMembers(org,filter,role) abort
    let url = join(['orgs', a:org, 'members'], '/')
    if index(['2fa_disabled', 'all'], a:filter) == -1
        let url = url . '?filter=all'
    else
        let url = url . '?filter=' . a:filter
    endif
    if index(['admin', 'member', 'all'], a:role) == -1
        let url = url . '&role=all'
    else
        let url = url . '&role=' . a:role
    endif
    return github#api#util#Get(url,[])
endfunction

""
" @public
" Check if a user is, publicly or privately, a member of the organization.
"
" Status:
"
"   * 204: requester is an organization member and user is a member
"   * 404: requester is an organization member and user is not a member,
"          requester is not an organization member and is inquiring about themselves
"   * 302: requester is not an organization member
"
" Github API : GET /orgs/:org/members/:username
function! github#api#orgs#CheckMembership(org,username,user,password) abort
    return github#api#util#GetStatus(join(['orgs', a:org, 'members', a:username], '/'),
                \ ['-u', a:user . ':' . a:password])
endfunction

""
" @public
" Remove a member
"
" Github API : DELETE /orgs/:org/members/:username
function! github#api#orgs#DeleteMember(org,username,user,password) abort
    return github#api#util#GetStatus(join(['orgs', a:org, 'members', a:username], '/'),
                \['-u', a:user . ':' . a:password])
endfunction

""
" @public
" List public members of an org
"
" Github API : GET /orgs/:org/public_members
function! github#api#orgs#ListPublicMembers(org) abort
    return github#api#util#Get(join(['orgs', a:org, 'public_members'], '/'), [])
endfunction

""
" @public
" Check public membership
"
" Github API : GET /orgs/:org/public_members/:username
function! github#api#orgs#CheckPublicMembership(org,username) abort
    return github#api#util#GetStatus(join(['orgs', a:org, 'public_members', a:username], '/'), []) == 204
endfunction

""
" @public
" Publicize a user's membership
" The user can publicize their own membership. (A user cannot publicize the membership for another user.)
"
" Github API : PUT /orgs/:org/public_members/:username
function! github#api#orgs#Publicize(org,user,password) abort
    return github#api#util#GetStatus(join(['orgs', a:org, 'public_members', a:user], '/'),
                \ ['-X', 'PUT',
                \ '-u', a:user . ':' . a:password]) == 204
endfunction

""
" @public
" Conceal a user's membership
"
" Github API : DELETE /orgs/:org/public_members/:username
function! github#api#orgs#ConcealUser(org,user,password) abort
    return github#api#util#GetStatus(join(['orgs', a:org, 'public_members', a:user], '/'),
                \ ['-X', 'DELETE',
                \ '-u', a:user . ':' . a:password]) == 204
endfunction

""
" @public
" Get organization membership
"
" Github API : GET /orgs/:org/memberships/:username
function! github#api#orgs#GetMemberships(org,username,user,password) abort
    return github#api#util#Get(join(['orgs', a:org, 'memberships', a:username], '/'),
                \ ['-u', a:user . ':' . a:password])
endfunction

""
" @public
" Add or update organization membership,use admin or member for {role}
"
" Github API : PUT /orgs/:org/memberships/:username
function! github#api#orgs#UpdateMembership(org,username,user,password,role) abort
    let url = join(['orgs', a:org, 'memberships', a:username], '/')
    if index(['admin', 'member'], a:role) == -1
        let url .= '?role=member'
    else
        let url .= '?role=' . a:role
    endif
    return github#api#util#Get(url,['-X', 'PUT', '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Remove organization membership
"
" Github API : DELETE /orgs/:org/memberships/:username
function! github#api#orgs#RemoveMembership(org,username,user,password) abort
    return github#api#util#GetStatus(join(['orgs', a:org, 'memberships', a:username], '/'),
                \ ['-X', 'DELETE',
                \ '-u', a:user . ':' . a:password]) == 204
endfunction
