test: vim-themis
	vim-themis/bin/themis --reporter spec test/commands.vim test/parse.vim test/sample.vim test/tsort.vim test/toml.vim
	vim-themis/bin/themis --reporter spec test/source.vim
	vim-themis/bin/themis --reporter spec test/lock.vim

# Use existing vim-themis install from ~/.vim, or clone it.
vim-themis:
	existing=$(firstword $(wildcard ~/.vim/*bundle*/*themis*/plugin/themis.vim)); \
	if [ -n "$$existing" ]; then \
		( cd test && ln -s $$(dirname $$(dirname $$existing)) vim-themis ); \
	else \
		git clone https://github.com/thinca/vim-themis vim-themis; \
	fi

.PHONY: test
