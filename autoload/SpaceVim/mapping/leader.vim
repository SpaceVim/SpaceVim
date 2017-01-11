function! SpaceVim#mapping#leader#defindWindowsLeader(key) abort
    if !empty(a:key)
        call zvim#util#defineMap('nnoremap', '[Window]', '<Nop>'   , 'Defind window prefix'   ,'normal [Window]')
        call zvim#util#defineMap('nmap'    , a:key, '[Window]', 'Use ' . a:key . ' as window prefix' ,'normal ' . a:key)

        call zvim#util#defineMap('nnoremap <silent>', '[Window]p', ':<C-u>vsplit<CR>:wincmd w<CR>',
                    \'vsplit vertically,switch to next window','vsplit | wincmd w')
        call zvim#util#defineMap('nnoremap <silent>', '[Window]v', ':<C-u>split<CR>', 'split window','split')
        call zvim#util#defineMap('nnoremap <silent>', '[Window]g', ':<C-u>vsplit<CR>', 'vsplit window','vsplit')
        call zvim#util#defineMap('nnoremap <silent>', '[Window]t', ':<C-u>tabnew<CR>', 'Create new tab','tabnew')
        call zvim#util#defineMap('nnoremap <silent>', '[Window]o', ':<C-u>only<CR>', 'Close other windows','only')
        call zvim#util#defineMap('nnoremap <silent>', '[Window]x', ':<C-u>call zvim#util#BufferEmpty()<CR>',
                    \'Empty current buffer','call zvim#util#BufferEmpty()')
        call zvim#util#defineMap('nnoremap <silent>', '[Window]\', ':<C-u>b#<CR>', 'Switch to the last buffer','b#')
        call zvim#util#defineMap('nnoremap <silent>', '[Window]q', ':<C-u>close<CR>', 'Close current windows','close')
    endif
endfunction

function! SpaceVim#mapping#leader#defindUniteLeader(key) abort
    
endfunction
