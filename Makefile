test: build/vader | build
	$(VIM_BIN) -Nu test/vimrc -c 'Vader! test/**'

COVIMERAGE=$(shell command -v covimerage 2>/dev/null || echo build/covimerage/bin/covimerage)

test_coverage: $(COVIMERAGE) build/vader | build
	$(COVIMERAGE) run --source after $(VIM_BIN) -Nu test/vimrc -c 'Vader! test/**'
	$(COVIMERAGE) run --source autoload $(VIM_BIN) -Nu test/vimrc -c 'Vader! test/**'
	$(COVIMERAGE) run --source colors $(VIM_BIN) -Nu test/vimrc -c 'Vader! test/**'
	$(COVIMERAGE) run --source config $(VIM_BIN) -Nu test/vimrc -c 'Vader! test/**'
	$(COVIMERAGE) run --source ftplugin $(VIM_BIN) -Nu test/vimrc -c 'Vader! test/**'

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
