#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C

docker pull spacevim/vims

git fetch origin dev:dev

if [ "${LINT#vimlint}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/syngan/vim-vimlint /tmp/vimlint
    git clone --depth=1 https://github.com/ynkdir/vim-vimlparser /tmp/vimlparser
elif [ "${LINT#vint}" != "$LINT" ]; then
    pip install vim-vint
elif [ "${LINT#vader}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/Shougo/dein.vim.git ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim
    if [ ! -f "$HOME/deps/bin/vim" ]; then
        C_OPTS="--prefix=$DEPS --with-features=huge --disable-gui --enable-pythoninterp"
        (git clone --depth 1 https://github.com/vim/vim /tmp/vim &&
        cd /tmp/vim &&
        ./configure $C_OPTS &&
        make install)
    fi
fi
