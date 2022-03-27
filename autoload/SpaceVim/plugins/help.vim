"=============================================================================
" help.vim --- help plugin for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" init local valuable

if exists('s:key_describ')
  finish
endif

let s:key_describ = {}


" load APIs
let s:KEY = SpaceVim#api#import('vim#key')
let s:VIM = SpaceVim#api#import('vim')
let s:TABs = SpaceVim#api#import('vim#tab')



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
  let key = s:VIM.getchar()
  let char = s:KEY.nr2name(char2nr(key))
  if index(keys(g:_spacevim_mappings_prefixs), char) != -1
    let name = SpaceVim#mapping#leader#getName(nr2char(key))
  else
    let name = char
  endif
  call add(keys, name)
  if has_key(root, name)
    " in Old vim we get E706
    " Variable type mismatch for conf, so we need to unlet conf first
    " ref: patch-7.4.1546
    " https://github.com/vim/vim/commit/f6f32c38bf3319144a84a01a154c8c91939e7acf
    let rootswap = root
    unlet root
    let root = rootswap[name]
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
    let key = s:VIM.getchar()
    let name = s:KEY.nr2name(char2nr(key))
    call add(keys, name)
    if has_key(root, name)
      " in Old vim we get E706
      " Variable type mismatch for conf, so we need to unlet conf first
      " ref: patch-7.4.1546
      " https://github.com/vim/vim/commit/f6f32c38bf3319144a84a01a154c8c91939e7acf
      let rootswap = root
      unlet root
      let root = rootswap[name]
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
  let tabtree = s:TABs.get_tree()
  if index(map(tabtree[tabpagenr()], 'bufname(v:val)'), '__help_describe__') == -1
    noautocmd botright split __help_describe__
    let s:helpbufnr = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber nocursorline
    set filetype=HelpDescribe
  else
    let winnr = bufwinnr(s:helpbufnr)
    exe winnr .  'wincmd w'
  endif
  setlocal modifiable
  silent normal! gg"_dG
  silent call setline(1, a:desc)
  setlocal nomodifiable
  let b:defind_file_name = split(a:desc[-1][12:], ':')
  let lines = &lines * 30 / 100
  if lines < winheight(0)
    exe 'resize ' . lines
  endif
  setlocal nofoldenable nomodifiable
  nnoremap <buffer><silent> q :bd<cr>
endfunction
