PATH := ./vim-themis/bin:$(PATH)
export THEMIS_VIM  := nvim
export THEMIS_ARGS := -e -s --headless
export THEMIS_HOME := ./vim-themis


install:
	pip install --upgrade -r test/requirements.txt

install-user:
	pip install --user --upgrade -r test/requirements.txt

lint:
	vint --version
	vint autoload

test: vim-themis
	themis --version
	themis test/

vim-themis:
	git clone https://github.com/thinca/vim-themis vim-themis

.PHONY: install install-user lint test
