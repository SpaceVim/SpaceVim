if [ ! -e /tmp/vader ]; then
    git clone https://github.com/junegunn/vader.vim.git /tmp/vader
fi
vim -Nu test/test.vim -c 'Vader! test/**'
