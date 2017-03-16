function! SpaceVim#mapping#leader#defindglobalMappings() abort
  inoremap <silent> <Leader><Tab> <C-r>=MyLeaderTabfunc()<CR>

  "for buftabs
  noremap <silent><Leader>bp :bprev<CR>
  noremap <silent><Leader>bn :bnext<CR>

  "background
  noremap <silent><leader>bg :call ToggleBG()<CR>
  "numbers
  noremap <silent><leader>nu :call ToggleNumber()<CR>

  " yark and paste
  vmap <Leader>y "+y
  vmap <Leader>d "+d
  nmap <Leader>p "+p
  nmap <Leader>P "+P
  vmap <Leader>p "+p
  vmap <Leader>P "+P

  cnoremap <Leader><C-F> <C-F>
  "When pressing <leader>cd switch to the directory of the open buffer
  map <Leader>cd :cd %:p:h<CR>:pwd<CR>

  " Fast saving
  call SpaceVim#mapping#def('nnoremap', '<Leader>w', ':w<CR>',
        \ 'Save current file',
        \ 'w',
        \ 'Save current file')
  call SpaceVim#mapping#def('vnoremap', '<Leader>w', '<Esc>:w<CR>',
        \ 'Save current file',
        \ 'w',
        \ 'Save current file')

  let g:_spacevim_mappings.t = {'name' : 'Toggle editor visuals'}
  nmap <Leader>ts :setlocal spell!<cr>
  nmap <Leader>tn :setlocal nonumber! norelativenumber!<CR>
  nmap <Leader>tl :setlocal nolist!<CR>
  nmap <Leader>th :nohlsearch<CR>
  nmap <Leader>tw :setlocal wrap! breakindent!<CR>

  " Location list movement
  let g:_spacevim_mappings.l = {'name' : 'Location list movement'}
  call SpaceVim#mapping#def('nnoremap', '<Leader>lj', ':lnext<CR>',
        \ 'Jump to next location list position',
        \ 'lnext',
        \ 'Next location list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>lk', ':lprev<CR>',
        \ 'Jump to previous location list position',
        \ 'lprev',
        \ 'Previous location list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>lq', ':lclose<CR>',
        \ 'Close the window showing the location list',
        \ 'lclose',
        \ 'Close location list window')

  " quickfix list movement
  let g:_spacevim_mappings.q = {'name' : 'Quickfix list movement'}
  call SpaceVim#mapping#def('nnoremap', '<Leader>qj', ':cnext<CR>',
        \ 'Jump to next quickfix list position',
        \ 'cnext',
        \ 'Next quickfix list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>qk', ':cprev<CR>',
        \ 'Jump to previous quickfix list position',
        \ 'cprev',
        \ 'Previous quickfix list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>qq', ':cclose<CR>',
        \ 'Close quickfix list window',
        \ 'cclose',
        \ 'Close quickfix list window')
  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>qr', 'q',
        \ 'Toggle recording',
        \ '',
        \ 'Toggle recording mode')

  " Duplicate lines
  nnoremap <Leader>d m`YP``
  vnoremap <Leader>d YPgv

  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader><C-c>',
        \ ':<c-u>call zvim#util#CopyToClipboard(1)<cr>',
        \ 'Yank the github link of current file to X11 clipboard',
        \ 'call zvim#util#CopyToClipboard(1)')
  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader><C-l>',
        \ ':<c-u>call zvim#util#CopyToClipboard(2)<cr>',
        \ 'Yank the github link of current line to X11 clipboard',
        \ 'call zvim#util#CopyToClipboard(2)')
  call SpaceVim#mapping#def('vnoremap <silent>', '<Leader><C-l>',
        \ ':<c-u>call zvim#util#CopyToClipboard(3)<cr>',
        \ 'Yank the github link of current selection to X11 clipboard',
        \ 'call zvim#util#CopyToClipboard(3)')
  call SpaceVim#mapping#def('vnoremap', '<Leader>S', "y:execute @@<CR>:echo 'Sourced selection.'<CR>",
        \ 'Sourced selection.',
        \ "echo 'Use <leader>S to sourced selection.'")
  call SpaceVim#mapping#def('nnoremap','<Leader>S',"^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>",'Source line',
        \ "echo 'Use <leader>S to sourced line.'")

  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>sv', ':call SpaceVim#mapping#split_previous_buffer()<CR>',
        \'Open previous buffer in split window' , 'call SpaceVim#mapping#split_previous_buffer()', 'Split previout buffer')
  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>sg', ':call SpaceVim#mapping#vertical_split_previous_buffer()<CR>',
        \'Open previous buffer in vsplit window' , 'call SpaceVim#mapping#vertical_split_previous_buffer()')
endfunction

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
    call zvim#util#defineMap('nnoremap <silent>', '[Window]Q',
          \ ':<C-u>call SpaceVim#mapping#close_current_buffer()<CR>',
          \ 'delete current windows',
          \ 'call SpaceVim#mapping#close_current_buffer()')
    call zvim#util#defineMap('nnoremap <silent>', '[Window]c', ':<C-u>call SpaceVim#mapping#clearBuffers()<CR>',
          \'Clear all the buffers','call SpaceVim#mapping#clearBuffers()')
  endif
endfunction

function! SpaceVim#mapping#leader#defindUniteLeader(key) abort
  if !empty(a:key)
    " The prefix key.
    nnoremap    [unite]   <Nop>
    exe 'nmap ' .a:key . ' [unite]'
    nnoremap <silent> [unite]r
          \ :<C-u>Unite -buffer-name=resume resume<CR>
    if has('nvim')
      nnoremap <silent> [unite]f  :<C-u>Unite file_rec/neovim<cr>
    else
      nnoremap <silent> [unite]f  :<C-u>Unite file_rec/async<cr>
    endif
    nnoremap <silent> [unite]i  :<C-u>Unite file_rec/git<cr>
    nnoremap <silent> [unite]g  :<C-u>Unite grep<cr>
    nnoremap <silent> [unite]u  :<C-u>Unite source<CR>
    nnoremap <silent> [unite]t  :<C-u>Unite tag<CR>
    nnoremap <silent> [unite]T  :<C-u>Unite tag/include<CR>
    nnoremap <silent> [unite]l  :<C-u>Unite locationlist<CR>
    nnoremap <silent> [unite]q  :<C-u>Unite quickfix<CR>
    nnoremap <silent> [unite]e  :<C-u>Unite
          \ -buffer-name=register register<CR>
    nnoremap <silent> [unite]j  :<C-u>Unite jump<CR>
    nnoremap <silent> [unite]h  :<C-u>Unite history/yank<CR>
    nnoremap <silent> [unite]<C-h>  :<C-u>UniteWithCursorWord help<CR>
    nnoremap <silent> [unite]s  :<C-u>Unite session<CR>
    nnoremap <silent> [unite]o  :<C-u>Unite -buffer-name=outline -start-insert -auto-preview -split outline<CR>
    nnoremap <silent> [unite]ma
          \ :<C-u>Unite mapping<CR>
    nnoremap <silent> [unite]me
          \ :<C-u>Unite output:message<CR>

    nnoremap <silent> [unite]c  :<C-u>UniteWithCurrentDir
          \ -buffer-name=files buffer bookmark file<CR>
    nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir
          \ -buffer-name=files -prompt=%\  buffer bookmark file<CR>
    nnoremap <silent> [unite]n  :<C-u>Unite session/new<CR>
    nnoremap <silent> [unite]/ :Unite -auto-preview grep:.<cr>
    nnoremap <silent> [unite]w
          \ :<C-u>Unite -buffer-name=files -no-split
          \ jump_point file_point buffer_tab
          \ file_rec:! file file/new<CR>
    nnoremap <silent>[unite]<Space> :Unite -silent -ignorecase -winheight=17 -start-insert menu:CustomKeyMaps<CR>
  endif
endfunction

" vim:set et sw=2 cc=80:
