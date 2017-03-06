scriptencoding utf-8
let g:unite_source_menu_menus =
      \ get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.CustomKeyMaps = {'description':
      \ 'Custom mapped keyboard shortcuts                   [unite]<SPACE>'}
let g:unite_source_menu_menus.CustomKeyMaps.command_candidates =
      \ get(g:unite_source_menu_menus.CustomKeyMaps,'command_candidates', [])

function! SpaceVim#mapping#def(type,key,value,desc,...) abort
  exec a:type . ' ' . a:key . ' ' . a:value
  let description = '➤ '
        \. a:desc
        \. repeat(' ', 80 - len(a:desc) - len(a:key))
        \. a:key
  let cmd = len(a:000) > 0 ? a:000[0] : a:value
  call add(g:unite_source_menu_menus.CustomKeyMaps.command_candidates, [description,cmd])
endfunction

function! SpaceVim#mapping#tab() abort
  if getline('.')[col('.')-2] ==# '{'&& pumvisible()
    return "\<C-n>"
  endif
  if index(g:spacevim_plugin_groups, 'autocomplete') != -1
    if neosnippet#expandable() && getline('.')[col('.')-2] ==# '(' && !pumvisible()
      return "\<Plug>(neosnippet_expand)"
    elseif neosnippet#jumpable()
          \ && getline('.')[col('.')-2] ==# '(' && !pumvisible() 
          \ && !neosnippet#expandable()
      return "\<plug>(neosnippet_jump)"
    elseif neosnippet#expandable_or_jumpable() && getline('.')[col('.')-2] !=#'('
      return "\<plug>(neosnippet_expand_or_jump)"
    elseif pumvisible()
      return "\<C-n>"
    else
      return "\<tab>"
    endif
  elseif pumvisible()
    return "\<C-n>"
  else
    return "\<tab>"
  endif
endfunction

function! SpaceVim#mapping#enter() abort
  if pumvisible()
    if getline('.')[col('.') - 2]==# '{'
      return "\<Enter>"
    elseif g:spacevim_autocomplete_method ==# 'neocomplete'||g:spacevim_autocomplete_method ==# 'deoplete'
      return "\<C-y>"
    else
      return "\<esc>a"
    endif
  elseif getline('.')[col('.') - 2]==#'{'&&getline('.')[col('.')-1]==#'}'
    return "\<Enter>\<esc>ko"
  else
    return "\<Enter>"
  endif
endfunction

function! SpaceVim#mapping#gd() abort
  if !empty(SpaceVim#mapping#gd#get())
    call call(SpaceVim#mapping#gd#get(), [])
  else
    normal! gd
  endif
endfunction

function! SpaceVim#mapping#clearBuffers() abort
  for i in range(1,bufnr('$'))
    if i != bufnr('%')
      try 
        exe 'bw ' . i
      catch
      endtry
    endif
  endfor
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

" vim:set et sw=2:
