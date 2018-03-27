"=============================================================================
" signatures.vim --- SpaceVim signatures API
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
let s:self = {}
let s:self.id = []
let s:self._STRING = SpaceVim#api#import('data#string')
function! s:self.info(line, col, message)  abort
  let chars = self._STRING.string2chars(self._STRING.strQ2B(a:message))
  let chars = [' '] + chars
  for index in range(len(chars))
    call add(self.id, matchaddpos('Conceal', [[a:line, a:col - 1 + index, 1]], 10, -1, {'conceal' : chars[index]}))
  endfor
endfunction


function! s:self.set_group(group) abort
  let self.group = a:group
  exe 'highlight ' . self.group . ' ctermbg=green guibg=green'
endfunction

call s:self.set_group('SpaceVim_signatures')

function! s:self.clear() abort
  for id in self.id
    call matchdelete(id)
  endfor
  let self.id = []
endfunction


function! SpaceVim#api#vim#signatures#get()

  return deepcopy(s:self)

endfunction
