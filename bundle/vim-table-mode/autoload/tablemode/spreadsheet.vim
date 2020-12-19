" Private Functions {{{1
function! s:TotalCells(list) "{{{2
  let result = 0
  for item in a:list
    if type(item) == type([])
      let result += s:TotalCells(item)
    else
      let result += 1
    endif
  endfor
  return result
endfunction

function! s:Min(list) "{{{2
  let found = v:false
  let result = 0
  for item in a:list
    if empty(item)
      continue
    endif
    if type(item) == type(1) || type(item) == type(1.0)
      if found == v:false || item < result
        let found = v:true
        let result = item
      endif
    elseif type(item) == type('')
      let val = str2float(item)
      if found == v:false || val < result
        let found = v:true
        let result = val
      endif
    elseif type(item) == type([])
      let val = s:Min(item)
      if found == v:false || val < result
        let found = v:true
        let result = val
      endif
    endif
  endfor
  return result
endfunction

function! s:Max(list) "{{{2
  let found = v:false
  let result = 0
  for item in a:list
    if empty(item)
      continue
    endif
    if type(item) == type(1) || type(item) == type(1.0)
      if found == v:false || item > result
        let found = v:true
        let result = item
      endif
    elseif type(item) == type('')
      let val = str2float(item)
      if found == v:false || val > result
        let found = v:true
        let result = val
      endif
    elseif type(item) == type([])
      let val = s:Max(item)
      if found == v:false || val > result
        let found = v:true
        let result = val
      endif
    endif
  endfor
  return result
endfunction

function! s:CountE(list) "{{{2
  let result = 0
  for item in a:list
    if empty(item)
      let result += 1
    elseif type(item) == type([])
      let result += s:CountE(item)
    endif
  endfor
  return result
endfunction

function! s:CountNE(list) "{{{2
  let result = 0
  for item in a:list
    if type(item) == type([])
      let result += s:CountNE(item)
    elseif !empty(item)
      let result += 1
    endif
  endfor
  return result
endfunction

function! s:PercentE(list) "{{{2
  return (s:CountE(a:list)*100)/s:TotalCells(a:list)
endfunction

function! s:PercentNE(list) "{{{2
  return (s:CountNE(a:list)*100)/s:TotalCells(a:list)
endfunction

function! s:Sum(list) "{{{2
  let result = 0.0
  for item in a:list
    if type(item) == type(1) || type(item) == type(1.0)
      let result += item
    elseif type(item) == type('')
      let result += str2float(item)
    elseif type(item) == type([])
      let result += s:Sum(item)
    endif
  endfor
  return result
endfunction

function! s:Average(list) "{{{2
  return s:Sum(a:list)/s:TotalCells(a:list)
endfunction

function! s:AverageNE(list) "{{{2
  return s:Sum(a:list)/s:CountNE(a:list)
endfunction

" Public Functions {{{1
function! tablemode#spreadsheet#GetFirstRow(line) "{{{2
  if tablemode#table#IsRow(a:line)
    let line = tablemode#utils#line(a:line)

    while !tablemode#table#IsHeader(line - 1) && (tablemode#table#IsRow(line - 1) || tablemode#table#IsBorder(line - 1))
      let line -= 1
    endwhile
    if tablemode#table#IsBorder(line) | let line += 1 | endif

    return line
  endif
endfunction

function! tablemode#spreadsheet#GetFirstRowOrHeader(line) "{{{2
  if tablemode#table#IsRow(a:line)
    let line = tablemode#utils#line(a:line)

    while tablemode#table#IsTable(line - 1)
      let line -= 1
    endwhile
    if tablemode#table#IsBorder(line) | let line += 1 | endif

    return line
  endif
endfunction

function! tablemode#spreadsheet#MoveToFirstRow() "{{{2
  if tablemode#table#IsRow('.')
    call tablemode#utils#MoveToLine(tablemode#spreadsheet#GetFirstRow('.'))
  endif
endfunction

function! tablemode#spreadsheet#MoveToFirstRowOrHeader() "{{{2
  if tablemode#table#IsRow('.')
    call tablemode#utils#MoveToLine(tablemode#spreadsheet#GetFirstRowOrHeader('.'))
  endif
endfunction

function! tablemode#spreadsheet#GetLastRow(line) "{{{2
  if tablemode#table#IsRow(a:line)
    let line = tablemode#utils#line(a:line)

    while tablemode#table#IsTable(line + 1)
      let line += 1
    endwhile
    if tablemode#table#IsBorder(line) | let line -= 1 | endif

    return line
  endif
endfunction

function! tablemode#spreadsheet#MoveToLastRow() "{{{2
  if tablemode#table#IsRow('.')
    call tablemode#utils#MoveToLine(tablemode#spreadsheet#GetLastRow('.'))
  endif
endfunction

function! tablemode#spreadsheet#LineNr(line, row) "{{{2
  if tablemode#table#IsRow(a:line)
    let line = tablemode#spreadsheet#GetFirstRow(a:line)
    let row_nr = 0

    while tablemode#table#IsTable(line + 1)
      if tablemode#table#IsRow(line)
        let row_nr += 1
        if a:row ==# row_nr | break | endif
      endif
      let line += 1
    endwhile

    return line
  endif
endfunction

function! tablemode#spreadsheet#RowNr(line) "{{{2
  let line = tablemode#utils#line(a:line)

  let rowNr = 0
  while !tablemode#table#IsHeader(line) && tablemode#table#IsTable(line)
    if tablemode#table#IsRow(line) | let rowNr += 1 | endif
    let line -= 1
  endwhile

  return rowNr
endfunction

function! tablemode#spreadsheet#RowCount(line) "{{{2
  let line = tablemode#utils#line(a:line)

  let [tline, totalRowCount] = [line, 0]
  while !tablemode#table#IsHeader(tline) && tablemode#table#IsTable(tline)
    if tablemode#table#IsRow(tline) | let totalRowCount += 1 | endif
    let tline -= 1
  endwhile

  let tline = line + 1
  while !tablemode#table#IsHeader(tline) && tablemode#table#IsTable(tline)
    if tablemode#table#IsRow(tline) | let totalRowCount += 1 | endif
    let tline += 1
  endwhile

  return totalRowCount
endfunction

function! tablemode#spreadsheet#ColumnNr(pos) "{{{2
  let pos = []
  if type(a:pos) == type('')
    let pos = [line(a:pos), col(a:pos)]
  elseif type(a:pos) == type([])
    let pos = a:pos
  else
    return 0
  endif
  let row_start = stridx(getline(pos[0]), g:table_mode_separator)
  return tablemode#utils#SeparatorCount(getline(pos[0])[row_start:pos[1]-2])
endfunction

function! tablemode#spreadsheet#ColumnCount(line) "{{{2
  return tablemode#utils#SeparatorCount(getline(tablemode#utils#line(a:line))) - 1
endfunction

function! tablemode#spreadsheet#IsFirstCell() "{{{2
  return tablemode#spreadsheet#ColumnNr('.') ==# 1
endfunction

function! tablemode#spreadsheet#IsLastCell() "{{{2
  return tablemode#spreadsheet#ColumnNr('.') ==# tablemode#spreadsheet#ColumnCount('.')
endfunction

function! tablemode#spreadsheet#MoveToStartOfCell() "{{{2
  if getline('.')[col('.')-1] !=# g:table_mode_separator || tablemode#spreadsheet#IsLastCell()
    call search(g:table_mode_escaped_separator_regex, 'b', line('.'))
  endif
  normal! 2l
endfunction

function! tablemode#spreadsheet#MoveToEndOfCell() "{{{2
  call search(g:table_mode_escaped_separator_regex, 'z', line('.'))
  normal! 2h
endfunction

function! tablemode#spreadsheet#DeleteColumn() "{{{2
  if tablemode#table#IsRow('.')
    for i in range(v:count1)
      call tablemode#spreadsheet#MoveToStartOfCell()
      call tablemode#spreadsheet#MoveToFirstRowOrHeader()
      silent! execute "normal! h\<C-V>"
      call tablemode#spreadsheet#MoveToEndOfCell()
      normal! 2l
      call tablemode#spreadsheet#MoveToLastRow()
      normal! d
    endfor

    call tablemode#table#Realign('.')
  endif
endfunction

function! tablemode#spreadsheet#DeleteRow() "{{{2
  if tablemode#table#IsRow('.')
    for i in range(v:count1)
      if tablemode#table#IsRow('.')
        normal! dd
      endif

      if !tablemode#table#IsRow('.')
        normal! k
      endif
    endfor

    call tablemode#table#Realign('.')
  endif
endfunction

function! tablemode#spreadsheet#InsertColumn(after) "{{{2
  if tablemode#table#IsRow('.')
    let quantity = v:count1

    call tablemode#spreadsheet#MoveToFirstRowOrHeader()
    call tablemode#spreadsheet#MoveToStartOfCell()
    if a:after
      call tablemode#spreadsheet#MoveToEndOfCell()
      normal! 3l
    endif
    execute "normal! h\<C-V>"
    call tablemode#spreadsheet#MoveToLastRow()
    normal! y

    let corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner')
    if a:after
      let cell_line = g:table_mode_separator.'  '
      let header_line = corner.g:table_mode_fillchar.g:table_mode_fillchar
    else
      let cell_line = '  '.g:table_mode_separator
      let header_line = g:table_mode_fillchar.g:table_mode_fillchar.corner
    endif
    let cell_line = escape(cell_line, '\&')
    let header_line = escape(header_line, '\&')

    " This transforms the character column before or after the column separator
    " into a new column with separator.
    " This requires, that
    "      g:table_mode_separator != g:table_mode_fillchar
    "   && g:table_mode_separator != g:table_mode_header_fillchar
    "   && g:table_mode_separator != g:table_mode_align_char
    call setreg(
      \ '"',
      \ substitute(
      \   substitute(@", ' ', cell_line, 'g'),
      \   '\V\C'.escape(g:table_mode_fillchar, '\')
      \     .'\|'.escape(g:table_mode_header_fillchar, '\')
      \     .'\|'.escape(g:table_mode_align_char, '\'),
      \   header_line,
      \   'g'),
      \ 'b')

    if a:after
      execute "normal! ".quantity."pl"
    else
      execute "normal! ".quantity."P"
    endif

    call tablemode#table#Realign('.')
    startinsert
  endif
endfunction

function! tablemode#spreadsheet#Min(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:Min(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#Max(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:Max(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#CountE(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:CountE(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#CountNE(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:CountNE(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#PercentE(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:PercentE(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#PercentNE(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:PercentNE(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#Sum(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:Sum(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#Average(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:Average(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#AverageNE(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:AverageNE(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#Sort(bang, ...) range "{{{2
  if exists('*getcurpos')
    let col = getcurpos()[4] " curswant
  else
    let col = col('.')
  endif
  let opts = a:0 ? a:1 : ''
  let bang = a:bang ? '!' : ''
  if a:firstline == a:lastline
    let [firstRow, lastRow] = [tablemode#spreadsheet#GetFirstRow('.'), tablemode#spreadsheet#GetLastRow('.')]
  else
    let [firstRow, lastRow] = [a:firstline, a:lastline]
  endif
  call tablemode#spreadsheet#MoveToStartOfCell()
  exec ':undojoin | '.firstRow.','.lastRow . 'sort'.bang opts '/.*\%'.col.'v/'
endfunction
