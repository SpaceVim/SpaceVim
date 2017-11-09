#!/usr/bin/env bash

set -e
if [ "${LINT#vimlint}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/syngan/vim-vimlint /tmp/vimlint
    git clone --depth=1 https://github.com/ynkdir/vim-vimlparser /tmp/vimlparser
elif [ "${LINT#vint}" != "$LINT" ]; then
    virtualenv /tmp/vint && source /tmp/vint/bin/activate && pip install vim-vint
elif [ "${LINT#vader}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/Shougo/dein.vim.git ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim
    C_OPTS="--prefix=$DEPS --with-features=huge --disable-gui --enable-pythoninterp"
    (git clone --depth 1 https://github.com/vim/vim /tmp/vim &&
        cd /tmp/vim &&
        ./configure $C_OPTS &&
        make install)
fi
