"==============================================================
"    file: complete_parameter.vim
"   brief: 
" VIM Version: 8.0
"  author: zhongtenghui
"   email: zhongtenghui@gf.com.cn
" created: 2017-08-10 09:37:46
"==============================================================

" deprecated
function! complete_parameter#pre_complete(failed_inserted) "{{{
  return cmp#pre_complete(a:failed_inserted)
endfunction "}}}

" deprecated
function! complete_parameter#jumpable(forward) "{{{
  return cmp#jumpable(a:forward)
endfunction "}}}
