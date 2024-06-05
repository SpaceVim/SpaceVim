# echodoc.vim

Displays function signatures from completions in the command line.

![example](https://cloud.githubusercontent.com/assets/111942/19444981/a076d748-9460-11e6-851c-f249f8110b3b.gif)

## Installation

Use a package manager and follow its instructions.

Note: echodoc requires v:completed_item feature. It is added in Vim 7.4.774.

### Global options

|Flag                               |Default            |Description                                                                                                       |
|-----------------------------------|-------------------|------------------------------------------------------------------------------------------------------------------|
|`g:echodoc#enable_at_startup`      |`0`                |If the value of this variable is non-zero, `echodoc` is automatically enabled at startup.                         |
|`g:echodoc#type`                   |` "echo"`          |Where the documentation is displayed. Choose between:` "echo"`,` "signature"`, `"virtual" `or `"floating"`        |
|`g:echodoc#events`                 |`['CompleteDone']` |If the `autocmd-events` are fired, echodoc is enabled.                                                            |
|`g:echodoc#floating_config`        |`{}`               |The configuration for the floating window.                                                                        |
|`g:echodoc#highlight_identifier`   |`"Identifier"`     |The highlight of identifier.                                                                                      |
|`g:echodoc#highlight_arguments`    |`"Special"`        |The highlight of current argument.                                                                                |
|`g:echodoc#highlight_trailing`     |`"Type"`           |The highlight of trailing.                                                                                        |

## Type "echo" Usage

When using
```vim
let g:echodoc#type = "echo" " Default value
```
The command line is used to display `echodoc` text.  This means that you will
either need to `set noshowmode` or `set cmdheight=2`.  Otherwise, the `--
INSERT --` mode text will overwrite `echodoc`'s text.

When you accept a completion for a function with `<c-y>`, `echodoc` will
display the function signature in the command line and highlight the argument
position your cursor is in.

## Examples

Option 1:
```vim
" To use echodoc, you must increase 'cmdheight' value.
set cmdheight=2
let g:echodoc_enable_at_startup = 1
```

Option 2:
```vim
" Or, you could disable showmode alltogether.
set noshowmode
let g:echodoc_enable_at_startup = 1
```

Option 3:
```vim
" Or, you could use neovim's virtual virtual text feature.
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'
```

Option 4:
```vim
" Or, you could use neovim's floating window feature.
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
" You could configure the behaviour of the floating window like below:
let g:echodoc#floating_config = {'border': 'single'}
" To use a custom highlight for the float window,
" change Pmenu to your highlight group
highlight link EchoDocFloat Pmenu
```

Option 5:
```vim
" Or, you could use vim's popup window feature.
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'popup'
" To use a custom highlight for the popup window,
" change Pmenu to your highlight group
highlight link EchoDocPopup Pmenu
```
