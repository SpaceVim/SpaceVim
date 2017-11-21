DOCKER = docker run -it --rm -v $(PWD):/testplugin -v $(PWD)/test:/test -v $(PWD)/build:/build "spacevim/vims"

ifeq ($(VIM),nvim) 
  DEFAULT_VIM:=$(DOCKER) neovim-stable
else
  DEFAULT_VIM:=$(DOCKER) vim8
endif

test: build/vader | build
	$(DEFAULT_VIM) -Nu test/vimrc -c 'Vader! test/**'

COVIMERAGE=$(shell command -v ccovimerage 2>/dev/null || echo build/covimerage/bin/covimerage)

test_coverage: $(COVIMERAGE) build/vader | build
	$(COVIMERAGE) run $(DEFAULT_VIM) -Nu test/vimrc -c 'Vader! test/**'

build/covimerage:
	virtualenv $@
build/covimerage/bin/covimerage: | build/covimerage
	build/covimerage/bin/pip install covimerage

build/vader:
	git clone --depth 1 https://github.com/junegunn/vader.vim.git $@

build:
	mkdir -p $@

clean:
	$(RM) -r build

.PHONY: clean test
