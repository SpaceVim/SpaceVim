#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then
  if [ "$LINT" = "vimlint-errors" ] ; then
    VIMLINT_LOG=""
    git clone https://github.com/wsdjeg/GitHub.vim.git build/GitHub.vim
    docker run -it --rm \
      -v $PWD/.ci:/.ci \
      -v $PWD/autoload/SpaceVim/api:/API/autoload/SpaceVim/api \
      -v $PWD/autoload/SpaceVim/api.vim:/API/autoload/SpaceVim/api.vim \
      -v $PWD/build:/build \
      spacevim/vims neovim-stable -u /.ci/common/github_commenter.vim
  elif [ "$LINT" = "vint-errors" ] ; then
    VIMLINT_LOG=""
    git clone https://github.com/wsdjeg/GitHub.vim.git build/GitHub.vim
    docker run -it --rm \
      -v $PWD/.ci:/.ci \
      -v $PWD/autoload/SpaceVim/api:/API/autoload/SpaceVim/api \
      -v $PWD/autoload/SpaceVim/api.vim:/API/autoload/SpaceVim/api.vim \
      -v $PWD/build:/build \
      spacevim/vims neovim-stable -u /.ci/common/github_commenter.vim
  elif [ "$LINT" = "vader" ] ; then
    echo ""
  fi
else
  if [ "$LINT" = "jekyll" ]; then
    ./wiki/async.sh "en"
    ./wiki/async.sh "cn"
    git remote add gitee https://SpaceVimBot:${BOTSECRET}@gitee.com/spacevim/SpaceVim.git
    git push gitee master 
    git remote add coding https://spacevim@outlook.com:${CODINGBOTSECRET}@e.coding.net/spacevim/SpaceVim.git
    git push coding master 
    .ci/detach_plugin.sh flygrep
    .ci/detach_plugin.sh dein-ui
    .ci/detach_plugin.sh vim-todo
    .ci/detach_plugin.sh iedit
    .ci/push_baidu.sh
  fi
fi
