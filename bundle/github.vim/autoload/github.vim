""
" @public
" List all orgs in github,{since} is the integer ID of the last Organization
" that you've seen.
"
" Github API : GET /organizations
function! github#ListAllOrgs(since) abort
    let url = 'organizations'
    if !empty(a:since)
        let url = url . '?since=' . a:since
    endif
    return githubapi#util#Get([url], [])
endfunction

