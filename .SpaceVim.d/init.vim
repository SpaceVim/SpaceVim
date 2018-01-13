let g:spacevim_force_global_config = 1
call SpaceVim#custom#SPC('nnoremap', ['a', 'r'], 'call SpaceVim#dev#releases#open()', 'Release SpaceVim', 1)
call SpaceVim#custom#SPC('nnoremap', ['a', 'w'], 'call SpaceVim#dev#website#open()', 'Open SpaceVim local website', 1)
call SpaceVim#custom#SPC('nnoremap', ['a', 't'], 'call SpaceVim#dev#website#terminal()', 'Close SpaceVim local website', 1)
