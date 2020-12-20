PATH := ./vim-themis/bin:$(PATH)
export THEMIS_VIM  := nvim
export THEMIS_ARGS := -e -s --headless
export THEMIS_HOME := ./vim-themis


install: vim-themis
	pip install --upgrade -r test/requirements.txt

install-user: vim-themis
	pip install --user --upgrade -r test/requirements.txt

lint:
	vint --version
	vint plugin
	vint autoload
	flake8 --version
	flake8 rplugin
	mypy --version
	mypy --ignore-missing-imports --follow-imports=skip --strict rplugin/python3/deoplete

test:
	themis --version
	themis test/autoload/*
	pytest --version
	pytest

vim-themis:
	git clone --depth 1 https://github.com/thinca/vim-themis $@

.PHONY: install lint test
