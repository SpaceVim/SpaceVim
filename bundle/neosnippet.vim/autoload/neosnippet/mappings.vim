"=============================================================================
" FILE: mappings.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neosnippet#mappings#expandable_or_jumpable() abort
  return neosnippet#mappings#expandable() || neosnippet#mappings#jumpable()
endfunction
function! neosnippet#mappings#expandable() abort
  " Check snippet trigger.
  return neosnippet#mappings#completed_expandable()
        \ || neosnippet#helpers#get_cursor_snippet(
        \      neosnippet#helpers#get_snippets('i'),
        \      neosnippet#util#get_cur_text()) !=# ''
endfunction
function! neosnippet#mappings#jumpable() abort
  " Found snippet placeholder.
  return search(neosnippet#get_placeholder_marker_pattern(). '\|'
            \ .neosnippet#get_sync_placeholder_marker_pattern(), 'nw') > 0
endfunction
function! neosnippet#mappings#completed_expandable() abort
  if empty(get(v:, 'completed_item', {}))
    return 0
  endif

  return !empty(s:get_completed_snippets(
        \ neosnippet#util#get_cur_text(), col('.')))
endfunction

function! neosnippet#mappings#_clear_select_mode_mappings() abort
  if !g:neosnippet#disable_select_mode_mappings || !exists('*execute')
    return
  endif

  let mappings = execute('smap', 'silent!')

  for map in map(filter(split(mappings, '\n'),
        \ "v:val !~# '^s' && v:val !~# '^\\a*\\s*<\\S\\+>'"),
        \ "matchstr(v:val, '^\\a*\\s*\\zs\\S\\+')")
    silent! execute 'sunmap' map
    silent! execute 'sunmap <buffer>' map
  endfor

  " Define default select mode mappings.
  snoremap <CR>     a<BS>
  snoremap <BS>     a<BS>
  snoremap <Del>    a<BS>
  snoremap <C-h>    a<BS>
endfunction

function! neosnippet#mappings#_register_oneshot_snippet() abort
  let trigger = input('Please input snippet trigger: ', 'oneshot')
  if trigger ==# ''
    return
  endif

  let selected_text = substitute(
        \ neosnippet#helpers#get_selected_text(visualmode(), 1), '\n$', '', '')
  call neosnippet#helpers#delete_selected_text(visualmode(), 1)

  let base_indent = matchstr(selected_text, '^\s*')

  " Delete base_indent.
  let selected_text = substitute(selected_text,
        \'^' . base_indent, '', 'g')

  let neosnippet = neosnippet#variables#current_neosnippet()
  let options = neosnippet#parser#_initialize_snippet_options()
  let options.word = 1
  let options.oneshot = 1

  let neosnippet.snippets[trigger] = neosnippet#parser#_initialize_snippet(
        \ { 'name' : trigger, 'word' : selected_text, 'options' : options },
        \ '', 0, '', trigger)

  echo 'Registered trigger : ' . trigger
endfunction

function! neosnippet#mappings#_expand_target() abort
  let trigger = input('Please input snippet trigger: ',
        \ '', 'customlist,neosnippet#commands#_complete_target_snippets')
  let neosnippet = neosnippet#variables#current_neosnippet()
  if !has_key(neosnippet#helpers#get_snippets('i'), trigger) ||
        \ neosnippet#helpers#get_snippets('i')[trigger].snip !~#
        \   neosnippet#get_placeholder_target_marker_pattern()
    if trigger !=# ''
      echo 'The trigger is invalid.'
    endif

    let neosnippet.target = ''
    return
  endif

  call neosnippet#mappings#_expand_target_trigger(trigger)
endfunction
function! neosnippet#mappings#_expand_target_trigger(trigger) abort
  let neosnippet = neosnippet#variables#current_neosnippet()
  let neosnippet.target = substitute(
        \ neosnippet#helpers#get_selected_text(visualmode(), 1), '\n$', '', '')

  let line = getpos("'<")[1]
  let col = getpos("'<")[2]

  call neosnippet#helpers#delete_selected_text(visualmode())

  call cursor(line, col)

  if col == 1
    let cur_text = a:trigger
  else
    let cur_text = neosnippet#util#get_cur_text()
    let cur_text = cur_text[: col-2] . a:trigger
  endif

  call neosnippet#view#_expand(cur_text, col, a:trigger)

  if !neosnippet#mappings#jumpable()
    call cursor(0, col('.') - 1)
    stopinsert
  endif
endfunction

function! neosnippet#mappings#_anonymous(snippet) abort
  let [cur_text, col, expr] = neosnippet#mappings#_pre_trigger()
  let expr .= printf("\<ESC>:call neosnippet#view#_insert(%s, {}, %s, %d)\<CR>",
        \ string(a:snippet), string(cur_text), col)

  return expr
endfunction
function! neosnippet#mappings#_expand(trigger) abort
  let [cur_text, col, expr] = neosnippet#mappings#_pre_trigger()

  let expr .= printf("\<ESC>:call neosnippet#view#_expand(%s, %d, %s)\<CR>",
        \ string(cur_text), col, string(a:trigger))

  return expr
endfunction

function! s:snippets_expand(cur_text, col) abort
  let cur_word = neosnippet#helpers#get_cursor_snippet(
        \ neosnippet#helpers#get_snippets('i'),
        \ a:cur_text)
  if cur_word !=# ''
    " Found snippet trigger.
    call neosnippet#view#_expand(
          \ neosnippet#util#get_cur_text(), a:col, cur_word)
    return 0
  endif

  return 1
endfunction
function! s:get_completed_snippets(cur_text, col) abort
  if empty(get(v:, 'completed_item', {}))
    return []
  endif

  let user_data = get(v:completed_item, 'user_data', '')
  if user_data !=# ''
    let ret = s:get_user_data(a:cur_text)
    if !empty(ret)
      return [ret[0], ret[1], ret[2]]
    endif
  endif

  if g:neosnippet#enable_completed_snippet
    let snippet = neosnippet#parser#_get_completed_snippet(
          \ v:completed_item, a:cur_text, neosnippet#util#get_next_text())
    if snippet !=# ''
      return [a:cur_text, snippet, {}]
    endif
  endif

  return []
endfunction
function! s:get_user_data(cur_text) abort
  let user_data = json_decode(v:completed_item.user_data)
  if type(user_data) !=# v:t_dict
    return []
  endif

  let cur_text = a:cur_text
  let has_lspitem = has_key(user_data, 'lspitem')
  let snippet_trigger = ''

  if has_lspitem && type(user_data.lspitem) == v:t_dict
    let lspitem = user_data.lspitem
    if has_key(lspitem, 'textEdit') && type(lspitem.textEdit) == v:t_dict
      let snippet = lspitem.textEdit.newText
      let snippet_trigger = v:completed_item.word
    elseif get(lspitem, 'insertTextFormat', -1) == 2
      let snippet = lspitem.insertText
      let snippet_trigger = v:completed_item.word
    endif
  elseif get(user_data, 'snippet', '') !=# ''
    let snippet = user_data.snippet
    let snippet_trigger = get(user_data, 'snippet_trigger',
          \ v:completed_item.word)
  endif

  if snippet_trigger !=# ''
    " Substitute $0, $1, $2,... to ${0}, ${1}, ${2}...
    let snippet = substitute(snippet, '\$\(\d\+\)', '${\1}', 'g')
    " Substitute quotes
    let snippet = substitute(snippet, "'", "''", 'g')

    let cur_text = cur_text[: -1-len(snippet_trigger)]
    return [cur_text, snippet, {'lspitem': has_lspitem}]
  endif

  return []
endfunction
function! neosnippet#mappings#_complete_done(cur_text, col) abort
  let ret = s:get_completed_snippets(a:cur_text, a:col)
  if empty(ret)
    return 0
  endif

  let [cur_text, snippet, options] = ret
  call neosnippet#view#_insert(snippet, options, cur_text, a:col)
  return 1
endfunction

function! s:snippets_expand_or_jump(cur_text, col) abort
  if s:snippets_expand(a:cur_text, a:col)
    call neosnippet#view#_jump('', a:col)
  endif
endfunction

function! s:snippets_jump_or_expand(cur_text, col) abort
  if search(neosnippet#get_placeholder_marker_pattern(). '\|'
            \ .neosnippet#get_sync_placeholder_marker_pattern(), 'nw') > 0
    " Found snippet placeholder.
    call neosnippet#view#_jump('', a:col)
  else
    return s:snippets_expand(a:cur_text, a:col)
  endif
endfunction

function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\ze\w\+$')
endfunction

function! neosnippet#mappings#_trigger(function) abort
  if g:neosnippet#enable_complete_done && pumvisible()
        \ && neosnippet#mappings#expandable()
      return ''
  endif

  if !neosnippet#mappings#expandable_or_jumpable()
    return ''
  endif

  let [cur_text, col, expr] = neosnippet#mappings#_pre_trigger()

  let expr .= printf("\<ESC>:call %s(%s,%d)\<CR>",
        \ a:function, string(cur_text), col)

  return expr
endfunction

function! neosnippet#mappings#_pre_trigger() abort
  call neosnippet#init#check()

  let cur_text = neosnippet#util#get_cur_text()

  let col = col('.')
  let expr = ''
  if mode() !=# 'i'
    " Fix column.
    let col += 2
  endif

  " Get selected text.
  let neosnippet = neosnippet#variables#current_neosnippet()
  let neosnippet.trigger = 1
  if mode() ==# 's' && neosnippet.optional_tabstop
    let expr .= "\<C-o>\"_d"
  endif

  return [cur_text, col, expr]
endfunction

" Plugin key-mappings.
function! neosnippet#mappings#expand_or_jump_impl() abort
  return mode() ==# 's' ?
        \ neosnippet#mappings#_trigger('neosnippet#view#_jump') :
        \ neosnippet#mappings#_trigger(
        \   s:SID_PREFIX().'snippets_expand_or_jump')
endfunction
function! neosnippet#mappings#jump_or_expand_impl() abort
  return mode() ==# 's' ?
        \ neosnippet#mappings#_trigger('neosnippet#view#_jump') :
        \ neosnippet#mappings#_trigger(
        \   s:SID_PREFIX().'snippets_jump_or_expand')
endfunction
function! neosnippet#mappings#expand_impl() abort
  return neosnippet#mappings#_trigger(s:SID_PREFIX().'snippets_expand')
endfunction
function! neosnippet#mappings#jump_impl() abort
  return neosnippet#mappings#_trigger('neosnippet#view#_jump')
endfunction
