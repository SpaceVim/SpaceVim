"=============================================================================
" help.vim --- help plugin for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:KEY = SpaceVim#api#import('vim#key')
let s:TABs = SpaceVim#api#import('vim#tab')
let s:key_describ = {}

function! SpaceVim#plugins#help#describe_bindings() abort
endfunction

function! SpaceVim#plugins#help#regist_root(dict) abort
  let keys = keys(a:dict)
  if type(a:dict) == 4 && len(keys) == 1
    call extend(s:key_describ, a:dict)
  endif
endfunction


function! SpaceVim#plugins#help#describe_key() abort
  let defined = 1
  let root = s:key_describ
  let prompt = 'Describe key:'
  let keys = []
  call s:build_mpt(prompt)
  let key = getchar()
  let char = s:KEY.nr2name(key)
  if index(keys(g:_spacevim_mappings_prefixs), char) != -1
    let name = SpaceVim#mapping#leader#getName(nr2char(key))
  else
    let name = char
  endif
  call add(keys, name)
  if has_key(root, name)
    let root = root[name]
    if type(root) == 3
      if len(root) == 3
        normal! :
        call s:open_describe_buffer(root[-1])
      else
        call s:build_mpt(['can not find describe for ', join(keys, ' - ')])
      endif
      let defined = 0
    else
      call s:build_mpt([prompt, join(keys + [''], ' - ')])
    endif
  else
    normal! :
    echohl Comment
    echon   join(keys, ' - ') . ' is undefined'
    echohl NONE
    let defined = 0
  endif
  while defined
    let key = getchar()
    let name = s:KEY.nr2name(key)
    call add(keys, name)
    if has_key(root, name)
      let root = root[name]
      if type(root) == 3
        if len(root) == 3
          normal! :
          call s:open_describe_buffer(root[-1])
        else
          call s:build_mpt(['can not find describe for ', join(keys, ' - ')])
        endif
        let defined = 0
      else
        call s:build_mpt([prompt, join(keys + [''], ' - ')])
      endif
    else
      normal! :
      echohl Comment
      echon   join(keys, ' - ') . ' is undefined'
      echohl NONE
      let defined = 0
    endif
  endwhile
endfunction

function! s:build_mpt(mpt) abort
  normal! :
  echohl Comment
  if type(a:mpt) == 1
    echon a:mpt
  elseif type(a:mpt) == 3
    echon join(a:mpt)
  endif
  echohl NONE
endfunction

function! s:open_describe_buffer(desc) abort
  " FIXME: check if the help windows exist in current tab
  " if the windows exit switch to that windows, clear content, update desc and
  " key binding
  let tabtree = s:TABs.get_tree()
  if index(map(tabtree[tabpagenr()], 'bufname(v:val)'), '__help_describe__') == -1
    noautocmd botright split __help_describe__
    let s:helpbufnr = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber nocursorline
    set filetype=HelpDescribe
    setlocal modifiable
    silent normal! "_ggdG
    silent call setline(1, a:desc)
    setlocal nomodifiable
    let b:defind_file_name = split(a:desc[-1][12:], ':')
    let lines = &lines * 30 / 100
    if lines < winheight(0)
      exe 'resize ' . lines
    endif
    setlocal nofoldenable nomodifiable
    nnoremap <buffer><silent> q :bd<cr>
  else
    let winnr = bufwinnr(s:helpbufnr)
    exe winnr .  'wincmd w'
    setlocal modifiable
    silent normal! "_ggdG
    silent call setline(1, a:desc)
    setlocal nomodifiable
    let b:defind_file_name = split(a:desc[-1][12:], ':')
    let lines = &lines * 30 / 100
    if lines < winheight(0)
      exe 'resize ' . lines
    endif
    setlocal nofoldenable nomodifiable
    nnoremap <buffer><silent> q :bd<cr>
  endif
endfunction
