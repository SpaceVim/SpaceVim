#!/bin/sh

PJ_ROOT=$(pwd)

if [ ! -d ./neovim ]; then
  git clone --depth 1 https://github.com/neovim/neovim
fi

cd ./neovim

make functionaltest \
  BUSTED_ARGS="--lpath=$PJ_ROOT/?.lua --lpath=$PJ_ROOT/lua/?.lua --lpath=$PJ_ROOT/lua/lspconfig/?.lua" \
  TEST_FILE="../test/lspconfig_spec.lua"
