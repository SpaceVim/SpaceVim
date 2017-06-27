function! s:generate_content() abort
  let content = []
  let content += s:issues_ac()
  return content
endfunction

function! s:find_position() abort
    let start = search('<!-- SpaceVim Achievements start -->','bwnc')
    let end = search('<!-- SpaceVim Achievements end -->','bnwc')
    return [start, end]
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
            call add(line, id . 'th issue(' . (is_pr ? 'PR' : 'issue') . ') | ' . issue.user.login)
        else
            break
        endif
    endfor
    return line
endfunction

function! SpaceVim#dev#Achievements#update()
    let [start, end] = s:find_position()
    if start != 0 && end != 0
        exe (start + 1) . ',' . (end - 1) . 'delete'
        call append(start, s:generate_content())
    endif
endfunction
