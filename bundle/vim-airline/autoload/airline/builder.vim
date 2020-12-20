" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

function! s:prototype.split(...) dict
  call add(self._sections, ['|', a:0 ? a:1 : '%='])
endfunction

function! s:prototype.add_section_spaced(group, contents) dict
  let spc = empty(a:contents) ? '' : g:airline_symbols.space
  call self.add_section(a:group, spc.a:contents.spc)
endfunction

function! s:prototype.add_section(group, contents) dict
  call add(self._sections, [a:group, a:contents])
endfunction

function! s:prototype.add_raw(text) dict
  call add(self._sections, ['', a:text])
endfunction

function! s:prototype.insert_section(group, contents, position) dict
  call insert(self._sections, [a:group, a:contents], a:position)
endfunction

function! s:prototype.insert_raw(text, position) dict
  call insert(self._sections, ['', a:text], a:position)
endfunction

function! s:prototype.get_position() dict
  return len(self._sections)
endfunction

function! airline#builder#get_prev_group(sections, i)
  let x = a:i - 1
  while x >= 0
    let group = a:sections[x][0]
    if group != '' && group != '|'
      return group
    endif
    let x = x - 1
  endwhile
  return ''
endfunction

function! airline#builder#get_next_group(sections, i)
  let x = a:i + 1
  let l = len(a:sections)
  while x < l
    let group = a:sections[x][0]
    if group != '' && group != '|'
      return group
    endif
    let x = x + 1
  endwhile
  return ''
endfunction

function! s:prototype.build() dict
  let side = 1
  let line = ''
  let i = 0
  let length = len(self._sections)
  let split = 0
  let is_empty = 0
  let prev_group = ''

  while i < length
    let section = self._sections[i]
    let group = section[0]
    let contents = section[1]
    let pgroup = prev_group
    let prev_group = airline#builder#get_prev_group(self._sections, i)
    if group ==# 'airline_c' && &buftype ==# 'terminal' && self._context.active
      let group = 'airline_term'
    elseif group ==# 'airline_c' && !self._context.active && has_key(self._context, 'bufnr')
      let group = 'airline_c'. self._context.bufnr
    elseif prev_group ==# 'airline_c' && !self._context.active && has_key(self._context, 'bufnr')
      let prev_group = 'airline_c'. self._context.bufnr
    endif
    if is_empty
      let prev_group = pgroup
    endif
    let is_empty = s:section_is_empty(self, contents)

    if is_empty
      " need to fix highlighting groups, since we
      " have skipped a section, we actually need
      " the previous previous group and so the
      " seperator goes from the previous previous group
      " to the current group
      let pgroup = group
    endif

    if group == ''
      let line .= contents
    elseif group == '|'
      let side = 0
      let line .= contents
      let split = 1
    else
      if prev_group == ''
        let line .= '%#'.group.'#'
      elseif split
        if !is_empty
          let line .= s:get_transitioned_seperator(self, prev_group, group, side)
        endif
        let split = 0
      else
        if !is_empty
          let line .= s:get_seperator(self, prev_group, group, side)
        endif
      endif
      let line .= is_empty ? '' : s:get_accented_line(self, group, contents)
    endif

    let i = i + 1
  endwhile

  if !self._context.active
    "let line = substitute(line, '%#airline_c#', '%#airline_c'.self._context.bufnr.'#', '')
    let line = substitute(line, '%#.\{-}\ze#', '\0_inactive', 'g')
  endif
  return line
endfunction

function! airline#builder#should_change_group(group1, group2)
  if a:group1 == a:group2
    return 0
  endif
  let color1 = airline#highlighter#get_highlight(a:group1)
  let color2 = airline#highlighter#get_highlight(a:group2)
  if g:airline_gui_mode ==# 'gui'
    return color1[1] != color2[1] || color1[0] != color2[0]
  else
    return color1[3] != color2[3] || color1[2] != color2[2]
  endif
endfunction

function! s:get_transitioned_seperator(self, prev_group, group, side)
  let line = ''
  if get(a:self._context, 'tabline', 0) && get(g:, 'airline#extensions#tabline#alt_sep', 0) && a:group ==# 'airline_tabsel' && a:side
    call airline#highlighter#add_separator(a:prev_group, a:group, 0)
    let line .= '%#'.a:prev_group.'_to_'.a:group.'#'
    let line .=  a:self._context.right_sep.'%#'.a:group.'#'
  else
    call airline#highlighter#add_separator(a:prev_group, a:group, a:side)
    let line .= '%#'.a:prev_group.'_to_'.a:group.'#'
    let line .= a:side ? a:self._context.left_sep : a:self._context.right_sep
    let line .= '%#'.a:group.'#'
  endif
  return line
endfunction

function! s:get_seperator(self, prev_group, group, side)
  if airline#builder#should_change_group(a:prev_group, a:group)
    return s:get_transitioned_seperator(a:self, a:prev_group, a:group, a:side)
  else
    return a:side ? a:self._context.left_alt_sep : a:self._context.right_alt_sep
  endif
endfunction

function! s:get_accented_line(self, group, contents)
  if a:self._context.active
    " active window
    let contents = []
    let content_parts = split(a:contents, '__accent')
    for cpart in content_parts
      let accent = matchstr(cpart, '_\zs[^#]*\ze')
      call add(contents, cpart)
    endfor
    let line = join(contents, a:group)
    let line = substitute(line, '__restore__', a:group, 'g')
  else
    " inactive window
    let line = substitute(a:contents, '%#__accent[^#]*#', '', 'g')
    let line = substitute(line, '%#__restore__#', '', 'g')
  endif
  return line
endfunction

function! s:section_is_empty(self, content)
  let start=1

  " do not check for inactive windows or the tabline
  if a:self._context.active == 0
    return 0
  elseif get(a:self._context, 'tabline', 0)
    return 0
  endif

  " only check, if airline#skip_empty_sections == 1
  if get(g:, 'airline_skip_empty_sections', 0) == 0
    return 0
  endif

  " only check, if airline#skip_empty_sections == 1
  if get(w:, 'airline_skip_empty_sections', -1) == 0
    return 0
  endif
  " assume accents sections to be never empty
  " (avoides, that on startup the mode message becomes empty)
  if match(a:content, '%#__accent_[^#]*#.*__restore__#') > -1
    return 0
  endif
  if empty(a:content)
    return 1
  endif
  let list=matchlist(a:content, '%{\zs.\{-}\ze}', 1, start)
  if empty(list)
    return 0 " no function in statusline text
  endif
  while len(list) > 0
    let expr = list[0]
    try
      " catch all exceptions, just in case
      if !empty(eval(expr))
        return 0
      endif
    catch
      return 0
    endtry
    let start += 1
    let list=matchlist(a:content, '%{\zs.\{-}\ze}', 1, start)
  endw
  return 1
endfunction

function! airline#builder#new(context)
  let builder = copy(s:prototype)
  let builder._context = a:context
  let builder._sections = []

  call extend(builder._context, {
        \ 'left_sep': g:airline_left_sep,
        \ 'left_alt_sep': g:airline_left_alt_sep,
        \ 'right_sep': g:airline_right_sep,
        \ 'right_alt_sep': g:airline_right_alt_sep,
        \ }, 'keep')
  return builder
endfunction
