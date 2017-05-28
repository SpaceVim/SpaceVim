function! SpaceVim#plugins#gitcommit#complete(findstart, base) abort
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] != ' '
            let start -= 1
        endwhile
        return start
    else
        let res = []
        for m in s:cache_commits()
            if m =~ a:base
                call add(res, m)
            endif
        endfor
        return res
    endif
endfunction

function! s:cache_commits() abort
    let rst = systemlist("git log --oneline -n 50 --pretty=format:'%h %s' --abbrev-commit")
    return rst
endfunction
