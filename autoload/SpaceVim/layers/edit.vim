function! SpaceVim#layers#edit#plugins() abort
    let plugins = [
                \ ['tpope/vim-surround'],
                \ ['junegunn/vim-emoji'],
                \ ['terryma/vim-multiple-cursors'],
                \ ['scrooloose/nerdcommenter'],
                \ ['mattn/emmet-vim',                        { 'on_cmd' : 'EmmetInstall'}],
                \ ['gcmt/wildfire.vim',{'on_map' : '<Plug>(wildfire-'}],
                \ ['easymotion/vim-easymotion',{'on_map' : '<Plug>(easymotion-prefix)', 'on_func' : 'EasyMotion#go'}],
                \ ['editorconfig/editorconfig-vim', { 'on_cmd' : 'EditorConfigReload'}],
                \ ['floobits/floobits-neovim',      { 'on_cmd' : ['FlooJoinWorkspace','FlooShareDirPublic','FlooShareDirPrivate']}],
                \ ]
    if executable('fcitx')
        call add(plugins,['lilydjwg/fcitx.vim',        { 'on_i' : 1}])
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
    map <Leader><Leader> <Plug>(easymotion-prefix)
endfunction
