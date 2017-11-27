let s:self = {}

function! s:self.info(line, col, message)  abort
  let self.id = matchaddpos(self.group, [[a:line - 1, a:col - 1, len(a:message)]], 10, -1, {'conceal' : a:message})
endfunction


function! s:self.set_group(group) abort
  let self.group = a:group
  exe 'highlight ' . self.group . ' ctermbg=green guibg=green'
endfunction

call s:self.set_group('SpaceVim_signatures')

function! s:self.clear() abort
  call matchdelete(self.id)
endfunction


function! SpaceVim#api#vim#signatures#get()

  return deepcopy(s:self)

endfunction
