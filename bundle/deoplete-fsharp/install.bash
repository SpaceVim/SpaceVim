#!/usr/bin/env bash

git clone --depth 1 'https://github.com/callmekohei/deoplete-fsharp-bin.git'
mv deoplete-fsharp-bin/bin ./
rm -rf deoplete-fsharp-bin

mkdir syntax
wget 'https://raw.githubusercontent.com/fsharp/vim-fsharp/master/syntax/fsharp.vim' -P './syntax/'

