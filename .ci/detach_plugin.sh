#!/usr/bin/env bash

_detact () {
    cp -f ../../$1 $1
}

_detach_bundle () {
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
        FlyGrep.vim)
            git clone https://github.com/wsdjeg/$1.git detach/$1
            cd detach/$1
            _checkdir syntax/
            _checkdir autoload/SpaceVim/api
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/neovim
            _checkdir autoload/SpaceVim/api/data
            _checkdir autoload/SpaceVim/mapping
            _checkdir autoload/SpaceVim/plugins
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
            # detach lua version flygrep
            _checkdir lua/spacevim/api
            _checkdir lua/spacevim/api/vim
            _checkdir lua/spacevim/plugin
            _detact lua/spacevim/plugin/flygrep.lua
            _detact lua/spacevim/plugin/search.lua
            _detact lua/spacevim.lua
            _detact lua/spacevim/logger.lua
            _detact lua/spacevim/api.lua
            _detact lua/spacevim/api/logger.lua
            _detact lua/spacevim/api/prompt.lua
            _detact lua/spacevim/api/notify.lua
            _detact lua/spacevim/api/job.lua
            _detact lua/spacevim/api/password.lua
            _detact lua/spacevim/api/vim.lua
            _detact lua/spacevim/api/system.lua
            _detact lua/spacevim/api/vim/compatible.lua
            _detact lua/spacevim/api/vim/highlight.lua
            _detact lua/spacevim/api/vim/regex.lua
            _detact lua/spacevim/api/vim/keys.lua
            _detact lua/spacevim/api/vim/buffer.lua
            _detact lua/spacevim/api/vim/window.lua
            _detact lua/spacevim/api/vim/statusline.lua
            # detach syntax/ftplugin etc
            _detact syntax/SpaceVimFlyGrep.vim
            # detach bundle
            _checkdir plugin
            _detach_bundle FlyGrep plugin/FlyGrep.vim
            _detach_bundle FlyGrep README.md
            _detach_bundle FlyGrep addon-info.json
            _checkdir doc/
            _detach_bundle FlyGrep doc/FlyGrep.txt
            # detach LICENSE
            _detact LICENSE
            # detach test vimrc
            _checkdir test
            _detach_bundle FlyGrep test/vimrc
            ;;
        dein-ui.vim)
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
            ;;
        cpicker.nvim)
            git clone https://github.com/wsdjeg/cpicker.nvim.git detach/$1
            cd detach/$1
            _checkdir syntax
            _detach_bundle cpicker.nvim syntax/spacevim_cpicker.vim
            _detach_bundle cpicker.nvim syntax/spacevim_cpicker_mix.vim
            _detach_bundle cpicker.nvim README.md
            _checkdir plugin
            _detach_bundle cpicker.nvim plugin/cpicker.lua
            _checkdir lua/cpicker/formats
            _detach_bundle cpicker.nvim lua/cpicker.lua
            _detach_bundle cpicker.nvim lua/cpicker/util.lua
            _detach_bundle cpicker.nvim lua/cpicker/mix.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/cmyk.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/hsl.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/hsv.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/hwb.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/lab.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/linear.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/rgb.lua
            _detach_bundle cpicker.nvim lua/cpicker/formats/xyz.lua
            _checkdir lua/spacevim/api
            _detact lua/spacevim/api/color.lua
            _detact lua/spacevim/api/notify.lua
            _detact lua/spacevim/api/password.lua
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/data
            _detact autoload/SpaceVim/api/notify.vim
            _detact autoload/SpaceVim/api/data/string.vim
            _detact autoload/SpaceVim/api/data/number.vim
            _detact autoload/SpaceVim/api/vim/buffer.vim
            _detact autoload/SpaceVim/api/vim/floatting.vim
            _checkdir autoload/SpaceVim/api/neovim
            _detact autoload/SpaceVim/api/neovim/floatting.vim
            _detact LICENSE
            ;;
        SourceCounter.vim)
            git clone https://github.com/wsdjeg/SourceCounter.vim.git detach/$1
            cd detach/$1
            _checkdir plugin
            _detach_bundle SourceCounter.vim plugin/SourceCounter.vim
            _checkdir autoload
            _detach_bundle SourceCounter.vim autoload/SourceCounter.vim
            _checkdir doc
            _detach_bundle SourceCounter.vim doc/SourceCounter.vim.txt
            _detach_bundle SourceCounter.vim README.md
            _detach_bundle SourceCounter.vim addon-info.json
            _detact LICENSE
            _checkdir pic
            _detach_bundle SourceCounter.vim pic/screen.png
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/data
            _detact autoload/SpaceVim/api/notify.vim
            _detact autoload/SpaceVim/api/data/string.vim
            _detact autoload/SpaceVim/api/data/number.vim
            _detact autoload/SpaceVim/api/vim/buffer.vim
            _detact autoload/SpaceVim/api/vim/floatting.vim
            _checkdir autoload/SpaceVim/api/neovim
            _detact autoload/SpaceVim/api/neovim/floatting.vim
            ;;
        iedit.vim)
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
            ;;
        vim-chat)
            git clone https://github.com/wsdjeg/vim-chat.git detach/$1
            cd detach/$1
            _detact LICENSE
            _checkdir autoload/SpaceVim/api
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/job.vim
            _checkdir autoload/chat/
            _detach_bundle vim-chat autoload/chat.vim
            _detach_bundle vim-chat autoload/chat/gitter.vim
            _detach_bundle vim-chat autoload/chat/logger.vim
            _detach_bundle vim-chat autoload/chat/notify.vim
            _detach_bundle vim-chat autoload/chat/qq.vim
            _detach_bundle vim-chat autoload/chat/weixin.vim
            _checkdir doc/
            _detach_bundle vim-chat doc/vim-chat.txt
            _checkdir syntax/
            _detach_bundle vim-chat syntax/vimchat.vim
            _detach_bundle vim-chat addon-info.json
            _detach_bundle vim-chat README.md
            ;;
        JavaUnit.vim)
            git clone https://github.com/wsdjeg/JavaUnit.vim.git detach/$1
            cd detach/$1
            # _detact LICENSE
            # _checkdir autoload/SpaceVim/api
            # _detact autoload/SpaceVim/api.vim
            # _detact autoload/SpaceVim/api/job.vim
            # _checkdir autoload/chat/
            _detach_bundle JavaUnit.vim README.md
            ;;
        git.vim)
            git clone https://github.com/wsdjeg/git.vim.git detach/$1
            cd detach/$1
            _checkdir autoload/SpaceVim/api
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/job.vim
            _detach_bundle git.vim LICENSE
            _detach_bundle git.vim README.md
            _detach_bundle git.vim addon-info.json
            _checkdir autoload/git/branch
            _detach_bundle git.vim autoload/git.vim
            _detach_bundle git.vim autoload/git/add.vim
            _detach_bundle git.vim autoload/git/blame.vim
            _detach_bundle git.vim autoload/git/branch.vim
            _detach_bundle git.vim autoload/git/branch/manager.vim
            _detach_bundle git.vim autoload/git/checkout.vim
            _detach_bundle git.vim autoload/git/cherry_pick.vim
            _detach_bundle git.vim autoload/git/clean.vim
            _detach_bundle git.vim autoload/git/commit.vim
            _detach_bundle git.vim autoload/git/config.vim
            _detach_bundle git.vim autoload/git/diff.vim
            _detach_bundle git.vim autoload/git/fetch.vim
            _detach_bundle git.vim autoload/git/log.vim
            _detach_bundle git.vim autoload/git/logger.vim
            _detach_bundle git.vim autoload/git/merge.vim
            _detach_bundle git.vim autoload/git/mv.vim
            _detach_bundle git.vim autoload/git/pull.vim
            _detach_bundle git.vim autoload/git/push.vim
            _detach_bundle git.vim autoload/git/rebase.vim
            _detach_bundle git.vim autoload/git/reflog.vim
            _detach_bundle git.vim autoload/git/remote.vim
            _detach_bundle git.vim autoload/git/reset.vim
            _detach_bundle git.vim autoload/git/rm.vim
            _detach_bundle git.vim autoload/git/stash.vim
            _detach_bundle git.vim autoload/git/status.vim
            _checkdir doc
            _detach_bundle git.vim doc/git.txt
            _checkdir plugin
            _detach_bundle git.vim plugin/git.vim
            _checkdir syntax
            _detach_bundle git.vim syntax/git-blame.vim
            _detach_bundle git.vim syntax/git-commit.vim
            _detach_bundle git.vim syntax/git-config.vim
            _detach_bundle git.vim syntax/git-log.vim
            _detach_bundle git.vim syntax/git-rebase.vim
            _detach_bundle git.vim syntax/git-reflog.vim
            _checkdir test
            _detach_bundle git.vim test/vimrc
            _checkdir lua/spacevim/api
            _detact lua/spacevim/api/job.lua
            _detact lua/spacevim/api/logger.lua
            _detact lua/spacevim/api.lua
            _detact lua/spacevim/logger.lua
            _detact lua/spacevim.lua
            _detact lua/spacevim/api/notify.lua
            _detact lua/spacevim/api/password.lua
            _checkdir lua/git/command
            _checkdir lua/git/ui
            _detach_bundle git.vim lua/git/init.lua
            _detach_bundle git.vim lua/git/log.lua
            _detach_bundle git.vim lua/git/command/add.lua
            _detach_bundle git.vim lua/git/command/add.lua
            _detach_bundle git.vim lua/git/command/blame.lua
            _detach_bundle git.vim lua/git/command/branch.lua
            _detach_bundle git.vim lua/git/command/checkout.lua
            _detach_bundle git.vim lua/git/command/cherry-pick.lua
            _detach_bundle git.vim lua/git/command/clean.lua
            _detach_bundle git.vim lua/git/command/commit.lua
            _detach_bundle git.vim lua/git/command/config.lua
            _detach_bundle git.vim lua/git/command/diff.lua
            _detach_bundle git.vim lua/git/command/fetch.lua
            _detach_bundle git.vim lua/git/command/grep.lua
            _detach_bundle git.vim lua/git/command/log.lua
            _detach_bundle git.vim lua/git/command/merge.lua
            _detach_bundle git.vim lua/git/command/mv.lua
            _detach_bundle git.vim lua/git/command/pull.lua
            _detach_bundle git.vim lua/git/command/push.lua
            _detach_bundle git.vim lua/git/command/rebase.lua
            _detach_bundle git.vim lua/git/command/reflog.lua
            _detach_bundle git.vim lua/git/command/remote.lua
            _detach_bundle git.vim lua/git/command/reset.lua
            _detach_bundle git.vim lua/git/command/rm.lua
            _detach_bundle git.vim lua/git/command/shortlog.lua
            _detach_bundle git.vim lua/git/command/stash.lua
            _detach_bundle git.vim lua/git/command/status.lua
            _detach_bundle git.vim lua/git/command/tag.lua
            _detach_bundle git.vim lua/git/command/update-index.lua
            _detach_bundle git.vim lua/git/ui/branch.lua
            _detach_bundle git.vim lua/git/ui/remote.lua
            ;;
        vim-cheat)
            git clone https://github.com/wsdjeg/vim-cheat.git detach/$1
            cd detach/$1
            _checkdir plugin/
            _checkdir autoload/
            _detact LICENSE
            _detach_bundle vim-cheat autoload/cheat.vim
            _detach_bundle vim-cheat plugin/cheat.vim
            _detach_bundle vim-cheat README.md
            _detach_bundle vim-cheat .travis.yml
            _detach_bundle vim-cheat .vintrc.yaml
            _checkdir doc/
            _detach_bundle vim-cheat doc/vim-cheat.txt
            ;;
        xmake.vim)
            git clone https://github.com/wsdjeg/xmake.vim.git detach/$1
            cd detach/$1
            _checkdir plugin/
            _detach_bundle xmake.vim plugin/xmake.vim
            _detach_bundle xmake.vim plugin/xmgen.py
            _checkdir autoload/
            _detach_bundle xmake.vim autoload/xmake.vim
            _detach_bundle xmake.vim autoload/spy.lua
            _detact LICENSE
            _default_readme "xmake.vim" "xmake support for neovim/vim"
            _checkdir autoload/xmake/
            _detach_bundle xmake.vim autoload/xmake/log.vim
            _checkdir doc/
            _detach_bundle xmake.vim doc/xmake.txt
            _checkdir UltiSnips/
            _detach_bundle xmake.vim UltiSnips/lua.snippets
            _checkdir rplugin/python3/deoplete/sources/docs/
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/xmake.py
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_defines
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_defines                     
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_deps                        
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_files                       
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_headers                     
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_includedirs                 
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_linkdirs                    
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_links                       
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/add_subdirs                     
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/is_os                           
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/is_plat                         
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_basename                    
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_headerdir                   
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_kind                        
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_languages                   
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_objectdir                   
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_optimize                    
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_project                     
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_strip                       
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_symbols                     
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_targetdir                   
            _detach_bundle xmake.vim rplugin/python3/deoplete/sources/docs/set_warnings 
            ;;
        scrollbar.vim)
            git clone https://github.com/wsdjeg/scrollbar.vim.git detach/$1
            cd detach/$1
            _checkdir autoload/SpaceVim/api/
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/neovim
            _checkdir autoload/SpaceVim/api/data
            _detact autoload/SpaceVim/api.vim
            _detact autoload/SpaceVim/api/vim.vim
            _detact autoload/SpaceVim/api/system.vim
            _detact autoload/SpaceVim/api/logger.vim
            _detact autoload/SpaceVim/api/time.vim
            _detact autoload/SpaceVim/api/vim/compatible.vim
            _detact autoload/SpaceVim/api/vim/buffer.vim
            _detact autoload/SpaceVim/api/vim/window.vim
            _detact autoload/SpaceVim/api/vim/floating.vim
            _detact autoload/SpaceVim/api/vim/highlight.vim
            _detact autoload/SpaceVim/api/neovim/floating.vim
            _detact autoload/SpaceVim/api/data/dict.vim
            _detact autoload/SpaceVim/api/data/string.vim
            _checkdir autoload/SpaceVim/plugins/
            _detact autoload/SpaceVim/plugins/scrollbar.vim
            _detact LICENSE
            _detach_bundle scrollbar.vim README.md
            _checkdir plugin
            _detach_bundle scrollbar.vim plugin/scrollbar.vim
            _checkdir test
            _detach_bundle scrollbar.vim test/vimrc
            _checkdir lua/spacevim/plugin
            _detact lua/spacevim/plugin/scrollbar.lua
            _checkdir lua/spacevim/api/vim
            _detact lua/spacevim/api/vim/buffer.lua
            _detact lua/spacevim/api/vim/window.lua
            _detact autoload/SpaceVim/logger.vim
            ;;
        GitHub.vim)
            git clone https://github.com/wsdjeg/GitHub.vim.git detach/$1
            cd detach/$1
            _checkdir plugin/
            _checkdir autoload/
            _detact LICENSE
            _detach_bundle github.vim autoload/github.vim
            _detach_bundle github.vim plugin/github.vim
            _default_readme "GitHub.vim" "GitHub API support for neovim/vim[wip]"
            _checkdir doc/
            _detach_bundle github doc/github.txt
            ;;
    esac
    git add .
    git config user.email "eric@wsdjeg.net"
    git config user.name  "Eric Wong"
    git commit -m "${SpaceVim_COMMIT_MSG}"
    git remote add wsdjeg_$1 https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/$1.git
    git push wsdjeg_$1 master 
    cd -
    rm -rf detach/$1
    exit 0
}

main $@
