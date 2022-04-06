"=============================================================================
" key.vim --- SpaceVim key API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

let s:specified_keys = {
            \ "\<F1>" : 'F1',
            \ "\<F2>" : 'F2',
            \ "\<Space>" : 'SPC',
            \ "\x80\xfc\<C-b>\<C-d>" : '<C-S-d>',
            \ }

function! s:self.nr2name(nr) abort
    if type(a:nr) == 0
        if a:nr == 32
            return 'SPC'
        elseif a:nr == 4
            return '<C-d>'
        elseif a:nr == 3
            return '<C-c>'
        elseif a:nr == 9
            return '<Tab>'
        elseif a:nr == 92
            return '<Leader>'
        elseif a:nr == 27
            return '<Esc>'
        else
            return nr2char(a:nr)
        endif
    else
        return get(s:specified_keys, a:nr, '')
    endif
endfunction

function! s:self.char2name(char) abort
  if len(a:char) == 1
    return self.nr2name(char2nr(a:char))
  endif
  return get(s:specified_keys, a:char, a:char)
endfunction


function! SpaceVim#api#vim#key#get() abort
    return deepcopy(s:self)
endfunction
