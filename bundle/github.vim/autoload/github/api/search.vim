""
" @public
" Search for repos, for how to {sort} result, you can use `stars`,`forks` and
" `updated`. and for {order} you can use `asc` and `desc`.for {q} see:
" Input: >
"                 {
"                 'in'       : 'name,description',
"                 'size'     : '',
"                 'forks'    : '',
"                 'fork'     : '',
"                 'created'  : '',
"                 'pushed'   : '',
"                 'user'     : '',
"                 'language' : '',
"                 'stars'    : '',
"                 'keywords' : ''
"                 }
" <
"
" Github API : GET /search/repositories
function! github#api#search#SearchRepos(q,sort,order) abort
    let url = 'search/repositories'
    let _sort = ['stars', 'forks', 'updated']
    let _order = ['asc', 'desc']
    let url = github#api#util#parserArgs(url, 'sort', a:sort, _sort, '')
    if index(_sort, a:sort) != -1
        let url = github#api#util#parserArgs(url, 'order', a:order, _order, 'desc')
    endif
    if stridx(url, '?') == -1
        let url .= '?'
    else
        let url .= '&'
    endif
    let url .= s:parser(a:q, s:repo_scopes)
    return github#api#util#Get(url, [])
endfunction

function! github#api#search#SearchCode(q,sort,order) abort
    let url = 'search/code'
    let _sort = ['indexed']
    let _order = ['asc', 'desc']
    let url = github#api#util#parserArgs(url, 'sort', a:sort, _sort, '')
    if index(_sort, a:sort) != -1
        let url = github#api#util#parserArgs(url, 'order', a:order, _order, 'desc')
    endif
    if stridx(url, '?') == -1
        let url .= '?'
    else
        let url .= '&'
    endif
    let url .= s:parser(a:q, s:code_scopes)
    return github#api#util#Get(url, [])
endfunction

function! github#api#search#SearchIssues(q,sort,order) abort
    let url = 'search/issues'
    let _sort = ['comments', 'created', 'updated']
    let _order = ['asc', 'desc']
    let url = github#api#util#parserArgs(url, 'sort', a:sort, _sort, '')
    if index(_sort, a:sort) != -1
        let url = github#api#util#parserArgs(url, 'order', a:order, _order, 'desc')
    endif
    if stridx(url, '?') == -1
        let url .= '?'
    else
        let url .= '&'
    endif
    let url .= s:parser(a:q, s:issues_scopes)
    return github#api#util#Get(url, [])
endfunction

function! github#api#search#SearchUsers(q,sort,order) abort
    let url = 'search/users'
    let _sort = ['followers', 'repositories', 'joined']
    let _order = ['asc', 'desc']
    let url = github#api#util#parserArgs(url, 'sort', a:sort, _sort, '')
    if index(_sort, a:sort) != -1
        let url = github#api#util#parserArgs(url, 'order', a:order, _order, 'desc')
    endif
    if stridx(url, '?') == -1
        let url .= '?'
    else
        let url .= '&'
    endif
    let url .= s:parser(a:q, s:users_scopes)
    return github#api#util#Get(url, [])
endfunction

" default       scopes   [valid values, default values]
let s:repo_scopes = {
            \ 'in'       : [['name', 'description', 'readme'], 'name,description'],
            \ 'size'     : '',
            \ 'forks'    : '',
            \ 'fork'     : '',
            \ 'created'  : '',
            \ 'pushed'   : '',
            \ 'user'     : '',
            \ 'language' : '',
            \ 'stars'    : '',
            \ 'keywords' : ''
            \ }
let s:code_scopes = {
            \ 'in'        : 'file',
            \ 'path'      : '',
            \ 'filename'  : '',
            \ 'extension' : '',
            \ 'user'      : '',
            \ 'size'      : '',
            \ 'forks'     : '',
            \ 'fork'      : '',
            \ 'language'  : ''
            \ }
" https://help.github.com/articles/searching-issues/
let s:issues_scopes = {
            \ 'type'      : 'pr,issue',
            \ 'in'        : 'title,body,comments',
            \ 'author'    : '',
            \ 'assignee'  : '',
            \ 'mentions'  : '',
            \ 'commenter' : '',
            \ 'involves'  : '',
            \ 'team'      : '',
            \ 'state'     : '',
            \ 'label'     : '',
            \ 'milestone' : '',
            \ 'no'        : '',
            \ 'language'  : '',
            \ 'is'        : '',
            \ 'created'   : '',
            \ 'updated'   : '',
            \ 'merged'    : '',
            \ 'status'    : '',
            \ 'head'      : '',
            \ 'base'      : '',
            \ 'closed'    : '',
            \ 'comments'  : '',
            \ 'user'      : ''
            \ }
let s:users_scopes = {
            \ 'type' : 'org,user',
            \ 'in' : 'username,email',
            \ 'repos' : '',
            \ 'location' : '',
            \ 'language' : '',
            \ 'created' : '',
            \ 'followers' : ''
            \ }
function! s:parser(q,scopes) abort
    let scopes = copy(a:scopes)
    " parser q
    let rs = ''
    if type(a:q) == type({})
        if has_key(a:q, 'keywords')
            let rs .= 'q=' . get(a:q, 'keywords')
            call remove(a:q, 'keywords')
        endif
        for scope in keys(scopes)
            if has_key(a:q, scope) && !empty(get(a:q, scope))
                let res = s:getArgv(get(a:q, scope), get(scopes, scope))
                if !empty(res)
                    let rs .= '+' . scope . ':' . res
                endif
            endif
        endfor
    elseif type(a:q) == type('')
        let rs .= 'q=' . a:q
    endif
    return rs
endfunction

fu! s:getArgv(args,base) abort
    if type(a:base) == type([])
        let vars = a:base[0]
        let default = a:base[1]
        let f = 0
        for a in (type(a:args) == type('') ? split(a:args, ',') : a:args)
            if index(vars, a) == -1
                let f = 1
            endif
        endfor
        if f && !empty(default)
            let result = default
        elseif f
            let result = ''
        else
            let result = a:args
        endif
        return result
    elseif type(a:base) == type('') && empty(a:base)
        return ''
    endif
endf
