"=============================================================================
" mapping.vim --- mapping functions in SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:BUFFER = SpaceVim#api#import('vim#buffer')


let g:unite_source_menu_menus =
      \ get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.CustomKeyMaps = {'description':
      \ 'Custom mapped keyboard shortcuts                   [unite]<SPACE>'}
let g:unite_source_menu_menus.CustomKeyMaps.command_candidates =
      \ get(g:unite_source_menu_menus.CustomKeyMaps,'command_candidates', [])

function! SpaceVim#mapping#_def(type,key,value,desc,...) abort
  exec a:type . ' ' . a:key . ' ' . a:value
  let description = '➤ '
        \. a:desc
        \. repeat(' ', 80 - len(a:desc) - len(a:key))
        \. a:key
  let cmd = len(a:000) > 0 ? a:000[0] : a:value
  call add(g:unite_source_menu_menus.CustomKeyMaps.command_candidates, [description,cmd])
endfunction

" a:1 unite desc
" a:2 unite cmd
" a:3 guide desc
" example  call SpaceVim#mapping#def('nnoremap <silent>', 'gf', ':call zvim#gf()<CR>', 'Jump to a file under cursor', '')
function! SpaceVim#mapping#def(type, key, value, ...) abort
  let feedkeys_mode = 'm'
  let map = split(a:type)[0]
  if map =~# 'nore'
    let feedkeys_mode = 'n'
  endif
  " TODO parse lhs and rhs, return list of key
  "let lhs = a:key
  "let rhs = a:value
  let gexe = a:value
  if a:value =~? '^<plug>'
    let gexe = '\' . a:value
  elseif a:value =~? ':.\+<cr>$'
    let gexe = substitute(gexe, '<cr>', "\<cr>", 'g')
    let gexe = substitute(gexe, '<CR>', "\<CR>", 'g')
    let gexe = substitute(gexe, '<Esc>', "\<Esc>", 'g')
  else
  endif
  if g:spacevim_enable_key_frequency
    exec a:type . ' <expr> ' . a:key . " SpaceVim#mapping#frequency#update('" . a:key . "', '" . a:value . "')"
  else
    exec a:type . ' ' . a:key . ' ' . a:value
  endif
  if a:0 > 0
    let desc = a:1
    let description = '➤ '
          \ . desc
          \ . repeat(' ', 80 - len(desc) - len(a:key))
          \ . a:key
    let cmd = a:0 == 2 ? a:2 : a:value
    call add(g:unite_source_menu_menus.CustomKeyMaps.command_candidates, [description,cmd])
    if a:0 == 3
      " enable guide
      if a:key =~? '^<leader>'
        if len(a:key) > 9
          let group = a:key[8:8]
          if !has_key(g:_spacevim_mappings, group)
            let g:_spacevim_mappings[group] = {'name': 'new group'}
          endif
          call extend(g:_spacevim_mappings[group], {
                \ a:key[9:] : ['call feedkeys("' . gexe . '", "'
                \ . feedkeys_mode . '")', a:3]
                \ })
        elseif len(a:key) == 9
          call extend(g:_spacevim_mappings, {
                \ a:key[8:] : ['call feedkeys("' . gexe . '", "'
                \ . feedkeys_mode . '")', a:3]
                \ })

        endif
      endif
    endif
  endif
endfunction

if g:spacevim_snippet_engine ==# 'neosnippet'
  function! SpaceVim#mapping#shift_tab() abort
    return pumvisible() ? "\<C-p>" : "\<Plug>delimitMateS-Tab"
  endfunction
elseif g:spacevim_snippet_engine ==# 'ultisnips'
  function! SpaceVim#mapping#shift_tab() abort
    return pumvisible() ? "\<C-p>" : "\<C-R>=UltiSnips#JumpForwards()\<CR>\<C-R>=cmp#ultisnips#JumpForward()\<CR>"
  endfunction
endif

function! SpaceVim#mapping#tab() abort
  return SpaceVim#mapping#tab#i_tab()
endfunction

function! SpaceVim#mapping#enter() abort
  return SpaceVim#mapping#enter#i_enter()
endfunction

function! SpaceVim#mapping#gd() abort
  if !empty(SpaceVim#mapping#gd#get())
    call call(SpaceVim#mapping#gd#get(), [])
  else
    normal! gd
  endif
endfunction

function! SpaceVim#mapping#clearBuffers() abort
  if confirm('Kill all other buffers?', "&Yes\n&No\n&Cancel") == 1
    let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    for i in blisted
      if i != bufnr('%')
        try 
          exe 'bw ' . i
        catch
        endtry
      endif
    endfor
  endif
endfunction

function! SpaceVim#mapping#split_previous_buffer() abort
  if bufnr('#') == -1
    call SpaceVim#util#echoWarn('There is no previous buffer')
  else
    split
    wincmd w
    e#
  endif

endfunction

function! SpaceVim#mapping#vertical_split_previous_buffer() abort
  if bufnr('#') == -1
    call SpaceVim#util#echoWarn('There is no previous buffer')
  else
    vsplit
    wincmd w
    e#
  endif
endfunction

function! SpaceVim#mapping#close_current_buffer() abort
  let buffers = get(g:, '_spacevim_list_buffers', [])
  let bn = bufnr('%')
  let f = ''
  if getbufvar(bn, '&modified', 0)
    redraw
    echohl WarningMsg
    echon 'save changes to "' . bufname(bn) . '"?  Yes/No/Cancel'
    echohl None
    let rs = nr2char(getchar())
    if rs ==? 'y'
      write
    elseif rs ==? 'n'
      let f = '!'
      redraw
      echohl ModeMsg
      echon 'discarded!'
      echohl None
    else
      redraw
      echohl ModeMsg
      echon 'canceled!'
      echohl None
      return
    endif
  endif

  if &buftype == 'terminal'
    exe 'bd!'
    return
  endif

  let cmd_close_buf = 'bd' . f
  let index = index(buffers, bn)
  if index != -1
    if index == 0
      if len(buffers) > 1
        exe 'b' . buffers[1]
        exe cmd_close_buf . bn
      else
        exe cmd_close_buf . bn
      endif
    elseif index > 0
      if index + 1 == len(buffers)
        exe 'b' . buffers[index - 1]
        exe cmd_close_buf . bn
      else
        exe 'b' . buffers[index + 1]
        exe cmd_close_buf . bn
      endif
    endif
  endif
endfunction

function! SpaceVim#mapping#close_term_buffer(...) abort
  let buffers = get(g:, '_spacevim_list_buffers', [])
  let abuf = str2nr(g:_spacevim_termclose_abuf)
  let index = index(buffers, abuf)
  if get(w:, 'shell_layer_win', 0) == 1
    exe 'bd!' . abuf
    return
  endif
  if index != -1
    if index == 0
      if len(buffers) > 1
        exe 'b' . buffers[1]
        exe 'bd!' . abuf
      else
        exe 'bd! ' . abuf
      endif
    elseif index > 0
      if index + 1 == len(buffers)
        exe 'b' . buffers[index - 1]
        exe 'bd!' . abuf
      else
        exe 'b' . buffers[index + 1]
        exe 'bd!' . abuf
      endif
    endif
  endif
endfunction

function! SpaceVim#mapping#kill_visible_buffer_choosewin() abort
  ChooseWin
  let nr = bufnr('%')
  for i in range(1, winnr('$'))
    if winbufnr(i) == nr
      exe i .  'wincmd w'
      enew
    endif
  endfor
  exe 'bwipeout ' . nr
endfunction

function! SpaceVim#mapping#menu(desc, key, cmd) abort
  let description = '➤ '
        \. a:desc
        \. repeat(' ', 80 - len(a:desc) - len(a:key))
        \. a:key
  call add(g:unite_source_menu_menus.CustomKeyMaps.command_candidates,
        \ [description ,
        \ a:cmd])
endfunction

function! SpaceVim#mapping#clear_saved_buffers()
  call s:BUFFER.filter_do(
        \ {
        \ 'expr' : [
        \ 'buflisted(v:val)',
        \ 'index(tabpagebuflist(), v:val) == -1',
        \ 'getbufvar(v:val, "&mod") == 0',
        \ ],
        \ 'do' : 'bd %d'
        \ }
        \ )
endfunction


" vim:set et sw=2 cc=80:
