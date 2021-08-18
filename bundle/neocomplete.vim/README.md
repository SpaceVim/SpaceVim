neocomplete
===========

Note: This plugin is not compatible with above Vim 8.2.1066!
https://github.com/vim/vim/commit/bd84617d1a6766efd59c94aabebb044bef805b99

**Note**: Active development on neocomplete.vim has stopped. The only future
changes will be bug fixes.

Please see [Deoplete.nvim](https://github.com/Shougo/deoplete.nvim).

neocomplete is the abbreviation of "neo-completion with cache". It provides
keyword completion system by maintaining a cache of keywords in the current
buffer. neocomplete can be customized easily and has many more features than
Vim's built-in completion.

Note: If you use neovim or Vim8+, you should use deoplete instead.
https://github.com/Shougo/deoplete.nvim

## Installation

**Note:** neocomplete requires Vim 7.3.885+ with Lua enabled.
See [requirements](#requirements) if you aren't sure whether you have this.

1. Extract the files and put them in your Vim directory
   (usually `~/.vim/` or `Program Files/Vim/vimfiles` on Windows).
2. Execute the `:NeoCompleteEnable` command or set `let
   g:neocomplete#enable_at_startup = 1` in your `.vimrc` (**not** in `.gvimrc`
   or `_gvimrc`!)

## Requirements

neocomplete requires Vim 7.3.885+ compiled with
[if\_lua](http://vimdoc.sourceforge.net/htmldoc/if_lua.html).  If `:echo
has("lua")` returns `1`, then you're done; otherwise, see below.

### Vim builds for Windows

  [github release](https://github.com/vim/vim-win32-installer/releases)
* [Vim 32bit](http://files.kaoriya.net/goto/vim73w32)
* [Vim 64bit](http://files.kaoriya.net/goto/vim73w64)
* [Vim 32bit alternative](http://tuxproject.de/projects/vim/)
* [Another alternative](http://wyw.dcweb.cn/#download)

**Note:** the Vim build may not include the Lua DLL. In that case,
[download Lua](http://lua-users.org/wiki/LuaBinaries) and put the `lua52.dll`
file in the same directory as `gvim.exe`.

### Vim for Mac OS X:

[MacVim with `if\_lua`](https://github.com/zhaocai/macvim)

Or, you can install MacVim with homebrew: (Make sure you have Xcode fully
installed)

    brew cask install macvim --with-cscope --with-lua

To install Vim (as opposed to MacVim) with homebrew:

    brew install vim --with-luajit

### Vim for Linux:

#### Debian (or Ubuntu)

Make sure you have any of these packages:
* vim-nox
* vim-gtk3

Which package depends on your graphical environment (except vim-nox which is
for vim with no GUI).

#### Fedora

The latest version of vim includes lua.
As of 2014-04-16 you need to [download the
rpm](http://koji.fedoraproject.org/koji/packageinfo?packageID=216).

#### Misc

Be aware, your distribution's package manager may have a fairly outdated
Vim build (for example, Ubuntu 12.04 ships Vim 7.3.429).
However, [building Vim](http://vim.wikia.com/wiki/Building_Vim) on Linux is not
difficult.  Remember to specify `--with-lua` (or `--with-features=huge`).

### Vim for Cygwin:

In a cygwin environment, the Lua interface is supported by default.

If you want to make manually, you also need gcc and make.

When everything is prepared, execute these commands.

    cd /usr/src
    tar jxf vim-7.4.tar.bz2
    tar xvfz lua-5.1.5.tar.gz
    cd vim74/
    ./configure --enable-luainterp --enable-gui=no \
    --without-x --enable-multibyte --prefix=/usr
    make && make install

To check if everything was successfull enter the following `vim --version`. You
should see ` +lua` in the list of features.

## Snippets

The Snippets feature of neocomplete was split into a
[separate plugin](https://github.com/Shougo/neosnippet).

A migration guide for existing users of neocomplcache is available:
[Migration guide](https://github.com/Shougo/neocomplete.vim/wiki/neocomplete-migration-guide)


## Screenshots

### Original filename completion

![Original filename completion.](https://f.cloud.github.com/assets/41495/622454/f519f6b8-cf42-11e2-921e-6e34dba148a6.png)
![Include filename completion.](https://f.cloud.github.com/assets/214488/623151/284ad86e-cf5b-11e2-828e-257d31bf0572.png)

### Omni completion

![Omni completion.](https://f.cloud.github.com/assets/41495/622456/fb2cc0bc-cf42-11e2-94e8-403cdcf5427e.png)

### Completion with [vimshell](http://github.com/Shougo/vimshell)

![Completion with vimshell(http://github.com/Shougo/vimshell).](https://f.cloud.github.com/assets/41495/622458/01dbc660-cf43-11e2-85f1-326e7432b0a1.png)

### Vim completion (provided by [neco-vim](https://github.com/Shougo/neco-vim))

![Vim completion.](https://f.cloud.github.com/assets/41495/622457/fe90ad5e-cf42-11e2-8e03-8f189b5e26e5.png)
![Vim completion with animation.](https://f.cloud.github.com/assets/214488/623496/94ed19a2-cf68-11e2-8d33-3aad8a39d7c1.gif)


## Configuration Examples

```vim
"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
```
