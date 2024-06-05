"=============================================================================
" FILE: echodoc.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Variables
let s:echodoc_dicts = [ echodoc#default#get() ]
let s:is_enabled = 0
let s:echodoc_id = 1050
if exists('*nvim_create_namespace')
  let s:echodoc_id = nvim_create_namespace('echodoc.vim')
elseif exists('*nvim_buf_add_highlight')
  let s:echodoc_id = nvim_buf_add_highlight(0, 0, '', 0, 0, 0)
endif
if exists('*nvim_create_buf')
  let s:floating_buf = v:null
  let s:win = v:null
  let s:floating_buf = nvim_create_buf(v:false, v:true)
endif

if exists('*popup_create')
  let s:win = v:null
  let s:last_ident_idx = v:null
endif

let g:echodoc#type = get(g:,
      \ 'echodoc#type', 'echo')
let g:echodoc#highlight_identifier = get(g:,
      \ 'echodoc#highlight_identifier', 'Identifier')
let g:echodoc#highlight_arguments = get(g:,
      \ 'echodoc#highlight_arguments', 'Special')
let g:echodoc#highlight_trailing = get(g:,
      \ 'echodoc#highlight_trailing', 'Type')
let g:echodoc#events = get(g:,
      \ 'echodoc#events', ['CompleteDone', 'TextChangedP'])

let g:echodoc#floating_config = get(g:,
      \ 'echodoc#floating_config', {})

function! echodoc#enable() abort
  if echodoc#is_echo() && &showmode && &cmdheight < 2
    " Increase the cmdheight so user can clearly see the error
    set cmdheight=2
    call s:print_error('Your cmdheight is too small. '
          \ .'You must increase ''cmdheight'' value or set noshowmode.')
  endif

  augroup echodoc
    autocmd!
    autocmd InsertEnter * call s:on_event('InsertEnter')
    autocmd CursorMovedI * call s:on_event('CursorMovedI')
    autocmd InsertLeave * call s:clear_documentation()
  augroup END
  for event in g:echodoc#events
    if exists('##' . event)
      execute printf('autocmd echodoc %s * call s:on_event("%s")',
            \ event, event)
    elseif exists('##User#' . event)
      execute printf('autocmd echodoc User %s * call s:on_event("%s")',
            \ event, event)
    endif
  endfor
  let s:is_enabled = 1
endfunction
function! echodoc#disable() abort
  augroup echodoc
    autocmd!
  augroup END
  let s:is_enabled = 0
endfunction
function! echodoc#is_enabled() abort
  return s:is_enabled
endfunction
function! echodoc#is_echo() abort
  return g:echodoc#type ==# 'echo'
endfunction
function! echodoc#is_signature() abort
  return g:echodoc#type ==# 'signature'
        \ && has('nvim') && get(g:, 'gonvim_running', 0)
endfunction
function! echodoc#is_virtual() abort
  return g:echodoc#type ==# 'virtual' && exists('*nvim_buf_set_extmark')
endfunction
function! echodoc#is_virtual_lines() abort
  return g:echodoc#type ==# 'virtual_lines' && has('nvim-0.6')
endfunction
function! echodoc#is_floating() abort
  return g:echodoc#type ==# 'floating' && exists('*nvim_open_win')
endfunction
function! echodoc#is_popup() abort
  return g:echodoc#type ==# 'popup' && exists('*popup_create')
endfunction
function! echodoc#get(name) abort
  return get(filter(s:echodoc_dicts,
        \ 'v:val.name ==#' . string(a:name)), 0, {})
endfunction
function! echodoc#register(name, dict) abort
  " Unregister previous dict.
  call echodoc#unregister(a:name)

  call add(s:echodoc_dicts, a:dict)

  " Sort.
  call sort(s:echodoc_dicts, 's:compare')
endfunction
function! echodoc#unregister(name) abort
  call filter(s:echodoc_dicts, 'v:val.name !=#' . string(a:name))
endfunction

" Misc.
function! s:compare(a1, a2) abort
  return a:a1.rank - a:a2.rank
endfunction
function! s:context_filetype_enabled() abort
  if !exists('s:exists_context_filetype')
    try
      call context_filetype#version()
      let s:exists_context_filetype = 1
    catch
      let s:exists_context_filetype = 0
    endtry
  endif

  return s:exists_context_filetype
endfunction
function! s:print_error(msg) abort
  echohl Error | echomsg '[echodoc] '  . a:msg | echohl None
endfunction

" Autocmd events.
function! s:on_event(event) abort
  " Skip if not enabled
  if !get(g:, 'echodoc#enable_at_startup', 0) && !get(b:, 'echodoc_enabled', 0)
    return
  endif

  let filetype = s:context_filetype_enabled() ?
        \ context_filetype#get_filetype(&filetype) : &l:filetype
  if filetype ==# ''
    let filetype = 'nothing'
  endif

  call s:get_completed_item_and_store(filetype)
  let dicts = filter(copy(s:echodoc_dicts),
        \ "empty(get(v:val, 'filetypes', {}))
        \  || get(v:val.filetypes, filetype, 0)")
  let default_only = len(dicts) == 1
  if default_only && empty(echodoc#default#get_cache(filetype))
    return
  endif

  if a:event ==# 'CompleteChanged' || mode() ==# 'c'
    " CompleteChanged or command line mode does not work for display
    return
  endif

  let [line, col, cur_text] = echodoc#util#get_func_text()
  " No function text was found
  if cur_text ==# '' && default_only
    call s:clear_documentation()
    return
  endif

  let echodoc = s:find_and_format_item(dicts, cur_text, filetype)
  if !empty(echodoc)
    for doc in echodoc
      let doc.line = line
      let doc.col = col
    endfor
    let b:echodoc = echodoc
    call s:display(echodoc, filetype, a:event)
  elseif exists('b:echodoc')
    unlet b:echodoc
  endif
endfunction

function! s:get_completed_item_and_store(filetype) abort
  let completed_item = get(v:, 'completed_item', {})
  if empty(completed_item) && exists('v:event')
    let completed_item = get(v:event, 'completed_item', {})
  endif
  if exists('g:pum#completed_item')
    let completed_item = g:pum#completed_item
  endif
  if a:filetype !=# ''
    if !empty(completed_item)
      call echodoc#default#make_cache(a:filetype, completed_item)
    endif
    let info = exists('*ddc#complete_info') ? ddc#complete_info() :
          \ exists('*complete_info') ? complete_info() :
          \ { 'items': [] }
    if !empty(info.items)
      let item = info.selected >= 0 ? info.items[info.selected] : info.items[0]
      call echodoc#default#make_cache(a:filetype, item)
    endif
  endif
endfunction

function! s:find_and_format_item(dicts, cur_text, filetype) abort
  let echodoc = []
  for doc_dict in a:dicts
    if doc_dict.name ==# 'default'
      let ret = doc_dict.search(a:cur_text, a:filetype)
    else
      let ret = doc_dict.search(a:cur_text)
    endif

    if !empty(ret)
      " Overwrite cached result
      let echodoc = ret
      break
    endif
  endfor
  return echodoc
endfunction

function! s:clear_documentation() abort
  if echodoc#is_echo()
    echo ''
  elseif echodoc#is_signature()
    call rpcnotify(0, 'Gui', 'signature_hide')
  elseif echodoc#is_floating()
    if s:win != v:null
      call nvim_win_close(s:win, v:false)
      let s:win = v:null
    endif
    call nvim_buf_clear_namespace(s:floating_buf, s:echodoc_id, 0, -1)
  elseif echodoc#is_virtual() || echodoc#is_virtual_lines()
    call nvim_buf_clear_namespace(bufnr('%'), s:echodoc_id, 0, -1)
  elseif echodoc#is_popup()
    if s:win != v:null
        silent! call popup_close(s:win)
        let s:win = v:null
    endif
  endif
endfunction

function! s:display(echodoc, filetype, event) abort
  " Text check
  let text = ''
  for doc in a:echodoc
    let text .= doc.text
  endfor
  if matchstr(text, '^\s*$')
    return
  endif

  let identifier_pos = match(getline(a:echodoc[0].line), a:echodoc[0].text)
  if identifier_pos != -1 " Identifier found in current line
    let cursor_pos = getpos('.')[2]
    " align the function signature text and the line text
    let identifier_pos = cursor_pos - identifier_pos
  endif

  " Display
  if echodoc#is_echo()
    echo ''
    let echospace = get(v:, 'echospace', -1)
    for doc in a:echodoc
      let text = doc.text
      if exists('v:echospace')
        " To prevent 2 "Hit enter to continue"
        let text = strcharpart(text, 0, echospace)
        let echospace -= strwidth(text)
      endif

      if has_key(doc, 'highlight')
        execute 'echohl' doc.highlight
        echon text
        echohl None
      else
        echon text
      endif
    endfor
  elseif echodoc#is_signature()
    let parse = echodoc#util#parse_funcs(getline('.'), a:filetype)
    if empty(parse)
      return
    endif
    let col = -(col('.') - parse[-1].start + 1)
    let idx = 0
    let text = ''
    let line = (winline() <= 2) ? 3 : -1
    for doc in a:echodoc
      let text .= doc.text
      if has_key(doc, 'i')
        let idx = doc.i
      endif
    endfor
    call rpcnotify(0, 'Gui', 'signature_show', text, [line, col], idx)
    redraw!
  elseif echodoc#is_virtual() || echodoc#is_virtual_lines()
    call nvim_buf_clear_namespace(0, s:echodoc_id, 0, -1)
    let chunks = map(copy(a:echodoc),
          \ { _, val -> [v:val.text, get(v:val, 'highlight', 'Normal')] })
    if echodoc#is_virtual()
      call nvim_buf_set_extmark(
            \ 0, s:echodoc_id, line('.') - 1, 0, { 'virt_text': chunks })
    else
      call nvim_buf_set_extmark(
            \ 0, s:echodoc_id, line('.') - 1, 0, {
            \   'virt_lines': [chunks],
            \   'virt_lines_above': v:true,
            \ })
    endif
  elseif echodoc#is_floating()
    let hunk = join(map(copy(a:echodoc), 'v:val.text'), '')
    let window_width = strlen(hunk)

    call nvim_buf_set_lines(s:floating_buf, 0, -1, v:true, [hunk])

    let opts = g:echodoc#floating_config

    call extend(opts, {
          \   'relative': 'cursor',
          \   'width': window_width,
          \   'height': 1,
          \   'col': -identifier_pos + 1,
          \   'row': a:echodoc[0].line - line('.'), 'anchor': 'SW',
          \ })

    if s:win == v:null
      let s:win = nvim_open_win(s:floating_buf, 0, opts)

      call nvim_win_set_option(s:win, 'number', v:false)
      call nvim_win_set_option(s:win, 'relativenumber', v:false)
      call nvim_win_set_option(s:win, 'cursorline', v:false)
      call nvim_win_set_option(s:win, 'cursorcolumn', v:false)
      call nvim_win_set_option(s:win, 'colorcolumn', '')
      call nvim_win_set_option(s:win, 'conceallevel', 2)
      call nvim_win_set_option(s:win, 'signcolumn', 'no')
      call nvim_win_set_option(s:win, 'winhl', 'Normal:EchoDocFloat')

      call nvim_buf_set_option(s:floating_buf, 'buftype', 'nofile')
      call nvim_buf_set_option(s:floating_buf, 'bufhidden', 'delete')
    else
      call nvim_win_set_config(s:win, opts)
    endif

    call nvim_buf_clear_namespace(s:floating_buf, s:echodoc_id, 0, -1)

    let last_chunk_index = 0
    for doc in a:echodoc
      let len_current_chunk = strlen(doc.text)
      if has_key(doc, 'highlight')
        call nvim_buf_add_highlight(
              \ s:floating_buf, s:echodoc_id, doc.highlight, 0,
              \ last_chunk_index,
              \ len_current_chunk + last_chunk_index)
      endif
      let last_chunk_index += len_current_chunk
    endfor
  elseif echodoc#is_popup()
    " popup_close if function changed
    if s:last_ident_idx != identifier_pos
      let s:last_ident_idx = identifier_pos
      call popup_close(s:win)
      let s:win = v:null
    endif

    let bufnr = winbufnr(s:win)
    if s:win == v:null || bufnr < 0
      let line = a:echodoc[0].line - line('.') - 1
      let col = -identifier_pos + 1

      let s:win = popup_create(text, {
            \ 'line': 'cursor' . line,
            \ 'col': 'cursor' . (col == 0 ? '' : col > 0 ? '+' . col : col),
            \ 'maxheight': 1,
            \ 'wrap': v:false,
            \ 'highlight': 'EchoDocPopup',
            \ })
    else
      call win_execute(s:win, 'call setbufline(winbufnr(s:win), 1, text)')
    endif

    let bufnr = winbufnr(s:win)

    " highlight
    " clear
    if bufnr < 0
        return
    endif
    call map(
          \ copy(prop_type_list({'bufnr': bufnr})),
          \ "prop_remove({'bufnr': bufnr, 'type': v:val, 'all': 1})",
          \ )

    let last_chunk_col = 1
    for doc in a:echodoc
      let len_current_chunk = strlen(doc.text)
      if has_key(doc, 'highlight')
        let type_name = 'Echodoc'.doc.highlight
        " define
        call prop_type_delete(type_name, {'bufnr': bufnr})
        call prop_type_add(type_name, {
              \ 'highlight': doc.highlight,
              \ 'bufnr': bufnr,
              \ })

        " place
        call prop_add(1, last_chunk_col, {
              \ 'length': len_current_chunk,
              \ 'bufnr': bufnr,
              \ 'type': type_name,
              \ })
      endif
      let last_chunk_col += len_current_chunk
    endfor
  endif
endfunction
