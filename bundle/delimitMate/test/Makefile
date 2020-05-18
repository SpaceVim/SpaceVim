all: build/runVimTests
	build/runVimTests/bin/runVimTests.sh -0 .

build/runVimTests: build/VimTAP
	git clone https://github.com/inkarkat/runVimTests $@

# Use VimTAP as directory name, as used with runVimTestsSetup.vim.
build/VimTAP:
	git clone https://github.com/inkarkat/vimtap $@
