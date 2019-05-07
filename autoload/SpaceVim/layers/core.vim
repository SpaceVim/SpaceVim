"=============================================================================
" core.vim --- SpaceVim core layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:SYS = SpaceVim#api#import('system')

function! SpaceVim#layers#core#plugins() abort
  let plugins = []
  if g:spacevim_filemanager ==# 'nerdtree'
    call add(plugins, ['scrooloose/nerdtree', { 'merged' : 0,
          \ 'loadconf' : 1}])
  elseif g:spacevim_filemanager ==# 'vimfiler'
    call add(plugins, ['Shougo/vimfiler.vim',{'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1, 'on_cmd' : ['VimFiler', 'VimFilerBufferDir']}])
    call add(plugins, ['Shougo/unite.vim',{ 'merged' : 0 , 'loadconf' : 1}])
    call add(plugins, ['Shougo/vimproc.vim', {'build' : [(executable('gmake') ? 'gmake' : 'make')]}])
  elseif g:spacevim_filemanager ==# 'defx'
    call add(plugins, ['Shougo/defx.nvim',{'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}])
  endif

  if !g:spacevim_vimcompatible
    call add(plugins, ['rhysd/clever-f.vim', {'merged' : 0}])
  endif
  call add(plugins, ['scrooloose/nerdcommenter', { 'loadconf' : 1, 'merged' : 0}])

  if exists('*matchaddpos')
    call add(plugins, ['andymass/vim-matchup', {'merged' : 0}])
  endif
  call add(plugins, ['morhetz/gruvbox', {'loadconf' : 1, 'merged' : 0}])
  call add(plugins, ['tyru/open-browser.vim', {
        \'on_cmd' : ['OpenBrowserSmartSearch', 'OpenBrowser',
        \ 'OpenBrowserSearch'],
        \'on_map' : '<Plug>(openbrowser-',
        \ 'loadconf' : 1,
        \}])
  call add(plugins, ['mhinz/vim-grepper' ,              { 'on_cmd' : 'Grepper',
        \ 'loadconf' : 1} ])
  return plugins
endfunction

let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#core#config() abort
  if g:spacevim_filemanager ==# 'nerdtree'
    noremap <silent> <F3> :NERDTreeToggle<CR>
  endif
  let g:matchup_matchparen_status_offscreen = 0
  " Unimpaired bindings
  " Quickly add empty lines
  nnoremap <silent> [<Space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>
  nnoremap <silent> ]<Space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

  "]e or [e move current line ,count can be useed
  nnoremap <silent>[e  :<c-u>execute 'move -1-'. v:count1<cr>
  nnoremap <silent>]e  :<c-u>execute 'move +'. v:count1<cr>

  " [b or ]n go to previous or next buffer
  nnoremap <silent> [b :<c-u>bN \| stopinsert<cr>
  nnoremap <silent> ]b :<c-u>bn \| stopinsert<cr>

  " [f or ]f go to next or previous file in dir
  nnoremap <silent> ]f :<c-u>call <SID>next_file()<cr>
  nnoremap <silent> [f :<c-u>call <SID>previous_file()<cr>

  " [l or ]l go to next and previous error
  nnoremap <silent> [l :lprevious<cr>
  nnoremap <silent> ]l :lnext<cr>

  " [c or ]c go to next or previous vcs hunk

  " [w or ]w go to next or previous window
  nnoremap <silent> [w :call <SID>previous_window()<cr>
  nnoremap <silent> ]w :call <SID>next_window()<cr>

  " [t or ]t for next and previous tab
  nnoremap <silent> [t :tabprevious<cr>
  nnoremap <silent> ]t :tabnext<cr>

  " [p or ]p for p and P
  nnoremap <silent> [p P
  nnoremap <silent> ]p p

  " Select last paste
  nnoremap <silent><expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

  call SpaceVim#mapping#space#def('nnoremap', ['f', 's'], 'write', 'save buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'S'], 'wall', 'save all buffer', 1)
  " help mappings
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'I'], 'call SpaceVim#issue#report()', 'Report an issue of SpaceVim', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'l'], 'SPLayer -l', 'lists all the layers available in SpaceVim', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'L'], 'SPRuntimeLog', 'view SpaceVim runtime log', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'm'], 'Unite manpage', 'search available man pages', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'k'], 'LeaderGuide "[KEYs]"', 'show top-level bindings with mapping guide', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', '0'], 'm`^', 'push mark and goto beginning of line', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', '$'], 'm`g_', 'push mark and goto end of line', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'b'], '<C-o>', 'jump backward', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'f'], '<C-i>', 'jump forward', 0)

  " file tree key bindings
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'd'], 'call call('
        \ . string(s:_function('s:explore_current_dir')) . ', [0])',
        \ 'Explore current directory', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'D'], 'call call('
        \ . string(s:_function('s:explore_current_dir')) . ', [1])',
        \ 'Explore current directory(other windows)', 1)

  call SpaceVim#mapping#space#def('nmap', ['j', 'j'], '<Plug>(easymotion-overwin-f)', 'jump to a character', 0)
  call SpaceVim#mapping#space#def('nmap', ['j', 'J'], '<Plug>(easymotion-overwin-f2)', 'jump to a suite of two characters', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'k'], 'j==', 'go to next line and indent', 0)
  call SpaceVim#mapping#space#def('nmap', ['j', 'l'], '<Plug>(easymotion-overwin-line)', 'jump to a line', 0)
  call SpaceVim#mapping#space#def('nmap', ['j', 'v'], '<Plug>(easymotion-overwin-line)', 'jump to a line', 0)
  call SpaceVim#mapping#space#def('nmap', ['j', 'w'], '<Plug>(easymotion-overwin-w)', 'jump to a word', 0)
  call SpaceVim#mapping#space#def('nmap', ['j', 'q'], '<Plug>(easymotion-overwin-line)', 'jump to a line', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'n'], "i\<cr>\<esc>", 'sp-newline', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'o'], "i\<cr>\<esc>k$", 'open-line', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 's'], 'call call('
        \ . string(s:_function('s:split_string')) . ', [0])',
        \ 'split sexp', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'S'], 'call call('
        \ . string(s:_function('s:split_string')) . ', [1])',
        \ 'split-and-add-newline', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'r'], 'call call('
        \ . string(s:_function('s:next_window')) . ', [])',
        \ 'rotate windows forward', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'R'], 'call call('
        \ . string(s:_function('s:previous_window')) . ', [])',
        \ 'rotate windows backward', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'u'], 'call call('
        \ . string(s:_function('s:jump_to_url')) . ', [])',
        \ 'jump to url', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['<Tab>'], 'try | b# | catch | endtry', 'last buffer', 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['b', '.'], 'call call('
        \ . string(s:_function('s:buffer_transient_state')) . ', [])',
        \ ['buffer transient state',
        \ [
        \ '[SPC b .] is to open the buffer transient state',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'd'], 'call SpaceVim#mapping#close_current_buffer()', 'kill this buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'D'],
        \ 'call SpaceVim#mapping#kill_visible_buffer_choosewin()',
        \ 'kill the buffer by selecting', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', '<C-d>'], 'call SpaceVim#mapping#clearBuffers()', 'kill-other-buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'c'], 'call SpaceVim#mapping#clear_saved_buffers()', 'clear all saved buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'e'], 'call call('
        \ . string(s:_function('s:safe_erase_buffer')) . ', [])',
        \ 'safe-erase-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'h'], 'Startify', 'home', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'm'], 'call call('
        \ . string(s:_function('s:open_message_buffer')) . ', [])',
        \ 'open-message-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'P'], 'normal! ggdG"+P', 'copy-clipboard-to-whole-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'R'], 'call call('
        \ . string(s:_function('s:safe_revert_buffer')) . ', [])',
        \ 'safe-revert-buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'Y'], 'normal! ggVG"+y``', 'copy-whole-buffer-to-clipboard', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'w'], 'setl readonly!', 'read-only-mode', 1)
  let g:_spacevim_mappings_space.b.N = {'name' : '+New empty buffer'}
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'h'], 'topleft vertical new', 'new-empty-buffer-left', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'j'], 'rightbelow new', 'new-empty-buffer-below', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'k'], 'new', 'new-empty-buffer-above', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'l'], 'rightbelow vertical new', 'new-empty-buffer-right', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'N', 'n'], 'enew', 'new-empty-buffer', 1)

  " file mappings
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'b'], 'BookmarkShowAll', 'unite-filtered-bookmarks', 1)
  let g:_spacevim_mappings_space.f.C = {'name' : '+Files/convert'}
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'C', 'd'], 'update | e ++ff=dos | w', 'unix2dos', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'C', 'u'], 'update | e ++ff=dos | setlocal ff=unix | w', 'dos2unix', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'D'], 'call call('
        \ . string(s:_function('s:delete_current_buffer_file')) . ', [])',
        \ 'delete-current-buffer-file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'F'], 'normal! gf', 'open-cursor-file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', '/'], 'call SpaceVim#plugins#find#open()', 'find-files', 1)
  if s:SYS.isWindows
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'd'], 'call call('
          \ . string(s:_function('s:ToggleWinDiskManager')) . ', [])',
          \ 'toggle Windows disk manager', 1)
  endif

  " file tree key bindings
  if g:spacevim_filemanager ==# 'vimfiler'
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'VimFiler | doautocmd WinEnter', 'toggle_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'VimFiler -no-toggle | doautocmd WinEnter', 'show_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], 'VimFiler -find', 'open_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'VimFilerBufferDir -no-toggle', 'show_file_tree_at_buffer_dir', 1)
  elseif g:spacevim_filemanager ==# 'nerdtree'
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'NERDTreeToggle', 'toggle_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'NERDTree', 'show_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], 'NERDTreeFind', 'open_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'NERDTree %', 'show_file_tree_at_buffer_dir', 1)
  elseif g:spacevim_filemanager ==# 'defx'
    " TODO: fix all these command
    call SpaceVim#mapping#space#def('nnoremap', ['f', 't'], 'Defx', 'toggle_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'T'], 'Defx -no-toggle', 'show_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'o'], "Defx  -no-toggle -search=`expand('%:p')` `stridx(expand('%:p'), getcwd()) < 0? expand('%:p:h'): getcwd()`", 'open_file_tree', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 't'], 'Defx -no-toggle', 'show_file_tree_at_buffer_dir', 1)
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'y'], 'call zvim#util#CopyToClipboard()', 'show-and-copy-buffer-filename', 1)
  let g:_spacevim_mappings_space.f.v = {'name' : '+Vim(SpaceVim)'}
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 'v'], 'let @+=g:spacevim_version | echo g:spacevim_version', 'display-and-copy-version', 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 'd'], 'SPConfig',
        \ ['open-custom-configuration',
        \ [
        \ '[SPC f v d] is to open the custom configuration file for SpaceVim',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['n', '-'], 'call call('
        \ . string(s:_function('s:number_transient_state')) . ', ["-"])',
        \ ['Decrease number under cursor',
        \ [
        \ '[SPC n -] is to decrease the number under the cursor, and open',
        \ 'the number translate state buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['n', '+'], 'call call('
        \ . string(s:_function('s:number_transient_state')) . ', ["+"])',
        \ ['Increase number under cursor',
        \ [
        \ '[SPC n +] is to increase the number under the cursor, and open',
        \ 'the number translate state buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  let g:vimproc#download_windows_dll = 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 't'], 'call SpaceVim#plugins#projectmanager#current_root()', 'find project root', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'k'], 'call SpaceVim#plugins#projectmanager#kill_project()', 'kill all project buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'p'], 'call SpaceVim#plugins#projectmanager#list()', 'List all projects', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', '/'], 'Grepper', 'fuzzy search for text in current project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'q'], 'qa', 'prompt-kill-vim', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'Q'], 'qa!', 'kill-vim', 1)
  if has('nvim') && s:SYS.isWindows
    call SpaceVim#mapping#space#def('nnoremap', ['q', 'R'], 'call call('
          \ . string(s:_function('s:restart_neovim_qt')) . ', [])',
          \ 'restrat neovim-qt', 1)
  else
    call SpaceVim#mapping#space#def('nnoremap', ['q', 'R'], '', 'restart-vim(TODO)', 1)
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'r'], '', 'restart-vim-resume-layouts(TODO)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 't'], 'tabclose!', 'kill current tab', 1)
  call SpaceVim#mapping#gd#add('HelpDescribe', function('s:gotodef'))

  let g:_spacevim_mappings_space.c = {'name' : '+Comments'}
  "
  " Comments sections
  "
  " Toggles the comment state of the selected line(s). If the topmost selected
  " line is commented, all selected lines are uncommented and vice versa.
  call SpaceVim#mapping#space#def('nmap', ['c', 'l'], '<Plug>NERDCommenterInvert', 'toggle comment lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'L'], '<Plug>NERDCommenterComment', 'comment lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'u'], '<Plug>NERDCommenterUncomment', 'uncomment lines', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'v'], '<Plug>NERDCommenterInvertgv', 'toggle comment lines and keep visual', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 's'], '<Plug>NERDCommenterSexy', 'comment with sexy/pretty layout', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'Y'], '<Plug>NERDCommenterYank', 'yank and comment', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', '$'], '<Plug>NERDCommenterToEOL', 'comment current line from cursor to the end of the line', 0, 1)

  nnoremap <silent> <Plug>CommentToLine :call <SID>comment_to_line(0)<Cr>
  nnoremap <silent> <Plug>CommentToLineInvert :call <SID>comment_to_line(1)<Cr>
  nnoremap <silent> <Plug>CommentParagraphs :call <SID>comment_paragraphs(0)<Cr>
  nnoremap <silent> <Plug>CommentParagraphsInvert :call <SID>comment_paragraphs(1)<Cr>
  call SpaceVim#mapping#space#def('nmap', ['c', 't'], '<Plug>CommentToLineInvert', 'toggle comment until the line', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'T'], '<Plug>CommentToLine', 'comment until the line', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'p'], '<Plug>CommentParagraphsInvert', 'toggle comment paragraphs', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['c', 'P'], '<Plug>CommentParagraphs', 'comment paragraphs', 0, 1)

  nnoremap <silent> <Plug>CommentOperator :set opfunc=<SID>commentOperator<Cr>g@
  let g:_spacevim_mappings_space[';'] = ['call feedkeys("\<Plug>CommentOperator")', 'comment operator']
  nmap <silent> [SPC]; <Plug>CommentOperator
endfunction

function! s:gotodef() abort
  let fname = get(b:, 'defind_file_name', '')
  if !empty(fname)
    close
    exe 'edit ' . fname[0]
    exe fname[1]
  endif
endfunction

function! s:number_transient_state(n) abort
  if a:n ==# '+'
    exe "normal! \<c-a>" 
  else
    exe "normal! \<c-x>" 
  endif
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Number Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : ['+','='],
        \ 'desc' : 'increase number',
        \ 'func' : '',
        \ 'cmd' : "normal! \<c-a>",
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : '-',
        \ 'desc' : 'decrease number',
        \ 'func' : '',
        \ 'cmd' : "normal! \<c-x>",
        \ 'exit' : 0,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

let s:file = SpaceVim#api#import('file')
let s:MESSAGE = SpaceVim#api#import('vim#message')
let s:CMP = SpaceVim#api#import('vim#compatible')

function! s:next_file() abort
  let dir = expand('%:p:h')
  let f = expand('%:t')
  let file = s:file.ls(dir, 1)
  if index(file, f) == -1
    call add(file,f)
  endif
  call sort(file)
  if len(file) != 1
    if index(file, f) == len(file) - 1
      exe 'e ' . dir . s:file.separator . file[0]
    else
      exe 'e ' . dir . s:file.separator . file[index(file, f) + 1]
    endif
  endif
endfunction

function! s:previous_file() abort
  let dir = expand('%:p:h')
  let f = expand('%:t')
  let file = s:file.ls(dir, 1)
  if index(file, f) == -1
    call add(file,f)
  endif
  call sort(file)
  if len(file) != 1
    if index(file, f) == 0
      exe 'e ' . dir . s:file.separator . file[-1]
    else
      exe 'e ' . dir . s:file.separator . file[index(file, f) - 1]
    endif
  endif
endfunction

function! s:next_window() abort
  try
    exe (winnr() + 1 ) . 'wincmd w'
  catch
    exe 1 . 'wincmd w'
  endtry
endfunction

function! s:previous_window() abort
  try
    if winnr() == 1
      exe winnr('$') . 'wincmd w'
    else
      exe (winnr() - 1 ) . 'wincmd w'
    endif
  catch
    exe winnr('$') . 'wincmd w'
  endtry
endfunction

function! s:split_string(newline) abort
  if s:is_string(line('.'), col('.'))
    let c = col('.')
    let sep = ''
    while c > 0
      if s:is_string(line('.'), c)
        let c -= 1
      else
        let sep = getline('.')[c]
        break
      endif
    endwhile
    let l:connector = a:newline ? "\n" : ''
    let l:save_register_m = @m
    let @m = sep . l:connector . sep
    normal! "mp
    let @m = l:save_register_m
    if a:newline
      normal! j==k$
    endif
  endif
endfunction

function! s:is_string(l, c) abort
  return synIDattr(synID(a:l, a:c, 1), 'name') == &filetype . 'String'
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

function! s:jump_to_url() abort
  let g:EasyMotion_re_anywhere = 'http[s]*://'
  call feedkeys("\<Plug>(easymotion-jumptoanywhere)")
endfunction

function! s:safe_erase_buffer() abort
  if s:MESSAGE.confirm('Erase content of buffer ' . expand('%:t'))
    normal! ggdG
  endif
  redraw!
endfunction

function! s:ToggleWinDiskManager() abort
  if bufexists('__windisk__')
    execute 'bd "__windisk__"'
  else
    call SpaceVim#plugins#windisk#open()
  endif
endfunction

function! s:open_message_buffer() abort
  vertical topleft edit __Message_Buffer__
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonumber norelativenumber
  setf message
  normal! ggdG
  silent put =s:CMP.execute(':message')
  normal! G
  setlocal nomodifiable
  nnoremap <silent> <buffer> q :silent bd<CR>
endfunction

function! s:safe_revert_buffer() abort
  if s:MESSAGE.confirm('Revert buffer form ' . expand('%:p'))
    edit!
  endif
  redraw!
endfunction

function! s:delete_current_buffer_file() abort
  if s:MESSAGE.confirm('Are you sure you want to delete this file')
    let f = expand('%')
    if delete(f) == 0
      call SpaceVim#mapping#close_current_buffer('n')
      echo "File '" . f . "' successfully deleted!"
    else
      call s:MESSAGE.warn('Failed to delete file:' . f)
    endif
  endif
endfunction

function! s:swap_buffer_with_nth_win(nr) abort
  if a:nr <= winnr('$') && a:nr != winnr()
    let cb = bufnr('%')
    let tb = winbufnr(a:nr)
    if cb != tb
      exe a:nr . 'wincmd w'
      exe 'b' . cb
      wincmd p
      exe 'b' . tb
    endif
  endif
endfunction

function! s:move_buffer_to_nth_win(nr) abort
  if a:nr <= winnr('$') && a:nr != winnr()
    let cb = bufnr('%')
    bp
    exe a:nr . 'wincmd w'
    exe 'b' . cb
    wincmd p
  endif
endfunction

function! s:buffer_transient_state() abort
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Buffer Selection Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : {
        \ 'name' : 'C-1..C-9',
        \ 'pos' : [[1,4], [6,9]],
        \ 'handles' : [
        \ ["\<C-1>" , ''],
        \ ["\<C-2>" , ''],
        \ ["\<C-3>" , ''],
        \ ["\<C-4>" , ''],
        \ ["\<C-5>" , ''],
        \ ["\<C-6>" , ''],
        \ ["\<C-7>" , ''],
        \ ["\<C-8>" , ''],
        \ ["\<C-9>" , ''],
        \ ],
        \ },
        \ 'desc' : 'goto nth window',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : {
        \ 'name' : '1..9',
        \ 'pos' : [[1,2], [4,5]],
        \ 'handles' : [
        \ ['1' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [1])'],
        \ ['2' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [2])'],
        \ ['3' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [3])'],
        \ ['4' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [4])'],
        \ ['5' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [5])'],
        \ ['6' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [6])'],
        \ ['7' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [7])'],
        \ ['8' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [8])'],
        \ ['9' , 'call call(' . string(s:_function('s:move_buffer_to_nth_win')) . ', [9])'],
        \ ],
        \ },
        \ 'desc' : 'move buffer to nth window',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : {
        \ 'name' : 'M-1..M-9',
        \ 'pos' : [[1,4], [6,9]],
        \ 'handles' : [
        \ ["\<M-1>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [1])'],
        \ ["\<M-2>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [2])'],
        \ ["\<M-3>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [3])'],
        \ ["\<M-4>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [4])'],
        \ ["\<M-5>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [5])'],
        \ ["\<M-6>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [6])'],
        \ ["\<M-7>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [7])'],
        \ ["\<M-8>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [8])'],
        \ ["\<M-9>" , 'call call(' . string(s:_function('s:swap_buffer_with_nth_win')) . ', [9])'],
        \ ],
        \ },
        \ 'desc' : 'swap buffer with nth window',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'next buffer',
        \ 'func' : '',
        \ 'cmd' : 'bnext',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : ['N', 'p'],
        \ 'desc' : 'previous buffer',
        \ 'func' : '',
        \ 'cmd' : 'bp',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'd',
        \ 'desc' : 'kill buffer',
        \ 'func' : '',
        \ 'cmd' : 'call SpaceVim#mapping#close_current_buffer()',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'q',
        \ 'desc' : 'quit',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

function! s:commentOperator(type, ...) abort
  let sel_save = &selection
  let &selection = 'inclusive'
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe 'normal! gv'
    call feedkeys("\<Plug>NERDCommenterComment")
  elseif a:type ==# 'line'
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

function! s:comment_paragraphs(invert) abort
  if a:invert
    call feedkeys("vip\<Plug>NERDCommenterInvert")
  else
    call feedkeys("vip\<Plug>NERDCommenterComment")
  endif
endfunction

" this func only for neovim-qt in windows
function! s:restart_neovim_qt() abort
  call system('taskkill /f /t /im nvim.exe')
endfunction


let g:_spacevim_autoclose_filetree = 1
function! s:explore_current_dir(cur) abort
  if g:spacevim_filemanager ==# 'vimfiler'
    if !a:cur
      let g:_spacevim_autoclose_filetree = 0
      VimFilerCurrentDir -no-split -no-toggle
      let g:_spacevim_autoclose_filetree = 1
    else
      VimFilerCurrentDir -no-toggle
    endif
  elseif g:spacevim_filemanager ==# 'nerdtree'
    if !a:cur
      exe 'e ' . getcwd() 
    else
      NERDTreeCWD
    endif
  elseif g:spacevim_filemanager ==# 'defx'
    if !a:cur
      let g:_spacevim_autoclose_filetree = 0
      Defx -no-toggle -no-resume -split=no `getcwd()`
      let g:_spacevim_autoclose_filetree = 1
    else
      Defx -no-toggle
    endif
  endif
endfunction
