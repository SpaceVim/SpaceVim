scriptencoding utf-8
exe 'set wildignore+=' . g:spacevim_wildignore
" shell
if has('filterpipe')
    set noshelltemp
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
if g:spacevim_colorscheme !=# '' "{{{
    try
        exec 'set background=' . g:spacevim_colorscheme_bg
        exec 'colorscheme ' . g:spacevim_colorscheme
    catch
        exec 'colorscheme '. g:spacevim_colorscheme_default
    endtry
else
    exec 'colorscheme '. g:spacevim_colorscheme_default
endif
if g:spacevim_hiddenfileinfo == 1 && has('patch-7.4.1570')
    set shortmess+=F
endif
if has('gui_running') && !empty(g:spacevim_guifont)
  if has('gui_vimr')
    " VimR has removed support for guifont
  else
    let &guifont = g:spacevim_guifont
  endif
endif
