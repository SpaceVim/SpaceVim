" TODO: create   T   title text-object
" TODO: make section jumps [[ ]] etc work

let s:atx_title = '\_^=*\s\+\(\S\%(.\%(\s\+=\+\s*\_$\)\@!\)*.\)\(\s\+=\+\)\?\s*$'
let s:setext_title_underline = '[-=~^+]\+\s*$'
let s:setext_title = '\_^\(\S.\+\)\s*\n' . s:setext_title_underline
let s:setext_levels = ['=','-', '~', '^', '+']

function! asciidoc#find_prior_section_title()
  let old_pos = getpos('.')
  let pos = old_pos
  let pos[2] = 0
  call setpos('.', pos)
  let prior_atx = search(s:atx_title, 'Wbn')
  let prior_setext = search(s:setext_title, 'Wbn')
  call setpos('.', old_pos)
  let prior = max([prior_atx, prior_setext])
  if prior == 0
    return
  endif
  return prior . 'G'
endfunction

function! asciidoc#find_next_section_title()
  let next_atx = search(s:atx_title, 'Wn')
  let next_setext = search(s:setext_title, 'Wn')
  let next = min(filter([next_atx, next_setext], 'v:val != 0'))
  if next == 0
    return
  endif
  return next . 'G'
endfunction

function! asciidoc#get_atx_section_title(line_number)
  let line = getline(a:line_number)
  let match = matchlist(line, s:atx_title)
  if !empty(match)
    let title = match[1]
    let symmetric = len(match[2]) != 0
    let level = len(matchstr(line, '^=*'))
    return {'line' : a:line_number, 'type' : 'atx', 'symmetric' : symmetric, 'level' : level, 'title' : title}
  else
    return {}
  endif
endfunction

function! asciidoc#get_setext_section_title(line_number)
  let line = getline(a:line_number)
  if line =~ '^' . s:setext_title_underline
    let underline = line
    let line_number = a:line_number - 1
    let line = getline(line_number)
  else
    let line_number = a:line_number
    let underline = getline(line_number + 1)
  endif
  let level = 1 + index(s:setext_levels, underline[0])
  if (line . "\n" . underline) =~ s:setext_title
    return {'line' : line_number, 'type' : 'setext', 'level' : level, 'title' : line}
  else
    return {}
  endif
endfunction

function! asciidoc#get_section_title(line_number)
  let atx = asciidoc#get_atx_section_title(a:line_number)
  if !empty(atx)
    return atx
  else
    return asciidoc#get_setext_section_title(a:line_number)
  endif
endfunction

function! asciidoc#set_atx_section_title(line_number, level, title, symmetric)
  let level_marks = repeat('=', a:level)
  call setline(a:line_number, level_marks . ' ' . a:title . (a:symmetric ? (' ' . level_marks) : ''))
endfunction

function! asciidoc#set_setext_section_title(line_number, level, title)
  let line_number = a:line_number + 1
  let level_marks = repeat(s:setext_levels[a:level - 1], len(a:title))
  if getline(line_number) =~ '^$'
    call append(line_number - 1, level_marks)
  else
    call setline(line_number, level_marks)
  endif
endfunction

function! asciidoc#set_section_title_level(level)
  let line = line('.')
  let section_title = asciidoc#get_section_title(line)
  if !empty(section_title)
    if section_title.type == 'atx'
      call asciidoc#set_atx_section_title(section_title.line, a:level, section_title.title, section_title.symmetric)
    else
      call asciidoc#set_setext_section_title(section_title.line, a:level, section_title.title)
    endif
  else
    let title = getline('.')
    if g:asciidoc_title_style == 'atx'
      call asciidoc#set_atx_section_title(line, a:level, title, g:asciidoc_title_style_atx != 'asymmetric')
    else
      call asciidoc#set_setext_section_title(line, a:level, title)
    endif
  endif
endfunction

function! asciidoc#make_list(type) range
  let old_search = @/
  exe a:firstline . ',' . a:lastline . 's/^\s*\([*.]*\)\s*/\=repeat("' . a:type . '", max([1, len(submatch(1))]))." "/'
  let @/ = old_search
endfunction

function! asciidoc#dent_list(in_out) range
  let old_search = @/
  if a:in_out == 'in'
    silent! exe a:firstline . ',' . a:lastline . 's/^[*.]//'
  else
    silent! exe a:firstline . ',' . a:lastline . 's/^\([*.]\)/&&/'
  endif
  let @/ = old_search
endfunction
