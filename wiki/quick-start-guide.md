### Quick start guide

SpaceVim load custom configuration from `~/.SpaceVim.d/init.vim`,

:warning: It is not `~/.SpaceVim/init.vim`, user should not change anything in `~/.SpaceVim/`.

here is an example:

```viml
" Here are some basic customizations, please refer to the ~/.SpaceVim.d/init.vim
" file for all possible options:
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80

" Change the default directory where all miscellaneous persistent files go.
" By default it is ~/.cache/vimfiles/.
let g:spacevim_plugin_bundle_dir = '~/.cache/vimfiles/'

" set SpaceVim colorscheme
let g:spacevim_colorscheme = 'jellybeans'

" Set plugin manager, you want to use, default is dein.vim
let g:spacevim_plugin_manager = 'dein'  " neobundle or dein or vim-plug

" use space as `<Leader>`
" let mapleader = "\<space>"

" Set windows shortcut leader [Window], default is `s`
let g:spacevim_windows_leader = 's'

" Set unite work flow shortcut leader [Unite], default is `f`
let g:spacevim_unite_leader = 'f'

" By default, language specific plugins are not loaded. This can be changed
" with the following, then the plugins for go development will be loaded.
call SpaceVim#layers#load('lang#go')

" loaded ui layer
call SpaceVim#layers#load('ui')

" If there is a particular plugin you don't like, you can define this
" variable to disable them entirely:
let g:spacevim_disabled_plugins=[
    \ ['junegunn/fzf.vim'],
    \ ]

" If you want to add some custom plugins, use these options:
let g:spacevim_custom_plugins = [
    \ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
    \ ['wsdjeg/GitHub.vim'],
    \ ]

" set the guifont
let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
```

Comprehensive documentation is available for each layer by <kbd>:h SpaceVim</kbd>.

You can also check the [general documentation](http://spacevim.org/documentation/).
