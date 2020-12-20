#!/bin/bash -
set -e


if [[ "$VIM_NAME" == 'nvim' ]]; then
    if [[ "$TRAVIS_OS_NAME" == 'osx'  ]]; then
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
        tar xzf nvim-macos.tar.gz
    else
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update -y
        sudo apt-get install neovim -y
    fi
else
    wget https://codeload.github.com/vim/vim/tar.gz/v7.4.774
    tar xzf v7.4.774
    cd vim-7.4.774
    ./configure --prefix="$HOME/vim" \
        --enable-fail-if-missing \
        --with-features=huge
    make -j 2
    make install
fi

