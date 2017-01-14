scriptencoding utf-8
function! SpaceVim#layers#ui#plugins() abort
    return [
                \ ['Yggdroot/indentLine'],
                \ ['mhinz/vim-signify'],
                \ ['majutsushi/tagbar', {'loadconf' : 1}],
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
endfunction
