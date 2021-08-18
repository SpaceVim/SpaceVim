function! lua#omni#complete(findstart, base) abort
  return luaeval("require('luavi').complete(require('luavi.vimutils').eval('a:findstart'), require('luavi.vimutils').eval('a:base'))")
endfunction
