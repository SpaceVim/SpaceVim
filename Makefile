test: build/vader | build
	$(VIM_BIN) -Nu test/vimrc $(VIM_Es) -c 'Vader! test/**'

build/vader:
	git clone --depth 1 https://github.com/junegunn/vader.vim.git $@

build:
	mkdir -p $@

clean:
	$(RM) -r build

.PHONY: clean test
