let s:t_list = type([])
let s:t_func = type(function('tr'))

function! s:_vital_loaded(V) abort
  let s:String = a:V.import('Data.String')
endfunction

function! s:_vital_depends() abort
  return ['Data.String']
endfunction

function! s:new() abort
  let options = copy(s:options)
  let options._options = {}
  return options
endfunction


" Private --------------------------------------------------------------------
function! s:_filter(arglead, candidates) abort
  let pattern = '^' . s:String.escape_pattern(a:arglead)
  let candidates = copy(a:candidates)
  call filter(candidates, 'v:val =~# pattern')
  return candidates
endfunction

function! s:_complete_choice(arglead, cmdline, cursorpos, choices) abort
  let leading = matchstr(a:arglead, '\%(-[^-]\|--\S\+=\)')
  let candidates = map(
        \ copy(a:choices),
        \ 'leading . v:val'
        \)
  return s:_filter(a:arglead, candidates)
endfunction

function! s:_complete_callback(arglead, cmdline, cursorpos, callback) abort
  let m = matchlist(a:arglead, '\(-[^-]\|--\S\+=\)\(.*\)')
  let candidates = a:callback(m[2], a:cmdline, a:cursorpos)
  return map(
        \ copy(candidates),
        \ 'm[1] . v:val'
        \)
endfunction

function! s:_compare_options(lhs, rhs) abort
  let lhs = a:lhs.names[-1]
  let rhs = a:rhs.names[-1]
  return lhs ==# rhs ? 0 : (lhs < rhs ? -1 : 1)
endfunction


" Options --------------------------------------------------------------------
let s:options = {}

function! s:options.define(query, description, ...) abort
  let self._options[a:query] = extend(copy(s:option), {
        \ 'names': split(a:query, '|'),
        \ 'value': a:0 ? a:1 : v:null,
        \ 'description': a:description,
        \})
endfunction

function! s:options.help(...) abort
  let lwidth = max(map(keys(self._options), 'len(v:val)')) + 3
  let rwidth = get(a:000, 0, 80) - lwidth
  let text = ['options:']
  call map(
        \ sort(values(self._options), function('s:_compare_options')),
        \ 'extend(text, v:val.help(lwidth, rwidth))'
        \)
  redraw | echo join(text, "\n")
endfunction

function! s:options.complete(arglead, cmdline, cursorpos) abort
  let leading = matchstr(a:arglead, '^\%(-[^-]\|--\S\+=\)')
  let candidates = []
  for option in values(self._options)
    if index(option.names, leading) != -1
      return option.complete(a:arglead, a:cmdline, a:cursorpos)
    endif
    call extend(candidates, option.names)
  endfor
  return s:_filter(a:arglead, candidates)
endfunction


" Option ---------------------------------------------------------------------
let s:option = {}

function! s:option.help(lwidth, rwidth) abort
  let rhs = s:String.wrap(self.description, a:rwidth)
  let lhs = [s:String.pad_right(join(self.names), a:lwidth)]
  let lhs += repeat([repeat(' ', a:lwidth)], len(rhs) - 1)
  return map(range(len(lhs)), 'lhs[v:val] . rhs[v:val]')
endfunction

function! s:option.complete(arglead, cmdline, cursorpos) abort
  if type(self.value) == s:t_list
    return s:_complete_choice(a:arglead, a:cmdline, a:cursorpos, self.value)
  elseif type(self.value) == s:t_func
    return s:_complete_callback(a:arglead, a:cmdline, a:cursorpos, self.value)
  endif
  return []
endfunction
