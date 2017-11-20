#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C

docker pull spacevim/vims

if [ "${LINT#vimlint}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/syngan/vim-vimlint /tmp/vimlint
    git clone --depth=1 https://github.com/ynkdir/vim-vimlparser /tmp/vimlparser
elif [ "${LINT#vint}" != "$LINT" ]; then
    virtualenv /tmp/vint && source /tmp/vint/bin/activate && pip install vim-vint
elif [ "${LINT#vader}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/Shougo/dein.vim.git ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim
fi
