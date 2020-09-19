" Static Var:
" char list of ['!'..'~'].
let s:chars  = map(range(33, 126), 'nr2char(v:val)')

" data file path
let s:data_large = expand("<sfile>:h") . '/data/large'
let s:data_small = expand("<sfile>:h") . '/data/small'

" Util:
let s:_ = choosewin#util#get()

function! s:scan_char(str, char) "{{{1
  " Return List of index where char mached to string
  " ex)
  "   s:scan_char('   ##   ', '#') => [3, 4]
  "   s:scan_char('        ', '#') => []
  let R = []
  for [index, char] in map(split(a:str, '\zs'), '[v:key, v:val]')
    if char is a:char
      call add(R, index)
    endif
  endfor
  return R
endfunction

"}}}

" Font:
function! s:font_new(data) "{{{1
  " Generate Font(=Dictionary) used by Overlay.
  let [line_used, col_used, pattern] = s:pattern_gen(a:data)
  let height = max(line_used) + 1
  let width  = max(col_used)
  return {
        \ 'width':     width,
        \ 'height':    height,
        \ 'col_used':  col_used,
        \ 'line_used': line_used,
        \ 'pattern':   pattern,
        \ }
endfunction

function! s:pattern_gen(data) "{{{1
  " Return Regexp pattern font_data represent.
  " This Regexp can't use without replacing special vars like '%{L+1}, %{C+1} ..'
  let R = []
  let line_used = []
  let col_used  = []
  for [i, val] in map(a:data, '[v:key, s:scan_char(v:val, "#")]')
    if empty(val)
      continue
    endif
    call extend(col_used, val)
    call add(line_used, i)
    call add(R, s:_parse_column(i, val))
  endfor
  let col_used = s:_.uniq(col_used)
  return [line_used, col_used, '\v' . join(R, '|')]
endfunction


function! s:_parse_column(line, column_list) "{{{1
  " c_base = previous column position
  let R = []
  let c_previous = -1
  for c in a:column_list
    if c is c_previous
      let R[-1] .= '.'
    else
      call add(R, '%{C+'. c .'}c.')
    endif
    let col_previous = c
  endfor

  let prefix = "%{L+". a:line ."}l"
  return join(map(R, 'prefix . v:val'), "|")
endfunction
"}}}

" Table:
function! s:read_data(file) "{{{1
  " file = font data file path
  " return Dictionary where key=char, val=fontdata as List.
  "   {
  "     '!': ['   ##   ', '   ##   ', '   ##   ', '        ', '   ##   '],
  "     '"': [' ##  ## ', ' ##  ## ', '  #  #  ', '        ', '        '],
  "     .......
  "   }
  let R = {}
  for c in s:chars | let R[c] = [] | endfor

  let lines = readfile(a:file)
  for c in s:chars
    while 1
      let line = remove(lines, 0)
      if line =~# '\v^---'
        break
      endif
      call add(R[c], line)
    endwhile
  endfor
  return R
endfunction
"}}}

" API:
function! choosewin#font#small() "{{{1
  return map(s:read_data(s:data_small),'s:font_new(v:val)')
endfunction

function! choosewin#font#large() "{{{1
  return map(s:read_data(s:data_large),'s:font_new(v:val)')
endfunction
"}}}
" vim: foldmethod=marker
