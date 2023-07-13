let s:JOB = SpaceVim#api#import('job')
let s:NOTI = SpaceVim#api#import('notify')

scriptencoding utf-8
let s:support_ft = ['vim', 'java', 'c', 'py', 'md', 'txt']
function! SourceCounter#View(bang, ...) abort
    let result = []
    if a:0
        let fts = a:000
    else
        let fts = s:support_ft
    endif
    call s:NOTI.notify('counting for: ' . join(fts, ', '))
    " return
    for ft in fts
        let _rs = s:counter(ft)
        if !empty(_rs)
            call add(result, _rs)
        endif
    endfor
    let result = sort(deepcopy(result), function('s:compare'))
    let table = s:draw_table(result)
    if a:bang
        tabnew
        for line in table
            call append(line('$'), line)
        endfor
    else
        call s:NOTI.notify(join(table, "\n"))
    endif
endfunction

function! s:compare(a, b) abort
    let m = get(g:, 'source_counter_sort', 'files')
    if m ==# 'lines'
        return a:a[2] == a:b[2] ? 0 : a:a[2] > a:b[2] ? -1 : 1
    else
        return a:a[1] == a:b[1] ? 0 : a:a[1] > a:b[1] ? -1 : 1
    endif
endfunction
" https://en.wikipedia.org/wiki/Box-drawing_character
function! s:draw_table(rst) abort
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
    let top_line = top_left_corner
                \ . repeat(top_bottom_side, 15)
                \ . top_middle
                \ . repeat(top_bottom_side, 15)
                \ . top_middle
                \ . repeat(top_bottom_side, 15)
                \ . top_right_corner

    let middle_line = left_middle
                \ . repeat(top_bottom_side, 15)
                \ . middle
                \ . repeat(top_bottom_side, 15)
                \ . middle
                \ . repeat(top_bottom_side, 15)
                \ . right_middle

    let bottom_line = bottom_left_corner
                \ . repeat(top_bottom_side, 15)
                \ . bottom_middle
                \ . repeat(top_bottom_side, 15)
                \ . bottom_middle
                \ . repeat(top_bottom_side, 15)
                \ . bottom_right_corner

    call add(table, top_line)
    let result = [['filetype', 'files', 'lines']] + a:rst
    for rsl in result
        let ft_line = side
                    \ . rsl[0] . repeat(' ', 15 - strwidth(rsl[0]))
                    \ . side
                    \ . rsl[1] . repeat(' ', 15 - strwidth(rsl[1]))
                    \ . side
                    \ . rsl[2] . repeat(' ', 15 - strwidth(rsl[2]))
                    \ . side
        call add(table, ft_line)
        call add(table, middle_line)
    endfor
    let table[-1] = bottom_line
    return table
endfunction

function! s:list_files_stdout(id, data, event) abort
  
endfunction

function! s:list_files_exit(id, data, event) abort
  
endfunction

function! s:counter(ft) abort
    let path = getcwd()
    let partten = '**/*.' . a:ft
    if executable('ag')
        if has('nvim')
            let files = systemlist(['ag','-g', '.' . a:ft . '$'])
        else
            let files = split(system('ag -g .'.a:ft.'$'),nr2char(10))
        endif
    else
        let files = globpath(l:path, l:partten, 0, 1)
    endif
    if len(files) == 0
        return []
    endif
    let lines = 0
    if has('nvim')
        if len(files) > 380
            while !empty(files)
                let lines += matchstr(systemlist(['wc', '-l'] + remove(files, 0, min([380, len(files) - 1])))[-1], '\d\+')
            endwhile
        else
            let lines = matchstr(systemlist(['wc', '-l'] + files)[-1], '\d\+')
        endif
    else
        for fl in files
            let lines += str2nr(matchstr(system('wc -l '. fl), '\d\+'))
        endfor
    endif
    return [a:ft, len(files), lines]
endfunction


