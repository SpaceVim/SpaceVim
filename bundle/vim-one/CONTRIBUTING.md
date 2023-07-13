If you wish to contribute to enhancing **vim-one**, please feel free to do so.
Open a pull request and I'll be happy to review it.

## Adding support for a new language

* Crack open `colors/one.vim`
* Create a new "section" for your language, the languages are alphabetically
  sorted

**Sample section**

```
  " C/C++ highlighting ------------------------------------------------------{{{
  " }}}

```

* Start hacking

There is one function you should call:

```
call <sid>X('cInclude',           s:hue_3,  '', '')
```

The arguments are:

* The highlight
* Foreground color
* Background color
* Decoration (bold, italic, underline or any combination), for example
  'bold,italic'


## Highlights

Highlights are defined in vim syntax files, there is no real standard, but some
of them are really "mainstream", for instance **elixir-lang/vim-elixir** for
*Elixir*.

I have these two following mapping in my `vimrc`

```
" Display highlight information
nnoremap <leader>ii :echo synIDattr(synID(line('.'), col('.'), 1), 'name')<CR>

" Display highlighting groups
nnoremap <leader>hi :so $VIMRUNTIME/syntax/hitest.vim<cr>
```

The first one `<leader>ii` displays the name of the hightlight the cursor is
on.
The second one `<leader>hi` lists all the highlights that are defined, bear in
mind that syntaxes are loaded dynamically by Vim.

Happy colorscheming...
