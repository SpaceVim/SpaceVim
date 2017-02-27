let s:box = {}
scriptencoding utf-8
" http://jrgraphix.net/r/Unicode/2500-257F

" json should be a list of items which have same keys
function! s:drawing_table(json) abort
    if empty(a:json)
        return []
    endif
    if &encoding ==# 'utf-8'
        let top_left_corner = '╭'
        let top_right_corner = '╮'
        let bottom_left_corner = '╰'
        let bottom_right_corner = '╯'
        let side = '│'
        let top_bottom_side = '─'
        let middle = '┼'
        let top_middle = '┬'
        let left_middle = '├'
        let right_middle = '┤'
        let bottom_middle = '┴'
    else
        let top_left_corner = '*'
        let top_right_corner = '*'
        let bottom_left_corner = '*'
        let bottom_right_corner = '*'
        let side = '|'
        let top_bottom_side = '-'
        let middle = '*'
        let top_middle = '*'
        let left_middle = '*'
        let right_middle = '*'
        let bottom_middle = '*'
    endif
    let table = []
    let col = len(keys(a:json[0]))




endfunction

function! SpaceVim#api#file#get() abort
    return deepcopy(s:box)
endfunction
