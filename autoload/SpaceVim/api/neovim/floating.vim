"=============================================================================
" floating.vim --- neovim#floating api
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:self = {}
" in old version nvim_open_win api is:
"    call nvim_open_win(s:bufnr, v:true, &columns, 12,
"         \ {
"         \ 'relative': 'editor',
"         \ 'row': &lines - 14,
"         \ 'col': 0
"         \ })
"  if exists('*nvim_open_win')
"   call nvim_win_set_config(win_getid(s:gwin), 
"         \ {
"         \ 'relative': 'editor',
"         \ 'width'   : &columns,
"         \ 'height'  : layout.win_dim + 2,
"         \ 'row'     : &lines - layout.win_dim - 4,
"         \ 'col'     : 0
"         \ })
function! s:self.open_win(buf, focuce, opt) abort
  try
    call nvim_open_win(a:buf, a:focuce, a:opt)
  catch /^Vim\%((\a\+)\)\=:E119/
    call nvim_open_win(a:buf, a:focuce, get(a:opt, 'width', 5), get(a:opt, 'height', 5), 
          \ {
          \ 'relative' : get(a:opt, 'relative', 'editor'),
          \ 'row' : get(a:opt, 'row', 5),
          \ 'col' : get(a:opt, 'col', 5),
          \ }) 
  endtry
endfunction

function! s:self.win_config(winid, opt) abort
  " Neovim 这一函数有三种状态：
  " 1：最初名称为 nvim_win_config，并且接受 4 个参数
  " 2：名称被重命名为 nvim_win_set_config，并且任然接受四个参数
  " 3：最新版本名称为 nvim_win_set_config，只接受 2 个参数
  " 这里实现的逻辑就是优先使用最新的api调用方式，当报错时顺历史变更顺序去尝试。
  try
    call nvim_win_set_config(a:winid, a:opt)
  catch /^Vim\%((\a\+)\)\=:E119/
    call nvim_win_set_config(a:winid, get(a:opt, 'width', 5), get(a:opt, 'height', 5), 
          \ {
          \ 'relative' : get(a:opt, 'relative', 'editor'),
          \ 'row' : get(a:opt, 'row', 5),
          \ 'col' : get(a:opt, 'col', 5),
          \ }) 
  catch /^Vim\%((\a\+)\)\=:E117/
    call nvim_win_config(a:winid, get(a:opt, 'width', 5), get(a:opt, 'height', 5), 
          \ {
          \ 'relative' : get(a:opt, 'relative', 'editor'),
          \ 'row' : get(a:opt, 'row', 5),
          \ 'col' : get(a:opt, 'col', 5),
          \ }) 
  endtry

endfunction


function! SpaceVim#api#neovim#floating#get() abort
  return deepcopy(s:self)
endfunction
