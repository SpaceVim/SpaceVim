function! SpaceVim#mapping#space#init() abort
    if s:has_map_to_spc()
        return
    endif
    nnoremap <silent><nowait> [SPC] :<c-u>LeaderGuide " "<CR>
    nmap <Space> [SPC]
    let g:_spacevim_mappings_space = {}
    let g:_spacevim_mappings_prefixs['[SPC]'] = {'name' : '+SPC prefix'}
    let g:_spacevim_mappings_space['?'] = ['Unite menu:CustomKeyMaps -input=[SPC]', 'show mappings']
    let g:_spacevim_mappings_space.t = {'name' : '+Toggles'}
    let g:_spacevim_mappings_space.t.h = {'name' : '+Toggles highlight'}
    let g:_spacevim_mappings_space.t.m = {'name' : '+modeline'}
    let g:_spacevim_mappings_space.T = {'name' : '+UI toggles/themes'}
    let g:_spacevim_mappings_space.a = {'name' : '+Applications'}
    let g:_spacevim_mappings_space.b = {'name' : '+Buffers'}
    let g:_spacevim_mappings_space.f = {'name' : '+Files'}
    let g:_spacevim_mappings_space.j = {'name' : '+Jump/Join/Split'}
    let g:_spacevim_mappings_space.w = {'name' : '+Windows'}
    let g:_spacevim_mappings_space.p = {'name' : '+Projects'}
    let g:_spacevim_mappings_space.h = {'name' : '+Help'}
    let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
    " Windows
    for i in range(1, 9)
        exe "call SpaceVim#mapping#space#def('nnoremap', [" . i . "], 'call SpaceVim#layers#core#statusline#jump(" . i . ")', 'window " . i . "', 1)"
    endfor
    let g:_spacevim_mappings_space.w['<Tab>'] = ['wincmd w', 'alternate-window']
    nnoremap <silent> [SPC]w<tab> :wincmd w<cr>
    call SpaceVim#mapping#menu('alternate-window', '[SPC]w<Tab>', 'wincmd w')
    call SpaceVim#mapping#space#def('nnoremap', ['w', '+'], 
                \ 'call call('
                \ . string(function('s:windows_layout_toggle'))
                \ . ', [])', 'windows-layout-toggle', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'c'], 'Goyo', 'centered-buffer-mode', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'C'], 'ChooseWin | Goyo', 'centered-buffer-mode(other windows)', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'd'], 'close', 'delete window', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'D'], 'ChooseWin | close | wincmd w', 'delete window (other windows)', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'F'], 'tabnew', 'create new tab', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'h'], 'wincmd h', 'window-left', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'j'], 'wincmd j', 'window-down', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'k'], 'wincmd k', 'window-up', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'l'], 'wincmd l', 'window-right', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'H'], 'wincmd H', 'window-far-left', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'J'], 'wincmd J', 'window-far-down', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'K'], 'wincmd K', 'window-far-up', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'L'], 'wincmd L', 'window-far-right', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'm'], 'only', 'maximize/minimize window', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'M'], 'ChooseWinSwap', 'swap window', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'o'], 'tabnext', 'other tabs', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', '/'], 'bel vs | wincmd w', 'split-window-right', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'v'], 'bel vs | wincmd w', 'split-window-right', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', '-'], 'bel split | wincmd w', 'split-window-below', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', '2'], 'silent only | vs | wincmd w', 'layout-double-columns', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', '3'], 'silent only | vs | vs | wincmd H', 'split-window-below', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'V'], 'bel vs', 'split-window-right-focus', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', '='], 'wincmd =', 'balance-windows', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'w'], 'wincmd w', 'cycle and focus between windows', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'W'], 'ChooseWin', 'select window', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'u'], 'call SpaceVim#plugins#windowsmanager#UndoQuitWin()', 'undo quieted window', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'U'], 'call SpaceVim#plugins#windowsmanager#RedoQuitWin()', 'redo quieted window', 1)
    nnoremap <silent> [SPC]bn :bnext<CR>
    let g:_spacevim_mappings_space.b.n = ['bnext', 'next buffer']
    call SpaceVim#mapping#menu('Open next buffer', '[SPC]bn', 'bp')
    nnoremap <silent> [SPC]bp :bp<CR>
    let g:_spacevim_mappings_space.b.p = ['bp', 'previous buffer']
    call SpaceVim#mapping#menu('Open previous buffer', '[SPC]bp', 'bp')
    let g:_spacevim_mappings_space.e = {'name' : '+Errors/Encoding'}
    let g:_spacevim_mappings_space.B = {'name' : '+Global-buffers'}
    nnoremap <silent> [SPC]tn  :<C-u>setlocal nonumber! norelativenumber!<CR>
    let g:_spacevim_mappings_space.t.n = ['setlocal nonumber! norelativenumber!', 'toggle line number']
    call SpaceVim#mapping#menu('toggle line number', '[SPC]tn', 'set nu!')
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'Unite buffer', 'buffer list', 1)
    call extend(g:_spacevim_mappings_prefixs['[SPC]'], get(g:, '_spacevim_mappings_space', {}))
endfunction

function! SpaceVim#mapping#space#def(m, keys, cmd, desc, is_cmd) abort
    if s:has_map_to_spc()
        return
    endif
    if a:is_cmd
        let cmd = ':<C-u>' . a:cmd . '<CR>' 
        let lcmd = a:cmd
    else
        let cmd = a:cmd
        let feedkey_m = a:m =~# 'nore' ? 'n' : 'm'
        if a:cmd =~? '^<plug>'
            let lcmd = 'call feedkeys("\' . a:cmd . '", "' . feedkey_m . '")'
        else
            let lcmd = 'call feedkeys("' . a:cmd . '", "' . feedkey_m . '")'
        endif
    endif
    exe a:m . ' <silent> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
    if len(a:keys) == 2
        let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]] = [lcmd, a:desc]
    elseif len(a:keys) == 3
        let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]][a:keys[2]] = [lcmd, a:desc]
    elseif len(a:keys) == 1
        let g:_spacevim_mappings_space[a:keys[0]] = [lcmd, a:desc]
    endif
    call SpaceVim#mapping#menu(a:desc, '[SPC]' . join(a:keys, ''), lcmd)
    call extend(g:_spacevim_mappings_prefixs['[SPC]'], get(g:, '_spacevim_mappings_space', {}))
endfunction

function! s:has_map_to_spc() abort
    return get(g:, 'mapleader', '\') ==# ' '
endfunction

function! s:windows_layout_toggle() abort
    if winnr('$') != 2
        echohl WarningMsg
        echom "Can't toggle window layout when the number of windows isn't two."
        echohl None
    else 
        if winnr() == 1
            let b = winbufnr(2)
        else
            let b = winbufnr(1)
        endif
        if winwidth(1) == &columns
            only
            vsplit
        else
            only
            split
        endif
        exe 'b'.b
        wincmd w
    endif
endfunction
function! SpaceVim#mapping#space#langSPC(m, keys, cmd, desc, is_cmd) abort
    if s:has_map_to_spc()
        return
    endif
    if a:is_cmd
        let cmd = ':<C-u>' . a:cmd . '<CR>' 
        let lcmd = a:cmd
    else
        let cmd = a:cmd
        let feedkey_m = a:m =~# 'nore' ? 'n' : 'm'
        if a:cmd =~? '^<plug>'
            let lcmd = 'call feedkeys("\' . a:cmd . '", "' . feedkey_m . '")'
        else
            let lcmd = 'call feedkeys("' . a:cmd . '", "' . feedkey_m . '")'
        endif
    endif
    exe a:m . ' <silent> <buffer> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
    if len(a:keys) == 2
        let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]] = [lcmd, a:desc]
    elseif len(a:keys) == 3
        let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]][a:keys[2]] = [lcmd, a:desc]
    elseif len(a:keys) == 1
        let g:_spacevim_mappings_space[a:keys[0]] = [lcmd, a:desc]
    endif
    call SpaceVim#mapping#menu(a:desc, '[SPC]' . join(a:keys, ''), lcmd)
    call extend(g:_spacevim_mappings_prefixs['[SPC]'], get(g:, '_spacevim_mappings_space', {}))
endfunction

