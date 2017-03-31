scriptencoding utf-8
exe 'set wildignore+=' . g:spacevim_wildignore
" shell
if has('filterpipe')
    set noshelltemp
endif
if count(g:spacevim_plugin_groups, 'colorscheme') && g:spacevim_colorscheme !=# '' "{{{
    try
        exec 'colorscheme '. g:spacevim_colorscheme
    catch
        exec 'colorscheme '. g:spacevim_colorscheme_default
    endtry
else
    exec 'colorscheme '. g:spacevim_colorscheme_default
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
if !empty(g:spacevim_guifont)
    exe 'set guifont=' . g:spacevim_guifont
endif
if g:spacevim_enable_guicolors == 1
    if !has('nvim') && has('patch-7.4.1770')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    if exists('+termguicolors')
        set termguicolors
    elseif exists('+guicolors')
        set guicolors
    endif
endif
