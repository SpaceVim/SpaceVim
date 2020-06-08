" Private Functions {{{1
function! s:blank(string) "{{{2
  return a:string =~# '^\s*$'
endfunction

function! s:BorderExpr() "{{{2
  let corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner')
  let corner_corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner_corner')
  let header_fillchar = tablemode#utils#get_buffer_or_global_option('table_mode_header_fillchar')
  return tablemode#table#StartExpr() .
        \ '[' . corner . corner_corner . ']' .
        \ '[' . escape(g:table_mode_fillchar . header_fillchar . corner . g:table_mode_align_char, '-') . ']\+' .
        \ '[' . corner . corner_corner . ']' .
        \ tablemode#table#EndExpr()
endfunction

function! s:DefaultBorder() "{{{2
  if tablemode#IsActive()
    let corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner')
    let corner_corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner_corner')
    return corner_corner . g:table_mode_fillchar . corner . g:table_mode_fillchar . corner_corner
  else
    return ''
  endif
endfunction

function! s:GenerateHeaderBorder(line) "{{{2
  let line = tablemode#utils#line(a:line)
  if tablemode#table#IsRow(line - 1) || tablemode#table#IsRow(line + 1)
    let line_val = ''
    if tablemode#table#IsRow(line + 1)
      let line_val = getline(line + 1)
    endif
    if tablemode#table#IsRow(line - 1) && tablemode#utils#strlen(line_val) < tablemode#utils#strlen(getline(line - 1))
      let line_val = getline(line - 1)
    endif
    if tablemode#utils#strlen(line_val) <= 1 | return s:DefaultBorder() | endif

    let corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner')
    let corner_corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner_corner')
    let header_fillchar = tablemode#utils#get_buffer_or_global_option('table_mode_header_fillchar')

    let tline = line_val[stridx(line_val, g:table_mode_separator):strridx(line_val, g:table_mode_separator)]
    let fillchar = tablemode#table#IsHeader(line - 1) ? header_fillchar : g:table_mode_fillchar

    let special_replacement = '___'
    let border = substitute(tline, g:table_mode_escaped_separator_regex, special_replacement, 'g')
    let seperator_match_regex = special_replacement . '\zs\(.\{-}\)\ze' . special_replacement
    let border = substitute(border, seperator_match_regex, '\=repeat(fillchar, tablemode#utils#StrDisplayWidth(submatch(0)))', 'g')
    let border = substitute(border, special_replacement, g:table_mode_separator, 'g')
    let border = substitute(border, g:table_mode_separator, corner, 'g')
    let border = substitute(border, '^' . corner . '\(.*\)' . corner . '$', corner_corner . '\1' . corner_corner, '')

    " Incorporate header alignment chars
    if getline(line) =~# g:table_mode_align_char
      let pat = '[' . corner_corner . corner . ']'
      let hcols = tablemode#align#Split(getline(line), pat)
      let gcols = tablemode#align#Split(border, pat)

      for idx in range(len(hcols))
        if hcols[idx] =~# g:table_mode_align_char
          " center align
          if hcols[idx] =~# g:table_mode_align_char . '[^'.g:table_mode_align_char.']\+' . g:table_mode_align_char
            let gcols[idx] = g:table_mode_align_char . gcols[idx][1:-2] . g:table_mode_align_char
          elseif hcols[idx] =~# g:table_mode_align_char . '$'
            let gcols[idx] = gcols[idx][:-2] . g:table_mode_align_char
          else
            let gcols[idx] = g:table_mode_align_char . gcols[idx][1:]
          endif
        endif
      endfor
      let border = join(gcols, '')
    endif

    let cstartexpr = tablemode#table#StartCommentExpr()
    if tablemode#utils#strlen(cstartexpr) > 0 && getline(line) =~# cstartexpr
      let sce = matchstr(line_val, tablemode#table#StartCommentExpr())
      let ece = matchstr(line_val, tablemode#table#EndCommentExpr())
      return sce . border . ece
    elseif getline(line) =~# tablemode#table#StartExpr()
      let indent = matchstr(line_val, tablemode#table#StartExpr())
      return indent . border
    else
      return border
    endif
  else
    return s:DefaultBorder()
  endif
endfunction

" Public Functions {{{1
function! tablemode#table#GetCommentStart() "{{{2
  let cstring = &commentstring
  if tablemode#utils#strlen(cstring) > 0
    return substitute(split(cstring, '%s')[0], '[^(%)]', '\\\0', 'g')
  else
    return ''
  endif
endfunction

function! tablemode#table#StartCommentExpr() "{{{2
  let cstartexpr = tablemode#table#GetCommentStart()
  if tablemode#utils#strlen(cstartexpr) > 0
    return '^\s*' . cstartexpr . '\s*'
  else
    return ''
  endif
endfunction

function! tablemode#table#GetCommentEnd() "{{{2
  let cstring = &commentstring
  if tablemode#utils#strlen(cstring) > 0
    let cst = split(cstring, '%s')
    if len(cst) == 2
      return substitute(cst[1], '[^()]', '\\\0', 'g')
    else
      return ''
    endif
  else
    return ''
  endif
endfunction

function! tablemode#table#EndCommentExpr() "{{{2
  let cendexpr = tablemode#table#GetCommentEnd()
  if tablemode#utils#strlen(cendexpr) > 0
    return '.*\zs\s\+' . cendexpr . '\s*$'
  else
    return ''
  endif
endfunction

function! tablemode#table#StartExpr() "{{{2
  let cstart = tablemode#table#GetCommentStart()
  if tablemode#utils#strlen(cstart) > 0
    return '^\s*\(' . cstart . '\)\?\s*'
  else
    return '^\s*'
  endif
endfunction

function! tablemode#table#EndExpr() "{{{2
  let cend = tablemode#table#GetCommentEnd()
  if tablemode#utils#strlen(cend) > 0
    return '\s*\(\s\+' . cend . '\)\?\s*$'
  else
    return '\s*$'
  endif
endfunction

function! tablemode#table#IsBorder(line) "{{{2
  return !s:blank(getline(a:line)) && getline(a:line) =~# s:BorderExpr()
endfunction

function! tablemode#table#IsHeader(line) "{{{2
  let line = tablemode#utils#line(a:line)
  " if line <= 0 || line > line('$') | return 0 | endif
  return tablemode#table#IsRow(line)
        \ && !tablemode#table#IsRow(line-1)
        \ && !tablemode#table#IsRow(line-2)
        \ && !tablemode#table#IsBorder(line-2)
        \ && tablemode#table#IsBorder(line+1)
endfunction

function! tablemode#table#IsRow(line) "{{{2
  return !tablemode#table#IsBorder(a:line) && getline(a:line) =~# (tablemode#table#StartExpr() . g:table_mode_separator) . '[^' . g:table_mode_separator . ']\+'
endfunction

function! tablemode#table#IsTable(line) "{{{2
  return tablemode#table#IsRow(a:line) || tablemode#table#IsBorder(a:line)
endfunction

function! tablemode#table#AddBorder(line) "{{{2
  call setline(a:line, s:GenerateHeaderBorder(a:line))
endfunction

function! tablemode#table#Realign(line) "{{{2
  let current_fm = &foldmethod " save foldmethod to be restored
  setlocal foldmethod=manual " manual foldmethod while table is being aligned

  let line = tablemode#utils#line(a:line)

  let lines = []
  let [lnum, blines] = [line, []]
  while tablemode#table#IsTable(lnum)
    if tablemode#table#IsBorder(lnum)
      call insert(blines, lnum)
      let lnum -= 1
      continue
    endif
    call insert(lines, {'lnum': lnum, 'text': getline(lnum)})
    let lnum -= 1
  endwhile

  let lnum = line + 1
  while tablemode#table#IsTable(lnum)
    if tablemode#table#IsBorder(lnum)
      call add(blines, lnum)
      let lnum += 1
      continue
    endif
    call add(lines, {'lnum': lnum, 'text': getline(lnum)})
    let lnum += 1
  endwhile

  let lines = tablemode#align#Align(lines)

  for aline in lines
    call setline(aline.lnum, aline.text)
  endfor

  for bline in blines
    call tablemode#table#AddBorder(bline)
  endfor

  " restore foldmethod
  execute "setlocal foldmethod=" . current_fm
endfunction
