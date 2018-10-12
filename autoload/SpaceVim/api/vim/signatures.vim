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
let s:self._cmp = SpaceVim#api#import('vim#compatible')

let s:self.hi_info_group = 'Comment'
let s:self.hi_warn_group = 'WarningMsg'
let s:self.hi_error_group = 'ErrorMsg'


if exists('*nvim_buf_set_virtual_text')
  function! s:self.info(line, col, message)  abort
    call nvim_buf_set_virtual_text(0, bufnr('%'), a:line, [[a:message, self.hi_info_group],], {})
  endfunction
  function! s:self.warn(line, col, message)  abort
    call nvim_buf_set_virtual_text(0, bufnr('%'), a:line, [[a:message, self.hi_warn_group],], {})
  endfunction
  function! s:self.error(line, col, message)  abort
    call nvim_buf_set_virtual_text(0, bufnr('%'), a:line, [[a:message, self.hi_error_group],], {})
  endfunction
else

  function! s:self.info(line, col, message)  abort
    let chars = self._STRING.string2chars(self._STRING.strQ2B(a:message))
    let chars = [' '] + chars
    for index in range(len(chars))
      call add(self.id, self._cmp.matchaddpos('Conceal', [[a:line, a:col - 1 + index, 1]], 10, -1, {'conceal' : chars[index]}))
    endfor
  endfunction

endif

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


function! SpaceVim#api#vim#signatures#get() abort

  return deepcopy(s:self)

endfunction
