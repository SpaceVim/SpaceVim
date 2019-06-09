"=============================================================================
" vim.vim --- vim api for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:self = {}
let s:CMP = SpaceVim#api#import('vim#compatible')

function! s:self.jumps() abort
  let result = []
  for jump in split(s:CMP.execute('jumps'), '\n')[1:]
    let list = split(jump)
    if len(list) < 4
      continue
    endif

    let [linenr, col, file_text] = [list[1], list[2]+1, join(list[3:])]
    let lines = getbufline(file_text, linenr)
    let path = file_text
    let bufnr = bufnr(file_text)
    if empty(lines)
      if stridx(join(split(getline(linenr))), file_text) == 0
        let lines = [file_text]
        let path = bufname('%')
        let bufnr = bufnr('%')
      elseif filereadable(path)
        let bufnr = 0
        let lines = ['buffer unloaded']
      else
        " Skip.
        continue
      endif
    endif

    if getbufvar(bufnr, '&filetype') ==# 'unite'
      " Skip unite buffer.
      continue
    endif

    call add(result, [linenr, col, file_text, path, bufnr, lines])
  endfor
  return result
endfunction

function! SpaceVim#api#vim#get() abort
  return deepcopy(s:self)
endfunction
