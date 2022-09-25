@echo off

git clone --depth 1 'https://github.com/callmekohei/deoplete-fsharp-bin.git'
move deoplete-fsharp-bin/bin ./
rmdir /s /q deoplete-fsharp-bin

powershell -Command "(new-object System.Net.WebClient).Downloadfile('https://raw.githubusercontent.com/fsharp/vim-fsharp/master/syntax/fsharp.vim', 'fsharp.vim')"
mkdir syntax
move fsharp.vim syntax



