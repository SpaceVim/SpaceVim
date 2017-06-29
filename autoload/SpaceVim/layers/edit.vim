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
    let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
    let g:_spacevim_mappings_space.i.l = {'name' : '+Lorem-ipsum'}
    let g:_spacevim_mappings_space.i.p = {'name' : '+Passwords'}
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 1], 'call call('
                \ . string(s:_function('s:insert_simple_password')) . ', [])',
                \ 'insert simple password', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 2], 'call call('
                \ . string(s:_function('s:insert_stronger_password')) . ', [])',
                \ 'insert stronger password', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 3], 'call call('
                \ . string(s:_function('s:insert_paranoid_password')) . ', [])',
                \ 'insert password for paranoids', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'p'], 'call call('
                \ . string(s:_function('s:insert_phonetically_password')) . ', [])',
                \ 'insert a phonetically easy password', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'n'], 'call call('
                \ . string(s:_function('s:insert_numerical_password')) . ', [])',
                \ 'insert a numerical password', 1)
endfunction

let s:PASSWORD = SpaceVim#api#import('password')
function! s:insert_simple_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_simple(8)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_stronger_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_strong(12)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_paranoid_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_paranoid(20)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_numerical_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_numeric(4)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_phonetically_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_phonetic(8)
    normal! "kPl
    let @k = save_register
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
    function! s:_function(fstr) abort
        return function(a:fstr)
    endfunction
else
    function! s:_SID() abort
        return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
    endfunction
    let s:_s = '<SNR>' . s:_SID() . '_'
    function! s:_function(fstr) abort
        return function(substitute(a:fstr, 's:', s:_s, 'g'))
    endfunction
endif
