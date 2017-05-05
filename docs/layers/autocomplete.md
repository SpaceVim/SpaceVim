# [Layers](https://spacevim.org/layers) > autocomplete

SpaceVim uses neocomplete as the default completion engine if vim has lua
support. If there is no lua support, neocomplcache will be used for the
completion engine. Spacevim uses deoplete as the default completion engine
for neovim. Deoplete requires neovim to be compiled with python support. For
more information about python support in neovim, please read neovim's documentation `:h provider-python`.

SpaceVim includes YouCompleteMe, but it is disabled by default. To enable
ycm, see `:h g:spacevim_enable_ycm`.

SpaceVim use neosnippet as the default snippet engine. The default snippets
are provided by `Shougo/neosnippet-snippets`. For more information, please read
`:h neosnippet`. Neosnippet support custom snippets, and the default snippets
directory is `~/.SpaceVim/snippets/`. If `g:spacevim_force_global_config = 1`,
SpaceVim will not append `./.SpaceVim/snippets` as default snippets directory.

## Key Mappings
