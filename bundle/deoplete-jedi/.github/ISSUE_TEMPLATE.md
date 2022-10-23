# Problem summary


## Expected


## Environment Information

 * OS:
 * Neovim version:


## Provide a minimal init.vim with less than 50 lines (required)

```vim
" Use the following as a template.
set runtimepath+=~/path/to/deoplete.nvim/
set runtimepath+=~/path/to/deoplete-jedi/
let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('jedi', 'is_debug_enabled', 1)
call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')
```

## Generate logfiles if appropriate

 1. export NVIM_PYTHON_LOG_FILE=/tmp/nvim-log
 2. export NVIM_PYTHON_LOG_LEVEL=DEBUG
 3. nvim -u minimal.vimrc

Then look at and attach the files `/tmp/nvim-log_{PID}` and
`/tmp/deoplete.log` here.


## Steps to reproduce the issue after starting Neovim (required)

 1.
 2.
 3.


## Screen shot (if possible)


## Upload the logfile(s)
