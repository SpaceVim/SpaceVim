"=============================================================================
" init.vim --- local config for SpaceVim development
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let g:spacevim_force_global_config = 1
call SpaceVim#custom#SPC('nnoremap', ['a', 'r'], 'call SpaceVim#dev#releases#open()', 'Release SpaceVim', 1)
call SpaceVim#custom#SPC('nnoremap', ['a', 'w'], 'call SpaceVim#dev#website#open()', 'Open SpaceVim local website', 1)
call SpaceVim#custom#SPC('nnoremap', ['a', 't'], 'call SpaceVim#dev#website#terminal()', 'Close SpaceVim local website', 1)
