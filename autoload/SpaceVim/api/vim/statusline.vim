let s:self = {}


function! s:self.build(left_sections, right_sections, lsep, rsep, hi_a, hi_b, hi_c, hi_z) abort
    let l = '%#' . a:hi_a . '#' . a:left_sections[0]
    let l .= '%#' . a:hi_a . '_' . a:hi_b . '#' . a:lsep
    let flag = 1
    for sec in filter(a:left_sections[1:], '!empty(v:val)')
        if flag == 1
            let l .= '%#' . a:hi_b . '#' . sec
            let l .= '%#' . a:hi_b . '_' . a:hi_c . '#' . a:lsep
        else
            let l .= '%#' . a:hi_c . '#' . sec
            let l .= '%#' . a:hi_c . '_' . a:hi_b . '#' . a:lsep
        endif
        let flag = flag * -1
    endfor
    let l = l[:len(a:lsep) * -1 - 1]
    if empty(a:right_sections)
        if flag == 1
            return l . '%#' . a:hi_c . '#'
        else
            return l . '%#' . a:hi_b . '#'
        endif
    endif
    if flag == 1
        let l .= '%#' . a:hi_c . '_' . a:hi_z . '#' . a:lsep . '%='
    else
        let l .= '%#' . a:hi_b . '_' . a:hi_z . '#' . a:lsep . '%='
    endif
    let l .= '%#' . a:hi_b . '_' . a:hi_z . '#' . a:rsep
    let flag = 1
    for sec in filter(a:right_sections, '!empty(v:val)')
        if flag == 1
            let l .= '%#' . a:hi_b . '#' . sec
            let l .= '%#' . a:hi_c . '_' . a:hi_b . '#' . a:rsep
        else
            let l .= '%#' . a:hi_c . '#' . sec
            let l .= '%#' . a:hi_b . '_' . a:hi_c . '#' . a:rsep
        endif
        let flag = flag * -1
    endfor
    return l[:-4]
endfunction

function! SpaceVim#api#vim#statusline#get() abort
    return deepcopy(s:self)
endfunction
