let s:NOTI = SpaceVim#api#import('notify')

scriptencoding utf-8
let s:support_ft = ['vim', 'java', 'c', 'py', 'md', 'txt']
function! SourceCounter#View(bang, ...) abort
  call s:NOTI.notify(string(a:000))
  let fts = []
  let dirs = []
  let result = {}
  let argv_type = ''
  for argv in a:000
    if argv == '-d'
      let argv_type = 'dir'
      continue
    elseif argv == '-ft'
      let argv_type = 'filetype'
      continue
    endif
    if argv_type == 'dir'
      call add(dirs, argv)
    elseif argv_type == 'filetype'
      call add(fts, argv)
    endif
  endfor
  call s:NOTI.notify('counting for: ' . join(fts, ', '))
  " return
  for dir in dirs
    for ft in fts
      let _rs = s:counter(ft, dir)
      if !empty(_rs)
        if has_key(result, ft)
          let result[ft].files = result[ft].files + _rs.files
          let result[ft].lines = result[ft].lines + _rs.lines
        else
          let result[ft] = {
                \ 'files' : _rs.files,
                \ 'lines' : _rs.lines,
                \ }
        endif
      endif
    endfor
  endfor
  let result = sort(s:build(result), function('s:compare'))
  let table = s:draw_table(result)
  if a:bang
    tabnew
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonumber norelativenumber
    setlocal modifiable
    noautocmd normal! gg"_dG
    for line in table
      call append(line('$'), line)
    endfor
    normal! G
    setlocal nomodifiable
    nnoremap <buffer><silent> q :bd<CR>
  else
    call s:NOTI.notify(join(table, "\n"))
  endif
endfunction

function! s:build(rst) abort
  let rst = []
  for k in keys(a:rst)
    call add(rst, [k, a:rst[k].files, a:rst[k].lines])
  endfor
  return rst
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

function! s:counter(ft, dir) abort
  if executable('ag')
    if has('nvim')
      let files = systemlist(['ag','-g', '.' . a:ft . '$'])
    else
      let files = split(system('ag -g .'.a:ft.'$'),nr2char(10))
    endif
  else
    let partten = '**/*.' . a:ft
    let files = globpath(a:dir, l:partten, 0, 1)
  endif
  if len(files) == 0
    return []
  endif
  let lines = 0
  let _file_count = len(files)
  if has('nvim')
    if len(files) > 380
      while !empty(files)
        let _fs = remove(files, 0, min([380, len(files) - 1]))
        let _rst = systemlist(['wc', '-l'] + _fs)[-1]
        let lines += matchstr(_rst, '\d\+')
      endwhile
    else
      let lines = matchstr(systemlist(['wc', '-l'] + files)[-1], '\d\+')
    endif
  else
    for fl in files
      let lines += str2nr(matchstr(system('wc -l '. fl), '\d\+'))
    endfor
  endif
  return {'files' : _file_count, 'lines' : lines}
endfunction


