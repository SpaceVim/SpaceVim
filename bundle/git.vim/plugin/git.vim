"=============================================================================
" git.vim --- git plugin for spacevim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let g:loaded_git = 1

""
" Run git command asynchronously
command! -nargs=+ -complete=custom,git#complete Git call git#run(<f-args>)

call SpaceVim#plugins#projectmanager#reg_callback(function('git#branch#detect'))
