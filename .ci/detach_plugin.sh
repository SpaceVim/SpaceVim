#!/usr/bin/env bash

_detect () {
    cp -f ../../$1 $1
}

_checkdir () {
    if [[ ! -d "$1" ]]; then
        mkdir -p $1
    fi
}

_default_readme () {
    cat <<EOT > README.md
# $1
> $2

This plugin is automatically detach from [SpaceVim](https://github.com/SpaceVim/SpaceVim/). you can use it without SpaceVim.
EOT
} 


main () {
    case "$1" in
        flygrep)
            git clone https://github.com/wsdjeg/FlyGrep.vim.git detach/$1
            cd detach/$1
            _checkdir syntax/
            _checkdir autoload/SpaceVim/api
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/neovim
            _checkdir autoload/SpaceVim/api/data
            _checkdir autoload/SpaceVim/mapping
            _checkdir autoload/SpaceVim/plugins
            _detect autoload/SpaceVim/plugins/flygrep.vim
            _detect autoload/SpaceVim/api.vim
            _detect autoload/SpaceVim/api/logger.vim
            _detect autoload/SpaceVim/api/vim/buffer.vim
            _detect autoload/SpaceVim/api/vim/regex.vim
            _detect autoload/SpaceVim/api/vim/compatible.vim
            _detect autoload/SpaceVim/api/neovim/floating.vim
            _detect autoload/SpaceVim/api/data/list.vim
            _detect autoload/SpaceVim/api/data/json.vim
            _detect autoload/SpaceVim/api/prompt.vim
            _detect autoload/SpaceVim/api/job.vim
            _detect autoload/SpaceVim/api/file.vim
            _detect autoload/SpaceVim/api/system.vim
            _detect autoload/SpaceVim/mapping/search.vim
            _detect autoload/SpaceVim/logger.vim
            _detect syntax/SpaceVimFlyGrep.vim
            cat <<EOT > README.md

# FlyGrep.vim
> Asynchronously fly grep in vim

This plugin is automatically detach from [SpaceVim](https://github.com/SpaceVim/SpaceVim/). you can use it without SpaceVim.

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

## Install

for dein.vim

```vim
call dein#add('wsdjeg/FlyGrep.vim')
```

for vim-plug

```vim
Plug 'wsdjeg/FlyGrep.vim'
```

## usage

```
:FlyGrep
```

you also can define custom mapping, for example:

```vim
nnoremap <Space>s/ :FlyGrep<cr>
```

Key Binding |	Description
-----------| -----------
`SPC s /` | Searching in project on the fly with default tools

key binding in FlyGrep buffer:

Key Binding |	Description
-----------| -----------
`<Esc>` | close FlyGrep buffer
`<C-c>` | close FlyGrep buffer
`<Enter>` | open file at the cursor line
`<Tab>` | move cursor line down
`<C-j>` | move cursor line down
`<S-Tab>` | move cursor line up
`<C-k>` | move cursor line up
`<Bs>` | remove last character
`<C-w>` | remove the Word before the cursor
`<C-u>` | remove the Line before the cursor
`<C-k>` | remove the Line after the cursor
`<C-a>`/`<Home>` | Go to the beginning of the line
`<C-e>`/`<End>` | Go to the end of the line
EOT
            _detect LICENSE
            _checkdir plugin
            cat <<EOT > plugin/FlyGrep.vim
"=============================================================================
" FlyGrep.vim --- Fly grep in vim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://github.com/wsdjeg/FlyGrep.vim
" License: MIT license
"=============================================================================

""
" @section Introduction, intro
" @stylized FlyGrep
" @library
" @order intro version dicts functions exceptions layers api faq
" Fly grep in vim, written in pure vim script for MacVim, gvim and vim version
" 8.0+.
"

""
" @section CONFIGURATION, config
" FlyGrep has strong default options, but you can also change the option
" yourself.

""
" FlyGrep will start to searching code after a delay, the default value is
" 500ms.
let g:FlyGrep_input_delay = 500

""
" A list of searching tools will be userd.
let g:FlyGrep_search_tools = ['ag', 'rg', 'grep', 'pt', 'ack']

let g:spacevim_data_dir
      \ = $XDG_CACHE_HOME != ''
      \   ? $XDG_CACHE_HOME . SpaceVim#api#import('file').separator
      \   : expand($HOME. join(['', '.cache', ''],
      \     SpaceVim#api#import('file').separator))

""
" Enable FlyGrep statusline
let g:FlyGrep_enable_statusline = 1

""
" Set FlyGrep default command prompt
let g:spacevim_commandline_prompt = '➭'

command! -nargs=0 FlyGrep call FlyGrep#open({})
EOT
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update"
            git remote add wsdjeg_flygrep https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/FlyGrep.vim.git
            git push wsdjeg_flygrep master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        dein-ui)
            git clone https://github.com/wsdjeg/dein-ui.vim.git detach/$1
            cd detach/$1
            _checkdir syntax/
            _checkdir autoload/SpaceVim/api
            _checkdir autoload/SpaceVim/api/data
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/mapping
            _checkdir autoload/SpaceVim/plugins
            _detect autoload/SpaceVim/plugins/manager.vim
            _detect autoload/SpaceVim/api.vim
            _detect autoload/SpaceVim/commands.vim
            _detect autoload/SpaceVim/api/job.vim
            _detect autoload/SpaceVim/api/system.vim
            _detect autoload/SpaceVim/api/data/list.vim
            _detect autoload/SpaceVim/api/vim/compatible.vim
            _detect syntax/SpaceVimPlugManager.vim
            _detect LICENSE
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update"
            git remote add wsdjeg_dein_ui https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/dein-ui.vim.git
            git push wsdjeg_dein_ui master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        iedit)
            git clone https://github.com/wsdjeg/iedit.vim.git detach/$1
            cd detach/$1
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/data
            _checkdir autoload/SpaceVim/plugins
            _detect autoload/SpaceVim/api.vim
            _detect autoload/SpaceVim/api/vim/compatible.vim
            _detect autoload/SpaceVim/api/vim/highlight.vim
            _detect autoload/SpaceVim/api/data/string.vim
            _detect autoload/SpaceVim/plugins/iedit.vim
            _checkdir autoload/plugin
            cat <<EOT > autoload/plugin/iedit.vim
"=============================================================================
" iedit.vim --- multiple cursor support for neovim and vim
" Copyright (c) 2016-2020 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://github.com/wsdjeg/iedit.vim
" License: MIT license
"=============================================================================

""
" @section Introduction, intro
" @stylized iedit.vim
" @library
" @order intro version dicts functions exceptions layers api faq
" multiple cursor in vim, written in pure vim script for MacVim, gvim and vim version
" 8.0+.
"

command! -nargs=0 Iedit call SpaceVim#plugins#iedit#start()
EOT
            _detect LICENSE
            _default_readme "iedit.vim" "multiple cussor support for Vim/Neovim"
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update"
            git remote add wsdjeg_vim_todo https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/iedit.vim.git
            git push wsdjeg_vim_todo master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        vim-todo)
            git clone https://github.com/wsdjeg/vim-todo.git detach/$1
            cd detach/$1
            _checkdir syntax/
            _detect syntax/SpaceVimTodoManager.vim
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/data
            _checkdir autoload/SpaceVim/plugins
            _checkdir autoload/SpaceVim/mapping
            _detect autoload/SpaceVim/api.vim
            _detect autoload/SpaceVim/api/logger.vim
            _detect autoload/SpaceVim/api/job.vim
            _detect autoload/SpaceVim/api/system.vim
            _detect autoload/SpaceVim/api/data/string.vim
            _detect autoload/SpaceVim/api/file.vim
            _detect autoload/SpaceVim/api/vim/buffer.vim
            _detect autoload/SpaceVim/api/vim/compatible.vim
            _detect autoload/SpaceVim/logger.vim
            _detect autoload/SpaceVim/mapping/search.vim
            _detect autoload/SpaceVim/plugins/todo.vim
            _detect LICENSE
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update"
            git remote add wsdjeg_vim_todo https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/vim-todo.git
            git push wsdjeg_vim_todo master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        scrollbar.vim)
            git clone https://github.com/wsdjeg/scrollbar.vim.git detach/$1
            cd detach/$1
            _checkdir autoload/SpaceVim/api/
            _detect autoload/SpaceVim/api.vim
            _detect autoload/SpaceVim/api/vim.vim
            _detect autoload/SpaceVim/plugins/scrollbar.vim
            _detect LICENSE
            _default_readme "scrollbar.vim" "floating scrollbar support for neovim/vim[wip]"
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update"
            git remote add wsdjeg_scrollbar https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/scrollbar.vim.git
            git push wsdjeg_scrollbar master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        spacevim-theme)
            exit 0
    esac
}

main $@
