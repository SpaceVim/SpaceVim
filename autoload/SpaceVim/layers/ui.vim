scriptencoding utf-8
function! SpaceVim#layers#ui#plugins() abort
    return [
                \ ['Yggdroot/indentLine'],
                \ ['mhinz/vim-signify'],
                \ ['majutsushi/tagbar', {'loadconf' : 1}],
                \ ['lvht/tagbar-markdown',{'merged' : 0}],
                \ ['t9md/vim-choosewin', {'merged' : 0}],
                \ ['vim-airline/vim-airline',                { 'merged' : 0,  'loadconf' : 1}],
                \ ['vim-airline/vim-airline-themes',         { 'merged' : 0}],
                \ ['mhinz/vim-startify', {'loadconf' : 1}],
                \ ]
endfunction

function! SpaceVim#layers#ui#config() abort
    let g:indentLine_color_term = 239
    let g:indentLine_color_gui = '#09AA08'
    let g:indentLine_char = '¦'
    let g:indentLine_concealcursor = 'niv' " (default 'inc')
    let g:indentLine_conceallevel = 2  " (default 2)
    let g:indentLine_fileTypeExclude = ['help', 'startify', 'vimfiler']
    let g:signify_disable_by_default = 0
    let g:signify_line_highlight = 0
    noremap <silent> <F2> :TagbarToggle<CR>
    " Ui toggles
    call SpaceVim#mapping#space#def('nnoremap', ['T', 'F'], '<F11>', 'fullscreen-frame', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['T', 'm'], 'call call(' . string(s:_function('s:toggle_menu_bar')) . ', [])', 'menu-bar', 1)
endfunction
" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
function! s:toggle_menu_bar() abort
 echom 1
endfunction
