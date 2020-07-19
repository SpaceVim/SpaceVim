" Private Functions {{{1
" function! s:ParseRange(range, ...) {{{2
" range: A string representing range of cells.
"        - Can be row1:row2 for values in the current columns in those rows.
"        - Can be row1,col1:row2,col2 for range between row1,col1 till
"          row2,col2.
function! s:ParseRange(range, ...)
  if a:0 < 1
    let default_col = tablemode#spreadsheet#ColumnNr('.')
  elseif a:0 < 2
    let default_col = a:1
  endif

  if type(a:range) != type('')
    let range = string(a:range)
  else
    let range = a:range
  endif

  let [rowcol1, rowcol2] = split(range, ':')
  let [rcs1, rcs2] = [map(split(rowcol1, ','), 'str2nr(v:val)'), map(split(rowcol2, ','), 'str2nr(v:val)')]

  if len(rcs1) == 2
    let [row1, col1] = rcs1
  else
    let [row1, col1] = [rcs1[0], default_col]
  endif

  if len(rcs2) == 2
    let [row2, col2] = rcs2
  else
    let [row2, col2] = [rcs2[0], default_col]
  endif

  return [row1, col1, row2, col2]
endfunction


" Public Functions {{{1
" function! tablemode#spreadsheet#cell#GetCells() - Function to get values of cells in a table {{{2
" tablemode#spreadsheet#GetCells(row) - Get values of all cells in a row as a List.
" tablemode#spreadsheet#GetCells(0, col) - Get values of all cells in a column as a List.
" tablemode#spreadsheet#GetCells(row, col) - Get the value of table cell by given row, col.
function! tablemode#spreadsheet#cell#GetCells(line, ...) abort
  let line = tablemode#utils#line(a:line)

  if tablemode#table#IsRow(line)
    if a:0 < 1
      let [row, colm] = [line, 0]
    elseif a:0 < 2
      let [row, colm] = [a:1, 0]
    elseif a:0 < 3
      let [row, colm] = a:000
    endif

    let first_row = tablemode#spreadsheet#GetFirstRow(line)
    let last_row = tablemode#spreadsheet#GetLastRow(line)
    if row == 0
      let values = []
      let line = first_row
      while tablemode#table#IsTable(line)
        if tablemode#table#IsRow(line)
          let row_line = getline(line)[stridx(getline(line), g:table_mode_separator):strridx(getline(line), g:table_mode_separator)]
          call add(values, tablemode#utils#strip(get(split(row_line, g:table_mode_separator), colm>0?colm-1:colm, '')))
        endif
        let line += 1
      endwhile
      return values
    else
      let row_nr = 0
      let row_diff = row > 0 ? 1 : -1
      let line = row > 0 ? first_row : last_row
      while tablemode#table#IsTable(line)
        if tablemode#table#IsRow(line)
          let row_nr += row_diff
          if row ==# row_nr | break | endif
        endif
        let line += row_diff
      endwhile

      let row_line = getline(line)[stridx(getline(line), g:table_mode_separator):strridx(getline(line), g:table_mode_separator)]
      if colm == 0
        return map(split(row_line, g:table_mode_separator), 'tablemode#utils#strip(v:val)')
      else
        let split_line = split(row_line, g:table_mode_separator)
        return tablemode#utils#strip(get(split(row_line, g:table_mode_separator), colm>0?colm-1:colm, ''))
      endif
    endif
  endif
endfunction

function! tablemode#spreadsheet#cell#GetCell(...) "{{{2
  if a:0 == 0
    let [row, colm] = [tablemode#spreadsheet#RowNr('.'), tablemode#spreadsheet#ColumnNr('.')]
  elseif a:0 == 2
    let [row, colm] = [a:1, a:2]
  endif

  return tablemode#spreadsheet#cell#GetCells('.', row, colm)
endfunction

function! tablemode#spreadsheet#cell#GetRow(row, ...) abort "{{{2
  let line = a:0 ? a:1 : '.'
  return tablemode#spreadsheet#cell#GetCells(line, a:row)
endfunction

function! tablemode#spreadsheet#cell#GetRowColumn(col, ...) abort "{{{2
  let line = a:0 ? a:1 : '.'
  let row = tablemode#spreadsheet#RowNr('.')
  return tablemode#spreadsheet#cell#GetCells(line, row, a:col)
endfunction

function! tablemode#spreadsheet#cell#GetColumn(col, ...) abort "{{{2
  let line = a:0 ? a:1 : '.'
  return tablemode#spreadsheet#cell#GetCells(line, 0, a:col)
endfunction

function! tablemode#spreadsheet#cell#GetColumnRow(row, ...) abort "{{{2
  let line = a:0 ? a:1 : '.'
  let col = tablemode#spreadsheet#ColumnNr('.')
  return tablemode#spreadsheet#cell#GetCells(line, a:row, col)
endfunction

function! tablemode#spreadsheet#cell#GetCellRange(range, ...) abort "{{{2
  if a:0 < 1
    let [line, colm] = ['.', tablemode#spreadsheet#ColumnNr('.')]
  elseif a:0 < 2
    let [line, colm] = [a:1, tablemode#spreadsheet#ColumnNr('.')]
  elseif a:0 < 3
    let [line, colm] = [a:1, a:2]
  else
    call tablemode#utils#throw('Invalid Range')
  endif

  let values = []

  if tablemode#table#IsRow(line)
    let [row1, col1, row2, col2] = s:ParseRange(a:range, colm)

    if row1 == row2
      if col1 == col2
        call add(values, tablemode#spreadsheet#cell#GetCells(line, row1, col1))
      else
        let values = tablemode#spreadsheet#cell#GetRow(row1, line)[(col1-1):(col2-1)]
      endif
    else
      if col1 == col2
        let values = tablemode#spreadsheet#cell#GetColumn(col1, line)[(row1-1):(row2-1)]
      else
        let tcol = col1
        while tcol <= col2
          call add(values, tablemode#spreadsheet#cell#GetColumn(tcol, line)[(row1-1):(row2-1)])
          let tcol += 1
        endwhile
      endif
    endif
  endif

  return values
endfunction

function! tablemode#spreadsheet#cell#SetCell(val, ...) "{{{2
  if a:0 == 0
    let [line, row, colm] = ['.', tablemode#spreadsheet#RowNr('.'), tablemode#spreadsheet#ColumnNr('.')]
  elseif a:0 == 2
    let [line, row, colm] = ['.', a:1, a:2]
  elseif a:0 == 3
    let [line, row, colm] = a:000
  endif

  " Account for negative values to reference from relatively from the last
  if row < 0 | let row = tablemode#spreadsheet#RowCount(line) + row + 1 | endif
  if colm < 0 | let colm = tablemode#spreadsheet#ColumnCount(line) + colm + 1 | endif

  if tablemode#table#IsRow(line)
    let line = tablemode#spreadsheet#LineNr(line, row)
    let line_val = getline(line)
    let cstartexpr = tablemode#table#StartCommentExpr()
    let values = split(getline(line)[stridx(line_val, g:table_mode_separator):strridx(line_val, g:table_mode_separator)], g:table_mode_separator)
    if len(values) < colm | return | endif
    let values[colm-1] = a:val
    let line_value = g:table_mode_separator . join(values, g:table_mode_separator) . g:table_mode_separator
    if tablemode#utils#strlen(cstartexpr) > 0 && line_val =~# cstartexpr
      let sce = matchstr(line_val, tablemode#table#StartCommentExpr())
      let ece = matchstr(line_val, tablemode#table#EndCommentExpr())
      let line_value = sce . line_value . ece
    endif
    call setline(line, line_value)
    call tablemode#table#Realign(line)
  endif
endfunction
function! tablemode#spreadsheet#cell#TextObject(inner) "{{{2
  if tablemode#table#IsRow('.')
    call tablemode#spreadsheet#MoveToStartOfCell()
    if a:inner
      normal! v
      call search('[^' . g:table_mode_separator . ']\ze\s*' . g:table_mode_separator)
    else
      execute 'normal! vf' . g:table_mode_separator . 'l'
    endif
  endif
endfunction
function! tablemode#spreadsheet#cell#Motion(direction, ...) "{{{2
  let l:count = a:0 ? a:1 : v:count1
  if tablemode#table#IsRow('.')
    for ii in range(l:count)
      if a:direction ==# 'l'
        if tablemode#spreadsheet#IsLastCell()
          if !tablemode#table#IsRow(line('.') + 1) && (tablemode#table#IsBorder(line('.') + 1) && !tablemode#table#IsRow(line('.') + 2))
            return
          endif
          call tablemode#spreadsheet#cell#Motion('j', 1)
          normal! 0
        endif

        " If line starts with g:table_mode_separator
        if getline('.')[col('.')-1] ==# g:table_mode_separator
          normal! 2l
        else
          execute 'normal! f' . g:table_mode_separator . '2l'
        endif
      elseif a:direction ==# 'h'
        if tablemode#spreadsheet#IsFirstCell()
          if !tablemode#table#IsRow(line('.') - 1) && (tablemode#table#IsBorder(line('.') - 1) && !tablemode#table#IsRow(line('.') - 2))
            return
          endif
          call tablemode#spreadsheet#cell#Motion('k', 1)
          normal! $
        endif

        " If line ends with g:table_mode_separator
        if getline('.')[col('.')-1] ==# g:table_mode_separator
          execute 'normal! F' . g:table_mode_separator . '2l'
        else
          execute 'normal! 2F' . g:table_mode_separator . '2l'
        endif
      elseif a:direction ==# 'j'
        if tablemode#table#IsRow(line('.') + 1)
          " execute 'normal! ' . 1 . 'j'
          normal! j
        elseif tablemode#table#IsBorder(line('.') + 1) && tablemode#table#IsRow(line('.') + 2)
          " execute 'normal! ' . 2 . 'j'
          normal! 2j
        endif
      elseif a:direction ==# 'k'
        if tablemode#table#IsRow(line('.') - 1)
          " execute 'normal! ' . 1 . 'k'
          normal! k
        elseif tablemode#table#IsBorder(line('.') - 1) && tablemode#table#IsRow(line('.') - 2)
          " execute 'normal! ' . (1 + 1) . 'k'
          normal! 2k
        endif
      endif
    endfor
  endif
endfunction

" vim: sw=2 sts=2 fdl=0 fdm=marker
