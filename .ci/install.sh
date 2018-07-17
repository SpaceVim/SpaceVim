#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C

docker pull spacevim/vims

git fetch origin master:master

if [ "${LINT#vimlint}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/syngan/vim-vimlint /tmp/vimlint
    git clone --depth=1 https://github.com/ynkdir/vim-vimlparser /tmp/vimlparser
elif [ "${LINT#vint}" != "$LINT" ]; then
    pip install vim-vint pathlib enum34 typing
elif [ "${LINT#vader}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/Shougo/dein.vim.git ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim
    if [[ ! -d "${DEPS}/_neovim" ]]; then
        mkdir -p "${DEPS}/_neovim"
        wget -q -O - https://github.com/neovim/neovim/releases/download/nightly/nvim-${TRAVIS_OS_NAME}64.tar.gz \
            | tar xzf - --strip-components=1 -C "${DEPS}/_neovim"

    fi
    export PATH="${DEPS}/_neovim/bin:${PATH}"
    echo "\$PATH: \"${PATH}\""

    export VIM="${DEPS}/_neovim/share/nvim/runtime"
    echo "\$VIM: \"${VIM}\""
    nvim --version
elif [ "$LINT" = "jekyll" ]; then
    .ci/bootstrap
fi
