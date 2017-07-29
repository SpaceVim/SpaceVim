"=============================================================================
" guide.vim --- mappings guide helper for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

function! SpaceVim#mapping#guide#has_configuration() "{{{
  return exists('s:desc_lookup')
endfunction "}}}

function! SpaceVim#mapping#guide#register_prefix_descriptions(key, dictname) " {{{
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
function! s:create_cache() " {{{
  let s:desc_lookup = {}
  let s:cached_dicts = {}
endfunction " }}}
function! s:create_target_dict(key) " {{{
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
function! s:merge(dict_t, dict_o) " {{{
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
        if has_key(other, k."m") && type(other[k."m"]) == type({})
          call s:merge(target[k."m"], other[k."m"])
        endif
      endif
    endif
  endfor
  call extend(target, other, "keep")
endfunction " }}}

" @vimlint(EVL103, 1, a:dictname)
function! SpaceVim#mapping#guide#populate_dictionary(key, dictname) " {{{
  call s:start_parser(a:key, s:cached_dicts[a:key])
endfunction " }}}
" @vimlint(EVL103, 0, a:dictname)

function! SpaceVim#mapping#guide#parse_mappings() " {{{
  for [k, v] in items(s:cached_dicts)
    call s:start_parser(k, v)
  endfor
endfunction " }}}


function! s:start_parser(key, dict) " {{{
  if a:key ==# '[KEYs]'
    return
  endif
  let key = a:key ==? ' ' ? "<Space>" : a:key
  let readmap = ""
  redir => readmap
  silent execute 'map '.key
  redir END
  let lines = split(readmap, "\n")
  let visual = s:vis == "gv" ? 1 : 0

  for line in lines
    let mapd = maparg(split(line[3:])[0], line[0], 0, 1)
    if mapd.lhs =~ '<Plug>.*' || mapd.lhs =~ '<SNR>.*'
      continue
    endif
    let mapd.display = s:format_displaystring(mapd.rhs)
    let mapd.lhs = substitute(mapd.lhs, key, "", "")
    let mapd.lhs = substitute(mapd.lhs, "<Space>", " ", "g")
    let mapd.lhs = substitute(mapd.lhs, "<Tab>", "<C-I>", "g")
    let mapd.rhs = substitute(mapd.rhs, "<SID>", "<SNR>".mapd['sid']."_", "g")
    if mapd.lhs != '' && mapd.display !~# 'LeaderGuide.*'
      let mapd.lhs = s:string_to_keys(mapd.lhs)
      if (visual && match(mapd.mode, "[vx ]") >= 0) ||
            \ (!visual && match(mapd.mode, "[vx]") == -1)
        call s:add_map_to_dict(mapd, 0, a:dict)
      endif
    endif
  endfor
endfunction " }}}

function! s:add_map_to_dict(map, level, dict) " {{{
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
      let curkey = curkey."m"
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
function! s:format_displaystring(map) " {{{
  let g:leaderGuide#displayname = a:map
  for Fun in g:leaderGuide_displayfunc
    call Fun()
  endfor
  let display = g:leaderGuide#displayname
  unlet g:leaderGuide#displayname
  return display
endfunction " }}}
" @vimlint(EVL111, 0, Fun)
function! s:flattenmap(dict, str) " {{{
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


function! s:escape_mappings(mapping) " {{{
  let feedkeyargs = a:mapping.noremap ? "nt" : "mt"
  let rstring = substitute(a:mapping.rhs, '\', '\\\\', 'g')
  let rstring = substitute(rstring, '<\([^<>]*\)>', '\\<\1>', 'g')
  let rstring = substitute(rstring, '"', '\\"', 'g')
  let rstring = 'call feedkeys("'.rstring.'", "'.feedkeyargs.'")'
  return rstring
endfunction " }}}
function! s:string_to_keys(input) " {{{
  " Avoid special case: <>
  if match(a:input, '<.\+>') != -1
    let retlist = []
    let si = 0
    let go = 1
    while si < len(a:input)
      if go
        call add(retlist, a:input[si])
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
    return retlist
  else
    return split(a:input, '\zs')
  endif
endfunction " }}}
function! s:escape_keys(inp) " {{{
  let ret = substitute(a:inp, "<", "<lt>", "")
  return substitute(ret, "|", "<Bar>", "")
endfunction " }}}


function! s:calc_layout() " {{{
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
    let ret.n_cols = winwidth(0) / maxlength
    let ret.col_width = winwidth(0) / ret.n_cols
    let ret.n_rows = ret.n_items / ret.n_cols + (fmod(ret.n_items,ret.n_cols) > 0 ? 1 : 0)
    let ret.win_dim = ret.n_rows
    "echom string(ret)
  endif
  return ret
endfunction " }}}
function! s:create_string(layout) " {{{
  let l = a:layout
  let l.capacity = l.n_rows * l.n_cols
  let overcap = l.capacity - l.n_items
  let overh = l.n_cols - overcap
  let n_rows =  l.n_rows - 1

  let rows = []
  let row = 0
  let col = 0
  let smap = sort(filter(keys(s:lmap), 'v:val !=# "name"'),'1')
  for k in smap
    let desc = type(s:lmap[k]) == type({}) ? s:lmap[k].name : s:lmap[k][1]
    let displaystring = "[". k ."] ".desc
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
    silent execute "cnoremap <nowait> <buffer> ".substitute(k, "|", "<Bar>", ""). " " . s:escape_keys(k) ."<CR>"
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
  call insert(r, '')
  let output = join(r, "\n ")
  cnoremap <nowait> <buffer> <Space> <Space><CR>
  cnoremap <nowait> <buffer> <silent> <C-h> <LGCMD>paging_help<CR>
  return output
endfunction " }}}


" @vimlint(EVL102, 1, l:string)
function! s:start_buffer() " {{{
  let s:winv = winsaveview()
  let s:winnr = winnr()
  let s:winres = winrestcmd()
  call s:winopen()
  let layout = s:calc_layout()
  let string = s:create_string(layout)

  if g:leaderGuide_max_size
    let layout.win_dim = min([g:leaderGuide_max_size, layout.win_dim])
  endif

  setlocal modifiable
  if g:leaderGuide_vertical
    noautocmd execute 'vert res '.layout.win_dim
  else
    noautocmd execute 'res '.layout.win_dim
  endif
  silent 1put!=string
  normal! gg"_dd
  setlocal nomodifiable
  if empty(maparg("<c-c>", "c", 0, 1))
    execute 'cnoremap <nowait> <silent> <buffer> <c-c> <esc>'
  endif
  call s:wait_for_input()
endfunction " }}}
" @vimlint(EVL102, 0, l:string)

function! s:handle_input(input) " {{{
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
function! s:wait_for_input() " {{{
  redraw!
  let inp = input("")
  if inp ==? ''
    let s:prefix_key_inp = ''
    call s:winclose()
    doautocmd WinEnter
  elseif match(inp, "^<LGCMD>paging_help") == 0
    let s:guide_help_mode = 1
    call s:updateStatusline()
    redraw!
    call s:submode_mappings()
  else
    if inp == ' '
      let inp = '[SPC]'
    endif
    let fsel = get(s:lmap, inp)
    if !empty(fsel)
      let s:prefix_key_inp = inp
      call s:handle_input(fsel)
    else
      let s:prefix_key_inp = ''
      call s:winclose()
      doautocmd WinEnter
    endif
  endif
endfunction " }}}
function! s:winopen() " {{{
  if !exists('s:bufnr')
    let s:bufnr = -1
  endif
  let pos = g:leaderGuide_position ==? 'topleft' ? 'topleft' : 'botright'
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
    autocmd WinLeave <buffer> call s:winclose()
  endif
  let s:gwin = winnr()
  setlocal filetype=leaderGuide
  setlocal nonumber norelativenumber nolist nomodeline nowrap
  setlocal nobuflisted buftype=nofile bufhidden=unload noswapfile
  setlocal nocursorline nocursorcolumn colorcolumn=
  setlocal winfixwidth winfixheight
  call s:updateStatusline()
endfunction " }}}

function! s:updateStatusline() abort
  call SpaceVim#mapping#guide#theme#hi()
  let gname = get(s:guide_group, 'name', '')
  if !empty(gname)
    let gname = ' - ' . gname[1:]
    let gname = substitute(gname,' ', '\\ ', 'g')
  endif
  exe 'setlocal statusline=%#LeaderGuiderPrompt#\ Guide:\ ' .
        \ '%#LeaderGuiderSep1#' . s:lsep .
        \ '%#LeaderGuiderName#\ ' .
        \ SpaceVim#mapping#leader#getName(s:prefix_key)
        \ . get(s:, 'prefix_key_inp', '') . gname
        \ . '\ %#LeaderGuiderSep2#' . s:lsep . '%#LeaderGuiderFill#'
        \ . s:guide_help_msg()
endfunction

function! s:guide_help_msg() abort
  if s:guide_help_mode == 1
    let msg = ' n -> next-page, p -> previous-page, u -> undo-key'
  else
    let msg = ' [C-h paging/help]'
  endif
  return substitute(msg,' ', '\\ ', 'g')
endfunction

function! s:winclose() " {{{
  noautocmd execute s:gwin.'wincmd w'
  if s:gwin == winnr()
    noautocmd close
    redraw!
    exe s:winres
    let s:gwin = -1
    noautocmd execute s:winnr.'wincmd w'
    call winrestview(s:winv)
  endif
endfunction " }}}
function! s:page_down() " {{{
  call feedkeys("\<c-c>", "n")
  call feedkeys("\<c-f>", "x")
  redraw!
  call s:wait_for_input()
endfunction " }}}
function! s:page_undo() " {{{
  call s:winclose()
  let s:guide_group = {}
  let s:prefix_key_inp = ''
  let s:lmap = s:lmap_undo
  call s:start_buffer()
endfunction " }}}
function! s:page_up() " {{{
  call feedkeys("\<c-c>", "n")
  call feedkeys("\<c-b>", "x")
  redraw!
  call s:wait_for_input()
endfunction " }}}

function! s:handle_submode_mapping(cmd) " {{{
  let s:guide_help_mode = 0
  call s:updateStatusline()
  if a:cmd ==? '<LGCMD>page_down'
    call s:page_down()
  elseif a:cmd ==? '<LGCMD>page_up'
    call s:page_up()
  elseif a:cmd ==? '<LGCMD>undo'
    call s:page_undo()
  elseif a:cmd ==? '<LGCMD>win_close'
    call s:winclose()
  else
    call feedkeys("\<c-c>", "n")
    redraw!
    call s:wait_for_input()
  endif
endfunction " }}}
function! s:submode_mappings() " {{{
  let maplist = []
  for key in items(g:leaderGuide_submode_mappings)
    let map = maparg(key[0], "c", 0, 1)
    if !empty(map)
      call add(maplist, map)
    endif
    execute 'cnoremap <nowait> <silent> <buffer> '.key[0].' <LGCMD>'.key[1].'<CR>'
  endfor
  let inp = input('')
  for map in maplist
    call s:mapmaparg(map)
  endfor
  silent call s:handle_submode_mapping(inp)
endfunction " }}}
function! s:mapmaparg(maparg) " {{{
  let noremap = a:maparg.noremap ? 'noremap' : 'map'
  let buffer = a:maparg.buffer ? '<buffer> ' : ''
  let silent = a:maparg.silent ? '<silent> ' : ''
  let nowait = a:maparg.nowait ? '<nowait> ' : ''
  let st = a:maparg.mode . '' . noremap . ' ' . nowait . silent . buffer
        \ . '' .a:maparg.lhs . ' ' . a:maparg.rhs
  execute st
endfunction " }}}

function! s:get_register() "{{{
  if match(&clipboard, 'unnamedplus') >= 0
    let clip = '+'
  elseif match(&clipboard, 'unnamed') >= 0
    let clip = '*'
  else
    let clip = '"'
  endif
  return clip
endfunction "}}}
function! SpaceVim#mapping#guide#start_by_prefix(vis, key) " {{{
  if a:key == ' ' && exists('b:spacevim_lang_specified_mappings')
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
function! SpaceVim#mapping#guide#start(vis, dict) " {{{
  let s:vis = a:vis ? 'gv' : 0
  let s:lmap = a:dict
  call s:start_buffer()
endfunction " }}}

if !exists("g:leaderGuide_displayfunc")
  function! s:leaderGuide_display()
    let g:leaderGuide#displayname = substitute(g:leaderGuide#displayname, '\c<cr>$', '', '')
  endfunction
  let g:leaderGuide_displayfunc = [function("s:leaderGuide_display")]
endif

if get(g:, 'mapleader', '\') == ' '
  call SpaceVim#mapping#guide#register_prefix_descriptions(' ',
        \ 'g:_spacevim_mappings')
else
  call SpaceVim#mapping#guide#register_prefix_descriptions('\',
        \ 'g:_spacevim_mappings')
  call SpaceVim#mapping#guide#register_prefix_descriptions(' ',
        \ 'g:_spacevim_mappings_space')
  call SpaceVim#plugins#help#regist_root({'SPC' : g:_spacevim_mappings_space})
endif
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ g:spacevim_unite_leader,
      \ 'g:_spacevim_mappings_unite')
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ g:spacevim_denite_leader,
      \ 'g:_spacevim_mappings_denite')
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ '[KEYs]',
      \ 'g:_spacevim_mappings_prefixs')
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ 'g',
      \ 'g:_spacevim_mappings_g')
call SpaceVim#mapping#guide#register_prefix_descriptions(
      \ 'z',
      \ 'g:_spacevim_mappings_z')
let [s:lsep, s:rsep] = SpaceVim#layers#core#statusline#rsep()
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
