#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C

git fetch origin master:master

if [ "${LINT#vimlint}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/syngan/vim-vimlint /tmp/vimlint
    git clone --depth=1 https://github.com/ynkdir/vim-vimlparser /tmp/vimlparser
elif [ "${LINT#vint}" != "$LINT" ]; then
    pip install vim-vint pathlib enum34 typing
elif [ "${LINT#vader}" != "$LINT" ]; then
    if [[ ! -d "$HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim" ]]; then
        git clone --depth=1 https://github.com/Shougo/dein.vim.git ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim
    fi
    .ci/install/linux.sh $VIM_BIN $VIM_TAG
    if [ "$VIM_BIN" = "nvim" ]; then
        export PATH="${DEPS}/_neovim/${VIM_TAG}/bin:${PATH}"
        export VIM="${DEPS}/_neovim/${VIM_TAG}/share/nvim/runtime"
    else
        export PATH="${DEPS}/_vim/${VIM_TAG}/bin:${PATH}"
        export VIM="${DEPS}/_vim/${VIM_TAG}/share/vim"
    fi

    echo "\$PATH: \"${PATH}\""
    echo "\$VIM: \"${VIM}\""
    echo "=================  nvim version ======================"
    $VIM_BIN --version
elif [ "$LINT" = "jekyll" ]; then
    .ci/bootstrap
fi
