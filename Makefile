test: build/vader | build
	vim -Nu test/vimrc -c 'Vader! test/**'

test_coverage: build/covimerage build/vader | build
	build/covimerage/bin/covimerage run vim -Nu test/vimrc -c 'Vader! test/**'

build/covimerage:
	virtualenv $@
	. $@/bin/activate && pip install --no-cache-dir https://github.com/Vimjas/covimerage/archive/develop.zip

build/vader:
	git clone --depth 1 https://github.com/junegunn/vader.vim.git $@

build:
	mkdir -p $@

clean:
	$(RM) -r build

.PHONY: clean test
