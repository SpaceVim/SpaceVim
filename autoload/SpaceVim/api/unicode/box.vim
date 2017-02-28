let s:box = {}
let s:json = SpaceVim#api#import('data#json')
let s:string = SpaceVim#api#import('data#string')
scriptencoding utf-8
" http://jrgraphix.net/r/Unicode/2500-257F
" http://www.alanflavell.org.uk/unicode/unidata.html

" json should be a list of items which have same keys
function! s:drawing_table(json, ...) abort
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
    let items = s:json.json_decode(a:json)
    let col = len(keys(items[0]))
    let top_line = top_left_corner
                \ . repeat(repeat(top_bottom_side, 15) . top_middle, col - 1)
                \ . repeat(top_bottom_side, 15)
                \ . top_right_corner
    let middle_line = left_middle
                \ . repeat(repeat(top_bottom_side, 15) . middle, col - 1)
                \ . repeat(top_bottom_side, 15)
                \ . right_middle
    let bottom_line = bottom_left_corner
                \ . repeat(repeat(top_bottom_side, 15) . bottom_middle, col - 1)
                \ . repeat(top_bottom_side, 15)
                \ . bottom_right_corner
    call add(table, top_line)
    let tytle = side
    if a:0 == 0
        let keys = keys(items[0])
    else
        let keys = a:1
    endif
    for key in keys
        let tytle .= s:string.fill(key , 15) . side
    endfor
    call add(table, tytle)
    call add(table, middle_line)
    for item in items
        let value_line = side
        for key in keys
            let value_line .= s:string.fill(item[key], 15) . side
        endfor
        call add(table, value_line)
        call add(table, middle_line)
    endfor
    let table[-1] = bottom_line
    return table
endfunction

let s:box['drawing_table'] = function('s:drawing_table')

function! SpaceVim#api#unicode#box#get() abort
    return deepcopy(s:box)
endfunction
