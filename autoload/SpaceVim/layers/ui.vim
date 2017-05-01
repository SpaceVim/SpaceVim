scriptencoding utf-8
function! SpaceVim#layers#ui#plugins() abort
    return [
                \ ['Yggdroot/indentLine'],
                \ ['mhinz/vim-signify'],
                \ ['majutsushi/tagbar', {'loadconf' : 1}],
                \ ['lvht/tagbar-markdown',{'merged' : 0}],
                \ ['t9md/vim-choosewin', {'merged' : 0}],
                \ ['vim-airline/vim-airline',                { 'merged' : 0, 
                \ 'loadconf' : 1}],
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
    call SpaceVim#mapping#space#def('nnoremap', ['t', '8'], 'call call('
                \ . string(s:_function('s:toggle_fill_column')) . ', [])',
                \ 'toggle-colorcolume', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'b'], 'call ToggleBG()',
                \ 'toggle background', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'f'], 'call call('
                \ . string(s:_function('s:toggle_colorcolumn')) . ', [])',
                \ 'toggle-colorcolume', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'h'], 'set cursorline!',
                \ 'toggle highlight of the current line', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'i'], 'call call('
                \ . string(s:_function('s:toggle_indentline')) . ', [])',
                \ 'menu-bar', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'c'], 'set cursorcolumn!',
                \ 'toggle highlight indentation current column', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 's'], 'call call('
                \ . string(s:_function('s:toggle_syntax_hi')) . ', [])',
                \ 'toggle syntax highlighting', 1)

    call SpaceVim#mapping#space#def('nnoremap', ['T', 'F'], '<F11>',
                \ 'fullscreen-frame', 0)
    call SpaceVim#mapping#space#def('nnoremap', ['T', 'm'], 'call call('
                \ . string(s:_function('s:toggle_menu_bar')) . ', [])',
                \ 'menu-bar', 1)
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
let s:tmflag = 0
function! s:toggle_menu_bar() abort
    if !s:tmflag
        set go+=m
        let s:tmflag = 1
    else
        set go-=m
        let s:tmflag = 0
    endif
endfunction

let s:ccflag = 0
function! s:toggle_colorcolumn() abort
    if !s:ccflag
        set cc=80
        let s:ccflag = 1
    else
        set cc=
        let s:ccflag = 0
    endif
endfunction

let s:fcflag = 0
function! s:toggle_fill_column() abort
    if !s:fcflag
        let &colorcolumn=join(range(80,999),",")
        let s:fcflag = 1
    else
        set cc=
        let s:fcflag = 0
    endif
endfunction

let s:idflag = 0
function! s:toggle_indentline() abort
    if !s:idflag
        IndentLinesDisable
        let s:idflag = 1
    else
        IndentLinesEnable
        let s:idflag = 0
    endif
endfunction

let s:shflag = 0
function! s:toggle_syntax_hi() abort
    if !s:shflag
        syntax off
        let s:shflag = 1
    else
        syntax on
        let s:shflag = 0
    endif
endfunction
