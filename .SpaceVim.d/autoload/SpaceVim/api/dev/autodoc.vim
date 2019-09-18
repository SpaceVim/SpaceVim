let s:self = {}


let s:self.begin = ''
let s:self.end = ''
let s:self.content_func = ''
let s:self.autoformat = 0


function! s:self._find_position() abort
  let start = search(self.begin,'bwnc')
  let end = search(self.end,'bnwc')
  return sort([start, end], 'n')
endfunction


function! s:self.update(...) abort
  let [start, end] = self._find_position()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, call(self.content_func, a:000))
    if self.autoformat
      silent! Neoformat
    endif
  endif
endfunction








function! SpaceVim#api#dev#autodoc#get() abort
  return deepcopy(s:self)
endfunction
