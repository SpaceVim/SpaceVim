"=============================================================================
" leader.vim --- mapping leader definition file for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:file = expand('<sfile>:~')

function! SpaceVim#mapping#leader#defindglobalMappings() abort
  if g:spacevim_enable_insert_leader
    inoremap <silent> <Leader><Tab> <C-r>=MyLeaderTabfunc()<CR>
  endif

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
  call SpaceVim#mapping#def('vnoremap', '<Leader>S',
        \ "y:execute @@<CR>:echo 'Sourced selection.'<CR>",
        \ 'Sourced selection.',
        \ "echo 'Use <leader>S to sourced selection.'")
  call SpaceVim#mapping#def('nnoremap', '<Leader>S',
        \ "^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>",
        \ 'Source line',
        \ "echo 'Use <leader>S to sourced line.'")

  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>sv',
        \ ':call SpaceVim#mapping#split_previous_buffer()<CR>',
        \ 'Open previous buffer in split window',
        \ 'call SpaceVim#mapping#split_previous_buffer()',
        \ 'Split previout buffer')
  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>sg',
        \ ':call SpaceVim#mapping#vertical_split_previous_buffer()<CR>',
        \ 'Open previous buffer in vsplit window' ,
        \ 'call SpaceVim#mapping#vertical_split_previous_buffer()')
endfunction

let s:lnum = expand('<slnum>') + 3
function! SpaceVim#mapping#leader#defindWindowsLeader(key) abort
  if !empty(a:key)
    exe 'nnoremap <silent><nowait> [Window] :<c-u>LeaderGuide "' .
          \ a:key . '"<CR>'
    exe 'nmap ' .a:key . ' [Window]'
    let g:_spacevim_mappings_windows = {}
    nnoremap <silent> [Window]p
          \ :<C-u>vsplit<CR>:wincmd w<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.p = ['vsplit | wincmd w',
          \ 'vsplit vertically,switch to next window',
          \ [
          \ '[WIN p ] is to split windows vertically, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]v
          \ :<C-u>split<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.v = ['split',
          \ 'split window',
          \ [
          \ '[WIN v] is to split windows, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]g
          \ :<C-u>vsplit<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.g = ['vsplit',
          \ 'vsplit window',
          \ [
          \ '[WIN g] is to split windows vertically, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]t
          \ :<C-u>tabnew<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.t = ['tabnew',
          \ 'create new tab',
          \ [
          \ '[WIN t] is to create new tab',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]o
          \ :<C-u>only<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.o = ['only',
          \ 'Close other windows',
          \ [
          \ '[WIN o] is to close all other windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]x
          \ :<C-u>call zvim#util#BufferEmpty()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.x = ['call zvim#util#BufferEmpty()',
          \ 'Empty current buffer',
          \ [
          \ '[WIN x] is to empty current buffer',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]\
          \ :<C-u>b#<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows['\'] = ['b#',
          \ 'Switch to the last buffer',
          \ [
          \ '[WIN \] is to switch to the last buffer',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]Q
          \ :<C-u>close<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.Q = ['close',
          \ 'Close current windows',
          \ [
          \ '[WIN Q] is to close current windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]q
          \ :<C-u>call SpaceVim#mapping#close_current_buffer()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.q = ['call SpaceVim#mapping#close_current_buffer()',
          \ 'delete current windows',
          \ [
          \ '[WIN q] is to delete current windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]c
          \ :<C-u>call SpaceVim#mapping#clearBuffers()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.c = ['call SpaceVim#mapping#clearBuffers()',
          \ 'Clear all the buffers',
          \ [
          \ '[WIN c] is to clear all the buffers',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  endif
endfunction

function! SpaceVim#mapping#leader#defindDeniteLeader(key) abort
  if !empty(a:key)
    if a:key ==# 'F'
      nnoremap <leader>F F
    endif
    exe 'nnoremap <silent><nowait> [denite] :<c-u>LeaderGuide "' .
          \ a:key . '"<CR>'
    exe 'nmap ' .a:key . ' [denite]'
    let g:_spacevim_mappings_denite = {}
    nnoremap <silent> [denite]r
          \ :<C-u>Denite -resume<CR>
    let g:_spacevim_mappings_denite.r = ['Denite -resume',
          \ 'resume denite window']
    nnoremap <silent> [denite]f  :<C-u>Denite file_rec<cr>
    let g:_spacevim_mappings_denite.f = ['Denite file_rec', 'file_rec']
    nnoremap <silent> [denite]i  :<C-u>Denite file_rec/git<cr>
    let g:_spacevim_mappings_denite.i = ['Denite file_rec/git', 'git files']
    nnoremap <silent> [denite]g  :<C-u>Denite grep<cr>
    let g:_spacevim_mappings_denite.g = ['Denite grep', 'denite grep']
    nnoremap <silent> [denite]t  :<C-u>Denite tag<CR>
    let g:_spacevim_mappings_denite.t = ['Denite tag', 'denite tag']
    nnoremap <silent> [denite]T  :<C-u>Denite tag:include<CR>
    let g:_spacevim_mappings_denite.T = ['Denite tag/include',
          \ 'denite tag/include']
    nnoremap <silent> [denite]j  :<C-u>Denite jump<CR>
    let g:_spacevim_mappings_denite.j = ['Denite jump', 'denite jump']
    nnoremap <silent> [denite]h  :<C-u>Denite neoyank<CR>
    let g:_spacevim_mappings_denite.h = ['Denite neoyank', 'denite neoyank']
    nnoremap <silent> [denite]<C-h>  :<C-u>DeniteCursorWord help<CR>
    let g:_spacevim_mappings_denite['<C-h>'] = ['DeniteCursorWord help',
          \ 'denite with cursor word help']
    nnoremap <silent> [denite]o  :<C-u>Denite -buffer-name=outline
          \  -auto-preview outline<CR>
    let g:_spacevim_mappings_denite.o = ['Denite outline', 'denite outline']
    nnoremap <silent> [denite]e  :<C-u>Denite
          \ -buffer-name=register register<CR>
    let g:_spacevim_mappings_denite.e = ['Denite register', 'denite register']
    nnoremap <silent> [denite]<Space> :Denite menu:CustomKeyMaps<CR>
    let g:_spacevim_mappings_denite['<space>'] = ['Denite menu:CustomKeyMaps',
          \ 'denite customkeymaps']
  endif
endfunction

let s:unite_lnum = expand('<slnum>') + 3
function! SpaceVim#mapping#leader#defindUniteLeader(key) abort
  if !empty(a:key)
    if a:key ==# 'f'
      nnoremap <leader>f f
    endif
    " The prefix key.
    exe 'nnoremap <silent><nowait> [unite] :<c-u>LeaderGuide "' .
          \ a:key . '"<CR>'
    exe 'nmap ' .a:key . ' [unite]'
    let g:_spacevim_mappings_unite = {}
    nnoremap <silent> [unite]r
          \ :<C-u>Unite -buffer-name=resume resume<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.r = ['Unite -buffer-name=resume resume',
          \ 'resume unite window',
          \ [
          \ '[UNITE r ] is to resume unite window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    if has('nvim')
      nnoremap <silent> [unite]f
            \ :<C-u>Unite file_rec/neovim<cr>
      let lnum = expand('<slnum>') + s:unite_lnum - 4
      let g:_spacevim_mappings_unite.f = ['Unite file_rec/neovim',
            \ 'file_rec',
            \ [
            \ '[UNITE f ] is to open unite file_rec source',
            \ '',
            \ 'Definition: ' . s:file . ':' . lnum,
            \ ]
            \ ]
    else
      nnoremap <silent> [unite]f
            \ :<C-u>Unite file_rec/async<cr>
      let lnum = expand('<slnum>') + s:unite_lnum - 4
      let g:_spacevim_mappings_unite.f = ['Unite file_rec/async',
            \ 'file_rec',
            \ [
            \ '[UNITE f ] is to open unite file_rec source',
            \ '',
            \ 'Definition: ' . s:file . ':' . lnum,
            \ ]
            \ ]
    endif
    nnoremap <silent> [unite]i
          \ :<C-u>Unite file_rec/git<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.i = ['Unite file_rec/git',
          \ 'git files',
          \ [
          \ '[UNITE f ] is to open unite file_rec source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]g
          \ :<C-u>Unite grep<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.g = ['Unite grep',
          \ 'unite grep',
          \ [
          \ '[UNITE g ] is to open unite grep source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]u
          \ :<C-u>Unite source<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.u = ['Unite source',
          \ 'unite source',
          \ [
          \ '[UNITE u ] is to open unite source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]t
          \ :<C-u>Unite tag<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.t = ['Unite tag',
          \ 'unite tag',
          \ [
          \ '[UNITE t ] is to open unite tag source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]T
          \ :<C-u>Unite tag/include<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.T = ['Unite tag/include',
          \ 'unite tag/include',
          \ [
          \ '[UNITE T ] is to open unite tag/include source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]l
          \ :<C-u>Unite locationlist<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.l = ['Unite locationlist',
          \ 'unite locationlist',
          \ [
          \ '[UNITE l ] is to open unite locationlist source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]q
          \ :<C-u>Unite quickfix<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.q = ['Unite quickfix',
          \ 'unite quickfix',
          \ [
          \ '[UNITE q ] is to open unite quickfix source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]e  :<C-u>Unite
          \ -buffer-name=register register<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.e = ['Unite register',
          \ 'unite register',
          \ [
          \ '[UNITE l ] is to open unite locationlist source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]j
          \ :<C-u>Unite jump<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.j = ['Unite jump',
          \ 'unite jump',
          \ [
          \ '[UNITE j ] is to open unite jump source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]h
          \ :<C-u>Unite history/yank<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.h = ['Unite history/yank',
          \ 'unite history/yank',
          \ [
          \ '[UNITE h ] is to open unite history/yank source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]<C-h>
          \ :<C-u>UniteWithCursorWord help<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite['<C-h>'] = ['UniteWithCursorWord help',
          \ 'unite with cursor word help',
          \ [
          \ '[UNITE <c-h> ] is to open unite help source for cursor word',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]s
          \ :<C-u>Unite session<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.s = ['Unite session',
          \ 'unite session',
          \ [
          \ '[UNITE s ] is to open unite session source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]o  :<C-u>Unite -buffer-name=outline
          \ -start-insert -auto-preview -split outline<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.o = ['Unite outline',
          \ 'unite outline',
          \ [
          \ '[UNITE o ] is to open unite outline source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

    " menu
    nnoremap <silent> [unite]ma
          \ :<C-u>Unite mapping<CR>
    nnoremap <silent> [unite]me
          \ :<C-u>Unite output:message<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 6
    let g:_spacevim_mappings_unite.m = {'name' : '+Menus',
          \ 'a' : ['Unite mapping', 'unite mappings',
          \ [
          \ '[UNITE m a ] is to open unite mapping menu',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ],
          \ 'e' : ['Unite output:message', 'unite messages',
          \ [
          \ '[UNITE o ] is to open unite message menu',
          \ '',
          \ 'Definition: ' . s:file . ':' . (lnum + 2),
          \ ]
          \ ]
          \ }

    nnoremap <silent> [unite]c  :<C-u>UniteWithCurrentDir
          \ -buffer-name=files buffer bookmark file<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.c =
          \ ['UniteWithCurrentDir -buffer-name=files buffer bookmark file',
          \ 'unite files in current dir',
          \ [
          \ '[UNITE c ] is to open unite outline source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir
          \ -buffer-name=files -prompt=%\  buffer bookmark file<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.b =
          \ ['UniteWithBufferDir -buffer-name=files' .
          \ ' buffer bookmark file',
          \ 'unite files in current dir',
          \ [
          \ '[UNITE b ] is to open unite buffer and bookmark source with cursor',
          \ 'word',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]n
          \ :<C-u>Unite session/new<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.n = ['Unite session/new',
          \ 'unite session/new',
          \ [
          \ '[UNITE n ] is to create new vim session',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]/
          \ :Unite grep:.<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite['/'] = ['Unite grep:.',
          \ 'unite grep with preview',
          \ [
          \ '[UNITE / ] is to open unite grep source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]w
          \ :<C-u>Unite -buffer-name=files -no-split
          \ jump_point file_point buffer_tab
          \ file_rec:! file file/new<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 6
    let g:_spacevim_mappings_unite.w= ['Unite -buffer-name=files -no-split' .
          \ ' jump_point file_point buffer_tab file_rec:! file file/new',
          \ 'unite all file and jump',
          \ [
          \ '[UNITE w ] is to open unite jump_point file_point and buffer_tab',
          \ 'source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent>[unite]<Space> :Unite -silent -ignorecase -winheight=17
          \ -start-insert menu:CustomKeyMaps<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite['[SPC]'] = ['Unite -silent -ignorecase' .
          \ ' -winheight=17 -start-insert menu:CustomKeyMaps',
          \ 'unite customkeymaps',
          \ [
          \ '[UNITE o ] is to open unite outline source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  endif
endfunction

function! SpaceVim#mapping#leader#getName(key) abort
  if a:key == g:spacevim_unite_leader
    return '[unite]'
  elseif a:key == g:spacevim_denite_leader
    return '[denite]'
  elseif a:key == ' '
    return '[SPC]'
  elseif a:key == 'g'
    return '[g]'
  elseif a:key == 'z'
    return '[z]'
  elseif a:key == g:spacevim_windows_leader
    return '[WIN]'
  elseif a:key ==# '\'
    return '<leader>'
  else
    return ''
  endif
endfunction

function! SpaceVim#mapping#leader#defindKEYs() abort
  let g:_spacevim_mappings_prefixs = {}
  let g:_spacevim_mappings_prefixs[g:spacevim_unite_leader] = {'name' : '+Unite prefix'}
  call extend(g:_spacevim_mappings_prefixs[g:spacevim_unite_leader], g:_spacevim_mappings_unite)
  let g:_spacevim_mappings_prefixs[g:spacevim_denite_leader] = {'name' : '+Denite prefix'}
  call extend(g:_spacevim_mappings_prefixs[g:spacevim_denite_leader], g:_spacevim_mappings_denite)
  let g:_spacevim_mappings_prefixs[g:spacevim_windows_leader] = {'name' : '+Window prefix'}
  call extend(g:_spacevim_mappings_prefixs[g:spacevim_windows_leader], g:_spacevim_mappings_windows)
  let g:_spacevim_mappings_prefixs['g'] = {'name' : '+g prefix'}
  call extend(g:_spacevim_mappings_prefixs['g'], g:_spacevim_mappings_g)
  let g:_spacevim_mappings_prefixs['z'] = {'name' : '+z prefix'}
  call extend(g:_spacevim_mappings_prefixs['z'], g:_spacevim_mappings_z)
  let leader = get(g:, 'mapleader', '\')
  let g:_spacevim_mappings_prefixs[leader] = {'name' : '+Leader prefix'}
  call extend(g:_spacevim_mappings_prefixs[leader], g:_spacevim_mappings)
endfunction


" vim:set et sw=2 cc=80:
