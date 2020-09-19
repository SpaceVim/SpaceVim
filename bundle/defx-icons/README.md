# Defx icons

Custom implementation of [vim-devicons](https://github.com/ryanoasis/vim-devicons) for [defx.nvim](https://github.com/Shougo/defx.nvim).

![screenshot from 2018-11-22 23-39-41](https://user-images.githubusercontent.com/1782860/48923552-eeed0b80-eeaf-11e8-98e8-8f4e7ec85194.png)

## Usage
```vimL
:Defx -columns=icons:indent:filename:type
```
This column is a replacement for mark column. It will properly highlight selected files.

## Configuration
This is the default configuration:

```vimL
let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 2
let g:defx_icons_directory_icon = ''
let g:defx_icons_mark_icon = '*'
let g:defx_icons_copy_icon = ''
let g:defx_icons_move_icon = ''
let g:defx_icons_parent_icon = ''
let g:defx_icons_default_icon = ''
let g:defx_icons_directory_symlink_icon = ''
" Options below are applicable only when using "tree" feature
let g:defx_icons_root_opened_tree_icon = ''
let g:defx_icons_nested_opened_tree_icon = ''
let g:defx_icons_nested_closed_tree_icon = ''
```

Note: Syntax highlighting can cause some performance issues in defx window. Just disable it with the `let g:defx_icons_enable_syntax_highlight = 0`


## Override colors

If you want to override some of the colors, you can do it this way:

For gui:

```vimL
let g:defx_icons_gui_colors = {
\ 'red': 'FFFFFF'
\ }
```

For term:

```vimL
let g:defx_icons_term_colors = {
\ 'red': 2
\ }
```

For directory icons these highlight groups are defined:

```vimL
hi default link DefxIconsMarkIcon Statement
hi default link DefxIconsCopyIcon WarningMsg
hi default link DefxIconsMoveIcon ErrorMsg
hi default link DefxIconsDirectory Directory
hi default link DefxIconsParentDirectory Directory
hi default link DefxIconsSymlinkDirectory Directory
hi default link DefxIconsOpenedTreeIcon Directory
hi default link DefxIconsNestedTreeIcon Directory
hi default link DefxIconsClosedTreeIcon Directory
```

For example, to change color of the directory icon when it's opened in tree to red color, you would do something like this:

```vimL
hi DefxIconsOpenedTreeIcon guifg=#FF0000
```

Or link it to something else that you want:

```vimL
hi link DefxIconsOpenedTreeIcon Error
```

## Thanks to

* [vim-devicons](https://github.com/ryanoasis/vim-devicons) for icons
* [vim-nerdtree-syntax-highlight](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight) for colors
