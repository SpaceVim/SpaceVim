test: build/vader | build
	vim -Nu test/vimrc -c 'Vader! test/**'

build/vader:
	git clone --depth 1 https://github.com/junegunn/vader.vim.git $@

build:
	mkdir -p $@
