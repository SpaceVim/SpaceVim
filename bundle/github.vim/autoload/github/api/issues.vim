""
" List issues
" List all issues assigned to the authenticated user across all visible
" repositories including owned repositories, member repositories, and
" organization repositories:
"
" Github API : GET /issues
" @public
function! github#api#issues#List_All(user,password) abort
    let issues = []
    for i in range(1,github#api#util#GetLastPage('issues', ['-u', a:user . ':' . a:password]))
        call extend(issues,github#api#util#Get('issues?page=' . i, ['-u', a:user . ':' . a:password]))
    endfor
    return issues
endfunction

""
" List all issues across owned and member repositories assigned to the
" authenticated user:
"
" Github API : GET /user/issues
" @public
function! github#api#issues#List_All_for_User(user,password) abort
    let issues = []
    for i in range(1,github#api#util#GetLastPage('user/issues', ['-u', a:user . ':' . a:password]))
        call extend(issues,github#api#util#Get('user/issues?page=' . i, ['-u', a:user . ':' . a:password]))
    endfor
    return issues
endfunction

""
" List all issues for a given organization assigned to the authenticated user:
"
" Github API : GET /orgs/:org/issues
" @public
function! github#api#issues#List_All_for_User_In_Org(org,user,password) abort
    let issues = []
    for i in range(1,github#api#util#GetLastPage('orgs/' . a:org . '/issues', ['-u', a:user . ':' . a:password]))
        call extend(issues,github#api#util#Get('orgs/' . a:org . '/issues?page=' . i, ['-u', a:user . ':' . a:password]))
    endfor
    return issues
endfunction

""
" List issues for a repository
" GET /repos/:owner/:repo/issues
" NOTE: this only list opened issues and pull request
function! github#api#issues#List_All_for_Repo(owner,repo, ...) abort
    let args = ''
    let page_key = '?page='
    let opts = get(a:000, 0, {})
    if !empty(opts)
        let args = '?'
        if has_key(opts, 'state')
            let args .= 'state=' . opts.state
        endif
        if has_key(opts, 'since')
            if args[-1:] !=# '?'
                let args .='&'
            endif
            let args .= 'since=' . opts.since
        endif
        if args[-1:] !=# '?'
            let page_key = '&page='
        else
            let page_key = 'page='
        endif
    endif
    let issues = []
    for i in range(1,github#api#util#GetLastPage('repos/' . a:owner . '/' . a:repo . '/issues' . args))
        let iss = github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues' . args . page_key . i, [])
        if !empty(iss) && type(iss) == 3
            call extend(issues, iss)
        endif
    endfor
    return issues
endfunction

function! github#api#issues#async_list_opened(owner, repo, callback) abort
    for i in range(1,github#api#util#GetLastPage('repos/' . a:owner . '/' . a:repo . '/issues'))
        call github#api#util#async_get('repos/' . a:owner . '/' . a:repo . '/issues?page=' . i, [], a:callback)
    endfor
endfunction

""
" Get a single issue
" @public
" GET /repos/:owner/:repo/issues/:number
function! github#api#issues#Get_issue(owner,repo,num) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/' . a:num, [])
endfunction

""
" @public
" Create an issue
"
" Input: >
"   {
"    "title": "Found a bug",
"    "body": "I'm having a problem with this.",
"    "assignee": "octocat",
"    "milestone": 1,
"    "labels": [
"      "bug"
"    ]
"   }
" <
" Github API : POST /repos/:owner/:repo/issues
function! github#api#issues#Create(owner,repo,user,password,issue) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues',
                \ ['-X', 'POST', '-d', json_encode(a:issue),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" Edit an issue
" PATCH /repos/:owner/:repo/issues/:number
function! github#api#issues#Edit(owner,repo,num,user,password,issue) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/' . a:num,
                \ ['-X', 'PATCH',
                \ '-H', 'Accept: application/vnd.github.symmetra-preview+json',
                \ '-d', json_encode(a:issue),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Lock an issue
"
" Github APi : PUT /repos/:owner/:repo/issues/:number/lock
function! github#api#issues#Lock(owner,repo,num,user,password) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/' . a:num . '/lock',
                \ ['-X', 'PUT',  '-u',  a:user . ':' . a:password,
                \ '-H', 'Accept: application/vnd.github.the-key-preview'])
endfunction

""
" @public
" Unlock an issue
"
" Github API : DELETE /repos/:owner/:repo/issues/:number/lock
function! github#api#issues#Unlock(owner,repo,num,user,password) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/' . a:num . '/lock',
                \ ['-X', 'DELETE',  '-u', a:user . ':' . a:password,
                \ '-H', 'Accept: application/vnd.github.the-key-preview'])
endfunction

""
" @public
" Lists all the available assignees to which issues may be assigned.
"
" Github API : GET /repos/:owner/:repo/assignees
function! github#api#issues#List_assignees(owner,repo) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/assignees', [])
endfunction

""
" @public
" Check assignee
"
" Github API : GET /repos/:owner/:repo/assignees/:assignee
function! github#api#issues#Check_assignee(owner,repo,assignee) abort
    return github#api#util#GetStatus('repos/' . a:owner . '/'
                \ . a:repo . '/assignees/' . a:assignee, []) ==# 204
endfunction

""
" @public
" Add assignees to an Issue
"
" Input: >
"   {
"    "assignees": [
"      "hubot",
"      "other_assignee"
"    ]
"   }
" <
" Github API : POST /repos/:owner/:repo/issues/:number/assignees
"
" NOTE: need `Accep:application/vnd.github.cerberus-preview+json`
function! github#api#issues#Addassignee(owner,repo,num,assignees,user,password) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/' . a:num . '/assignees',
                \ ['-X', 'POST', '-d', json_encode(a:assignees), '-u', a:user . ':' . a:password,
                \ '-H', 'Accept: application/vnd.github.cerberus-preview+json'])
endfunction

""
" @public
" Remove assignees from an Issue
"
" Input: >
"   {
"    "assignees": [
"      "hubot",
"      "other_assignee"
"    ]
"   }
" <
" DELETE /repos/:owner/:repo/issues/:number/assignees
"
" NOTE: need `Accep:application/vnd.github.cerberus-preview+json`
function! github#api#issues#Removeassignee(owner,repo,num,assignees,user,password) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/' . a:num . '/assignees',
                \ ['-X', 'DELETE', '-d', json_encode(a:assignees), '-u', a:user . ':' . a:password,
                \ '-H', 'Accept: application/vnd.github.cerberus-preview+json'])
endfunction

""
" @public
" List comments on an issue, updated at or after {since} .
" {since} : YYYY-MM-DDTHH:MM:SSZ
"
" Github API : GET /repos/:owner/:repo/issues/:number/comments
function! github#api#issues#List_comments(owner,repo,num,since) abort
    let comments = []
    for i in range(1,github#api#util#GetLastPage('repos/' . a:owner . '/' . a:repo
                \. '/issues/' . a:num . '/comments'
                \. (empty(a:since) ? '' : '?since='.a:since)))
        call extend(comments,github#api#util#Get('repos/' . a:owner . '/' . a:repo
                    \. '/issues/' . a:num . '/comments?page=' . i
                    \. (empty(a:since) ? '' : '&since='.a:since), []))
    endfor
    return comments
endfunction

""
" @public
" List comments in a repository
"
" Github API : GET /repos/:owner/:repo/issues/comments
function! github#api#issues#List_All_comments(owner,repo,sort,desc,since) abort
    let url = 'repos/' . a:owner . '/' . a:repo . '/issues/comments'
    if index(['created','updated'], a:sort) != -1
        let url = url . '?sort=' . a:sort
        if index(['asc','desc'], a:desc) != -1
            let url = url . '&direction=' . a:desc
        endif
        if !empty(a:since)
            let url = url . '&since=' . a:since
        endif
    else
        if !empty(a:since)
            let url = url . '?since=' . a:since
        endif
    endif
    let comments = []
    for i in range(1,github#api#util#GetLastPage(url))
        call extend(comments,github#api#util#Get(url . (stridx(url,'?') == -1 ? '?page='  : '&page=') . i ,[]))
    endfor
    return comments
endfunction

""
" @public
" Get a single comment
"
" Github API : GET /repos/:owner/:repo/issues/comments/:id
function! github#api#issues#Get_comment(owner,repo,id) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/comments/' . a:id, [])
endfunction

""
" @public
" Create a comment
"
" Input: >
"   {
"       "body": "Me too"
"   }
" <
" Github API : POST /repos/:owner/:repo/issues/:number/comments
function! github#api#issues#Create_comment(owner,repo,num,json,user,password) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/' . a:num . '/comments',
                \ ['-X', 'POST', '-u', a:user . ':' . a:password, '-d', json_encode(a:json)])
endfunction

""
" @public
" Edit a comment
"
" Input: >
"   {
"       "body": "Me too"
"   }
" <
" Github API : PATCH /repos/:owner/:repo/issues/comments/:id
function! github#api#issues#Edit_comment(owner,repo,id,json,user,password) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/comments/' . a:id,
                \ ['-X', 'PATCH', '-u', a:user . ':' . a:password, '-d', json_encode(a:json)])
endfunction

""
" @public
" Delete a comment
"
" Github API : ELETE /repos/:owner/:repo/issues/comments/:id
function! github#api#issues#Delete_comment(owner,repo,id,user,password) abort
    return github#api#util#GetStatus('repos/' . a:owner . '/'
                \ . a:repo . '/issues/comments/' . a:id,
                \ ['-u', a:user . ':' . a:password, '-X', 'DELETE']) ==# 204
endfunction

""
" @public
" List events for an issue
" Github API : GET /repos/:owner/:repo/issues/:issue_number/events
function! github#api#issues#List_events(owner,repo,num) abort
    let url = join(['repos',a:owner,a:repo,'issues',a:num,'events'], '/')
    let events = []
    for i in range(1,github#api#util#GetLastPage(url))
        call extend(events,github#api#util#Get(url . '?page=' . i, []))
    endfor
    return events
endfunction

function! s:GetEvent(event) abort
    let events = {
                \ 'closed' : 'The issue was closed by the actor. When the commit_id is present, '
                \ . 'it identifies the commit that closed the issue using "closes / fixes #NN" syntax.',
                \ 'reopened' : 'The issue was reopened by the actor.',
                \ 'subscribed' : 'The actor subscribed to receive notifications for an issue.',
                \ 'merged' : 'The issue was merged by the actor. The `commit_id` attribute is the SHA1 of the HEAD commit that was merged.',
                \ 'referenced' : 'The issue was referenced from a commit message. '
                \ . 'The `commit_id` attribute is the commit SHA1 of where that happened.',
                \ 'mentioned' : 'The actor was @mentioned in an issue body.',
                \ 'assigned' : 'The issue was assigned to the actor.',
                \ 'unassigned' : 'The actor was unassigned from the issue.',
                \ 'labeled' : 'A label was added to the issue.',
                \ 'unlabeled' : 'A label was removed from the issue.',
                \ 'milestoned' : 'The issue was added to a milestone.',
                \ 'demilestoned' : 'The issue was removed from a milestone.',
                \ 'renamed' : 'The issue title was changed.',
                \ 'locked' : 'The issue was locked by the actor.',
                \ 'unlocked' : 'The issue was unlocked by the actor.',
                \ 'head_ref_deleted' : 'The pull request`s branch was deleted.',
                \ 'head_ref_restored' : 'The pull request`s branch was restored. '
                \ }
    let event = json_decode(a:event).event
    return get(events, event)
endfunction

""
" @public
" List events for a repository
"
" Github API : GET /repos/:owner/:repo/issues/events
function! github#api#issues#List_events_for_repo(owner,repo) abort
    let url = join(['repos', a:owner, a:repo, 'issues','events'], '/')
    let events = []
    for i in range(1,github#api#util#GetLastPage(url))
        call extend(events,github#api#util#Get(url . '?page=' . i, []))
    endfor
    return events
endfunction

""
" @public
" Get a single event
"
" Github API : GET /repos/:owner/:repo/issues/events/:id
function! github#api#issues#Get_event(owner,repo,id) abort
    return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues/events/' . a:id, [])
endfunction

""
" @public
" List milestones for a repository
"
" Github API : GET /repos/:owner/:repo/milestones
" Parameters >
"   Name      Type      Description
"   state     string The state of the milestone. Either open, closed, or all.
"                    Default: open
"   sort      string What to sort results by. Either due_on or completeness.
"                    Default: due_on
"   direction string The direction of the sort. Either asc or desc.
"                    Default: asc
" <
function! github#api#issues#ListAllMilestones(owner,repo,state,sort,direction) abort
    let url = join(['repos', a:owner, a:repo, 'milestones'], '/')
    if index(['open', 'closed', 'all'], a:state) == -1
        let url = url . '?state=open'
    else
        let url = url . '?state=' . a:state
    endif
    if index(['due_on', 'completeness'], a:sort) == -1
        let url = url . '&sort=due_on'
    else
        let url = url . '&sort=' . a:sort
    endif
    if index(['asc', 'desc'], a:direction) == -1
        let url = url . '&direction=asc'
    else
        let url = url . '&direction=' . a:direction
    endif
    return github#api#util#Get(url, ['-H', 'Accept: application/vnd.github.jean-grey-preview+json'])
endfunction

""
" @public
" Get a single milestone
"
" Github API : GET /repos/:owner/:repo/milestones/:number
function! github#api#issues#GetSingleMilestone(owner,repo,num) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'milestones', a:num], '/'), [])
endfunction

""
" @public
" Create a milestone
"
" Input >
"    {
"      "title": "v1.0",
"      "state": "open",
"      "description": "Tracking milestone for version 1.0",
"      "due_on": "2012-10-09T23:39:01Z"
"    }
" <
" Github API : POST /repos/:owner/:repo/milestones
function! github#api#issues#CreateMilestone(owner,repo,milestone,user,password) abort
    return github#api#util#GetStatus(join(['repos', a:owner, a:repo, 'milestones'], '/'),
                \ ['-X', 'POST',
                \ '-d', json_encode(a:milestone),
                \ '-u', a:user . ':' . a:password]) == 201
endfunction

""
" @public
" Update a milestone
"
" Github API : PATCH /repos/:owner/:repo/milestones/:number
function! github#api#issues#UpdateMilestone(owner,repo,num,milestone,user,password) abort
    return github#api#util#Get(join(['repos', a:owner, a:repo, 'milestones', a:num], '/'),
                \ ['-X', 'PATCH',
                \ '-d', json_encode(a:milestone),
                \ '-u', a:user . ':' . a:password])
endfunction

""
" @public
" Delete a milestone
"
" Github API : DELETE /repos/:owner/:repo/milestones/:number
function! github#api#issues#DeleteMilestone(owner,repo,num,user,password) abort
    return github#api#util#GetStatus(join(['repos', a:owner, a:repo, 'milestones', a:num], '/'),
                \ ['-u', a:user . ':' . a:password]) == 204
endfunction
