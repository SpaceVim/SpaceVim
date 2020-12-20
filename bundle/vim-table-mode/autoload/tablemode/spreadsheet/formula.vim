" Private Functions {{{1
function! s:IsHTMLComment(line) "{{{2
  return getline(a:line) =~# '^\s*<!--'
endfunction

function! s:IsFormulaLine(line) "{{{2
  return getline(a:line) =~# 'tmf: '
endfunction

" Public Functions {{{1
function! tablemode#spreadsheet#formula#Add(...) "{{{2
  let fr = a:0 ? a:1 : input('f=')
  let row = tablemode#spreadsheet#RowNr('.')
  let colm = tablemode#spreadsheet#ColumnNr('.')
  let indent = indent('.')
  let indent_str = repeat(' ', indent)

  if fr !=# ''
    let fr = '$' . row . ',' . colm . '=' . fr
    let fline = tablemode#spreadsheet#GetLastRow('.') + 1
    if tablemode#table#IsBorder(fline) | let fline += 1 | endif
    if s:IsHTMLComment(fline) | let fline += 1 | endif
    let cursor_pos = [line('.'), col('.')]
    if getline(fline) =~# 'tmf: '
      " Comment line correctly
      let line_val = getline(fline)
      let start_pos = match(line_val, tablemode#table#StartCommentExpr())
      let end_pos = match(line_val, tablemode#table#EndCommentExpr())
      if empty(end_pos) | let end_pos = len(line_val) | endif
      let line_expr = strpart(line_val, start_pos, end_pos)
      let sce = matchstr(line_val, tablemode#table#StartCommentExpr() . '\zs')
      let ece = matchstr(line_val, tablemode#table#EndCommentExpr())
      call setline(fline, sce . line_expr . '; ' . fr . ece)
    else
      let cstring = &commentstring
      let [cmss, cmse] = ['', '']
      if len(cstring) > 0
        let cms = split(cstring, '%s')
        if len(cms) == 2
          let [cmss, cmse] = cms
        else
          let [cmss, cmse] = [cms[0], '']
        endif
      endif
      let fr = indent_str . cmss . ' tmf: ' . fr . ' ' . cmse
      call append(fline-1, fr)
      call cursor(cursor_pos)
    endif
    call tablemode#spreadsheet#formula#EvaluateFormulaLine()
  endif
endfunction

function! tablemode#spreadsheet#formula#EvaluateExpr(expr, line) abort "{{{2
  let line = tablemode#utils#line(a:line)
  let [target, expr] = map(split(a:expr, '='), 'tablemode#utils#strip(v:val)')
  let cell = substitute(target, '\$', '', '')
  if cell =~# ','
    let [row, colm] = map(split(cell, ','), 'str2nr(v:val)')
  else
    let [row, colm] = [0, str2nr(cell)]
  endif

  if expr =~# 'Min(.*)'
    let expr = substitute(expr, 'Min(\([^)]*\))', 'tablemode#spreadsheet#Min("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'Max(.*)'
    let expr = substitute(expr, 'Max(\([^)]*\))', 'tablemode#spreadsheet#Max("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'CountE(.*)'
    let expr = substitute(expr, 'CountE(\([^)]*\))', 'tablemode#spreadsheet#CountE("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'CountNE(.*)'
    let expr = substitute(expr, 'CountNE(\([^)]*\))', 'tablemode#spreadsheet#CountNE("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'PercentE(.*)'
    let expr = substitute(expr, 'PercentE(\([^)]*\))', 'tablemode#spreadsheet#PercentE("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'PercentNE(.*)'
    let expr = substitute(expr, 'PercentNE(\([^)]*\))', 'tablemode#spreadsheet#PercentNE("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'Sum(.*)'
    let expr = substitute(expr, 'Sum(\([^)]*\))', 'tablemode#spreadsheet#Sum("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'Average(.*)'
    let expr = substitute(expr, 'Average(\([^)]*\))', 'tablemode#spreadsheet#Average("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# 'AverageNE(.*)'
    let expr = substitute(expr, 'AverageNE(\([^)]*\))', 'tablemode#spreadsheet#AverageNE("\1",'.line.','.colm.')', 'g')
  endif

  if expr =~# '\$\-\?\d\+,\-\?\d\+'
    let expr = substitute(expr, '\$\(\-\?\d\+\),\(\-\?\d\+\)',
          \ '\=str2float(tablemode#spreadsheet#cell#GetCells(line, submatch(1), submatch(2)))', 'g')
  endif

  if cell =~# ','
    if expr =~# '\$'
      let expr = substitute(expr, '\$\(\d\+\)',
          \ '\=str2float(tablemode#spreadsheet#cell#GetCells(line, row, submatch(1)))', 'g')
    endif
    call tablemode#spreadsheet#cell#SetCell(eval(expr), line, row, colm)
  else
    let [row, line] = [1, tablemode#spreadsheet#GetFirstRow(line)]
    while tablemode#table#IsRow(line)
      let texpr = expr
      if expr =~# '\$'
        let texpr = substitute(texpr, '\$\(\d\+\)',
              \ '\=str2float(tablemode#spreadsheet#cell#GetCells(line, row, submatch(1)))', 'g')
      endif

      call tablemode#spreadsheet#cell#SetCell(eval(texpr), line, row, colm)
      let row += 1
      let line += 1
    endwhile
  endif
endfunction

function! tablemode#spreadsheet#formula#EvaluateFormulaLine() abort "{{{2
  let exprs = []
  let cstring = &commentstring
  let matchexpr = ''
  if len(cstring) > 0
    let cms = split(cstring, '%s')
    if len(cms) == 2
      let matchexpr = '^\s*' . escape(cms[0], '/*') . '\s*tmf: \zs.*\ze' . escape(cms[1], '/*') . '\s*$'
    else
      let matchexpr = '^\s*' . escape(cms[0], '/*') . '\s*tmf: \zs.*$'
    endif
  else
    let matchexpr = '^\s* tmf: \zs.*$'
  endif
  if tablemode#table#IsRow('.') " We're inside the table
    let line = tablemode#spreadsheet#GetLastRow('.')
    let fline = line + 1
    if s:IsHTMLComment(fline) | let fline += 1 | endif
    if tablemode#table#IsBorder(fline) | let fline += 1 | endif
    while s:IsFormulaLine(fline)
      let exprs += split(matchstr(getline(fline), matchexpr), ';')
      let fline += 1
    endwhile
  elseif s:IsFormulaLine('.')
    let fline = line('.')
    let line = line('.') - 1
    while s:IsFormulaLine(line) | let fline = line | let line -= 1 | endwhile
    if s:IsHTMLComment(line) | let line -= 1 | endif
    if tablemode#table#IsBorder(line) | let line -= 1 | endif
    if tablemode#table#IsRow(line)
      " let exprs = split(matchstr(getline('.'), matchexpr), ';')
      while s:IsFormulaLine(fline)
        let exprs += split(matchstr(getline(fline), matchexpr), ';')
        let fline += 1
      endwhile
    endif
  endif

  for expr in exprs
    call tablemode#spreadsheet#formula#EvaluateExpr(expr, line)
  endfor
endfunction
