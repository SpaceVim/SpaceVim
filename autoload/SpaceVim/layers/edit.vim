function! SpaceVim#layers#edit#plugins() abort
    let plugins = [
                \ ['tpope/vim-surround'],
                \ ['junegunn/vim-emoji'],
                \ ['terryma/vim-multiple-cursors'],
                \ ['terryma/vim-expand-region', { 'loadconf' : 1}],
                \ ['kana/vim-textobj-user'],
                \ ['kana/vim-textobj-indent'],
                \ ['kana/vim-textobj-line'],
                \ ['kana/vim-textobj-entire'],
                \ ['scrooloose/nerdcommenter', { 'loadconf' : 1}],
                \ ['mattn/emmet-vim',                        { 'on_cmd' : 'EmmetInstall'}],
                \ ['gcmt/wildfire.vim',{'on_map' : '<Plug>(wildfire-'}],
                \ ['easymotion/vim-easymotion'],
                \ ['haya14busa/vim-easyoperator-line'],
                \ ['editorconfig/editorconfig-vim', { 'on_cmd' : 'EditorConfigReload'}],
                \ ['floobits/floobits-neovim',      { 'on_cmd' : ['FlooJoinWorkspace','FlooShareDirPublic','FlooShareDirPrivate']}],
                \ ]
    if executable('fcitx')
        call add(plugins,['lilydjwg/fcitx.vim',        { 'on_event' : 'InsertEnter'}])
    endif
    return plugins
endfunction

function! SpaceVim#layers#edit#config() abort
    let g:multi_cursor_next_key='<C-j>'
    let g:multi_cursor_prev_key='<C-k>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'
    let g:user_emmet_install_global = 0
    let g:user_emmet_leader_key='<C-e>'
    let g:user_emmet_mode='a'
    let g:user_emmet_settings = {
                \  'jsp' : {
                \      'extends' : 'html',
                \  },
                \}
    "noremap <SPACE> <Plug>(wildfire-fuel)
    vnoremap <C-SPACE> <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']
endfunction
