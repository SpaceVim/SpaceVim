function! SpaceVim#plugins#gitcommit#complete(findstart, base) abort
    if a:findstart
        return strridx(getline('.'), ' ')
    else
        return s:cache_commits(a:base)
    endif
endfunction

function! s:cache_commits(base) abort
    let rst = systemlist("git log --oneline -n 20 --pretty=format:'%h %s' --abbrev-commit")
    return rst
endfunction

