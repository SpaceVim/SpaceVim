vim-grammarous
==============

vim-grammarous is a powerful grammar checker for Vim. Simply do `:GrammarousCheck` to see the powerful checking.
This plugin automatically downloads [LanguageTool](https://www.languagetool.org/), which requires Java 8+.

This plugin can use job feature on Vim 8.0.27 (or later) or Neovim. It enables asynchronous command execution so you don't need to
be blocked until the check has been done on Vim8+ or Neovim.

![demo screen cast](https://github.com/rhysd/ss/blob/master/vim-grammarous/demo.gif?raw=true)


## Commands

```
:[range]GrammarousCheck [--lang={lang}] [--(no-)preview] [--(no-)comments-only]
```

Execute the grammar checker for current buffer (when `[range]` is specified, the target is a text in the range).

1. It makes LanguageTool check grammar (It takes a while)
2. It highlights the locations of detected grammar errors
3. When you move the cursor to a location of an error, it automatically shows the error with the information window (named `[Grammarous]`).

Please do `:GrammarousCheck --help` to show more detail about the command.

```
:GrammarousReset
```

Reset the current check.


## Mappings

### Local mappings in the information window

You can use some mappings in the information window, which is opened to show the detail of an error when the cursor moves to the error.

| Mappings | Description                                    |
| -------- |:---------------------------------------------- |
|   `q`    | Quit the info window                           |
|  `<CR>`  | Move to the location of the error              |
|   `f`    | Fix the error __automatically__                |
|   `r`    | Remove the error without fix                   |
|   `R`    | Disable the grammar rule in the checked buffer |
|   `n`    | Move to the next error's location              |
|   `p`    | Move to the previous error's location          |
|   `?`    | Show help of the mapping in info window        |

### `<Plug>` mappings to execute actions anywhere

The above local mappings are enough to deal with grammar errors.

However, for a more convenient use, vim-grammarous provides the following global mappings to enable
using all grammarous actions globally within vim. This might be beneficial, as the standard mappings
only work within the info window, which loses focus after every action.

By mapping the actions listed below to your favorite shortcuts, it is possible to map all actions
that work within the info window, to work globally within vim. This is done via `:nmap` and an example
for a mapping would be `:nmap <F5> (grammarous-move-to-next-error)`.

| Mappings                                    | Description                                          |
| ------------------------------------------- |:---------------------------------------------------- |
| `<Plug>(grammarous-move-to-info-window)`    | Move the cursor to the info window                   |
| `<Plug>(grammarous-open-info-window)`       | Open the info window for the error under the cursor  |
| `<Plug>(grammarous-reset)`                  | Reset the current check                              |
| `<Plug>(grammarous-fixit)`                  | Fix the error under the cursor automatically         |
| `<Plug>(grammarous-fixall)`                 | Fix all the errors in a current buffer automatically |
| `<Plug>(grammarous-close-info-window)`      | Close the information window from checked buffer     |
| `<Plug>(grammarous-remove-error)`           | Remove the error under the cursor                    |
| `<Plug>(grammarous-disable-rule)`           | Disable the grammar rule under the cursor            |
| `<Plug>(grammarous-move-to-next-error)`     | Move cursor to the next error                        |
| `<Plug>(grammarous-move-to-previous-error)` | Move cursor to the previous error                    |

### Operator mappings

Operator mapping checks grammatical errors in the extent which the text object specifies.
This mapping is available when [vim-operator-user](https://github.com/kana/vim-operator-user) is installed.

| Mappings                      | Description                            |
| ----------------------------- |:-------------------------------------- |
| `<Plug>(operator-grammarous)` | Execute grammar check to a text object |

### `grammarous` unite.vim source

If you are [unite.vim](https://github.com/Shougo/unite.vim) user, `grammarous` unite source is available to look and search the error list incrementally.
To the candidates of the list, you can do the actions which are the same as ones in the info window. (`fixit`, `remove error` and `disable rule`)
Execute below command in the buffer already checked or you want to check.

```
:Unite grammarous
```

### `grammarous` denite.nvim source

For [denite.nvim](https://github.com/Shougo/denite.nvim) users, `grammarous` denite source is available. Note that the kind is currently set to `file`,
which means that actions a user can use are limited to open(jump), preview, etc. Execute below command in the buffer already checked.

```
:Denite grammarous
```

## Fix examples

- [vim-themis](https://github.com/rhysd/vim-themis/commit/b2f838b29f47180ccee50488e01d6774a21d0c03)
- [unite.vim](https://github.com/rhysd/unite.vim/commit/5716eac38781e7a233c98f2a3d7aee8909326791)
- [vim-quickrun](https://github.com/rhysd/vim-quickrun/commit/236c753e0572266670d176e667054d55ad52a3f3)
- [neosnippet.vim](https://github.com/rhysd/neosnippet/commit/c72e26e50ccf53f9d66a31fd9d70696c85c62873)


## FAQ

### How do I check comments only in source code by default?

Please use `g:grammarous#default_comments_only_filetypes`.

For example, below setting makes grammar checker check comments only except for markdown and vim help.

```vim
let g:grammarous#default_comments_only_filetypes = {
            \ '*' : 1, 'help' : 0, 'markdown' : 0,
            \ }
```

### How are rules added to the default rule set?

Please use `g:grammarous#enabled_rules` to enable additional rules. The value is dictionary whose keys
are a filetype (`*` means 'any') and whose values are a list of rule names.

For example, below setting enables `PASSIVE_VOICE` rule in all filetypes.

```vim
let g:grammarous#enabled_rules = {'*' : ['PASSIVE_VOICE']}
```

### Some rules annoy me.

Please use `g:grammarous#disabled_rules` to disable specific rules.

For example, below setting disables some rules for each filetype. `*` means all filetypes, `help` means vim help.

```vim
let g:grammarous#disabled_rules = {
            \ '*' : ['WHITESPACE_RULE', 'EN_QUOTES'],
            \ 'help' : ['WHITESPACE_RULE', 'EN_QUOTES', 'SENTENCE_WHITESPACE', 'UPPERCASE_SENTENCE_START'],
            \ }
```

The rule names are displayed in Vim command line when you disable the rule in the info window or by `<Plug>(grammarous-disable-rule)`.

### How are categories added to the default rule set?

Please use `g:grammarous#enabled_categories` to enable additional categories. The value is dictionary whose keys
are a filetype (`*` means 'any') and whose values are a list of categories names.

For example, below setting enables `PASSIVE_VOICE` rule in all filetypes.

```vim
let g:grammarous#enabled_categories = {'*' : ['PUNCTUATION']}
```

### Some categories annoy me.

Please use `g:grammarous#disabled_categories` to disable specific categories.

For example, below setting disables some categories for each filetype. `*` means all filetypes, `help` means vim help.

```vim
let g:grammarous#disabled_categories = {
            \ '*' : ['PUNCTUATION'],
            \ 'help' : ['PUNCTUATION', 'TYPOGRAPHY'],
            \ }
```

The category names are displayed in Vim command line when you disable the category in the info window or by `<Plug>(grammarous-disable-category)`.

### How do I use this plugin with vim's spelllang?

Please use `g:grammarous#use_vim_spelllang`. Default 0, to enable 1.

### I want to use above `<Plug>` mappings only after checking.

`on_check` and `on_reset` are available.

For example, below setting defines `<C-n>` and `<C-p>` mappings as buffer-local mappings when the check has been completed.
They are cleared when the check is reset.

```vim
let g:grammarous#hooks = {}
function! g:grammarous#hooks.on_check(errs) abort
    nmap <buffer><C-n> <Plug>(grammarous-move-to-next-error)
    nmap <buffer><C-p> <Plug>(grammarous-move-to-previous-error)
endfunction

function! g:grammarous#hooks.on_reset(errs) abort
    nunmap <buffer><C-n>
    nunmap <buffer><C-p>
endfunction
```

### I want to use system global LanguageTool command

`g:grammarous#languagetool_cmd` is available for the purpose.
If some command is set to `g:grammarous#languagetool_cmd` in your `.vimrc`, vim-grammarous does not install
its own LanguageTool jar and use the command to run LanguageTool.

```vim
let g:grammarous#languagetool_cmd = 'languagetool'
```

### I want to see the first error in an information window soon after `:GrammarousCheck`

Please set `g:grammarous#show_first_error` to `1`. It opens an information window after `:GrammarousCheck` immediately when some error detected.

### I want to use a location list to jump among errors

Please set `g:grammarous#use_location_list` to `1`. It sets all grammatical errors to location list.
This variable is set to `0` by default to avoid conflicts of location list usage with other plugins.

## Automatic installation

This plugin attempts to install [LanguageTool](https://www.languagetool.org/) using `curl` or `wget` command at first time.
If it fails, you should install it manually. Please download zip file of LanguageTool and extract it to `path/to/vim-grammarous/misc`.


## Requirements

- Java8+ (required)
- [vimproc.vim](https://github.com/Shougo/vimproc.vim) (optional for Vim 8.0.25 or earlier on Windows)
- [unite.vim](https://github.com/Shougo/unite.vim) (optional)
- [vim-operator-user](https://github.com/kana/vim-operator-user) (optional)


## Future

- __Ignore specific regions__ : Enable to specify the region which vim-grammarous should not check. It is helpful for GFM's fenced code blocks.
- __Incremental grammarous check__ : Check only the sentences you input while starting from entering and leaving insert mode.


## Contribution

If you find some bugs, please report it to [issues page](https://github.com/rhysd/vim-grammarous/issues).
Pull requests are welcome. None of them is too short.


## License

    Copyright (c) 2014 rhysd

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
    of the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
    THE USE OR OTHER DEALINGS IN THE SOFTWARE.

