" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

" Set the point in the tabline where the builder should insert the titles.
"
" Subsequent calls will overwrite the previous ones, so only the last call
" determines to location to insert titles.
"
" NOTE: The titles are not inserted until |build| is called, so that the
" remaining contents of the tabline can be taken into account.
"
" Callers should define at least |get_title| and |get_group| on the host
" object before calling |build|.
function! s:prototype.insert_titles(current, first, last) dict
  let self._first_title = a:first " lowest index
  let self._last_title = a:last " highest index
  let self._left_title = a:current " next index to add on the left
  let self._right_title = a:current + 1 " next index to add on the right
  let self._left_position = self.get_position() " left end of titles
  let self._right_position = self._left_position " right end of the titles
endfunction

" Insert a title for entry number |index|, of group |group| at position |pos|,
" if there is space for it. Returns 1 if it is inserted, 0 otherwise
"
" |force| inserts the title even if there isn't enough space left for it.
" |sep_size| adjusts the size change that the title is considered to take up,
"            to account for changes to the separators
"
" The title is defined by |get_title| on the hosting object, called with
" |index| as its only argument.
" |get_pretitle| and |get_posttitle| may be defined on the host object to
" insert some formatting before or after the title. These should be 0-width.
"
" This method updates |_right_position| and |_remaining_space| on the host
" object, if the title is inserted.
function! s:prototype.try_insert_title(index, group, pos, sep_size, force) dict
  let title = self.get_title(a:index)
  let title_size = s:tabline_evaluated_length(title) + a:sep_size
  if a:force || self._remaining_space >= title_size
    let pos = a:pos
    if has_key(self, "get_pretitle")
      call self.insert_raw(self.get_pretitle(a:index), pos)
      let self._right_position += 1
      let pos += 1
    endif

    call self.insert_section(a:group, title, pos)
    let self._right_position += 1
    let pos += 1

    if has_key(self, "get_posttitle")
      call self.insert_raw(self.get_posttitle(a:index), pos)
      let self._right_position += 1
      let pos += 1
    endif

    let self._remaining_space -= title_size
    return 1
  endif
  return 0
endfunction

function! s:get_separator_change(new_group, old_group, end_group, sep_size, alt_sep_size)
  return s:get_separator_change_with_end(a:new_group, a:old_group, a:end_group, a:end_group, a:sep_size, a:alt_sep_size)
endfunction

" Compute the change in size of the tabline caused by separators
"
" This should be kept up-to-date with |s:get_transitioned_seperator| and
" |s:get_separator| in autoload/airline/builder.vim
function! s:get_separator_change_with_end(new_group, old_group, new_end_group, old_end_group, sep_size, alt_sep_size)
  let sep_change = 0
  if !empty(a:new_end_group) " Separator between title and the end
    let sep_change += airline#builder#should_change_group(a:new_group, a:new_end_group) ? a:sep_size : a:alt_sep_size
  endif
  if !empty(a:old_group) " Separator between the title and the one adjacent
    let sep_change += airline#builder#should_change_group(a:new_group, a:old_group) ? a:sep_size : a:alt_sep_size
    if !empty(a:old_end_group) " Remove mis-predicted separator
      let sep_change -= airline#builder#should_change_group(a:old_group, a:old_end_group) ? a:sep_size : a:alt_sep_size
    endif
  endif
  return sep_change
endfunction

" This replaces the build function of the |airline#builder#new| object, to
" insert titles as specified by the last call to |insert_titles| before
" passing to the original build function.
"
" Callers should define at least |get_title| and |get_group| on the host
" object if |insert_titles| has been called on it.
function! s:prototype.build() dict
  if has_key(self, '_left_position') && self._first_title <= self._last_title
    let self._remaining_space = &columns - s:tabline_evaluated_length(self._build())

    let center_active = get(g:, 'airline#extensions#tabline#center_active', 0)

    let sep_size = s:tabline_evaluated_length(self._context.left_sep)
    let alt_sep_size = s:tabline_evaluated_length(self._context.left_alt_sep)

    let outer_left_group = airline#builder#get_prev_group(self._sections, self._left_position)
    let outer_right_group = airline#builder#get_next_group(self._sections, self._right_position)

    let overflow_marker = get(g:, 'airline#extensions#tabline#overflow_marker', g:airline_symbols.ellipsis)
    let overflow_marker_size = s:tabline_evaluated_length(overflow_marker)
    " Allow space for the markers before we begin filling in titles.
    if self._left_title > self._first_title
      let self._remaining_space -= overflow_marker_size +
        \ s:get_separator_change(self.overflow_group, "", outer_left_group, sep_size, alt_sep_size)
    endif
    if self._left_title < self._last_title
      let self._remaining_space -= overflow_marker_size +
        \ s:get_separator_change(self.overflow_group, "", outer_right_group, sep_size, alt_sep_size)
    endif

    " Add the current title
    let group = self.get_group(self._left_title)
    if self._left_title == self._first_title
      let sep_change = s:get_separator_change(group, "", outer_left_group, sep_size, alt_sep_size)
    else
      let sep_change = s:get_separator_change(group, "", self.overflow_group, sep_size, alt_sep_size)
    endif
    if self._left_title == self._last_title
      let sep_change += s:get_separator_change(group, "", outer_right_group, sep_size, alt_sep_size)
    else
      let sep_change += s:get_separator_change(group, "", self.overflow_group, sep_size, alt_sep_size)
    endif
    let left_group = group
    let right_group = group
    let self._left_title -=
      \ self.try_insert_title(self._left_title, group, self._left_position, sep_change, 1)

    if get(g:, 'airline#extensions#tabline#current_first', 0)
      " always have current title first
      let self._left_position += 1
    endif

    if !center_active && self._right_title <= self._last_title
      " Add the title to the right
      let group = self.get_group(self._right_title)
      if self._right_title == self._last_title
        let sep_change = s:get_separator_change_with_end(group, right_group, outer_right_group, self.overflow_group, sep_size, alt_sep_size) - overflow_marker_size
      else
        let sep_change = s:get_separator_change(group, right_group, self.overflow_group, sep_size, alt_sep_size)
      endif
      let right_group = group
      let self._right_title +=
      \ self.try_insert_title(self._right_title, group, self._right_position, sep_change, 1)
    endif

    while self._remaining_space > 0
      let done = 0
      if self._left_title >= self._first_title
        " Insert next title to the left
        let group = self.get_group(self._left_title)
        if self._left_title == self._first_title
          let sep_change = s:get_separator_change_with_end(group, left_group, outer_left_group, self.overflow_group, sep_size, alt_sep_size) - overflow_marker_size
        else
          let sep_change = s:get_separator_change(group, left_group, self.overflow_group, sep_size, alt_sep_size)
        endif
        let left_group = group
        let done = self.try_insert_title(self._left_title, group, self._left_position, sep_change, 0)
        let self._left_title -= done
      endif
      " If center_active is set, this |if| operates as an independent |if|,
      " otherwise as an |elif|.
      if self._right_title <= self._last_title && (center_active || !done)
        " Insert next title to the right
        let group = self.get_group(self._right_title)
        if self._right_title == self._last_title
          let sep_change = s:get_separator_change_with_end(group, right_group, outer_right_group, self.overflow_group, sep_size, alt_sep_size) - overflow_marker_size
        else
          let sep_change = s:get_separator_change(group, right_group, self.overflow_group, sep_size, alt_sep_size)
        endif
        let right_group = group
        let done = self.try_insert_title(self._right_title, group, self._right_position, sep_change, 0)
        let self._right_title += done
      endif
      if !done
        break
      endif
    endwhile

    if self._left_title >= self._first_title
      if get(g:, 'airline#extensions#tabline#current_first', 0)
        let self._left_position -= 1
      endif
      call self.insert_section(self.overflow_group, overflow_marker, self._left_position)
      let self._right_position += 1
    endif

    if self._right_title <= self._last_title
      call self.insert_section(self.overflow_group, overflow_marker, self._right_position)
    endif
  endif

  return self._build()
endfunction

let s:prototype.overflow_group = 'airline_tab'

" Extract the text content a tabline will render. (Incomplete).
"
" See :help 'statusline' for the list of fields.
function! s:evaluate_tabline(tabline)
  let tabline = a:tabline
  let tabline = substitute(tabline, '%{\([^}]\+\)}', '\=eval(submatch(1))', 'g')
  let tabline = substitute(tabline, '%#[^#]\+#', '', 'g')
  let tabline = substitute(tabline, '%(\([^)]\+\)%)', '\1', 'g')
  let tabline = substitute(tabline, '%\d\+[TX]', '', 'g')
  let tabline = substitute(tabline, '%=', '', 'g')
  let tabline = substitute(tabline, '%\d*\*', '', 'g')
  if has('tablineat')
    let tabline = substitute(tabline, '%@[^@]\+@', '', 'g')
  endif
  return tabline
endfunction

function! s:tabline_evaluated_length(tabline)
  return airline#util#strchars(s:evaluate_tabline(a:tabline))
endfunction

function! airline#extensions#tabline#builder#new(context)
  let builder = airline#builder#new(a:context)
  let builder._build = builder.build
  call extend(builder, s:prototype, 'force')
  return builder
endfunction
