"=============================================================================
" Achievements.vim --- Script for generate achievements
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! s:generate_content() abort
    let content = ['## Achievements', '']
    let content += s:issues_ac()
    let content += s:stargazers_ac()
    return content
endfunction

function! s:find_position() abort
    let start = search('^<!-- SpaceVim Achievements start -->$','bwnc')
    let end = search('^<!-- SpaceVim Achievements end -->$','bnwc')
    return sort([start, end])
endfunction

function! s:issues_ac() abort
    let line = ['### issues']
    call add(line, '')
    call add(line, 'Achievements | Account')
    call add(line, '----- | -----')
    let acc = [100, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    for id in acc
        let issue = github#api#issues#Get_issue('SpaceVim', 'SpaceVim', id)
        if has_key(issue, 'id')
            let is_pr = has_key(issue, 'pull_request')
            call add(line, '[' . id . 'th issue(' .
                        \ (is_pr ? 'PR' : 'issue') .
                        \ ')](https://github.com/SpaceVim/SpaceVim/issues/' . id . ') | [' . issue.user.login
                        \ . '](https://github.com/' . issue.user.login . ')'
                        \ )
        else
            break
        endif
    endfor
    if line[-1] !=# ''
        let line += ['']
    endif
    return line
endfunction

function! s:stargazers_ac() abort
    let line = ['### Stars, forks and watchers']
    call add(line, '')
    call add(line, 'Achievements | Account')
    call add(line, '----- | -----')
    let stc = [1, 100, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    for id in stc
        if id == 1
            let user = github#api#activity#List_stargazers('SpaceVim','SpaceVim')[0]
            call add(line, 'First stargazers | [' . user.login  . '](https://github.com/' . user.login . ')')
        else
            let index = id % 30
            if index == 0
                let page = id/30
                let index = 30
            else
                let page = id/30 + 1
            endif
            let users = github#api#activity#List_stargazers('SpaceVim','SpaceVim', page)
            if type(users) == type([]) && len(users) >= index
                let user = users[index - 1]
                call add(line, id . 'th stargazers | [' . user.login  . '](https://github.com/' . user.login . ')')
            endif
        endif
    endfor
    if line[-1] !=# ''
        let line += ['']
    endif
    return line
endfunction

function! SpaceVim#dev#Achievements#update() abort
    let [start, end] = s:find_position()
    if start != 0 && end != 0
        if end - start > 1
            exe (start + 1) . ',' . (end - 1) . 'delete'
        endif
        call append(start, s:generate_content())
    endif
endfunction
