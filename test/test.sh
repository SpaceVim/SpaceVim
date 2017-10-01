if [ ! -e /tmp/vader ]; then
    git clone --depth 1 https://github.com/junegunn/vader.vim.git /tmp/vader
fi
vim -Nu test/vimrc -c 'Vader! test/**'
