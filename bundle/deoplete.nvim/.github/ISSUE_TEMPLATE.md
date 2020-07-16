**Warning:  I will close the issue without the minimal init.vim and the reproduction instructions.**

# Problems summary


## Expected


## Environment Information

 * deoplete version (SHA1):

 * OS:

 * neovim/Vim `:version` output:

 * `:checkhealth` or `:CheckHealth` result(neovim only):

## Provide a minimal init.vim/vimrc with less than 50 lines (Required!)

```vim
" Your minimal init.vim/vimrc
set runtimepath+=~/path/to/deoplete.nvim/
let g:deoplete#enable_at_startup = 1

" For Vim only
"set runtimepath+=~/path/to/nvim-yarp/
"set runtimepath+=~/path/to/vim-hug-neovim-rpc/
```


## How to reproduce the problem from neovim/Vim startup (Required!)

 1. foo
 2. bar
 3. baz


## Generate a logfile if appropriate

 1. export NVIM_PYTHON_LOG_FILE=/tmp/log
 2. export NVIM_PYTHON_LOG_LEVEL=DEBUG
 3. nvim -u minimal.vimrc
 4. some works
 5. cat /tmp/log_{PID}


## Screenshot (if possible)


## Upload the log file
