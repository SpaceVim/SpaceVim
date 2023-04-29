#!/usr/bin/env bash

_detact () {
    cp -f ../../$1 $1
}

_detact_bundle () {
    cp -f ../../bundle/$1/$2 $2
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
            _checkdir lua/spacevim/api
            _detact autoload/SpaceVim/plugins/flygrep.vim
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/logger.vim
            _detact autoload/SpaceVim/api/vim/buffer.vim
            _detact autoload/SpaceVim/api/vim/regex.vim
            _detact autoload/SpaceVim/api/vim/compatible.vim
            _detact autoload/SpaceVim/api/vim/floating.vim
            _detact autoload/SpaceVim/api/vim/highlight.vim
            _detact autoload/SpaceVim/api/vim/statusline.vim
            _detact autoload/SpaceVim/api/vim/window.vim
            _detact autoload/SpaceVim/api/neovim/floating.vim
            _detact autoload/SpaceVim/api/data/dict.vim
            _detact autoload/SpaceVim/api/data/list.vim
            _detact autoload/SpaceVim/api/data/json.vim
            _detact autoload/SpaceVim/api/data/string.vim
            _detact autoload/SpaceVim/api/prompt.vim
            _detact autoload/SpaceVim/api/job.vim
            _detact autoload/SpaceVim/api/vim.vim
            _detact autoload/SpaceVim/api/file.vim
            _detact autoload/SpaceVim/api/system.vim
            _detact autoload/SpaceVim/api/time.vim
            _detact autoload/SpaceVim/mapping/search.vim
            _detact autoload/SpaceVim/logger.vim
            _detact lua/spacevim.lua
            _detact lua/spacevim/api.lua
            _detact lua/spacevim/api/logger.lua
            _detact lua/spacevim/logger.lua
            _detact syntax/SpaceVimFlyGrep.vim
            _default_readme "FlyGrep.vim" "Grep on the fly in Vim/Neovim"
            _detact LICENSE
            _checkdir plugin
            cat <<EOT > plugin/FlyGrep.vim
"=============================================================================
" FlyGrep.vim --- Fly grep in vim
" Copyright (c) 2016-2022 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
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
let g:FlyGrep_input_delay = get(g:, 'FlyGrep_input_delay', 500)

""
" A list of searching tools will be userd.
let g:FlyGrep_search_tools = get(g:, 'FlyGrep_search_tools', ['ag', 'rg', 'grep', 'pt', 'ack'])

let g:spacevim_data_dir = get(g:, 'spacevim_data_dir', '~/.cache')

""
" Enable FlyGrep statusline
let g:FlyGrep_enable_statusline = get(g:, 'FlyGrep_enable_statusline', 1)

""
" Set FlyGrep default command prompt
let g:spacevim_commandline_prompt = get(g:, 'spacevim_commandline_prompt', '➭')

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
            _detact autoload/SpaceVim/plugins/manager.vim
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/commands.vim
            _detact autoload/SpaceVim/logger.vim
            _detact autoload/SpaceVim/api/job.vim
            _detact autoload/SpaceVim/api/system.vim
            _detact autoload/SpaceVim/api/data/list.vim
            _detact autoload/SpaceVim/api/vim/compatible.vim
            _detact syntax/SpaceVimPlugManager.vim
            _detact LICENSE
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
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/vim/compatible.vim
            _detact autoload/SpaceVim/api/vim/highlight.vim
            _detact autoload/SpaceVim/api/data/string.vim
            _detact autoload/SpaceVim/plugins/iedit.vim
            _checkdir autoload/plugin
            cat <<EOT > autoload/plugin/iedit.vim
"=============================================================================
" iedit.vim --- multiple cursor support for neovim and vim
" Copyright (c) 2016-2022 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
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
            _detact LICENSE
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
            _detact syntax/SpaceVimTodoManager.vim
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/data
            _checkdir autoload/SpaceVim/plugins
            _checkdir autoload/SpaceVim/mapping
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/logger.vim
            _detact autoload/SpaceVim/api/job.vim
            _detact autoload/SpaceVim/api/system.vim
            _detact autoload/SpaceVim/api/data/string.vim
            _detact autoload/SpaceVim/api/file.vim
            _detact autoload/SpaceVim/api/vim/buffer.vim
            _detact autoload/SpaceVim/api/vim/regex.vim
            _detact autoload/SpaceVim/api/vim/compatible.vim
            _detact autoload/SpaceVim/logger.vim
            _detact autoload/SpaceVim/mapping/search.vim
            _detact autoload/SpaceVim/plugins/todo.vim
            _checkdir plugin
            cat <<EOT > plugin/todo.vim
"=============================================================================
" todo.vim --- todo manager for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

command! OpenTodo call todo#open()
EOT
            _detact LICENSE
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
        vim-chat)
            git clone https://github.com/wsdjeg/vim-chat.git detach/$1
            cd detach/$1
            _detact LICENSE
            _checkdir autoload/SpaceVim/api
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/job.vim
            _checkdir autoload/chat/
            _detact_bundle vim-chat autoload/chat.vim
            _detact_bundle vim-chat autoload/chat/gitter.vim
            _detact_bundle vim-chat autoload/chat/logger.vim
            _detact_bundle vim-chat autoload/chat/notify.vim
            _detact_bundle vim-chat autoload/chat/qq.vim
            _detact_bundle vim-chat autoload/chat/weixin.vim
            _checkdir doc/
            _detact_bundle vim-chat doc/vim-chat.txt
            _checkdir syntax/
            _detact_bundle vim-chat syntax/vimchat.vim
            _detact_bundle vim-chat addon-info.json
            _detact_bundle vim-chat README.md
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update based on https://github.com/SpaceVim/SpaceVim/commit/${GITHUB_SHA}"
            git remote add wsdjeg_vim_chat https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/vim-chat.git
            git push wsdjeg_vim_chat master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        JavaUnit.vim)
            git clone https://github.com/wsdjeg/JavaUnit.vim.git detach/$1
            cd detach/$1
            # _detact LICENSE
            # _checkdir autoload/SpaceVim/api
            # _detact autoload/SpaceVim/api.vim
            # _detact autoload/SpaceVim/api/job.vim
            # _checkdir autoload/chat/
            _detact_bundle JavaUnit.vim README.md
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update based on https://github.com/SpaceVim/SpaceVim/commit/${GITHUB_SHA}"
            git remote add wsdjeg_javaunit_vim https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/JavaUnit.vim.git
            git push wsdjeg_javaunit_vim master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        vim-cheat)
            git clone https://github.com/wsdjeg/vim-cheat.git detach/$1
            cd detach/$1
            _checkdir plugin/
            _checkdir autoload/
            _detact LICENSE
            _detact_bundle vim-cheat autoload/cheat.vim
            _detact_bundle vim-cheat plugin/cheat.vim
            _detact_bundle vim-cheat README.md
            _detact_bundle vim-cheat .travis.yml
            _detact_bundle vim-cheat .vintrc.yaml
            _checkdir doc/
            _detact_bundle vim-cheat doc/vim-cheat.txt
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update based on https://github.com/SpaceVim/SpaceVim/commit/${GITHUB_SHA}"
            git remote add wsdjeg_vim_cheat https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/vim-cheat.git
            git push wsdjeg_vim_cheat master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        xmake.vim)
            git clone https://github.com/wsdjeg/xmake.vim.git detach/$1
            cd detach/$1
            _checkdir plugin/
            _detact_bundle xmake.vim plugin/xmake.vim
            _detact_bundle xmake.vim plugin/xmgen.py
            _checkdir autoload/
            _detact_bundle xmake.vim autoload/xmake.vim
            _detact_bundle xmake.vim autoload/spy.lua
            _detact LICENSE
            _default_readme "xmake.vim" "xmake support for neovim/vim"
            _checkdir autoload/xmake/
            _detact_bundle xmake.vim autoload/xmake/log.vim
            _checkdir doc/
            _detact_bundle xmake.vim doc/xmake.txt
            _checkdir UltiSnips/
            _detact_bundle xmake.vim UltiSnips/lua.snippets
            _checkdir rplugin/python3/deoplete/sources/docs/
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/xmake.py
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_defines
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_defines                     
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_deps                        
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_files                       
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_headers                     
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_includedirs                 
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_linkdirs                    
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_links                       
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_subdirs                     
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/is_os                           
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/is_plat                         
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_basename                    
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_headerdir                   
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_kind                        
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_languages                   
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_objectdir                   
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_optimize                    
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_project                     
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_strip                       
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_symbols                     
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_targetdir                   
            _detact_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_warnings 
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update based on https://github.com/SpaceVim/SpaceVim/commit/${GITHUB_SHA}"
            git remote add wsdjeg_xmake_vim https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/xmake.vim.git
            git push wsdjeg_xmake_vim master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        scrollbar.vim)
            git clone https://github.com/wsdjeg/scrollbar.vim.git detach/$1
            cd detach/$1
            _checkdir autoload/SpaceVim/api/
            _checkdir autoload/SpaceVim/api/vim
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/vim.vim
            _detact autoload/SpaceVim/api/vim/buffer.vim
            _detact autoload/SpaceVim/api/vim/window.vim
            _checkdir autoload/SpaceVim/plugins/
            _detact autoload/SpaceVim/plugins/scrollbar.vim
            _detact LICENSE
            _default_readme "scrollbar.vim" "floating scrollbar support for neovim/vim[wip]"
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update based on https://github.com/SpaceVim/SpaceVim/commit/${GITHUB_SHA}"
            git remote add wsdjeg_scrollbar https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/scrollbar.vim.git
            git push wsdjeg_scrollbar master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        github.vim)
            git clone https://github.com/wsdjeg/GitHub.vim.git detach/$1
            cd detach/$1
            _checkdir plugin/
            _checkdir autoload/
            _detact LICENSE
            _detact_bundle github.vim autoload/github.vim
            _detact_bundle github.vim plugin/github.vim
            _default_readme "GitHub.vim" "GitHub API support for neovim/vim[wip]"
            _checkdir doc/
            _detact_bundle github doc/github.txt
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Auto Update based on https://github.com/SpaceVim/SpaceVim/commit/${GITHUB_SHA}"
            git remote add wsdjeg_github_vim https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/GitHub.vim.git
            git push wsdjeg_github_vim master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        spacevim-theme)
            exit 0
    esac
}

main $@
