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
      _checkdir autoload/SpaceVim/api
      _checkdir autoload/SpaceVim/api/vim
      _checkdir autoload/SpaceVim/mapping
      _checkdir autoload/SpaceVim/plugins
      _detect autoload/SpaceVim/plugins/flygrep.vim
      _detect autoload/SpaceVim/api.vim
      _detect autoload/SpaceVim/api/logger.vim
      _detect autoload/SpaceVim/api/vim/buffer.vim
      _detect autoload/SpaceVim/api/prompt.vim
      _detect autoload/SpaceVim/api/job.vim
      _detect autoload/SpaceVim/api/system.vim
      _detect autoload/SpaceVim/mapping/search.vim
      _detect autoload/SpaceVim/logger.vim
      git add .
      git commit -m "Auto Update"
      git remote add wsdjeg_flygrep https://SpaceVimBot:${BOTSECRET}@github.com/wsdjeg/FlyGrep.vim.git
      git push wsdjeg_flygrep master 
      cd -
      rm -rf detach/$1
      exit 0
      ;;
    spacevim-theme)
      exit 0
  esac
}

main $@
