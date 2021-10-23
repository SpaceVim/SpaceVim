" source Lua...
if has('lua')
    exe 'luafile ' . fnamemodify(expand('<sfile>'), ':h:h').'/lua/luavi/complete.lua'
endif


""
" @public
" this function is the omnifunc for lua file. to enable lua complete, add this
" to you vimrc.
" >
"   augroup vim-lua
"   autocmd!
"   autocmd FileType lua setlocal omnifunc=lua#complete
"   augroup END
" <
function! lua#complete(findstart, base) abort

 return lua#omni#complete(a:findstart, a:base)   

endfunction
