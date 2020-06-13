#!/bin/sh

BASE_DIR=$HOME/.vim/bundle
sh ${BASE_DIR}/vim-vimlint/bin/vimlint.sh \
  -l ${BASE_DIR}/vim-vimlint \
  -p ${BASE_DIR}/vim-vimlparser \
  -e EVL102.l:_=1 \
  autoload/incsearch.vim
sh ${BASE_DIR}/vim-vimlint/bin/vimlint.sh \
  -l ${BASE_DIR}/vim-vimlint \
  -p ${BASE_DIR}/vim-vimlparser \
  -e EVL102.l:_=1 \
  autoload/incsearch
