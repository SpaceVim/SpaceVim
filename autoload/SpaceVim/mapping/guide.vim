"=============================================================================
" guide.vim --- key binding guide for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

" Load SpaceVim API

let s:CMP = SpaceVim#api#import('vim#compatible')
let s:STR = SpaceVim#api#import('data#string')
let s:KEY = SpaceVim#api#import('vim#key')
if has('nvim')
  let s:FLOATING = SpaceVim#api#import('neovim#floating')
else
  let s:FLOATING = SpaceVim#api#import('vim#floating')
endif
let s:SL = SpaceVim#api#import('vim#statusline')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

" guide specific var

let s:winid = -1
let s:bufnr = -1

function! SpaceVim#mapping#guide#has_configuration() abort "{{{
  return exists('s:desc_lookup')
endfunction "}}}

function! SpaceVim#mapping#guide#register_prefix_descriptions(key, dictname) abort " {{{
  let key = a:key ==? '<Space>' ? ' ' : a:key
  if !exists('s:desc_lookup')
    call s:create_cache()
  endif
  if strlen(key) == 0
    let s:desc_lookup['top'] = a:dictname
    return
  endif
  if !has_key(s:desc_lookup, key)
    let s:desc_lookup[key] = a:dictname
  endif
endfunction "}}}
function! s:create_cache() abort " {{{
  let s:desc_lookup = {}
  let s:cached_dicts = {}
endfunction " }}}
function! s:create_target_dict(key) abort " {{{
  if has_key(s:desc_lookup, 'top')
    let toplevel = deepcopy({s:desc_lookup['top']})
    let tardict = s:toplevel ? toplevel : get(toplevel, a:key, {})
    let mapdict = s:cached_dicts[a:key]
    call s:merge(tardict, mapdict)
  elseif has_key(s:desc_lookup, a:key)
    let tardict = deepcopy({s:desc_lookup[a:key]})
    let mapdict = s:cached_dicts[a:key]
    call s:merge(tardict, mapdict)
  else
    let tardict = s:cached_dicts[a:key]
  endif
  return tardict
endfunction " }}}
function! s:merge(dict_t, dict_o) abort " {{{
  let target = a:dict_t
  let other = a:dict_o
  for k in keys(target)
    if type(target[k]) == type({}) && has_key(other, k)
      if type(other[k]) == type({})
        if has_key(target[k], 'name')
          let other[k].name = target[k].name
        endif
        call s:merge(target[k], other[k])
      elseif type(other[k]) == type([])
        if g:leaderGuide_flatten == 0 || type(target[k]) == type({})
          let target[k.'m'] = target[k]
        endif
        let target[k] = other[k]
        if has_key(other, k.'m') && type(other[k.'m']) == type({})
          call s:merge(target[k.'m'], other[k.'m'])
        endif
      endif
    endif
  endfor
  call extend(target, other, 'keep')
endfunction " }}}

" @vimlint(EVL103, 1, a:dictname)
function! SpaceVim#mapping#guide#populate_dictionary(key, dictname) abort " {{{
  call s:start_parser(a:key, s:cached_dicts[a:key])
endfunction " }}}
" @vimlint(EVL103, 0, a:dictname)

function! SpaceVim#mapping#guide#parse_mappings() abort " {{{
  for [k, v] in items(s:cached_dicts)
    call s:start_parser(k, v)
  endfor
endfunction " }}}


function! s:start_parser(key, dict) abort " {{{
  if a:key ==# '[KEYs]'
    return
  endif
  let key = a:key ==? ' ' ? '<Space>' : a:key

  0verbose let readmap = s:CMP.execute('map ' . key, 'silent')

  let lines = split(readmap, "\n")
  let visual = s:vis ==# 'gv' ? 1 : 0

  for line in lines
    let mapd = maparg(split(line[3:])[0], line[0], 0, 1)
    if mapd.lhs ==# '\\'
      let mapd.feedkeyargs = ''
    elseif mapd.noremap == 1
      let mapd.feedkeyargs = 'nt'
    else
      let mapd.feedkeyargs = 'mt'
    endif
    if mapd.lhs =~# '<Plug>.*' || mapd.lhs =~# '<SNR>.*'
      continue
    endif
    let mapd.display = s:format_displaystring(mapd.rhs)
    let mapd.lhs = substitute(mapd.lhs, key, '', '')
    let mapd.lhs = substitute(mapd.lhs, '<Space>', ' ', 'g')
    let mapd.lhs = substitute(mapd.lhs, '<Tab>', '<C-I>', 'g')
    let mapd.rhs = substitute(mapd.rhs, '<SID>', '<SNR>'.mapd['sid'].'_', 'g')
    if mapd.lhs !=# '' && mapd.display !~# 'LeaderGuide.*'
      let mapd.lhs = s:string_to_keys(mapd.lhs)
      if (visual && match(mapd.mode, '[vx ]') >= 0) ||
            \ (!visual && match(mapd.mode, '[vx]') == -1)
        call s:add_map_to_dict(mapd, 0, a:dict)
      endif
    endif
  endfor
endfunction " }}}

function! s:add_map_to_dict(map, level, dict) abort " {{{
  if len(a:map.lhs) > a:level+1
    let curkey = a:map.lhs[a:level]
    let nlevel = a:level+1
    if !has_key(a:dict, curkey)
      let a:dict[curkey] = { 'name' : g:leaderGuide_default_group_name }
      " mapping defined already, flatten this map
    elseif type(a:dict[curkey]) == type([]) && g:leaderGuide_flatten
      let cmd = s:escape_mappings(a:map)
      let curkey = join(a:map.lhs[a:level+0:], '')
      let nlevel = a:level
      if !has_key(a:dict, curkey)
        let a:dict[curkey] = [cmd, a:map.display]
      endif
    elseif type(a:dict[curkey]) == type([]) && g:leaderGuide_flatten == 0
      let cmd = s:escape_mappings(a:map)
      let curkey = curkey.'m'
      if !has_key(a:dict, curkey)
        let a:dict[curkey] = { 'name' : g:leaderGuide_default_group_name }
      endif
    endif
    " next level
    if type(a:dict[curkey]) == type({})
      call s:add_map_to_dict(a:map, nlevel, a:dict[curkey])
    endif
  else
    let cmd = s:escape_mappings(a:map)
    if !has_key(a:dict, a:map.lhs[a:level])
      let a:dict[a:map.lhs[a:level]] = [cmd, a:map.display]
      " spot is taken already, flatten existing submaps
    elseif type(a:dict[a:map.lhs[a:level]]) == type({}) && g:leaderGuide_flatten
      let childmap = s:flattenmap(a:dict[a:map.lhs[a:level]], a:map.lhs[a:level])
      for it in keys(childmap)
        let a:dict[it] = childmap[it]
      endfor
      let a:dict[a:map.lhs[a:level]] = [cmd, a:map.display]
    endif
  endif
endfunction " }}}
" @vimlint(EVL111, 1, Fun)
function! s:format_displaystring(map) abort " {{{
  let g:leaderGuide#displayname = a:map
  for Fun in g:leaderGuide_displayfunc
    call Fun()
  endfor
  let display = g:leaderGuide#displayname
  unlet g:leaderGuide#displayname
  return display
endfunction " }}}
" @vimlint(EVL111, 0, Fun)
function! s:flattenmap(dict, str) abort " {{{
  let ret = {}
  for kv in keys(a:dict)
    if type(a:dict[kv]) == type([])
      let toret = {}
      let toret[a:str.kv] = a:dict[kv]
      return toret
    elseif type(a:dict[kv]) == type({})
      call extend(ret, s:flattenmap(a:dict[kv], a:str.kv))
    endif
  endfor
  return ret
endfunction " }}}


function! s:escape_mappings(mapping) abort " {{{
  let rstring = substitute(a:mapping.rhs, '\', '\\\\', 'g')
  let rstring = substitute(rstring, '<\([^<>]*\)>', '\\<\1>', 'g')
  let rstring = substitute(rstring, '"', '\\"', 'g')
  let rstring = 'call feedkeys("'.rstring.'", "'.a:mapping.feedkeyargs.'")'
  return rstring
endfunction " }}}
function! s:string_to_keys(input) abort " {{{
  " Avoid special case: <>
  let retlist = []
  if match(a:input, '<.\+>') != -1
    let si = 0
    let go = 1
    while si < len(a:input)
      if go
        if a:input[si] ==# ' '
          call add(retlist, '[SPC]')
        else
          call add(retlist, a:input[si])
        endif
      else
        let retlist[-1] .= a:input[si]
      endif
      if a:input[si] ==? '<'
        let go = 0
      elseif a:input[si] ==? '>'
        let go = 1
      end
      let si += 1
    endw
  else
    for it in split(a:input, '\zs')
      if it ==# ' '
        call add(retlist, '[SPC]')
      else
        call add(retlist, it)
      endif
    endfor
  endif
  return retlist
endfunction " }}}
function! s:escape_keys(inp) abort " {{{
  let ret = substitute(a:inp, '<', '<lt>', '')
  return substitute(ret, '|', '<Bar>', '')
endfunction " }}}

function! s:calc_layout() abort " {{{
  let ret = {}
  let smap = filter(copy(s:lmap), 'v:key !=# "name"')
  let ret.n_items = len(smap)
  let length = values(map(smap,
        \ 'strdisplaywidth("[".v:key."]".'.
        \ '(type(v:val) == type({}) ? v:val["name"] : v:val[1]))'))
  let maxlength = max(length) + g:leaderGuide_hspace
  if g:leaderGuide_vertical
    let ret.n_rows = winheight(0) - 2
    let ret.n_cols = ret.n_items / ret.n_rows + (ret.n_items != ret.n_rows)
    let ret.col_width = maxlength
    let ret.win_dim = ret.n_cols * ret.col_width
  else
    let ret.n_cols = winwidth(s:winid) >= maxlength ? winwidth(s:winid) / maxlength : 1
    let ret.col_width = winwidth(s:winid) / ret.n_cols
    let ret.n_rows = ret.n_items / ret.n_cols + (fmod(ret.n_items,ret.n_cols) > 0 ? 1 : 0)
    let ret.win_dim = ret.n_rows
  endif
  return ret
endfunction " }}}

" icon -> number -> A-Za-z 
" 65-90 97-122
function! s:compare_key(i1, i2) abort
  let a = char2nr(a:i1 ==# '[SPC]' ? ' ' : a:i1 ==? '<Tab>' ? "\t" : a:i1)
  let b = char2nr(a:i2 ==# '[SPC]' ? ' ' : a:i2 ==? '<Tab>' ? "\t" : a:i2)
  if a - b == 32 && a >= 97 && a <= 122
    return -1
  elseif b - a == 32 && b >= 97 && b <= 122
    return 1
  elseif a >= 97 && a <= 122 && b >= 97 && b <= 122
    return a == b ? 0 : a > b ? 1 : -1
  elseif a >= 65 && a <= 90 && b >= 65 && b <= 90
    return a == b ? 0 : a > b ? 1 : -1
  elseif a >= 97 && a <= 122 && b >= 65 && b <= 90
    return s:compare_key(nr2char(a), nr2char(b + 32))
  elseif a >= 65 && a <= 90 && b >= 97 && b <= 122
    return s:compare_key(nr2char(a), nr2char(b - 32))
  endif
  return a == b ? 0 : a > b ? 1 : -1
endfunction

function! s:create_string(layout) abort " {{{
  let l = a:layout
  let l.capacity = l.n_rows * l.n_cols
  let overcap = l.capacity - l.n_items
  let overh = l.n_cols - overcap
  let n_rows =  l.n_rows - 1

  let rows = []
  let row = 0
  let col = 0
  let smap = sort(filter(keys(s:lmap), 'v:val !=# "name"'), function('s:compare_key'))
  for k in smap
    let desc = type(s:lmap[k]) == type({}) ? s:lmap[k].name : s:lmap[k][1]
    let displaystring = '['. k .'] '.desc
    let crow = get(rows, row, [])
    if empty(crow)
      call add(rows, crow)
    endif
    call add(crow, displaystring)
    call add(crow, repeat(' ', l.col_width - strdisplaywidth(displaystring)))

    if !g:leaderGuide_sort_horizontal
      if row >= n_rows - 1
        if overh > 0 && row < n_rows
          let overh -= 1
          let row += 1
        else
          let row = 0
          let col += 1
        endif
      else
        let row += 1
      endif
    else
      if col == l.n_cols - 1
        let row +=1
        let col = 0
      else
        let col += 1
      endif
    endif
  endfor
  let r = []
  let mlen = 0
  for ro in rows
    let line = join(ro, '')
    call add(r, line)
    if strdisplaywidth(line) > mlen
      let mlen = strdisplaywidth(line)
    endif
  endfor
  let output = join(r, "\n")
  return output
endfunction " }}}

let s:VIMH = SpaceVim#api#import('vim#highlight')
function! s:highlight_cursor() abort
  let info = {
        \ 'name' : 'SpaceVimGuideCursor',
        \ 'guibg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'guifg'),
        \ 'guifg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'guibg'),
        \ 'ctermbg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'ctermfg'),
        \ 'ctermfg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'ctermbg'),
        \ }
  hi! def link SpaceVimGuideCursor Cursor
  call s:VIMH.hi(info)
  if s:vis ==# 'gv'
    " [bufnum, lnum, col, off]
    let begin = getpos("'<")
    let end = getpos("'>")
    if begin[1] == end[1]
      let s:cursor_hi = s:CMP.matchaddpos('SpaceVimGuideCursor', [[begin[1], min([begin[2], end[2]]), abs(begin[2] - end[2]) + 1]]) 
    else
      let pos = [[begin[1], begin[2], len(getline(begin[1])) - begin[2] + 1],
            \ [end[1], 1, end[2]],
            \ ]
      for lnum in range(begin[1] + 1, end[1] - 1)
        call add(pos, [lnum, 1, len(getline(lnum))])
      endfor
      let s:cursor_hi = s:CMP.matchaddpos('SpaceVimGuideCursor', pos) 
    endif
  else
    let s:cursor_hi = s:CMP.matchaddpos('SpaceVimGuideCursor', [[line('.'), col('.'), 1]]) 
  endif
endfunction

function! s:remove_cursor_highlight() abort
  try
    call matchdelete(s:cursor_hi)
  catch
  endtry
endfunction

" @vimlint(EVL102, 1, l:string)
function! s:start_buffer() abort " {{{
  let s:winv = winsaveview()
  let s:winnr = winnr()
  let s:winres = winrestcmd()
  let [s:winid, s:bufnr] = s:winopen()
  let layout = s:calc_layout()
  let string = s:create_string(layout)

  if g:leaderGuide_max_size
    let layout.win_dim = min([g:leaderGuide_max_size, layout.win_dim])
  endif

  call setbufvar(s:bufnr, '&modifiable', 1)
  if s:FLOATING.exists()
    let rst = s:FLOATING.win_config(s:winid, 
          \ {
          \ 'relative': 'editor',
          \ 'width'   : &columns, 
          \ 'height'  : layout.win_dim + 2,
          \ 'row'     : &lines - layout.win_dim - 4,
          \ 'col'     : 0
          \ })
  else
    if g:leaderGuide_vertical
      noautocmd execute 'vert res '.layout.win_dim
    else
      noautocmd execute 'res '.layout.win_dim
    endif
  endif
  if s:FLOATING.exists()
    " when using floating windows, and the flaating windows do not support
    " statusline, add extra black line at top and button of the content.
    call s:BUFFER.buf_set_lines(s:bufnr, 0, -1, 0, [''] + split(string, "\n") + [''])
  else
    call s:BUFFER.buf_set_lines(s:bufnr, 0, -1, 0, split(string, "\n"))
  endif
  call setbufvar(s:bufnr, '&modifiable', 0)
  redraw!
  call s:wait_for_input()
endfunction " }}}
" @vimlint(EVL102, 0, l:string)

function! s:handle_input(input) abort " {{{
  call s:winclose()
  if type(a:input) ==? type({})
    let s:lmap = a:input
    let s:guide_group = a:input
    call s:start_buffer()
  else
    let s:prefix_key_inp = ''
    call feedkeys(s:vis.s:reg.s:count, 'ti')
    redraw!
    try
      unsilent execute a:input[0]
    catch
      unsilent echom v:exception
    endtry
  endif
endfunction " }}}

if has('nvim')
  function! s:getchar(...) abort
    let ret = call('getchar', a:000)
    return (type(ret) == type(0) ? nr2char(ret) : ret)
  endfunction
else
  function! s:getchar(...) abort
    let ret = call('getchar', a:000)
    while ret ==# "\x80\xfd\d"
      let ret = call('getchar', a:000)
    endwhile
    return (type(ret) == type(0) ? nr2char(ret) : ret)
  endfunction

endif


" wait for in input sub function should be not block vim
function! s:wait_for_input() abort " {{{
  redraw!
  let inp = s:getchar()
  if inp ==# "\<Esc>"
    let s:prefix_key_inp = ''
    let s:guide_help_mode = 0
    call s:winclose()
    doautocmd WinEnter
  elseif s:guide_help_mode ==# 1
    call s:submode_mappings(inp)
    let s:guide_help_mode = 0
    call s:updateStatusline()
    redraw!
  elseif inp ==# "\<C-h>"
    let s:guide_help_mode = 1
    call s:updateStatusline()
    redraw!
    call s:wait_for_input()
  else
    if inp ==# ' '
      let inp = '[SPC]'
    else
      let inp = s:KEY.nr2name(char2nr(inp))
    endif
    let fsel = get(s:lmap, inp)
    if !empty(fsel)
      let s:prefix_key_inp = inp
      call s:handle_input(fsel)
    else
      call s:winclose()
      doautocmd WinEnter
      let keys = get(s:, 'prefix_key_inp', '')
      let name = SpaceVim#mapping#leader#getName(s:prefix_key)
      let _keys = join(s:STR.string2chars(keys), '-')
      if empty(_keys)
        call s:build_mpt(['key bindings is not defined: ', name . '-' . inp])
      else
        call s:build_mpt(['key bindings is not defined: ', name . '-' . _keys . '-' . inp])
      endif
      let s:prefix_key_inp = ''
      let s:guide_help_mode = 0
    endif
  endif
endfunction " }}}

function! s:build_mpt(mpt) abort
  normal! :
  echohl Comment
  if type(a:mpt) == 1
    echon a:mpt
  elseif type(a:mpt) == 3
    echon join(a:mpt)
  endif
  echohl NONE
endfunction


" change this func, do not focus to the new windows, and return winid.

function! s:winopen() abort " {{{
  call s:highlight_cursor()
  let pos = g:leaderGuide_position ==? 'topleft' ? 'topleft' : 'botright'
  if s:FLOATING.exists()
    if !bufexists(s:bufnr)
      let s:bufnr = s:BUFFER.create_buf(v:false, v:true)
    endif
    let s:winid = s:FLOATING.open_win(s:bufnr, v:true,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : &columns,
          \ 'height'  : 12,
          \ 'row'     : &lines - 14,
          \ 'col'     : 0
          \ })
  else
    if bufexists(s:bufnr)
      let qfbuf = &buftype ==# 'quickfix'
      let splitcmd = g:leaderGuide_vertical ? ' 1vs' : ' 1sp'
      noautocmd execute pos . splitcmd
      let bnum = bufnr('%')
      noautocmd execute 'buffer '.s:bufnr
      cmapclear <buffer>
      if qfbuf
        noautocmd execute bnum.'bwipeout!'
      endif
    else
      let splitcmd = g:leaderGuide_vertical ? ' 1vnew' : ' 1new'
      noautocmd execute pos.splitcmd
      let s:bufnr = bufnr('%')
      augroup guide_autocmd
        autocmd!
        autocmd WinLeave <buffer> call s:winclose()
      augroup END
    endif
    let s:winid = winnr()
  endif
  let s:guide_help_mode = 0
  call setbufvar(s:bufnr, '&filetype', 'leaderGuide')
  call setbufvar(s:bufnr, '&number', 0)
  call setbufvar(s:bufnr, '&relativenumber', 0)
  call setbufvar(s:bufnr, '&list', 0)
  call setbufvar(s:bufnr, '&modeline', 0)
  call setbufvar(s:bufnr, '&wrap', 0)
  call setbufvar(s:bufnr, '&buflisted', 0)
  call setbufvar(s:bufnr, '&buftype', 'nofile')
  call setbufvar(s:bufnr, '&bufhidden', 'unload')
  call setbufvar(s:bufnr, '&swapfile', 0)
  call setbufvar(s:bufnr, '&cursorline', 0)
  call setbufvar(s:bufnr, '&cursorcolumn', 0)
  call setbufvar(s:bufnr, '&colorcolumn', '')
  call setbufvar(s:bufnr, '&winfixwidth', 1)
  call setbufvar(s:bufnr, '&winfixheight', 1)

  if exists('&winhighlight')
    set winhighlight=Normal:Pmenu
  endif
  " @fixme not sure if the listchars should be changed!
  " setlocal listchars=
  call s:updateStatusline()
  call s:toggle_hide_cursor()
  return [s:winid, s:bufnr]
endfunction " }}}

if s:SL.support_float()
  function! s:updateStatusline() abort
    call SpaceVim#mapping#guide#theme#hi()
    let gname = get(s:guide_group, 'name', '')
    if !empty(gname)
      let gname = ' - ' . gname[1:]
      " let gname = substitute(gname,' ', '\\ ', 'g')
    endif
    let keys = get(s:, 'prefix_key_inp', '')
    " let keys = substitute(keys, '\', '\\\', 'g')
    call s:SL.open_float([
          \ ['Guide: ', 'LeaderGuiderPrompt'],
          \ [' ', 'LeaderGuiderSep1'],
          \ [SpaceVim#mapping#leader#getName(s:prefix_key)
          \ . keys . gname, 'LeaderGuiderName'],
          \ [' ', 'LeaderGuiderSep2'],
          \ [s:guide_help_msg(0), 'LeaderGuiderFill'],
          \ [repeat(' ', 999), 'LeaderGuiderFill'],
          \ ])
  endfunction
  function! s:close_float_statusline() abort
    call s:SL.close_float()
  endfunction
else
  function! s:updateStatusline() abort
    call SpaceVim#mapping#guide#theme#hi()
    let gname = get(s:guide_group, 'name', '')
    if !empty(gname)
      let gname = ' - ' . gname[1:]
      let gname = substitute(gname,' ', '\\ ', 'g')
    endif
    let keys = get(s:, 'prefix_key_inp', '')
    let keys = substitute(keys, '\', '\\\', 'g')
    call setbufvar(s:bufnr, '&statusline', '%#LeaderGuiderPrompt#\ Guide:\ ' .
          \ '%#LeaderGuiderSep1#' . s:lsep .
          \ '%#LeaderGuiderName#\ ' .
          \ SpaceVim#mapping#leader#getName(s:prefix_key)
          \ . keys . gname
          \ . '\ %#LeaderGuiderSep2#' . s:lsep . '%#LeaderGuiderFill#'
          \ . s:guide_help_msg(1))
  endfunction
endif

function! Test_st() abort
  call s:updateStatusline()
endfunction

function! s:guide_help_msg(escape) abort
  if s:guide_help_mode == 1
    let msg = ' n -> next-page, p -> previous-page, u -> undo-key'
  else
    let msg = ' [C-h paging/help]'
  endif
  return a:escape ? substitute(msg,' ', '\\ ', 'g') : msg
endfunction

let s:t_ve = ''
function! s:toggle_hide_cursor() abort
  let t_ve = &t_ve
  let &t_ve = s:t_ve
  let s:t_ve = t_ve
endfunction


function! s:winclose() abort " {{{
  call s:toggle_hide_cursor()
  if s:FLOATING.exists()
    call s:FLOATING.win_close(s:winid, 1)
    if s:SL.support_float()
      call s:close_float_statusline()
    endif
  else
    noautocmd execute s:winid.'wincmd w'
    if s:winid == winnr()
      noautocmd close
      redraw!
      exe s:winres
      let s:winid = -1
      noautocmd execute s:winnr.'wincmd w'
      call winrestview(s:winv)
      if exists('*nvim_open_win')
        doautocmd WinEnter
      endif
    endif
  endif
  call s:remove_cursor_highlight()
endfunction " }}}
function! s:page_down() abort " {{{
  call feedkeys("\<c-c>", 'n')
  call feedkeys("\<c-f>", 'x')
  redraw!
  call s:wait_for_input()
endfunction " }}}
function! s:page_undo() abort " {{{
  call s:winclose()
  let s:guide_group = {}
  let s:prefix_key_inp = ''
  let s:lmap = s:lmap_undo
  call s:start_buffer()
endfunction " }}}
function! s:page_up() abort " {{{
  call feedkeys("\<c-c>", 'n')
  call feedkeys("\<c-b>", 'x')
  redraw!
  call s:wait_for_input()
endfunction " }}}

function! s:handle_submode_mapping(cmd) abort " {{{
  let s:guide_help_mode = 0
  call s:updateStatusline()
  if a:cmd ==# 'n'
    call s:page_down()
  elseif a:cmd ==# 'p'
    call s:page_up()
  elseif a:cmd ==# 'u'
    call s:page_undo()
  else
    call s:winclose()
  endif
endfunction " }}}
function! s:submode_mappings(key) abort " {{{
  silent call s:handle_submode_mapping(a:key)
endfunction " }}}
function! s:mapmaparg(maparg) abort " {{{
  let noremap = a:maparg.noremap ? 'noremap' : 'map'
  let buffer = a:maparg.buffer ? '<buffer> ' : ''
  let silent = a:maparg.silent ? '<silent> ' : ''
  let nowait = a:maparg.nowait ? '<nowait> ' : ''
  let st = a:maparg.mode . '' . noremap . ' ' . nowait . silent . buffer
        \ . '' .a:maparg.lhs . ' ' . a:maparg.rhs
  execute st
endfunction " }}}

function! s:get_register() abort "{{{
  if match(&clipboard, 'unnamedplus') >= 0
    let clip = '+'
  elseif match(&clipboard, 'unnamed') >= 0
    let clip = '*'
  else
    let clip = '"'
  endif
  return clip
endfunction "}}}
function! SpaceVim#mapping#guide#start_by_prefix(vis, key) abort " {{{
  if a:key ==# ' ' && exists('b:spacevim_lang_specified_mappings')
    let g:_spacevim_mappings_space.l = b:spacevim_lang_specified_mappings
  endif
  let s:guide_help_mode = 0
  let s:vis = a:vis ? 'gv' : ''
  let s:count = v:count != 0 ? v:count : ''
  let s:toplevel = a:key ==? '  '
  let s:prefix_key = a:key
  let s:guide_group = {}

  if has('nvim') && !exists('s:reg')
    let s:reg = ''
  else
    let s:reg = v:register != s:get_register() ? '"'.v:register : ''
  endif

  if !has_key(s:cached_dicts, a:key) || g:leaderGuide_run_map_on_popup
    "first run
    let s:cached_dicts[a:key] = {}
    call s:start_parser(a:key, s:cached_dicts[a:key])
  endif

  if has_key(s:desc_lookup, a:key) || has_key(s:desc_lookup , 'top')
    let rundict = s:create_target_dict(a:key)
  else
    let rundict = s:cached_dicts[a:key]
  endif
  let s:lmap = rundict
  let s:lmap_undo = rundict
  call s:start_buffer()
endfunction " }}}
function! SpaceVim#mapping#guide#start(vis, dict) abort " {{{
  let s:vis = a:vis ? 'gv' : 0
  let s:lmap = a:dict
  call s:start_buffer()
endfunction " }}}

if !exists('g:leaderGuide_displayfunc')
  function! s:leaderGuide_display() abort
    if has_key(s:registered_name, g:leaderGuide#displayname)
      return s:registered_name[g:leaderGuide#displayname]
    endif
    let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '\c<cr>$', '', '')
  endfunction
  let g:leaderGuide_displayfunc = [function('s:leaderGuide_display')]
endif

let s:registered_name = {}
function! SpaceVim#mapping#guide#register_displayname(lhs, name)
  call extend(s:registered_name, {a:lhs : a:name})
endfunction

if get(g:, 'mapleader', '\') ==# ' '
  call SpaceVim#mapping#guide#register_prefix_descriptions(' ',
        \ 'g:_spacevim_mappings')
else
  call SpaceVim#mapping#guide#register_prefix_descriptions(get(g:, 'mapleader', '\'),
        \ 'g:_spacevim_mappings')
  call SpaceVim#plugins#help#regist_root({'<leader>' : g:_spacevim_mappings})
  call SpaceVim#mapping#guide#register_prefix_descriptions(' ',
        \ 'g:_spacevim_mappings_space')
  call SpaceVim#plugins#help#regist_root({'SPC' : g:_spacevim_mappings_space})
endif
if !g:spacevim_vimcompatible && !empty(g:spacevim_windows_leader)
  call SpaceVim#mapping#guide#register_prefix_descriptions(
        \ g:spacevim_windows_leader,
        \ 'g:_spacevim_mappings_windows')
  call SpaceVim#plugins#help#regist_root({'[WIN]' : g:_spacevim_mappings_windows})
endif
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ '[KEYs]',
      \ 'g:_spacevim_mappings_prefixs')
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ 'g',
      \ 'g:_spacevim_mappings_g')
call SpaceVim#plugins#help#regist_root({'[g]' : g:_spacevim_mappings_g})
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ 'z',
      \ 'g:_spacevim_mappings_z')
call SpaceVim#plugins#help#regist_root({'[z]' : g:_spacevim_mappings_z})
let [s:lsep, s:rsep] = SpaceVim#layers#core#statusline#rsep()
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
