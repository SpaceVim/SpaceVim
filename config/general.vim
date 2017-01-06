scriptencoding utf-8
exe 'set wildignore+=' . g:spacevim_wildignore
" shell
if has('filterpipe')
    set noshelltemp
endif
filetype plugin indent on
syntax on
if count(g:spacevim_plugin_groups, 'colorscheme') && g:spacevim_colorscheme !=# '' "{{{
    set background=dark
    try
        exec 'colorscheme '. g:spacevim_colorscheme
    catch
        exec 'colorscheme '. g:spacevim_colorscheme_default
    endtry
endif
if g:spacevim_enable_cursorline == 1
    set cursorline                  "显示当前行
endif
if g:spacevim_enable_cursorcolumn == 1
    set cursorcolumn                "显示当前列
endif
if g:spacevim_hiddenfileinfo == 1 && has('patch-7.4.1570')
    set shortmess=filnxtToOFs
endif
if g:spacevim_enable_guicolors == 1
    if exists('+termguicolors')
        set termguicolors
    elseif exists('+guicolors')
        set guicolors
    endif
endif
