test: vim-themis
	vim-themis/bin/themis --reporter spec test

vim-themis:
	git clone https://github.com/thinca/vim-themis vim-themis

lint:
	vint --version
	vint plugin
	vint autoload

.PHONY: test lint
