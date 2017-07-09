function! s:body() abort
    return 'SpaceVim development (pre-release:' . g:spacevim_version . ') build.'
endfunction

function! SpaceVim#dev#releases#open() abort
    let username = input('github username:')
    let password = input('github password:')
    let releases = {
                \ 'tag_name': 'nightly',
                \ 'target_commitish': 'dev',
                \ 'name': g:spacevim_version,
                \ 'body': s:body(),
                \ 'draft': v:false,
                \ 'prerelease': v:true
                \ }
    let response = github#api#repos#releases#Create('SpaceVim', 'SpaceVim',
                \ username, password, releases)
    if !empty(response)
        echomsg 'releases successed! ' . response.url
    else
        echom 'releases failed!'
    endif
endfunction
