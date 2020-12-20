# defx-git

Git status implementation for [defx.nvim](http://github.com/Shougo/defx.nvim).

## Usage

Just append `git` to your columns when starting defx:

```viml
:Defx -columns=git:mark:filename:type
```

## Options

### Indicators

Which indicators (icons) to use for each status. These are the defaults:

```viml
call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })
```

### Column Length

How many space should git column take. Default is `1` (Defx adds a single space between columns):

```viml
call defx#custom#column('git', 'column_length', 1)
```

Missing characters to match this length are populated with spaces, which means
`✹` becomes `✹ `, etc.

Note: Make sure indicators are not longer than the column_length

### Show ignored

This flag determines if ignored files should be marked with indicator. Default is `false`:

```viml
call defx#custom#column('git', 'show_ignored', 0)
```

### Raw Mode

Show git status in raw mode (Same as first two chars of `git status --porcelain` command). Default is `0`:

```viml
call defx#custom#column('git', 'raw_mode', 0)
```

### Max Indicator Width

The number of characters to pad the git column. If not specified, the default
will be the width of the longest indicator character.

```viml
call defx#custom#column('git', 'max_indicator_width', 2)
```

## Highlighting

Each indicator type can be overridden with the custom highlight. These are the defaults:

```viml
hi Defx_git_Untracked guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE
hi Defx_git_Ignored guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE
hi Defx_git_Unknown guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE
hi Defx_git_Renamed ctermfg=214 guifg=#fabd2f
hi Defx_git_Modified ctermfg=214 guifg=#fabd2f
hi Defx_git_Unmerged ctermfg=167 guifg=#fb4934
hi Defx_git_Deleted ctermfg=167 guifg=#fb4934
hi Defx_git_Staged ctermfg=142 guifg=#b8bb26
```

To use for example red for untracked files, add this **after** your colorscheme setup:

```viml
colorscheme gruvbox
hi Defx_git_Untracked guifg=#FF0000
```

## Mappings

There are 5 mappings:

* `<Plug>(defx-git-next)` - Goes to the next file that has a git status
* `<Plug>(defx-git-prev)` - Goes to the previous file that has a git status
* `<Plug>(defx-git-stage)` - Stages the file/directory under cursor
* `<Plug>(defx-git-reset)` - Unstages the file/directory under cursor
* `<Plug>(defx-git-discard)` - Discards all changes to file/directory under cursor

If these are not manually mapped by the user, defaults are:
```viml
nnoremap <buffer><silent> [c <Plug>(defx-git-prev)
nnoremap <buffer><silent> ]c <Plug>(defx-git-next)
nnoremap <buffer><silent> ]a <Plug>(defx-git-stage)
nnoremap <buffer><silent> ]r <Plug>(defx-git-reset)
nnoremap <buffer><silent> ]d <Plug>(defx-git-discard)
```
