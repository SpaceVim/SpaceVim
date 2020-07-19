" textobj-user - Create your own text objects
" Version: 0.7.6
" Copyright (C) 2007-2018 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interfaces  "{{{1
" simple  "{{{2

function! textobj#user#move(pattern, flags, previous_mode)
  let i = v:count1

  call s:prepare_movement(a:previous_mode)
  while 0 < i
    let result = searchpos(a:pattern, a:flags.'W')
    let i = i - 1
  endwhile
  return result
endfunction


" FIXME: growing the current selection like iw/aw, is/as, and others.
" FIXME: countable.
function! textobj#user#select(pattern, flags, previous_mode)
  let ORIG_POS = s:gpos_to_spos(getpos('.'))

  let pft = searchpos(a:pattern, 'ceW')
  let pfh = searchpos(a:pattern, 'bcW')
  call cursor(ORIG_POS)
  let pbh = searchpos(a:pattern, 'bcW')
  let pbt = searchpos(a:pattern, 'ceW')
  let pos = s:choose_better_pos(a:flags, ORIG_POS, pfh, pft, pbh, pbt)

  if pos isnot 0
    if a:flags !~# 'N'
      call s:range_select(pos[0], pos[1], s:choose_wise(a:flags))
    endif
    return pos
  else
    return s:cancel_selection(a:previous_mode, ORIG_POS)
  endif
endfunction

function! s:choose_better_pos(flags, ORIG_POS, pfh, pft, pbh, pbt)
  " search() family with 'c' flag may not be matched to a pattern which
  " matches to multiple lines.  To choose appropriate range, we have to check
  " another range [X] whether it contains the cursor or not.
  let vf = s:range_validp(a:pfh, a:pft)
  let vb = s:range_validp(a:pbh, a:pbt)
  let cf = vf && s:range_containsp(a:pfh, a:pft, a:ORIG_POS)
  let cb = vb && s:range_containsp(a:pbh, a:pbt, a:ORIG_POS)
  let lf = vf && s:range_in_linep(a:pfh, a:pft, a:ORIG_POS)
  let lb = vb && s:range_in_linep(a:pbh, a:pbt, a:ORIG_POS)

  if cb  " [X]
    return [a:pbh, a:pbt]
  elseif cf
    return [a:pfh, a:pft]
  elseif lf && a:flags =~# '[nl]'
    return [a:pfh, a:pft]
  elseif lb && a:flags =~# '[nl]'
    return [a:pbh, a:pbt]
  elseif vf && (a:flags =~# '[fn]' || a:flags !~# '[bcl]')
    return [a:pfh, a:pft]
  elseif vb && a:flags =~# '[bn]'
    return [a:pbh, a:pbt]
  else
    return 0
  endif
endfunction




" pair  "{{{2

" FIXME: NIY, but is this necessary?
" function! textobj#user#move_pair(pattern1, pattern2, flags)
" endfunction


" BUGS: With o_CTRL-V, this may not work properly.
function! textobj#user#select_pair(pattern1, pattern2, flags, previous_mode)
  let ORIG_POS = s:gpos_to_spos(getpos('.'))

  " adjust the cursor to the head of a:pattern2 if it's already in the range.
  let pos2c_tail = searchpos(a:pattern2, 'ceW')
  let pos2c_head = searchpos(a:pattern2, 'bcW')
  if !s:range_validp(pos2c_head, pos2c_tail)
    return s:cancel_selection(a:previous_mode, ORIG_POS)
  endif
  if s:range_containsp(pos2c_head, pos2c_tail, ORIG_POS)
    let more_flags = 'c'
  else
    let more_flags = ''
    call cursor(ORIG_POS)
  endif

  " get the positions of a:pattern1 and a:pattern2.
  let pos2p_head = searchpairpos(a:pattern1, '', a:pattern2, 'W'.more_flags)
  let pos2p_tail = searchpos(a:pattern2, 'ceW')
  if !s:range_validp(pos2p_head, pos2p_tail)
    return s:cancel_selection(a:previous_mode, ORIG_POS)
  endif
  call cursor(pos2p_head)
  let pos1p_head = searchpairpos(a:pattern1, '', a:pattern2, 'bW')
  let pos1p_tail = searchpos(a:pattern1, 'ceW')
  if !s:range_validp(pos1p_head, pos1p_tail)
    return s:cancel_selection(a:previous_mode, ORIG_POS)
  endif

  " select the range, then adjust if necessary.
  if a:flags =~# 'i'
    if s:range_no_text_without_edgesp(pos1p_tail, pos2p_head)
      return s:cancel_selection(a:previous_mode, ORIG_POS)
    endif
    call s:range_select(pos1p_tail, pos2p_head, s:choose_wise(a:flags))

    " adjust the range.
    let whichwrap_orig = &whichwrap
    let &whichwrap = '<,>'
    execute "normal! \<Left>o\<Right>"
    let &whichwrap = whichwrap_orig
  else
    call s:range_select(pos1p_head, pos2p_tail, s:choose_wise(a:flags))
  endif
  return
endfunction




function! textobj#user#define(pat0, pat1, pat2, guideline)  "{{{2
  let pat0 = s:rhs_escape(a:pat0)
  let pat1 = s:rhs_escape(a:pat1)
  let pat2 = s:rhs_escape(a:pat2)
  for function_name in keys(a:guideline)
    let _lhss = a:guideline[function_name]
    if type(_lhss) == type('')
      let lhss = [_lhss]
    else
      let lhss = _lhss
    endif

    for lhs in lhss
      if function_name == 'move-to-next'
        execute 'nnoremap' s:mapargs_single_move(lhs, pat0, '', 'n')
        execute 'vnoremap' s:mapargs_single_move(lhs, pat0, '', 'v')
        execute 'onoremap' s:mapargs_single_move(lhs, pat0, '', 'o')
      elseif function_name == 'move-to-next-end'
        execute 'nnoremap' s:mapargs_single_move(lhs, pat0, 'e', 'n')
        execute 'vnoremap' s:mapargs_single_move(lhs, pat0, 'e', 'v')
        execute 'onoremap' s:mapargs_single_move(lhs, pat0, 'e', 'o')
      elseif function_name == 'move-to-prev'
        execute 'nnoremap' s:mapargs_single_move(lhs, pat0, 'b', 'n')
        execute 'vnoremap' s:mapargs_single_move(lhs, pat0, 'b', 'v')
        execute 'onoremap' s:mapargs_single_move(lhs, pat0, 'b', 'o')
      elseif function_name == 'move-to-prev-end'
        execute 'nnoremap' s:mapargs_single_move(lhs, pat0, 'be', 'n')
        execute 'vnoremap' s:mapargs_single_move(lhs, pat0, 'be', 'v')
        execute 'onoremap' s:mapargs_single_move(lhs, pat0, 'be', 'o')
      elseif function_name == 'select-next' || function_name == 'select'
        execute 'vnoremap' s:mapargs_single_select(lhs, pat0, '', 'v')
        execute 'onoremap' s:mapargs_single_select(lhs, pat0, '', 'o')
      elseif function_name == 'select-prev'
        execute 'vnoremap' s:mapargs_single_select(lhs, pat0, 'b', 'v')
        execute 'onoremap' s:mapargs_single_select(lhs, pat0, 'b', 'o')
      elseif function_name == 'select-pair-all'
        execute 'vnoremap' s:mapargs_pair_select(lhs, pat1, pat2, 'a', 'v')
        execute 'onoremap' s:mapargs_pair_select(lhs, pat1, pat2, 'a', 'o')
      elseif function_name == 'select-pair-inner'
        execute 'vnoremap' s:mapargs_pair_select(lhs, pat1, pat2, 'i', 'v')
        execute 'onoremap' s:mapargs_pair_select(lhs, pat1, pat2, 'i', 'o')
      else
        throw 'Unknown function name: ' . string(function_name)
      endif
    endfor
  endfor
endfunction




function! textobj#user#map(plugin_name, obj_specs, ...)  "{{{2
  if a:0 == 0
    " It seems to be directly called by user - a:obj_specs are not normalized.
    call s:normalize(a:obj_specs)
  endif
  let banged_p = a:0 == 0 || a:1
  for [obj_name, specs] in items(a:obj_specs)
    for [spec_name, spec_info] in items(specs)
      let rhs = s:interface_mapping_name(a:plugin_name, obj_name, spec_name)
      if s:is_non_ui_property_name(spec_name)
        " ignore
      elseif spec_name =~# '^move-[npNP]$'
        for lhs in spec_info
          call s:map(banged_p, lhs, rhs)
        endfor
      elseif spec_name =~# '^select\(\|-[ai]\)$'
        for lhs in spec_info
          call s:objmap(banged_p, lhs, rhs)
        endfor
      else
        throw printf('Unknown property: %s given to %s',
        \            string(spec_name),
        \            string(obj_name))
      endif

      unlet spec_info  " to avoid E706.
    endfor
  endfor

  call s:define_failsafe_key_mappings(a:plugin_name, a:obj_specs)
endfunction




function! textobj#user#plugin(plugin_name, obj_specs)  "{{{2
  if a:plugin_name =~# '\L'
    throw '{plugin} contains non-lowercase alphabet: ' . string(a:plugin_name)
  endif
  let plugin = a:plugin_name
  let Plugin = substitute(a:plugin_name, '^\(\l\)', '\u\1', 0)

  let g:__textobj_{plugin} = s:plugin.new(a:plugin_name, a:obj_specs)

  execute
  \ 'command! -bang -bar -nargs=0 Textobj'.Plugin.'DefaultKeyMappings'
  \ 'call g:__textobj_'.plugin.'.define_default_key_mappings("<bang>" == "!")'
  call g:__textobj_{plugin}.define_interface_key_mappings()
  if (!has_key(a:obj_specs, '*no-default-key-mappings*'))
  \  && (!exists('g:textobj_'.plugin.'_no_default_key_mappings'))
    execute 'Textobj'.Plugin.'DefaultKeyMappings'
  endif

  return g:__textobj_{plugin}
endfunction








" Misc.  "{{{1
" pos  "{{{2

" Terms:
"   gpos        [bufnum, lnum, col, off] - a value returned by getpos()
"   spos        [lnum, col] - a value returned by searchpos()
"   pos         same as spos
function! s:gpos_to_spos(gpos)
  return a:gpos[1:2]
endfunction


function! s:pos_headp(pos)
  return a:pos[1] <= 1
endfunction

function! s:pos_lastp(pos)
  return a:pos[1] == len(getline(a:pos[0]))
endfunction


function! s:pos_le(pos1, pos2)  " less than or equal
  return ((a:pos1[0] < a:pos2[0])
  \       || (a:pos1[0] == a:pos2[0] && a:pos1[1] <= a:pos2[1]))
endfunction




" range  "{{{2

function! s:range_containsp(range_head, range_tail, target_pos)
  return (s:pos_le(a:range_head, a:target_pos)
  \       && s:pos_le(a:target_pos, a:range_tail))
endfunction


function! s:range_in_linep(range_head, range_tail, target_pos)
  return a:range_head[0] == a:target_pos[0]
  \      || a:range_tail[0] == a:target_pos[0]
endfunction


function! s:range_no_text_without_edgesp(range_head, range_tail)
  let [hl, hc] = a:range_head
  let [tl, tc] = a:range_tail
  return ((hl == tl && hc - tc == -1)
  \       || (hl - tl == -1
  \           && (s:pos_lastp(a:range_head) && s:pos_headp(a:range_tail))))
endfunction


function! s:range_validp(range_head, range_tail)
  let NULL_POS = [0, 0]
  return (a:range_head != NULL_POS) && (a:range_tail != NULL_POS)
endfunction


function! s:range_select(range_head, range_tail, fallback_wise)
  execute 'normal!' s:wise(a:fallback_wise)
  call cursor(a:range_head)
  normal! o
  call cursor(a:range_tail)
  if &selection ==# 'exclusive'
    normal! l
  endif
endfunction




" Save the last cursort position  "{{{2

noremap <expr> <SID>(save-cursor-pos) <SID>save_cursor_pos()

" let s:last_cursor_gpos = getpos('.')

function! s:save_cursor_pos()
  let s:last_cursor_gpos = getpos('.')
  return ''
endfunction




" for textobj#user#define()  "{{{2

function! s:rhs_escape(pattern)
  let r = a:pattern
  let r = substitute(r, '<', '<LT>', 'g')
  let r = substitute(r, '|', '<Bar>', 'g')
  return r
endfunction


function! s:mapargs_single_move(lhs, pattern, flags, previous_mode)
  return printf('<silent> %s  :<C-u>call textobj#user#move(%s, %s, %s)<CR>',
              \ a:lhs,
              \ string(a:pattern), string(a:flags), string(a:previous_mode))
endfunction

function! s:mapargs_single_select(lhs, pattern, flags, previous_mode)
  return printf('<silent> %s  :<C-u>call textobj#user#select(%s, %s, %s)<CR>',
              \ a:lhs,
              \ string(a:pattern), string(a:flags), string(a:previous_mode))
endfunction

function! s:mapargs_pair_select(lhs, pattern1, pattern2, flags, previous_mode)
  return printf(
       \   '<silent> %s  :<C-u>call textobj#user#select_pair(%s,%s,%s,%s)<CR>',
       \   a:lhs,
       \   string(a:pattern1), string(a:pattern2),
       \   string(a:flags), string(a:previous_mode)
       \ )
endfunction




" for textobj#user#plugin()  "{{{2
" basics  "{{{3
let s:plugin = {}

function! s:plugin.new(plugin_name, obj_specs)
  let _ = extend({'name': a:plugin_name, 'obj_specs': a:obj_specs},
  \              s:plugin, 'keep')
  call _.normalize()
  return _
endfunction

function! s:plugin.normalize()
  call s:normalize(self.obj_specs)
endfunction

function! s:normalize(obj_specs)
  call s:normalize_property_names(a:obj_specs)
  call s:normalize_property_values(a:obj_specs)
endfunction

function! s:normalize_property_names(obj_specs)
  for spec in values(a:obj_specs)
    for old_prop_name in keys(spec)
      if old_prop_name =~ '^\*.*\*$'
        let new_prop_name = substitute(old_prop_name, '^\*\(.*\)\*$', '\1', '')
        let spec[new_prop_name] = spec[old_prop_name]
        unlet spec[old_prop_name]
      endif
    endfor
  endfor
endfunction

function! s:normalize_property_values(obj_specs)
  for [obj_name, specs] in items(a:obj_specs)
    for [spec_name, spec_info] in items(specs)
      if s:is_ui_property_name(spec_name)
        if type(spec_info) == type('')
          let specs[spec_name] = [spec_info]
        endif
      endif

      if spec_name =~# '-function$'
        if spec_info =~# '^s:'
          if has_key(specs, 'sfile')
            let specs[spec_name] = substitute(spec_info,
            \                                 '^s:',
            \                                 s:snr_prefix(specs['sfile']),
            \                                 '')
          else
            echoerr '"sfile" must be given to use a script-local function:'
            \       string(spec_name) '/' string(spec_info)
          endif
        else
          " Nothing to do.
        endif
      elseif spec_name ==# 'pattern'
        if !has_key(specs, 'region-type')
          let specs['region-type'] = 'v'
        endif
        if !has_key(specs, 'scan')
          let specs['scan'] = 'forward'
        endif
      endif

      unlet spec_info  " to avoid E706.
    endfor
  endfor
endfunction


function! s:plugin.define_default_key_mappings(banged_p)  "{{{3
  call textobj#user#map(self.name, self.obj_specs, a:banged_p)
endfunction


function! s:plugin.define_interface_key_mappings()  "{{{3
  let RHS_FORMAT =
  \   '<SID>(save-cursor-pos)'
  \ . ':<C-u>call g:__textobj_' . self.name . '.%s('
  \ .   '"%s",'
  \ .   '"%s",'
  \ .   '"<mode>"'
  \ . ')<Return>'

  for [obj_name, specs] in items(self.obj_specs)
    for spec_name in filter(keys(specs), 's:is_ui_property_name(v:val)')
      " lhs
      let lhs = self.interface_mapping_name(obj_name, spec_name)

      " rhs
      let _ = spec_name . '-function'
      if has_key(specs, _)
        let do = 'do_by_function'
      elseif has_key(specs, 'pattern')
        let do = 'do_by_pattern'
      else
        " skip to allow to define user's own {rhs} of the interface mapping.
        continue
      endif
      let rhs = printf(RHS_FORMAT, do, spec_name, obj_name)

      " map
      if spec_name =~# '^move'
        let MapFunction = function('s:noremap')
      else  " spec_name =~# '^select'
        let MapFunction = function('s:objnoremap')
      endif
      call MapFunction(1, '<silent> <script>' . lhs, rhs)
    endfor
  endfor
endfunction


function! s:plugin.interface_mapping_name(obj_name, spec_name)  "{{{3
  return s:interface_mapping_name(self.name, a:obj_name, a:spec_name)
endfunction


function! s:interface_mapping_name(plugin_name, obj_name, spec_name)  "{{{3
  let _ = printf('<Plug>(textobj-%s-%s-%s)',
  \              a:plugin_name,
  \              a:obj_name,
  \              substitute(a:spec_name, '^\(move\|select\)', '', ''))
  let _ = substitute(_, '-\+', '-', 'g')
  let _ = substitute(_, '-\ze)$', '', '')
  return _
endfunction


" "pattern" wrappers  "{{{3
function! s:plugin.do_by_pattern(spec_name, obj_name, previous_mode)
  let specs = self.obj_specs[a:obj_name]
  let flags = s:PATTERN_FLAGS_TABLE[a:spec_name]
  \           . (a:spec_name =~# '^select' ? specs['region-type'] : '')
  \           . (a:spec_name ==# 'select' ? specs['scan'][0] : '')
  call {s:PATTERN_IMPL_TABLE[a:spec_name]}(
  \   specs['pattern'],
  \   flags,
  \   a:previous_mode
  \ )
endfunction

let s:PATTERN_IMPL_TABLE = {
\   'move-n': 's:move_wrapper',
\   'move-N': 's:move_wrapper',
\   'move-p': 's:move_wrapper',
\   'move-P': 's:move_wrapper',
\   'select': 'textobj#user#select',
\   'select-a': 's:select_pair_wrapper',
\   'select-i': 's:select_pair_wrapper',
\ }

let s:PATTERN_FLAGS_TABLE = {
\   'move-n': '',
\   'move-N': 'e',
\   'move-p': 'b',
\   'move-P': 'be',
\   'select': '',
\   'select-a': 'a',
\   'select-i': 'i',
\ }

function! s:move_wrapper(patterns, flags, previous_mode)
  " \x16 = CTRL-V
  call textobj#user#move(
  \   a:patterns,
  \   substitute(a:flags, '[vV\x16]', '', 'g'),
  \   a:previous_mode
  \ )
endfunction

function! s:select_pair_wrapper(patterns, flags, previous_mode)
  call textobj#user#select_pair(
  \   a:patterns[0],
  \   a:patterns[1],
  \   a:flags,
  \   a:previous_mode
  \ )
endfunction


" "*-function" wrappers  "{{{3
function! s:plugin.do_by_function(spec_name, obj_name, previous_mode)
  let specs = self.obj_specs[a:obj_name]
  call {s:FUNCTION_IMPL_TABLE[a:spec_name]}(
  \   specs[a:spec_name . '-function'],
  \   a:spec_name,
  \   a:previous_mode
  \ )
endfunction

let s:FUNCTION_IMPL_TABLE = {
\   'move-n': 's:move_function_wrapper',
\   'move-N': 's:move_function_wrapper',
\   'move-p': 's:move_function_wrapper',
\   'move-P': 's:move_function_wrapper',
\   'select': 's:select_function_wrapper',
\   'select-a': 's:select_function_wrapper',
\   'select-i': 's:select_function_wrapper',
\ }

function! s:select_function_wrapper(function_name, spec_name, previous_mode)
  let ORIG_POS = s:gpos_to_spos(getpos('.'))

  let _ = function(a:function_name)()
  if _ is 0
    call s:cancel_selection(a:previous_mode, ORIG_POS)
  else
    let [motion_type, start_position, end_position] = _
    call s:range_select(
    \   s:gpos_to_spos(start_position),
    \   s:gpos_to_spos(end_position),
    \   motion_type
    \ )
  endif
endfunction

function! s:move_function_wrapper(function_name, spec_name, previous_mode)
  " ":" in Visual mode moves the cursor to '< before executing Ex command
  " (= the context where this function is called).  For example:
  "
  " -----------------------------------------
  " | User typed | Cursor | '<     | '>     |
  " |---------------------------------------|
  " | 1GVV       | Line 1 | Line 1 | Line 1 |
  " |     Vjj    | Line 3 | Line 1 | Line 1 |
  " |        :   | Line 1 | Line 1 | Line 3 |
  " -----------------------------------------
  "
  " So that user-defined motion does not work correctly in Visual mode if the
  " last "expected" cursor position is not '<.  That's why we have to save and
  " restore s:last_cursor_gpos explicitly.
  call cursor(s:gpos_to_spos(s:last_cursor_gpos))

  let _ = function(a:function_name)()

  call s:prepare_movement(a:previous_mode)
  if _ is 0
    call cursor(s:gpos_to_spos(s:last_cursor_gpos))
  else
    " FIXME: Support motion_type.  But unlike selecting a text object, the
    " motion_type must be known before calling a user-given function.
    let [motion_type, start_position, end_position] = _
    call setpos('.', a:spec_name =~# '[np]$' ? start_position : end_position)
  endif
endfunction


" map wrappers  "{{{3
function! s:_map(map_commands, forced_p, lhs, rhs)
  for _ in a:map_commands
    execute 'silent!' (_) (a:forced_p ? '' : '<unique>') a:lhs
    \       substitute(a:rhs, '<mode>', _[0], 'g')
  endfor
endfunction


function! s:noremap(forced_p, lhs, rhs)
  let v = s:proper_visual_mode(a:lhs)
  call s:_map(['nnoremap', v.'noremap', 'onoremap'], a:forced_p, a:lhs, a:rhs)
endfunction

function! s:objnoremap(forced_p, lhs, rhs)
  let v = s:proper_visual_mode(a:lhs)
  call s:_map([v.'noremap', 'onoremap'], a:forced_p, a:lhs, a:rhs)
endfunction


function! s:map(forced_p, lhs, rhs)
  let v = s:proper_visual_mode(a:lhs)
  call s:_map(['nmap', v.'map', 'omap'], a:forced_p, a:lhs, a:rhs)
endfunction

function! s:objmap(forced_p, lhs, rhs)
  let v = s:proper_visual_mode(a:lhs)
  call s:_map([v.'map', 'omap'], a:forced_p, a:lhs, a:rhs)
endfunction




" Etc  "{{{2

function! textobj#user#_sid()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID>  <SID>


function! s:prepare_movement(previous_mode)
  if a:previous_mode ==# 'v'
    normal! gv
  endif
endfunction


function! s:cancel_selection(previous_mode, orig_pos)
  if a:previous_mode ==# 'v'
    normal! gv
  else  " if a:previous_mode ==# 'o'
    call cursor(a:orig_pos)
  endif
endfunction


function! s:snr_prefix(sfile)
  " :redir captures also 'verbose' messages.  Its result must be filtered.
  redir => result
  silent scriptnames
  redir END

  for line in split(result, '\n')
    let _ = matchlist(line, '^\s*\(\d\+\):\s*\(.*\)$')
    if !empty(_) && s:normalize_path(a:sfile) ==# s:normalize_path(_[2])
      return printf("\<SNR>%d_", _[1])
    endif
  endfor

  return 's:'
endfunction


function! s:normalize_path(unnormalized_path)
  return substitute(fnamemodify(a:unnormalized_path, ':p'), '\\', '/', 'g')
endfunction


function! s:choose_wise(flags)
  return
  \ a:flags =~# 'v' ? 'v' :
  \ a:flags =~# 'V' ? 'V' :
  \ a:flags =~# "\<C-v>" ? "\<C-v>" :
  \ 'v'
endfunction


function! s:wise(default)
  return (exists('v:motion_force') && v:motion_force != ''
  \       ? v:motion_force
  \       : a:default)
endfunction


function! s:proper_visual_mode(lhs)
  " Return the mode prefix of proper "visual" mode for a:lhs key sequence.
  " a:lhs should not be defined in Select mode if a:lhs starts with
  " a printable character.  Otherwise a:lhs may be defined in Select mode.

  " a:lhs may be prefixed with :map-arguments such as <buffer>.
  " It's necessary to remove them to determine the first character in a:lhs.
  let s1 = substitute(
  \   a:lhs,
  \   '\v^(\<(buffer|silent|special|script|expr|unique)\>\s*)*',
  \   '',
  \   ''
  \ )
  " All characters in a:lhs are printable characters, so it's necessary to
  " convert <>-escaped notation into corresponding characters.
  let s2 = substitute(s1,
  \                   '^\(<[^<>]\+>\)',
  \                   '\=eval("\"\\" . submatch(1) . "\"")',
  \                   '')
  return s2 =~# '^\p' ? 'x' : 'v'
endfunction


let s:ui_property_names = [
\   'move-N',
\   'move-P',
\   'move-n',
\   'move-p',
\   'select',
\   'select-a',
\   'select-i',
\ ]

function! s:is_ui_property_name(name)
  return 0 <= index(s:ui_property_names, a:name)
endfunction

let s:non_ui_property_names = [
\   'move-N-function',
\   'move-P-function',
\   'move-n-function',
\   'move-p-function',
\   'pattern',
\   'region-type',
\   'scan',
\   'select-a-function',
\   'select-function',
\   'select-i-function',
\   'sfile',
\ ]

function! s:is_non_ui_property_name(name)
  return 0 <= index(s:non_ui_property_names, a:name)
endfunction


function! s:define_failsafe_key_mappings(plugin_name, obj_specs)
  for [obj_name, specs] in items(a:obj_specs)
    for [spec_name, spec_info] in items(specs)
      if !s:is_non_ui_property_name(spec_name)
        let lhs = s:interface_mapping_name(a:plugin_name, obj_name, spec_name)
        if maparg(lhs, 'v') == ''
          let rhs = printf('<SID>fail(%s)',
          \                string(substitute(lhs, '<', '<LT>', 'g')))
          let mapf = spec_name =~# '^move-[npNP]$'
          \          ? 's:noremap'
          \          : 's:objnoremap'
          call {mapf}(0, '<expr>' . lhs, rhs)
        endif
      endif
      unlet spec_info  " to avoid E706.
    endfor
  endfor
endfunction

function! s:fail(interface_key_mapping_lhs)
  throw printf('Text object %s is not defined', a:interface_key_mapping_lhs)
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
