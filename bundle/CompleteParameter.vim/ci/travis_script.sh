#!/bin/bash -
set -e

if [ $# -ne 1 ]; then
    exit 1
fi

$1 -Nu <(cat << VIMRC
filetype off
set rtp+=vader.vim
set rtp+=.
runtime! cm_parser/*.vim
filetype plugin indent on
syntax enable
VIMRC) -c 'Vader! vader/*' > /dev/null

