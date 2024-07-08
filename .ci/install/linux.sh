#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C

install_vim() {
    local URL=https://github.com/vim/vim
    local tag=$1
    local ext=$([[ $tag == "nightly" ]] && echo "" || echo "-b $tag")
    local tmp="$(mktemp -d)"
    local out="${DEPS}/_vim/$tag"
    mkdir -p $out
    git clone --depth 1 --single-branch $ext $URL $tmp
    cd $tmp

    # Apply Vim patch v8.0.1635 to fix build with Python.
    if grep -q _POSIX_THREADS src/if_python3.c; then
      sed -i '/#ifdef _POSIX_THREADS/,+2 d' src/if_python3.c
    fi

    ./configure \
        --with-features=huge \
        --enable-pythoninterp \
        --enable-python3interp \
        --enable-luainterp \
        --prefix=${out}
    make
    make install
}

install_nvim() {
    local URL=https://github.com/neovim/neovim
    local tag=$1
    local tmp="$(mktemp -d)"
    local out="${DEPS}/_neovim/$tag"
    mkdir -p $out
    curl  -o $tmp/nvim-linux64.tar.gz -L "https://github.com/neovim/neovim/releases/download/$tag/nvim-linux64.tar.gz"
    tar -xzvf $tmp/nvim-linux64.tar.gz -C $tmp
    cp -r $tmp/nvim-linux64/* $out
    chmod +x $out/bin/nvim
    # fix ModuleNotFoundError: No module named 'setuptools'
    python3 -m pip install -U setuptools
    python3 -m pip install pynvim
}

install() {
    local vim=$1
    local tag=$2

    if [[ -d "${DEPS}/_$vim/$tag/bin" ]]; then
        echo "Use a cached version '$HOME/_$vim/$tag'."
        return
    fi
    if [[ $vim == "nvim" ]]; then
        install_nvim $tag
    else
        install_vim $tag
    fi
}

install $@
