function! SpaceVim#mapping#space#init() abort
  if s:has_map_to_spc()
    return
  endif
  nnoremap <silent><nowait> [SPC] :<c-u>LeaderGuide " "<CR>
  vnoremap <silent><nowait> [SPC] :<c-u>LeaderGuideVisual " "<CR>
  nmap <Space> [SPC]
  vmap <Space> [SPC]
  let g:_spacevim_mappings_space = {}
  let g:_spacevim_mappings_prefixs['[SPC]'] = {'name' : '+SPC prefix'}
  let g:_spacevim_mappings_space['?'] = ['Unite menu:CustomKeyMaps -input=[SPC]', 'show mappings']
  let g:_spacevim_mappings_space.t = {'name' : '+Toggles'}
  let g:_spacevim_mappings_space.t.h = {'name' : '+Toggles highlight'}
  let g:_spacevim_mappings_space.t.m = {'name' : '+modeline'}
  let g:_spacevim_mappings_space.T = {'name' : '+UI toggles/themes'}
  let g:_spacevim_mappings_space.a = {'name' : '+Applications'}
  let g:_spacevim_mappings_space.b = {'name' : '+Buffers'}
  let g:_spacevim_mappings_space.c = {'name' : '+Comments'}
  let g:_spacevim_mappings_space.f = {'name' : '+Files'}
  let g:_spacevim_mappings_space.j = {'name' : '+Jump/Join/Split'}
  let g:_spacevim_mappings_space.m = {'name' : '+Major-mode'}
  let g:_spacevim_mappings_space.w = {'name' : '+Windows'}
  let g:_spacevim_mappings_space.p = {'name' : '+Projects'}
  let g:_spacevim_mappings_space.h = {'name' : '+Help'}
  let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
  let g:_spacevim_mappings_space.s = {'name' : '+Searching'}
  let g:_spacevim_mappings_space.r = {'name' : '+Registers/rings/resume'}
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
  let g:_spacevim_mappings_space.b.n = ['bnext', 'next buffer',
        \ [
        \ 'SPC b n is running :bnext, jump to next buffer',
        \ 'which is a vim build in command',
        \ 'It is bound to SPC b n, ] b,',
        \ ]
        \ ]
  call SpaceVim#mapping#menu('Open next buffer', '[SPC]bn', 'bp')
  nnoremap <silent> [SPC]bp :bp<CR>
  let g:_spacevim_mappings_space.b.p = ['bp', 'previous buffer']
  call SpaceVim#mapping#menu('Open previous buffer', '[SPC]bp', 'bp')

  "
  " Comments sections
  "
  " Toggles the comment state of the selected line(s). If the topmost selected
  " line is commented, all selected lines are uncommented and vice versa.
  call SpaceVim#mapping#space#def('nmap', ['c', 'l'], '<Plug>NERDCommenterComment', 'comment lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'L'], '<Plug>NERDCommenterInvert', 'toggle comment lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'p'], 'vip<Plug>NERDCommenterComment', 'comment paragraphs', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'P'], 'vip<Plug>NERDCommenterInvert', 'toggle comment paragraphs', 0, 1)

  nnoremap <silent> <Plug>CommentToLine :call <SID>comment_to_line(0)<Cr>
  nnoremap <silent> <Plug>CommentToLineInvert :call <SID>comment_to_line(1)<Cr>
  call SpaceVim#mapping#space#def('nmap', ['c', 't'], '<Plug>CommentToLine', 'comment until the line', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'T'], '<Plug>CommentToLineInvert', 'toggle comment until the line', 0, 1)

  nnoremap <silent> <Plug>CommentOperator :set opfunc=<SID>commentOperator<Cr>g@
  let g:_spacevim_mappings_space[';'] = ['call feedkeys("\<Plug>CommentOperator")', 'comment operator']
  nmap <silent> [SPC]; <Plug>CommentOperator

  " in nerdcomment if has map to <plug>... the default mapping will be
  " disable, so we add it for compatibility
  nmap <Leader>cc <Plug>NERDCommenterComment
  xmap <Leader>cc <Plug>NERDCommenterComment
  nmap <Leader>ci <Plug>NERDCommenterInvert
  xmap <Leader>ci <Plug>NERDCommenterInvert

  let g:_spacevim_mappings_space.e = {'name' : '+Errors/Encoding'}
  let g:_spacevim_mappings_space.B = {'name' : '+Global-buffers'}
  if g:spacevim_relativenumber
    nnoremap <silent> [SPC]tn  :<C-u>setlocal nonumber! norelativenumber!<CR>
    let g:_spacevim_mappings_space.t.n = ['setlocal nonumber! norelativenumber!', 'toggle line number']
    call SpaceVim#mapping#menu('toggle line number', '[SPC]tn', 'set nu!')
  else
    nnoremap <silent> [SPC]tn  :<C-u>setlocal number!<CR>
    let g:_spacevim_mappings_space.t.n = ['setlocal number!', 'toggle line number']
    call SpaceVim#mapping#menu('toggle line number', '[SPC]tn', 'setlocal number!')
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'Unite buffer', 'buffer list', 1)
  call extend(g:_spacevim_mappings_prefixs['[SPC]'], get(g:, '_spacevim_mappings_space', {}))
  call SpaceVim#mapping#space#def('nnoremap', ['r', 'l'], 'Unite resume', 'resume unite buffer', 1)

  " Searching in current buffer
  call SpaceVim#mapping#space#def('nnoremap', ['s', 's'], 'Unite line', 'grep in current buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'S'], "execute 'Unite grep:%::' . expand(\"<cword>\") . '  -start-insert'",
        \ 'grep cursor word in current buffer', 1)
  " Searching in all loaded buffers
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'b'], 'Unite grep:$buffers', 'grep in all loaded buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'B'], "execute 'Unite grep:$buffers::' . expand(\"<cword>\") . '  -start-insert'",
        \ 'grep cursor word in all loaded buffers', 1)
  " Searching in files in an arbitrary directory
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'f'], 'Unite grep', 'grep in arbitrary directory', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'F'], "execute 'Unite grep:::' . expand(\"<cword>\") . '  -start-insert'",
        \ 'grep in arbitrary directory', 1)
  " Searching in project
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'p'], 'Unite grep:.', 'grep in project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'P'], "execute 'Unite grep:.::' . expand(\"<cword>\") . '  -start-insert'",
        \ 'grep in project', 1)
  " Searching background
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'j'],
        \ 'call SpaceVim#plugins#searcher#find("", SpaceVim#mapping#search#default_tool())', 'Background search keywords in project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'J'],
        \ 'call SpaceVim#plugins#searcher#find(expand("<cword>"),SpaceVim#mapping#search#default_tool())',
        \ 'Background search cursor words in project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'l'], 'call SpaceVim#plugins#searcher#list()', 'List all searching results', 1)

  " Searching tools
  " ag
  let g:_spacevim_mappings_space.s.a = {'name' : '+ag'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'b'], 'call SpaceVim#mapping#search#grep("a", "b")', 'search in all buffers with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'B'], 'call SpaceVim#mapping#search#grep("a", "B")',
        \ 'search cursor word in all buffers with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'p'], 'call SpaceVim#mapping#search#grep("a", "p")', 'search in project with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'P'], 'call SpaceVim#mapping#search#grep("a", "P")',
        \ 'search cursor word in project with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'f'], 'call SpaceVim#mapping#search#grep("a", "f")',
        \ 'search in arbitrary directory  with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'F'], 'call SpaceVim#mapping#search#grep("a", "F")',
        \ 'search cursor word in arbitrary directory  with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'j'], 'call SpaceVim#plugins#searcher#find("", "ag")',
        \ 'Background search cursor words in project with ag', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'a', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "ag")',
        \ 'Background search cursor words in project with ag', 1)
  " grep
  let g:_spacevim_mappings_space.s.g = {'name' : '+grep'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'b'], 'call SpaceVim#mapping#search#grep("g", "b")',
        \ 'search in all buffers with grep', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'B'], 'call SpaceVim#mapping#search#grep("g", "B")',
        \ 'search cursor word in all buffers with grep', 1)
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
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'b'], 'call SpaceVim#mapping#search#grep("r", "b")', 'search in all buffers with rt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'B'], 'call SpaceVim#mapping#search#grep("r", "B")',
        \ 'search cursor word in all buffers with rt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'p'], 'call SpaceVim#mapping#search#grep("r", "p")', 'search in project with rt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'P'], 'call SpaceVim#mapping#search#grep("r", "P")',
        \ 'search cursor word in project with rt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'f'], 'call SpaceVim#mapping#search#grep("r", "f")',
        \ 'search in arbitrary directory  with rt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'F'], 'call SpaceVim#mapping#search#grep("r", "F")',
        \ 'search cursor word in arbitrary directory  with rt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'j'], 'call SpaceVim#plugins#searcher#find("", "rg")',
        \ 'Background search cursor words in project with rg', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 'r', 'J'], 'call SpaceVim#plugins#searcher#find(expand("<cword>"), "rg")',
        \ 'Background search cursor words in project with rg', 1)
  " pt
  let g:_spacevim_mappings_space.s.t = {'name' : '+pt'}
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'b'], 'call SpaceVim#mapping#search#grep("t", "b")', 'search in all buffers with pt', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['s', 't', 'B'], 'call SpaceVim#mapping#search#grep("t", "B")',
        \ 'search cursor word in all buffers with pt', 1)
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

  call SpaceVim#mapping#space#def('nnoremap', ['s', 'g', 'G'], 'call SpaceVim#plugins#flygrep#open()',
        \ 'grep on the fly', 1)

  call SpaceVim#mapping#space#def('nnoremap', ['s', 'c'], 'noh',
        \ 'clear search highlight', 1)

  " Getting help
  let g:_spacevim_mappings_space.h.d = {'name' : '+help-describe'}
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'd', 'b'],
        \ 'call SpaceVim#plugins#help#describe_bindings()',
        \ 'describe key bindings', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'd', 'k'],
        \ 'call SpaceVim#plugins#help#describe_key()',
        \ 'describe key bindings', 1)

endfunction

function! SpaceVim#mapping#space#def(m, keys, cmd, desc, is_cmd, ...) abort
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
  exe a:m . ' <silent> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
  if is_visual
    if a:m ==# 'nnoremap'
      exe 'xnoremap <silent> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
    elseif a:m ==# 'nmap'
      exe 'xmap <silent> [SPC]' . join(a:keys, '') . ' ' . substitute(cmd, '|', '\\|', 'g')
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
function! SpaceVim#mapping#space#refrashLSPC()
  let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
  if !empty(&filetype) && has_key(s:language_specified_mappings, &filetype)
    call call(s:language_specified_mappings[&filetype], [])
    let b:spacevim_lang_specified_mappings = g:_spacevim_mappings_space.l
  endif

endfunction

function! SpaceVim#mapping#space#regesit_lang_mappings(ft, func)
  call extend(s:language_specified_mappings, {a:ft : a:func})
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

function! s:commentOperator(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gv"
    call feedkeys("\<Plug>NERDCommenterComment")
  elseif a:type == 'line'
    call feedkeys('`[V`]')
    call feedkeys("\<Plug>NERDCommenterComment")
  else
    call feedkeys('`[v`]')
    call feedkeys("\<Plug>NERDCommenterComment")
  endif

  let &selection = sel_save
  let @@ = reg_save
  set opfunc=
endfunction

function! s:comment_to_line(invert) abort
  let input = input('line number: ')
  if empty(input)
    return
  endif
  let line = str2nr(input)
  let ex = line - line('.')
  if ex > 0
    exe 'normal! V'. ex .'j'
  elseif ex == 0
  else
    exe 'normal! V'. abs(ex) .'k'
  endif
  if a:invert
    call feedkeys("\<Plug>NERDCommenterInvert")
  else
    call feedkeys("\<Plug>NERDCommenterComment")
  endif
endfunction

" vim:set et sw=2 cc=80:
