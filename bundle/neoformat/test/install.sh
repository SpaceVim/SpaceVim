#!/usr/bin/env bash

if [[ $OSTYPE == darwin* ]]; then
    OS='mac'
elif [[ $OSTYPE == linux-gnu* ]]; then
    OS='linux'
else
    OS='unknown'
fi

# Formatters
npm install -g csscomb@3.1.7
npm install -g prettydiff@99.0.1
npm install -g js-beautify@1.6.2 # for css-beautify
npm install -g typescript@2.0.6
npm install -g typescript-formatter@4.0.1
pip install yapf==0.14.0

# Linter(s)
if ! hash vint 2>/dev/null; then
    pip3 install vim-vint
fi

# Make sure neovim is installed
if ! hash nvim 2>/dev/null; then
    echo "installing neovim"
    if [[ $OS == 'linux' ]]; then
        echo "installing nvim on linux"
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update
        sudo apt-get install -y neovim
    elif [[ $OS == 'mac' ]]; then
        echo "install nvim on mac"
        brew install neovim
    fi
else
    echo "neovim already installed"
fi

# Vader
if [ ! -d "$HOME/.vim/plugged/vader.vim" ]; then
    git clone https://github.com/junegunn/vader.vim.git ~/.vim/plugged/vader.vim
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PATH=$PATH:"$DIR"/bin
echo $PATH
