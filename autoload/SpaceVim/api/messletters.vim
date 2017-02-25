scriptencoding utf-8
let s:chars = {}
" type :
" 0: 1 ➛ ➊ 
" 1: 1 ➛ ➀
" 2: 1 ➛ ⓵
function! s:bubble_num(num, type) abort
    let list = []
    call add(list,['➊', '➋', '➌', '➍', '➎', '➏', '➐', '➑', '➒', '➓'])
    call add(list,['➀', '➁', '➂', '➃', '➄', '➅', '➆', '➇', '➈', '➉'])
    call add(list,['⓵', '⓶', '⓷', '⓸', '⓹', '⓺', '⓻', '⓼', '⓽', '⓾'])
    return list[a:type][a:num-1]
endfunction

let s:chars['bubble_num'] = function('s:bubble_num')


function! SpaceVim#api#messletters#get() abort
    return deepcopy(s:chars)
endfunction

