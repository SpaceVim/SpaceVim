"=============================================================================
" space.vim --- Space key bindings
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:file = expand('<sfile>:~')
let s:funcbeginline =  expand('<slnum>') + 1
function! SpaceVim#mapping#space#init() abort
  let g:_spacevim_mappings_space = {}
  let g:_spacevim_mappings_prefixs['[SPC]'] = {'name' : '+SPC prefix'}
  let g:_spacevim_mappings_space.t = {'name' : '+Toggles'}
  let g:_spacevim_mappings_space.t.h = {'name' : '+Toggles highlight'}
  let g:_spacevim_mappings_space.t.m = {'name' : '+modeline'}
  let g:_spacevim_mappings_space.T = {'name' : '+UI toggles/themes'}
  let g:_spacevim_mappings_space.a = {'name' : '+Applications'}
  let g:_spacevim_mappings_space.b = {'name' : '+Buffers'}
  let g:_spacevim_mappings_space.f = {'name' : '+Files'}
  let g:_spacevim_mappings_space.j = {'name' : '+Jump/Join/Split'}
  let g:_spacevim_mappings_space.m = {'name' : '+Major-mode'}
  let g:_spacevim_mappings_space.w = {'name' : '+Windows'}
  let g:_spacevim_mappings_space.p = {'name' : '+Projects/Packages'}
  let g:_spacevim_mappings_space.h = {'name' : '+Help'}
  let g:_spacevim_mappings_space.n = {'name' : '+Narrow/Numbers'}
  let g:_spacevim_mappings_space.q = {'name' : '+Quit'}
  let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
  let g:_spacevim_mappings_space.s = {'name' : '+Searching/Symbol'}
  let g:_spacevim_mappings_space.r = {'name' : '+Registers/rings/resume'}
  let g:_spacevim_mappings_space.d = {'name' : '+Debug'}
  if s:has_map_to_spc()
    return
  endif
  nnoremap <silent><nowait> [SPC] :<c-u>LeaderGuide " "<CR>
  vnoremap <silent><nowait> [SPC] :<c-u>LeaderGuideVisual " "<CR>
  nmap <Space> [SPC]
  vmap <Space> [SPC]
  if !g:spacevim_vimcompatible && g:spacevim_enable_language_specific_leader
    nmap , [SPC]l
    xmap , [SPC]l
  endif
  " Windows
  for i in range(1, 9)
    exe "call SpaceVim#mapping#space#def('nnoremap', ["
          \ . i . "], 'call SpaceVim#layers#core#statusline#jump("
          \ . i . ")', 'window-" . i . "', 1)"
  endfor
  let g:_spacevim_mappings_space.w['<Tab>'] = ['wincmd w', 'alternate-window']
  nnoremap <silent> [SPC]w<tab> :wincmd w<cr>
  call SpaceVim#mapping#menu('alternate-window', '[SPC]w<Tab>', 'wincmd w')
  call SpaceVim#mapping#space#def('nnoremap', ['w', '+'], 
        \ 'call call('
        \ . string(function('s:windows_layout_toggle'))
        \ . ', [])', 'windows-layout-toggle', 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', '.'], 'call call('
        \ . string(s:_function('s:windows_transient_state')) . ', [])',
        \ ['buffer-transient-state',
        \ [
        \ '[SPC w .] is to open the buffer transient state',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'd'], 'close',
        \ ['close-current-windows',
        \ [
        \ '[SPC w d] is to close current windows',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'D'], 'ChooseWin | close | wincmd w',
        \ ['delete-window-(other-windows)',
        \ [
        \ '[SPC w D] is to select a windows to close',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'f'], 'tabnew',
        \ ['create-new-tab',
        \ [
        \ '[SPC w f] is to create new tab',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'F'], 'call call('
        \ . string(function('s:create_new_named_tab'))
        \ . ', [])',
        \ ['create-new-named-tab',
        \ [
        \ '[SPC w F] is to create new named tab',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'h'], 'wincmd h',
        \ ['window-left',
        \ [
        \ '[SPC w h] is to jump to the left window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'j'], 'wincmd j',
        \ ['window-down',
        \ [
        \ '[SPC w j] is to jump to the window below current windows',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'k'], 'wincmd k',
        \ ['window-up',
        \ [
        \ '[SPC w k] is to jump to the window above current windows',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'l'], 'wincmd l',
        \ ['window-right',
        \ [
        \ '[SPC w l] is to jump to the right window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'H'], 'wincmd H',
        \ ['window-far-left',
        \ [
        \ '[SPC w H] is to jump to the far left window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'J'], 'wincmd J',
        \ ['window-far-down',
        \ [
        \ '[SPC w J] is to jump to the far down window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'K'], 'wincmd K',
        \ ['window-far-up',
        \ [
        \ '[SPC w K] is to jump to the far up window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'L'], 'wincmd L',
        \ ['window-far-right',
        \ [
        \ '[SPC w L] is to jump to the far right window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'm'], 'only',
        \ ['maximize/minimize window',
        \ [
        \ '[SPC w m] is to maximize/minimize window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'M'], 
        \ "execute eval(\"winnr('$')<=2 ? 'wincmd x' : 'ChooseWinSwap'\")",
        \ ['swap window',
        \ [
        \ '[SPC w M] is to swap window',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'o'], 'tabnext',
        \ ['other-tabs',
        \ [
        \ '[SPC w o] is to switch to next tabs',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', '/'], 'belowright vsplit | wincmd w',
        \ ['split-windows-right',
        \ [
        \ '[SPC w /] is to split windows on the right',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'v'], 'belowright vsplit | wincmd w',
        \ ['split-windows-right',
        \ [
        \ '[SPC w v] is to split windows on the right',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', '-'], 'bel split | wincmd w',
        \ ['split-windows-below',
        \ [
        \ '[SPC w -] is to split windows below',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 's'], 'bel split | wincmd w',
        \ ['split-windows-below',
        \ [
        \ '[SPC w s] is to split windows below',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'S'], 'bel split',
        \ ['split-focus-windows-below',
        \ [
        \ '[SPC w S] is to split windows below and focus on new windows',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', '2'], 'silent only | vs | wincmd w',
        \ ['layout-double-columns',
        \ [
        \ '[SPC w 2] is to change current windows layout to double columns',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['w', '3'], 'silent only | vs | vs | wincmd H',
        \ ['layout-three-columns',
        \ [
        \ '[SPC w 3] is to change current windows layout to three columns',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'V'],
        \ 'bel vs', 'split-window-right-focus', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', '='],
        \ 'wincmd =', 'balance-windows', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'w'],
        \ 'wincmd w', 'cycle and focus between windows', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'W'],
        \ 'ChooseWin', 'select window', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'u'], 'call SpaceVim#plugins#windowsmanager#UndoQuitWin()', 'undo quieted window', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'U'], 'call SpaceVim#plugins#windowsmanager#RedoQuitWin()', 'redo quieted window', 1)
  let s:lnum = expand('<slnum>') + s:funcbeginline
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'n'], 'bnext', ['next-buffer',
        \ [
        \ '[SPC b n] is running :bnext, jump to next buffer',
        \ 'which is a vim build in command',
        \ 'It is bound to SPC b n, ] b,',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)
  let s:lnum = expand('<slnum>') + 3
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'p'], 'bp', ['previous-buffer',
        \ [
        \ 'SPC b p is running :bp, jump to previous buffer',
        \ 'which is a vim build in command',
        \ 'It is bound to SPC b p, [ b,',
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ]
        \ , 1)

  let g:_spacevim_mappings_space.e = {'name' : '+Errors/Encoding'}
  let g:_spacevim_mappings_space.B = {'name' : '+Global buffers'}
  if g:spacevim_relativenumber
    nnoremap <silent> [SPC]tn  :<C-u>setlocal nonumber! norelativenumber!<CR>
    let g:_spacevim_mappings_space.t.n = ['setlocal nonumber! norelativenumber!', 'toggle-line-number']
    call SpaceVim#mapping#menu('toggle line number', '[SPC]tn', 'set nu!')
  else
    nnoremap <silent> [SPC]tn  :<C-u>setlocal number!<CR>
    let g:_spacevim_mappings_space.t.n = ['setlocal number!', 'toggle-line-number']
    call SpaceVim#mapping#menu('toggle line number', '[SPC]tn', 'setlocal number!')
  endif
  call extend(g:_spacevim_mappings_prefixs['[SPC]'], get(g:, '_spacevim_mappings_space', {}))

  " Searching in current buffer
  call SpaceVim#mapping#space#def('nnoremap', ['s', 's'], "call SpaceVim#plugins#flygrep#open({'input' : input(\"grep pattern:\"), 'files': bufname(\"%\")})",
        \ 'grep-in-current-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'S'], "call SpaceVim#plugins#flygrep#open({'input' : expand(\"<cword>\"), 'files': bufname(\"%\")})",
        \ 'grep-cword-in-current-buffer', 1)
  " Searching in all loaded buffers
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'b'], "call SpaceVim#plugins#flygrep#open({'input' : input(\"grep pattern:\"), 'files':'@buffers'})",
        \ 'grep-in-all-buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'B'], "call SpaceVim#plugins#flygrep#open({'input' : expand(\"<cword>\"), 'files':'@buffers'})",
        \ 'grep-cword-in-all-buffers', 1)
  " Searching in buffer directory
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'd'], "call SpaceVim#plugins#flygrep#open({'input' :"
        \ . " input(\"grep pattern:\"), 'dir' : fnamemodify(expand('%'), ':p:h')})",
        \ 'grep-in-buffer-directory', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'D'], "call SpaceVim#plugins#flygrep#open({'input' :"
        \ . " expand(\"<cword>\"), 'dir' : fnamemodify(expand('%'), ':p:h')})",
        \ 'grep-cword-in-buffer-directory', 1)
  " Searching in files in an arbitrary directory
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'f'], "call SpaceVim#plugins#flygrep#open({'input' :"
        \ . " input(\"grep pattern:\"), 'dir' : input(\"arbitrary dir:\", '', 'dir')})",
        \ 'grep-in-arbitrary-directory', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'F'],
        \ "call SpaceVim#plugins#flygrep#open({'input' :"
        \ . " expand(\"<cword>\"), 'dir' : input(\"arbitrary dir:\", '', 'dir')})",
        \ 'grep-cword-in-arbitrary-directory', 1)
  " Searching in project
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'p'],
        \ 'call SpaceVim#plugins#flygrep#open(' .
        \ "{'input' : input(\"grep pattern:\"), 'dir' : get(b:, \"rootDir\", getcwd())})",
        \ 'grep-in-project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'P'],
        \ "call SpaceVim#plugins#flygrep#open({'input' : expand(\"<cword>\"), 'dir' : get(b:, \"rootDir\", getcwd())})",
        \ 'grep-cword-in-project', 1)
  " Searching background
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'j'],
        \ 'call SpaceVim#plugins#searcher#find("", SpaceVim#mapping#search#default_tool()[0])', 'background-search-in-project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'J'],
        \ 'call SpaceVim#plugins#searcher#find(expand("<cword>"),SpaceVim#mapping#search#default_tool()[0])',
        \ 'background-search-cwords-in-project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'l'], 'call SpaceVim#plugins#searcher#list()', 'list-all-searching-results', 1)

  " Searching tools
  " ag
  let g:_spacevim_mappings_space.s.a = {'name' : '+ag'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'b'], 'call SpaceVim#mapping#search#grep("a", "b")', 'search in all buffers with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'B'], 'call SpaceVim#mapping#search#grep("a", "B")',
        \ 'search cursor word in all buffers with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'd'], 'call SpaceVim#mapping#search#grep("a", "d")', 'search in buffer directory with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'D'], 'call SpaceVim#mapping#search#grep("a", "D")',
        \ 'search cursor word in buffer directory with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'p'], 'call SpaceVim#mapping#search#grep("a", "p")', 'search in project with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'P'], 'call SpaceVim#mapping#search#grep("a", "P")',
        \ 'search cursor word in project with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'f'], 'call SpaceVim#mapping#search#grep("a", "f")',
        \ 'search in arbitrary directory with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'F'], 'call SpaceVim#mapping#search#grep("a", "F")',
        \ 'search cursor word in arbitrary directory with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'j'], 'call SpaceVim#plugins#searcher#find("", "ag")',
        \ 'Background search in project with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "ag")',
        \ 'Background search cursor words in project with ag', 1)
  " grep
  let g:_spacevim_mappings_space.s.g = {'name' : '+grep'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'b'], 'call SpaceVim#mapping#search#grep("g", "b")',
        \ 'search in all buffers with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'B'], 'call SpaceVim#mapping#search#grep("g", "B")',
        \ 'search cursor word in all buffers with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'd'], 'call SpaceVim#mapping#search#grep("g", "d")', 'search in buffer directory with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'D'], 'call SpaceVim#mapping#search#grep("g", "D")',
        \ 'search cursor word in buffer directory with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'p'], 'call SpaceVim#mapping#search#grep("g", "p")', 'search in project with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'P'], 'call SpaceVim#mapping#search#grep("g", "P")',
        \ 'search cursor word in project with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'f'], 'call SpaceVim#mapping#search#grep("g", "f")',
        \ 'search in arbitrary directory  with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'F'], 'call SpaceVim#mapping#search#grep("g", "F")',
        \ 'search cursor word in arbitrary directory  with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'j'], 'call SpaceVim#plugins#searcher#find("", "grep")',
        \ 'Background search cursor words in project with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "grep")',
        \ 'Background search cursor words in project with grep', 1)
  " ack
  let g:_spacevim_mappings_space.s.k = {'name' : '+ack'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'b'], 'call SpaceVim#mapping#search#grep("k", "b")', 'search in all buffers with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'B'], 'call SpaceVim#mapping#search#grep("k", "B")',
        \ 'search cursor word in all buffers with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'd'], 'call SpaceVim#mapping#search#grep("k", "d")', 'search in buffer directory with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'D'], 'call SpaceVim#mapping#search#grep("k", "D")',
        \ 'search cursor word in buffer directory with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'p'], 'call SpaceVim#mapping#search#grep("k", "p")', 'search in project with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'P'], 'call SpaceVim#mapping#search#grep("k", "P")',
        \ 'search cursor word in project with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'f'], 'call SpaceVim#mapping#search#grep("k", "f")',
        \ 'search in arbitrary directory  with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'F'], 'call SpaceVim#mapping#search#grep("k", "F")',
        \ 'search cursor word in arbitrary directory  with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'j'], 'call SpaceVim#plugins#searcher#find("", "ack")',
        \ 'Background search cursor words in project with ack', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'k', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "ack")',
        \ 'Background search cursor words in project with ack', 1)
  " rg
  let g:_spacevim_mappings_space.s.r = {'name' : '+rg'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'b'], 'call SpaceVim#mapping#search#grep("r", "b")', 'search in all buffers with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'B'], 'call SpaceVim#mapping#search#grep("r", "B")',
        \ 'search cursor word in all buffers with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'd'], 'call SpaceVim#mapping#search#grep("r", "d")', 'search in buffer directory with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'D'], 'call SpaceVim#mapping#search#grep("r", "D")',
        \ 'search cursor word in buffer directory with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'p'], 'call SpaceVim#mapping#search#grep("r", "p")', 'search in project with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'P'], 'call SpaceVim#mapping#search#grep("r", "P")',
        \ 'search cursor word in project with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'f'], 'call SpaceVim#mapping#search#grep("r", "f")',
        \ 'search in arbitrary directory  with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'F'], 'call SpaceVim#mapping#search#grep("r", "F")',
        \ 'search cursor word in arbitrary directory  with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'j'], 'call SpaceVim#plugins#searcher#find("", "rg")',
        \ 'Background search cursor words in project with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "rg")',
        \ 'Background search cursor words in project with rg', 1)

  " findstr
  let g:_spacevim_mappings_space.s.i = {'name' : '+findstr'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'b'], 'call SpaceVim#mapping#search#grep("i", "b")', 'search in all buffers with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'B'], 'call SpaceVim#mapping#search#grep("i", "B")',
        \ 'search cursor word in all buffers with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'd'], 'call SpaceVim#mapping#search#grep("i", "d")', 'search in buffer directory with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'D'], 'call SpaceVim#mapping#search#grep("i", "D")',
        \ 'search cursor word in buffer directory with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'p'], 'call SpaceVim#mapping#search#grep("i", "p")', 'search in project with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'P'], 'call SpaceVim#mapping#search#grep("i", "P")',
        \ 'search cursor word in project with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'f'], 'call SpaceVim#mapping#search#grep("i", "f")',
        \ 'search in arbitrary directory  with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'F'], 'call SpaceVim#mapping#search#grep("i", "F")',
        \ 'search cursor word in arbitrary directory  with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'j'], 'call SpaceVim#plugins#searcher#find("", "findstr")',
        \ 'Background search cursor words in project with findstr', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'i', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "findstr")',
        \ 'Background search cursor words in project with findstr', 1)
  " pt
  let g:_spacevim_mappings_space.s.t = {'name' : '+pt'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'b'], 'call SpaceVim#mapping#search#grep("t", "b")', 'search in all buffers with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'B'], 'call SpaceVim#mapping#search#grep("t", "B")',
        \ 'search cursor word in all buffers with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'd'], 'call SpaceVim#mapping#search#grep("t", "d")', 'search in buffer directory with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'D'], 'call SpaceVim#mapping#search#grep("t", "D")',
        \ 'search cursor word in buffer directory with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'p'], 'call SpaceVim#mapping#search#grep("t", "p")', 'search in project with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'P'], 'call SpaceVim#mapping#search#grep("t", "P")',
        \ 'search cursor word in project with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'f'], 'call SpaceVim#mapping#search#grep("t", "f")',
        \ 'search in arbitrary directory  with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'F'], 'call SpaceVim#mapping#search#grep("t", "F")',
        \ 'search cursor word in arbitrary directory  with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'j'], 'call SpaceVim#plugins#searcher#find("", "pt")',
        \ 'Background search cursor words in project with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "pt")',
        \ 'Background search cursor words in project with pt', 1)

  call SpaceVim#mapping#space#def('nnoremap', ['s', '/'], 'call SpaceVim#plugins#flygrep#open({})',
        \ 'grep-on-the-fly', 1)

  call SpaceVim#mapping#space#def('nnoremap', ['s', 'c'], 'call SpaceVim#plugins#searcher#clear()',
        \ 'clear-search-results', 1)

  "Symbol
  nnoremap <silent> <plug>SpaceVim-plugin-iedit :call SpaceVim#plugins#iedit#start()<cr>
  xnoremap <silent> <plug>SpaceVim-plugin-iedit :call SpaceVim#plugins#iedit#start(1)<cr>
  call SpaceVim#mapping#space#def('nmap', ['s', 'e'], '<plug>SpaceVim-plugin-iedit',
        \ 'start-iedit-mode', 0, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'H'], 'call SpaceVim#plugins#highlight#start(1)',
        \ 'highlight-all-symbols', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'h'], 'call SpaceVim#plugins#highlight#start(0)',
        \ 'highlight-current-symbols', 1)
  " Getting help
  let g:_spacevim_mappings_space.h.d = {'name' : '+help describe'}
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'd', 'k'],
        \ 'call SpaceVim#plugins#help#describe_key()',
        \ 'describe-key-bindings', 1)
  call SpaceVim#custom#SPC('nnoremap', ['a', 'o'], 'call SpaceVim#plugins#todo#list()', 'open-todo-manager', 1)
endfunction

function! SpaceVim#mapping#space#def(m, keys, cmd, desc, is_cmd, ...) abort
  if s:has_map_to_spc()
    return
  endif
  let is_visual = a:0 > 0 ? a:1 : 0
  if a:is_cmd
    let cmd = ':<C-u>' . a:cmd . '<CR>' 
    let xcmd = ':' . a:cmd . '<CR>' 
    let lcmd = a:cmd
  else
    let cmd = a:cmd
    let xcmd = a:cmd
    let feedkey_m = a:m =~# 'nore' ? 'n' : 'm'
    if a:cmd =~? '^<plug>'
      let lcmd = 'call feedkeys("\' . a:cmd . '", "' . feedkey_m . '")'
    else
      let lcmd = 'call feedkeys("' . a:cmd . '", "' . feedkey_m . '")'
    endif
  endif
  exe a:m . ' <silent> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
  if is_visual
    if a:m ==# 'nnoremap'
      exe 'xnoremap <silent> [SPC]' . join(a:keys, '') . ' ' . substitute(xcmd, '|', '\\|', 'g')
    elseif a:m ==# 'nmap'
      exe 'xmap <silent> [SPC]' . join(a:keys, '') . ' ' . substitute(xcmd, '|', '\\|', 'g')
    endif
  endif
  if len(a:keys) == 2
    if type(a:desc) == 1
      let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]] = [lcmd, a:desc]
    else
      let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]] = [lcmd, a:desc[0], a:desc[1]]
    endif
  elseif len(a:keys) == 3
    if type(a:desc) == 1
      let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]][a:keys[2]] = [lcmd, a:desc]
    else
      let g:_spacevim_mappings_space[a:keys[0]][a:keys[1]][a:keys[2]] = [lcmd, a:desc[0], a:desc[1]]
    endif
  elseif len(a:keys) == 1
    if type(a:desc) == 1
      let g:_spacevim_mappings_space[a:keys[0]] = [lcmd, a:desc]
    else
      let g:_spacevim_mappings_space[a:keys[0]] = [lcmd, a:desc[0], a:desc[1]]
    endif
  endif
  if type(a:desc) == 1
    call SpaceVim#mapping#menu(a:desc, '[SPC]' . join(a:keys, ''), lcmd)
  else
    call SpaceVim#mapping#menu(a:desc[0], '[SPC]' . join(a:keys, ''), lcmd)
  endif
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


let s:language_specified_mappings = {}
function! SpaceVim#mapping#space#refrashLSPC() abort
  let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
  if !empty(&filetype) && has_key(s:language_specified_mappings, &filetype)
    call call(s:language_specified_mappings[&filetype], [])
    let b:spacevim_lang_specified_mappings = g:_spacevim_mappings_space.l
  endif

endfunction

function! SpaceVim#mapping#space#regesit_lang_mappings(ft, func) abort
  call extend(s:language_specified_mappings, {a:ft : a:func})
endfunction

function! SpaceVim#mapping#space#langSPC(m, keys, cmd, desc, is_cmd, ...) abort
  if s:has_map_to_spc()
    return
  endif
  let is_visual = a:0 > 0 ? a:1 : 0
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
  if is_visual
    if a:m ==# 'nnoremap'
      exe 'xnoremap <silent> <buffer> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
    elseif a:m ==# 'nmap'
      exe 'xmap <silent> <buffer> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
    endif
  endif
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


function! s:create_new_named_tab() abort
  let tabname = input('Tab name:', '')
  if !empty(tabname)
    tabnew
    let t:_spacevim_tab_name = tabname
    set tabline=%!SpaceVim#layers#core#tabline#get()
  else
    tabnew
  endif
endfunction

function! s:windows_transient_state() abort

  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Buffer Selection Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'next buffer',
        \ 'func' : '',
        \ 'cmd' : 'bnext',
        \ 'exit' : 0,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
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

" vim:set et nowrap sw=2 cc=80:
