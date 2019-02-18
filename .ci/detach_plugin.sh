#!/usr/bin/env bash

_detect () {
    cp -f ../../$1 $1
}

_checkdir () {
    if [[ ! -d "$1" ]]; then
        mkdir -p $1
    fi
}

main () {
    case "$1" in
        flygrep)
            git clone https://github.com/wsdjeg/FlyGrep.vim.git detach/$1
            cd detach/$1
            _checkdir syntax/
            _checkdir autoload/SpaceVim/api
            _checkdir autoload/SpaceVim/api/vim
            _checkdir autoload/SpaceVim/api/data
            _checkdir autoload/SpaceVim/mapping
            _checkdir autoload/SpaceVim/plugins
            _detect autoload/SpaceVim/plugins/flygrep.vim
            _detect autoload/SpaceVim/api.vim
            _detect autoload/SpaceVim/api/logger.vim
            _detect autoload/SpaceVim/api/vim/buffer.vim
            _detect autoload/SpaceVim/api/vim/compatible.vim
            _detect autoload/SpaceVim/api/data/list.vim
            _detect autoload/SpaceVim/api/prompt.vim
            _detect autoload/SpaceVim/api/job.vim
            _detect autoload/SpaceVim/api/system.vim
            _detect autoload/SpaceVim/mapping/search.vim
            _detect autoload/SpaceVim/logger.vim
            _detect syntax/SpaceVimFlyGrep.vim
            _detect LICENSE
            git add .
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
            git commit -m "Auto Update"
            git remote add wsdjeg_dein_ui https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/dein-ui.vim.git
            git push wsdjeg_dein_ui master 
            cd -
            rm -rf detach/$1
            exit 0
            ;;
        spacevim-theme)
            exit 0
    esac
}

main $@
