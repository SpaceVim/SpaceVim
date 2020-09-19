The plugins runVimTests (http://www.vim.org/scripts/script.php?script_id=2565)
and VimTAP (http://www.vim.org/scripts/script.php?script_id=2213) are needed to
run these tests.

Besides the _setup.vim configuration file present in this repo you need to
create a global one and place it in the same dir where the runVimTests
executable is located. Assuming the executable is at '~/bin/runVimTests' this
global configuration file should be '~/bin/runVimTestsSetup.vim' and should
have something like the following lines inside of it:

" Prepend tests repos to &rtp
let &runtimepath = '/path/to/runVimTests_dir,' . &rtp
let &runtimepath = '/path/to/vimTAP_dir,' . &rtp
