#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C


git config --global user.name "Travis"

git config --global user.email travis@example.com

export PYTHONUSERBASE="$HOME/.local"

# Get root path of the script
root=$(cd $(dirname $0); pwd)

. $root/install/linux.sh

# Install Vim/Neovim
install $VIM $VIM_VERSION

if [ "${LINT#vimlint}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/syngan/vim-vimlint /tmp/vimlint
    git clone --depth=1 https://github.com/ynkdir/vim-vimlparser /tmp/vimlparser
elif [ "${LINT#vint}" != "$LINT" ]; then
    virtualenv /tmp/vint && source /tmp/vint/bin/activate && pip install vim-vint
elif [ "${LINT#vader}" != "$LINT" ]; then
    git clone --depth=1 https://github.com/Shougo/dein.vim.git ~/.cache/vimfiles/repos/github.com/Shougo/dein.vim
fi
