scriptencoding utf-8
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
    let g:multi_cursor_next_key     = '<C-j>'
    let g:multi_cursor_prev_key     = '<C-k>'
    let g:multi_cursor_skip_key     = '<C-x>'
    let g:multi_cursor_quit_key     = '<Esc>'
    let g:user_emmet_install_global = 0
    let g:user_emmet_leader_key     = '<C-e>'
    let g:user_emmet_mode           = 'a'
    let g:user_emmet_settings       = {
                \  'jsp' : {
                \      'extends' : 'html',
                \  },
                \}
    "noremap <SPACE> <Plug>(wildfire-fuel)
    vnoremap <C-SPACE> <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']
    let g:_spacevim_mappings_space.x = {'name' : '+Text'}
    let g:_spacevim_mappings_space.x.a = {'name' : '+align'}
    let g:_spacevim_mappings_space.x.d = {'name' : '+delete'}
    let g:_spacevim_mappings_space.x.i = {'name' : '+change symbol style'}
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '&'], 'Tabularize /&', 'align region at &', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '('], 'Tabularize /(', 'align region at (', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ')'], 'Tabularize /)', 'align region at )', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '['], 'Tabularize /[', 'align region at [', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ']'], 'Tabularize /]', 'align region at ]', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '{'], 'Tabularize /{', 'align region at {', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '}'], 'Tabularize /}', 'align region at }', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ','], 'Tabularize /,', 'align region at ,', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '.'], 'Tabularize /.', 'align region at .', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ':'], 'Tabularize /:', 'align region at :', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ';'], 'Tabularize /;', 'align region at ;', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '='], 'Tabularize /=', 'align region at =', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '¦'], 'Tabularize /¦', 'align region at ¦', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', 'w'], 'StripWhitespace', 'delete trailing whitespaces', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', '[SPC]'], 'silent call call('
                \ . string(s:_function('s:delete_extra_space')) . ', [])',
                \ 'delete extra space arround cursor', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'c'], 'silent call call('
                \ . string(s:_function('s:lowerCamelCase')) . ', [])',
                \ 'change symbol style to lowerCamelCase', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'C'], 'silent call call('
                \ . string(s:_function('s:UpperCamelCase')) . ', [])',
                \ 'change symbol style to UpperCamelCase', 1)
endfunction

function! s:lowerCamelCase() abort
    " fooFzz
    let cword = expand('<cword>')
    if !empty(cword) && cword[0:0] =~# '[A-Z]'
        let save_cursor = getcurpos()
        normal! b~
        call setpos('.', save_cursor)
    endif
endfunction

function! s:UpperCamelCase() abort
    " FooFzz
    let cword = expand('<cword>')
    if !empty(cword) && cword[0:0] =~# '[a-z]'
        let save_cursor = getcurpos()
        normal! b~
        call setpos('.', save_cursor)
    endif
endfunction

function! s:kebab_case() abort
    " foo-fzz


endfunction

let s:STRING = SpaceVim#api#import('data#string')
function! s:parse_symbol(symbol) abort
    if a:symbol =~ '^[a-z]\+\(-[a-zA-Z]\+\)*$'
        return split(a:symbol, '-')
    elseif a:symbol =~ '^[a-z]\+\(_[a-zA-Z]\+\)*$'
        return split(a:symbol, '_')
    elseif a:symbol =~ '^[a-z]\+\([A-Z][a-z]\+\)*$'
        let chars = s:STRING.str2chars(a:symbol)
        let rst = []
        let word = ''
        for char in chars
            if char =~# '[a-z]'
                let word .= char
            else
                call add(rst, word)
                let word = char
            endif
        endfor
        if !empty(word)
            call add(rst, word)
        endif
        return rst
    else
        return [a:symbol]
    endif
endfunction


function! s:delete_extra_space() abort
    if !empty(getline('.'))
        if getline('.')[col('.')-1] ==# ' '
            exe "normal! viw\"_di\<Space>\<Esc>"
        endif
    endif
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
