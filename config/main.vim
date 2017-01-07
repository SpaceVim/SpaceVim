let g:Config_Main_Home = fnamemodify(expand('<sfile>'), ':p:h:gs?\\?'.((has('win16') || has('win32') || has('win64'))?'\':'/') . '?')

try
    call zvim#util#source_rc('functions.vim')
catch
    execute 'set rtp +=' . fnamemodify(g:Config_Main_Home, ':p:h:h')
    call zvim#util#source_rc('functions.vim')
endtry


call zvim#util#source_rc('init.vim')

call SpaceVim#default()

call SpaceVim#loadCustomConfig()

call SpaceVim#end()

call zvim#util#source_rc('general.vim')



call SpaceVim#autocmds#init()

if has('nvim')
    call zvim#util#source_rc('neovim.vim')
endif

call zvim#util#source_rc('commands.vim')
filetype plugin indent on
syntax on
