Neosnippet
==========

The Neosnippet plug-In adds snippet support to Vim. Snippets are
small templates for commonly used code that you can fill in on the
fly. To use snippets can increase your productivity in Vim a lot.
The functionality of this plug-in is quite similar to plug-ins like
snipMate.vim. But since you can choose snippets with the
[deoplete](https://github.com/Shougo/deoplete.nvim) interface, you might have
less trouble using them, because you do not have to remember each snippet name.

**Note**: Active development on neosnippet.vim has stopped. The only future
changes will be bug fixes.

Please see [Deoppet.nvim](https://github.com/Shougo/deoppet.nvim).

Installation
------------

To install neosnippet and other Vim plug-ins it is recommended to use one of the
popular package managers for Vim, rather than installing by drag and drop all
required files into your `.vim` folder.

Notes:

* Vim 7.4 or above is needed.

* Vim 8.0 or above or neovim is recommended.

* Default snippets files are available in:
  [neosnippet-snippets](https://github.com/Shougo/neosnippet-snippets)

* Installing default snippets is optional. If choose not to install them,
  you must deactivate them with `g:neosnippet#disable_runtime_snippets`.

* deoplete is not required to use neosnippet, but it's highly recommended.

* Extra snippets files can be found in:
  [vim-snippets](https://github.com/honza/vim-snippets).

### Vundle

```vim
Plugin 'Shougo/deoplete.nvim'
if !has('nvim')
  Plugin 'roxma/nvim-yarp'
  Plugin 'roxma/vim-hug-neovim-rpc'
endif

Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
```

### dein.vim

```vim
call dein#add('Shougo/deoplete.nvim')
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif
let g:deoplete#enable_at_startup = 1

call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
```

### vim-plug

```vim
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
```

Configuration
-------------

This is an example `~/.vimrc` configuration for Neosnippet. It is assumed you
already have deoplete configured. With the settings of the example, you can use
the following keys:

* `C-k` to select-and-expand a snippet from the deoplete popup (Use `C-n`
  and `C-p` to select it). `C-k` can also be used to jump to the next field in
  the snippet.

* `Tab` to select the next field to fill in the snippet.

```vim
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
```

If you want to use a different collection of snippets than the
built-in ones, then you can set a path to the snippets with
the `g:neosnippet#snippets_directory` variable (e.g [Honza's
Snippets](https://github.com/honza/vim-snippets))

But if you enable `g:neosnippet#enable_snipmate_compatibility`, neosnippet will
load snipMate snippets from runtime path automatically.

```vim
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
```

