" Borrowed from Tabular
" Private Functions {{{1
" function! s:StripTrailingSpaces(string) - Remove all trailing spaces {{{2
" from a string.
function! s:StripTrailingSpaces(string)
  return matchstr(a:string, '^.\{-}\ze\s*$')
endfunction

function! s:Padding(string, length, where) "{{{3
  let gap_length = a:length - tablemode#utils#StrDisplayWidth(a:string)
  if a:where =~# 'l'
    return a:string . repeat(" ", gap_length)
  elseif a:where =~# 'r'
    return repeat(" ", gap_length) . a:string
  elseif a:where =~# 'c'
    let right = gap_length / 2
    let left = right + (right * 2 != gap_length)
    return repeat(" ", left) . a:string . repeat(" ", right)
  endif
endfunction

" Public Functions {{{1
" function! tablemode#align#Split() - Split a string into fields and delimiters {{{2
" Like split(), but include the delimiters as elements
" All odd numbered elements are delimiters
" All even numbered elements are non-delimiters (including zero)
function! tablemode#align#Split(string, delim)
  let rv = []
  let beg = 0

  let len = len(a:string)
  let searchoff = 0

  while 1
    let mid = match(a:string, a:delim, beg + searchoff, 1)
    if mid == -1 || mid == len
      break
    endif

    let matchstr = matchstr(a:string, a:delim, beg + searchoff, 1)
    let length = strlen(matchstr)

    if length == 0 && beg == mid
      " Zero-length match for a zero-length delimiter - advance past it
      let searchoff += 1
      continue
    endif

    if beg == mid
      let rv += [ "" ]
    else
      let rv += [ a:string[beg : mid-1] ]
    endif

    let rv += [ matchstr ]

    let beg = mid + length
    let searchoff = 0
  endwhile

  let rv += [ strpart(a:string, beg) ]

  return rv
endfunction

function! tablemode#align#alignments(lnum, ncols) "{{{2
  let achr = g:table_mode_align_char
  let alignments = []
  if tablemode#table#IsBorder(a:lnum+1)
    let corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner')
    let corner_corner = tablemode#utils#get_buffer_or_global_option('table_mode_corner_corner')
    let hcols = tablemode#align#Split(getline(a:lnum+1), '[' . corner . corner_corner . ']')
    for idx in range(len(hcols))
      " Right align if header
      call add(alignments, 'l')
      if hcols[idx] =~# achr . '[^'.achr.']\+' . achr
        let alignments[idx] = 'c'
      elseif hcols[idx] =~# achr . '$'
        let alignments[idx] = 'r'
      endif
      " if hcols[idx] !~# '[^0-9\.]' | let alignments[idx] = 'r' | endif
    endfor
  end
  return alignments
endfunction

function! tablemode#align#Align(lines) "{{{2
  if empty(a:lines) | return [] | endif
  let lines = map(a:lines, 'map(v:val, "v:key =~# \"text\" ? tablemode#align#Split(v:val, g:table_mode_escaped_separator_regex) : v:val")')

  for line in lines
    let stext = line.text
    if len(stext) <= 1 | continue | endif

    if stext[0] !~ tablemode#table#StartExpr()
      let stext[0] = s:StripTrailingSpaces(stext[0])
    endif
    if len(stext) >= 2
      for i in range(1, len(stext)-1)
        let stext[i] = tablemode#utils#strip(stext[i])
      endfor
    endif
  endfor

  let maxes = []
  for line in lines
    let stext = line.text
    if len(stext) <= 1 | continue | endif
    for i in range(len(stext))
      if i == len(maxes)
        let maxes += [ tablemode#utils#StrDisplayWidth(stext[i]) ]
      else
        let maxes[i] = max([ maxes[i], tablemode#utils#StrDisplayWidth(stext[i]) ])
      endif
    endfor
  endfor

  let alignments = tablemode#align#alignments(lines[0].lnum, len(lines[0].text))

  for idx in range(len(lines))
    let tlnum = lines[idx].lnum
    let tline = lines[idx].text

    if len(tline) <= 1 | continue | endif
    for jdx in range(len(tline))
      " Dealing with the header being the first line
      if jdx >= len(alignments) | call add(alignments, 'l') | endif
      let field = s:Padding(tline[jdx], maxes[jdx], alignments[jdx])
      let tline[jdx] = field . (jdx == 0 || jdx == len(tline) ? '' : ' ')
    endfor

    let lines[idx].text = s:StripTrailingSpaces(join(tline, ''))
  endfor

  return lines
endfunction
