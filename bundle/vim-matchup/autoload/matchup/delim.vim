" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

function! matchup#delim#get_next(type, side, ...) " {{{1
  return s:get_delim(extend({
        \ 'direction' : 'next',
        \ 'type' : a:type,
        \ 'side' : a:side,
        \}, get(a:, '1', {})))
endfunction

" }}}1
function! matchup#delim#get_prev(type, side, ...) " {{{1
  return s:get_delim(extend({
        \ 'direction' : 'prev',
        \ 'type' : a:type,
        \ 'side' : a:side,
        \}, get(a:, '1', {})))
endfunction

" }}}1
function! matchup#delim#get_current(type, side, ...) " {{{1
  return s:get_delim(extend({
        \ 'direction' : 'current',
        \ 'type' : a:type,
        \ 'side' : a:side,
        \}, get(a:, '1', {})))
endfunction

" }}}1

function! matchup#delim#get_matching(delim, ...) " {{{1
  if empty(a:delim) || !has_key(a:delim, 'lnum') | return {} | endif

  let l:opts = a:0 && type(a:1) == type({}) ? a:1 : {}
  let l:stopline = get(l:opts, 'stopline', s:stopline)

  " get all the matching position(s)
  " *important*: in the case of mid, we search up before searching down
  " this gives us a context object which we use for the other side
  " TODO: what if no open is found here?
  let l:matches = []
  let l:save_pos = matchup#pos#get_cursor()
  for l:down in {'open': [1], 'close': [0], 'mid': [0,1]}[a:delim.side]
    call matchup#pos#set_cursor(a:delim)

    " second iteration: [] refers to the current match
    if !empty(l:matches)
      call add(l:matches, [])
    endif

    let l:res = a:delim.get_matching(l:down, l:stopline)
    if l:res[0][1] > 0
      call extend(l:matches, l:res)
    elseif l:down
      let l:matches = []
    endif
  endfor
  call matchup#pos#set_cursor(l:save_pos)

  if a:delim.side ==# 'open'
    call insert(l:matches, [])
  endif
  if a:delim.side ==# 'close'
    call add(l:matches, [])
  endif

  " create the match result(s)
  let l:matching_list = []
  for l:i in range(len(l:matches))
    if empty(l:matches[l:i])
      let a:delim.match_index = l:i
      call add(l:matching_list, a:delim)
      continue
    end

    let [l:match, l:lnum, l:cnum] = l:matches[l:i]

    let l:matching = copy(a:delim)
    let l:matching.class = copy(a:delim.class)

    let l:matching.lnum = l:lnum
    let l:matching.cnum = l:cnum
    let l:matching.match = l:match
    let l:matching.side = l:i == 0 ? 'open'
          \ : l:i == len(l:matches)-1 ? 'close' : 'mid'
    let l:matching.class[1] = 'FIXME'
    let l:matching.match_index = l:i

    call add(l:matching_list, l:matching)
  endfor

  " set up links between matches
  for l:i in range(len(l:matching_list))
    let l:c = l:matching_list[l:i]
    let l:c.links = {}
    let l:c.links.next = l:matching_list[(l:i+1) % len(l:matching_list)]
    let l:c.links.prev = l:matching_list[l:i-1]
    let l:c.links.open = l:matching_list[0]
    let l:c.links.close = l:matching_list[-1]
  endfor

  return l:matching_list
endfunction

" }}}1

function! matchup#delim#get_surrounding(type, ...) " {{{1
  call matchup#perf#tic('delim#get_surrounding')

  let l:save_pos = matchup#pos#get_cursor()
  let l:pos_val_cursor = matchup#pos#val(l:save_pos)
  let l:pos_val_last = l:pos_val_cursor
  let l:pos_val_open = l:pos_val_cursor - 1

  let l:count = a:0 >= 1 ? a:1 : 1
  let l:counter = l:count

  " third argument specifies local any block, otherwise,
  " provided count == 0 refers to local any block
  let l:opts = a:0 >= 2 ? a:2 : {}
  let l:local = get(l:opts, 'local', l:count == 0 ? 1 : 0)

  let l:delimopts = {}
  let s:invert_skip = 0   " TODO: this logic is still bad
  if matchup#delim#skip() " TODO: check for insert mode (?)
    let l:delimopts.check_skip = 0
  endif
  " TODO: pin skip
  if get(l:opts, 'check_skip', 0)
    let l:delimopts.check_skip = 1
  endif

  " keep track of the outermost pair found so far
  " returned when g:matchup_delim_count_fail = 1
  let l:best = []

  while l:pos_val_open < l:pos_val_last
    let l:open = matchup#delim#get_prev(a:type,
          \ l:local ? 'open_mid' : 'open', l:delimopts)
    if empty(l:open) | break | endif

    " if configured, we may still accept this match
    if matchup#perf#timeout_check() && !g:matchup_delim_count_fail
      break
    endif

    let l:matches = matchup#delim#get_matching(l:open, 1)

    " TODO: getting one match result here is surely wrong
    if len(l:matches) == 1
      let l:matches = []
    endif

    if has_key(l:opts, 'matches')
      let l:opts.matches = l:matches
    endif

    if len(l:matches)
      let l:close = l:local ? l:open.links.next : l:open.links.close
      let l:pos_val_try = matchup#pos#val(l:close)
            \ + matchup#delim#end_offset(l:close)
    endif

    if len(l:matches) && l:pos_val_try >= l:pos_val_cursor
      if l:counter <= 1
        " restore cursor and accept
        call matchup#pos#set_cursor(l:save_pos)
        call matchup#perf#toc('delim#get_surrounding', 'accept')
        return [l:open, l:close]
      endif
      let l:counter -= 1
      let l:best = [l:open, l:close]
    else
      let l:pos_val_last = l:pos_val_open
      let l:pos_val_open = matchup#pos#val(l:open)
    endif

    if l:open.lnum == 1 && l:open.cnum == 1
      break
    endif
    call matchup#pos#set_cursor(matchup#pos#prev(l:open))
  endwhile

  if !empty(l:best) && g:matchup_delim_count_fail
    call matchup#pos#set_cursor(l:save_pos)
    call matchup#perf#toc('delim#get_surrounding', 'bad_count')
    return l:best
  endif

  " restore cursor and return failure
  call matchup#pos#set_cursor(l:save_pos)
  call matchup#perf#toc('delim#get_surrounding', 'fail')
  return [{}, {}]
endfunction

" }}}1
function! matchup#delim#get_surround_nearest(open, ...) " {{{1
  " finds the first consecutive pair whose start
  " positions surround pos (default to the cursor)
  let l:cur_pos = a:0 ? a:1 : matchup#pos#get_cursor()
  let l:pos_val_cursor = matchup#pos#val(l:cur_pos)
  let l:pos_val_open = matchup#pos#val(a:open)

  let l:pos_val_prev = l:pos_val_open
  let l:delim = a:open.links.next
  let l:pos_val_next = matchup#pos#val(l:delim)
  while l:pos_val_next > l:pos_val_open
    let l:end_offset = matchup#delim#end_offset(l:delim)
    if l:pos_val_prev <= l:pos_val_cursor
          \ && l:pos_val_next + l:end_offset >= l:pos_val_cursor
      return [l:delim.links.prev, l:delim]
    endif
    let l:pos_val_prev = l:pos_val_next
    let l:delim = l:delim.links.next
    let l:pos_val_next = matchup#pos#val(l:delim)
  endwhile

  return [{}, {}]
endfunction

" }}}1

function! matchup#delim#jump_target(delim) " {{{1
  let l:save_pos = matchup#pos#get_cursor()

  " unicode note: technically wrong, but works in practice
  " since the cursor snaps back to start of multi-byte chars
  let l:column = a:delim.cnum
  let l:column += strlen(a:delim.match) - 1

  if strlen(a:delim.match) < 2
    return l:column
  endif

  for l:tries in range(strlen(a:delim.match)-1)
    call matchup#pos#set_cursor(a:delim.lnum, l:column)

    let l:delim_test = matchup#delim#get_current('all', 'both_all')
    if l:delim_test.class[0] ==# a:delim.class[0]
      break
    endif

    let l:column -= 1
  endfor

  call matchup#pos#set_cursor(l:save_pos)
  return l:column
endfunction

" }}}1
function! matchup#delim#end_offset(delim) " {{{1
  return max([0, match(a:delim.match, '.$')])
endfunction

" }}}1
function! matchup#delim#end_pos(delim) abort " {{{1
  return [a:delim.lnum, a:delim.cnum + matchup#delim#end_offset(a:delim)]
endfunction

" }}}1

function! s:get_delim(opts) " {{{1
  " arguments: {{{2
  "   opts = {
  "     'direction'   : 'next' | 'prev' | 'current'
  "     'type'        : 'delim_tex'
  "                   | 'delim_all'
  "                   | 'all'
  "     'side'        : 'open'     | 'close'
  "                   | 'both'     | 'mid'
  "                   | 'both_all' | 'open_mid'
  "  }
  "
  "  }}}2
  " returns: {{{2
  "   delim = {
  "     type     : 'delim'
  "     lnum     : line number
  "     cnum     : column number
  "     match    : the actual text match
  "     augment  : how to match a corresponding open
  "     groups   : dict of captured groups
  "     side     : 'open' | 'close' | 'mid'
  "     class    : [ c1, c2 ] identifies the kind of match_words
  "     regexone : the regex item, like \1foo
  "     regextwo : the regex_capture item, like \(group\)foo
  "   }
  "
  " }}}2

  if !get(b:, 'matchup_delim_enabled', 0)
    return {}
  endif

  call matchup#perf#tic('s:get_delim')

  let l:save_pos = matchup#pos#get_cursor()

  call matchup#loader#refresh_match_words()

  " this contains all the patterns for the specified type and side
  let l:re = b:matchup_delim_re[a:opts.type][a:opts.side]

  let l:cursorpos = col('.')

  let l:insertmode = get(a:opts, 'insertmode', 0)
  if l:cursorpos > 1 && l:insertmode
    let l:cursorpos -= 1
  endif
  if l:cursorpos > strlen(getline('.'))
        \ && stridx("vV\<c-v>", mode()) > -1
    let l:cursorpos -= 1
  endif

  let s:invert_skip = 0

  if a:opts.direction ==# 'current'
    let l:check_skip = get(a:opts, 'check_skip',
          \ g:matchup_delim_noskips >= 2
          \ || g:matchup_delim_noskips >= 1
          \     && getline(line('.'))[l:cursorpos-1] =~ '[^[:punct:]]')
    if l:check_skip && matchup#delim#skip(line('.'), l:cursorpos)
      return {}
    endif
  else
    " check skip if cursor is not currently in skip
    let l:check_skip = get(a:opts, 'check_skip',
          \ !matchup#delim#skip(line('.'), l:cursorpos)
          \ || g:matchup_delim_noskips >= 2)
  endif

  let a:opts.cursorpos = l:cursorpos

  " for current, we want to find matches that end after the cursor
  " note: we expect this to give false-positives with \ze
  if a:opts.direction ==# 'current'
    let l:re .= '\%>'.(l:cursorpos).'c'
  "  let l:re = '\%<'.(l:cursorpos+1).'c' . l:re
  endif

  " allow overlapping delimiters
  " without this, the > in <tag> would not be found
  if b:matchup_delim_re[a:opts.type]._engine_info.has_zs[a:opts.side]
    let l:save_cpo = &cpo
    noautocmd set cpo-=c
  else
    " faster than changing cpo but doesn't work right with \zs
    let l:re .= '\&'
  endif

  " move cursor one left for searchpos if necessary
  let l:need_restore_cursor = 0
  if l:insertmode
    call matchup#pos#set_cursor(line('.'), col('.')-1)
    let l:need_restore_cursor = 1
  endif

  " stopline may depend on the current action
  let l:stopline = get(a:opts, 'stopline', s:stopline)

  " in the first pass, we get matching line and column numbers
  " this is intended to be as fast as possible, with no capture groups
  " we look for a match on this line (if direction == current)
  " or forwards or backwards (if direction == next or prev)
  " for current, we actually search leftwards from the cursor
  while 1
    let l:to = matchup#perf#timeout()
    let [l:lnum, l:cnum] = a:opts.direction ==# 'next'
          \ ? searchpos(l:re, 'cnW', line('.') + l:stopline, l:to)
          \ : a:opts.direction ==# 'prev'
          \   ? searchpos(l:re, 'bcnW',
          \               max([line('.') - l:stopline, 1]), l:to)
          \   : searchpos(l:re, 'bcnW', line('.'), l:to)
    if l:lnum == 0 | break | endif

    " note: the skip here should not be needed
    " in 'current' mode, but be explicit
    if a:opts.direction !=# 'current'
          \ && (l:check_skip || g:matchup_delim_noskips == 1
          \     && getline(l:lnum)[l:cnum-1] =~ '[^[:punct:]]')
          \ && matchup#delim#skip(l:lnum, l:cnum)
          \ && (a:opts.direction ==# 'prev' ? (l:lnum > 1 || l:cnum > 1)
          \     : (l:lnum < line('$') || l:cnum < len(getline('$'))))

      " invalid match, move cursor and keep looking
      call matchup#pos#set_cursor(a:opts.direction ==# 'next'
            \ ? matchup#pos#next(l:lnum, l:cnum)
            \ : matchup#pos#prev(l:lnum, l:cnum))
      let l:need_restore_cursor = 1
      continue
    endif

    break
  endwhile

  " restore cpo if necessary
  " note: this messes with cursor position
  if exists('l:save_cpo')
    noautocmd let &cpo = l:save_cpo
    let l:need_restore_cursor = 1
  endif

  " restore cursor
  if l:need_restore_cursor
    call matchup#pos#set_cursor(l:save_pos)
  endif

  call matchup#perf#toc('s:get_delim', 'first_pass')

  " nothing found, leave now
  if l:lnum == 0
    call matchup#perf#toc('s:get_delim', 'nothing_found')
    return {}
  endif

  if matchup#perf#timeout_check()
    return {}
  endif

  let l:skip_state = 0
  if !l:check_skip && (!&synmaxcol || l:cnum <= &synmaxcol)
    " XXX: workaround an apparent obscure vim bug where the
    " reported syntax id is incorrect on the first synID() call
    call matchup#delim#skip(l:lnum, l:cnum)
    if matchup#perf#timeout_check()
      return {}
    endif

    let l:skip_state = matchup#delim#skip(l:lnum, l:cnum)
  endif

  " now we get more data about the match in this position
  " there may be capture groups which need to be stored

  " result stub, to be filled by the parser when there is a match
  let l:result = {
        \ 'lnum'     : l:lnum,
        \ 'cnum'     : l:cnum,
        \ 'type'     : '',
        \ 'match'    : '',
        \ 'augment'  : '',
        \ 'groups'   : '',
        \ 'side'     : '',
        \ 'class'    : [],
        \ 'regexone' : '',
        \ 'regextwo' : '',
        \ 'skip'     : l:skip_state,
        \}

  for l:type in s:types[a:opts.type]
    let l:parser_result = l:type.parser(l:lnum, l:cnum, a:opts)
    if !empty(l:parser_result)
      let l:result = extend(l:parser_result, l:result, 'keep')
      break
    endif
  endfor

  call matchup#perf#toc('s:get_delim', 'got_results')

  return empty(l:result.type) ? {} : l:result
endfunction

" }}}1

function! s:parser_delim_new(lnum, cnum, opts) " {{{1
  let l:cursorpos = a:opts.cursorpos
  let l:found = 0

  let l:sides = matchup#loader#sidedict()[a:opts.side]
  let l:rebrs = b:matchup_delim_lists[a:opts.type].regex_capture

  " use b:match_ignorecase
  let l:ic = get(b:, 'match_ignorecase', 0) ? '\c' : '\C'

  " loop through all (index, side) pairs,
  let l:ns = len(l:sides)
  let l:found = 0
  for l:i in range(len(l:rebrs)*l:ns)
    let l:side = l:sides[ l:i % l:ns ]

    if l:side ==# 'mid'
      let l:res = l:rebrs[l:i / l:ns].mid_list
      if empty(l:res) | continue | end
    else
      let l:res = [ l:rebrs[l:i / l:ns][l:side] ]
      if empty(l:res[0]) | continue | end
    endif

    " if pattern may contain \zs, extra processing is required
    let l:extra_info = l:rebrs[l:i / l:ns].extra_info
    let l:has_zs = get(l:extra_info, 'has_zs', 0)

    let l:mid_id = 0
    for l:re in l:res
      let l:mid_id += 1

      " check whether hlend needs to be handled
      let l:id = l:side ==# 'mid' ? l:mid_id : l:side ==# 'open' ? 0 : -1
      let l:extra_entry = l:rebrs[l:i / l:ns].extra_list[l:id]
      let l:has_hlend = has_key(l:extra_entry, 'hlend')

      if l:has_hlend && get(a:opts, 'highlighting', 0)
        let l:re = s:process_hlend(l:re, l:cursorpos)
      endif

      " prepend the column number and append the cursor column
      " to anchor the match; we don't use {start} for matchlist
      " because there may be zero-width look behinds
      let l:re_anchored = l:ic . s:anchor_regex(l:re, a:cnum, l:has_zs)

      " for current we want the first match which the cursor is inside
      if a:opts.direction ==# 'current'
        let l:re_anchored .= '\%>'.(l:cursorpos).'c'
      endif

      let l:matches = matchlist(getline(a:lnum), l:re_anchored)
      if empty(l:matches) | continue | endif

      " reject matches which the cursor is outside of
      " this matters only for \ze
      if !l:has_hlend && a:opts.direction ==# 'current'
          \ && a:cnum + strlen(l:matches[0]) <= l:cursorpos
        continue
      endif

      " if pattern contains \zs we need to re-check the starting column
      if l:has_zs && match(getline(a:lnum), l:re_anchored) != a:cnum-1
        continue
      endif

      let l:found = 1
      break
    endfor

    if !l:found | continue | endif

    break
  endfor

  " reset ignorecase (defunct)

  if !l:found
    return {}
  endif

  let l:match = l:matches[0]

  let l:list = b:matchup_delim_lists[a:opts.type]
  let l:thisre   = l:list.regex[l:i / l:ns]
  let l:thisrebr = l:list.regex_capture[l:i / l:ns]

  let l:augment = {}

  " these are the capture groups indexed by their 'open' id
  let l:groups = {}
  let l:id = 0

  if l:side ==# 'open'
    " XXX we might as well store all the groups...
    "for l:br in keys(l:thisrebr.need_grp)
    for l:br in range(1,9)
      if empty(l:matches[l:br]) | continue | endif
      let l:groups[l:br] = l:matches[l:br]
    endfor
  else
    let l:id = (l:side ==# 'close')
          \ ? len(l:thisrebr.mid_list)+1
          \ : l:mid_id

    if has_key(l:thisrebr.grp_renu, l:id)
      for [l:br, l:to] in items(l:thisrebr.grp_renu[l:id])
        let l:groups[l:to] = l:matches[l:br]
      endfor
    endif

    " fill in augment pattern
    " TODO all the augment patterns should match,
    " but checking might be too slow
    if has_key(l:thisrebr.aug_comp, l:id)
      let l:aug = l:thisrebr.aug_comp[l:id][0]
      let l:augment.str = matchup#delim#fill_backrefs(
            \ l:aug.str, l:groups, 0)
      let l:augment.unresolved = deepcopy(l:aug.outputmap)
    endif
  endif

  let l:result = {
        \ 'type'         : 'delim_tex',
        \ 'match'        : l:match,
        \ 'augment'      : l:augment,
        \ 'groups'       : l:groups,
        \ 'side'         : l:side,
        \ 'class'        : [(l:i / l:ns), l:id],
        \ 'get_matching' : s:basetypes['delim_tex'].get_matching,
        \ 'regexone'     : l:thisre,
        \ 'regextwo'     : l:thisrebr,
        \ 'midmap'       : get(l:list, 'midmap', {}),
        \ 'highlighting' : get(a:opts, 'highlighting', 0),
        \}

  return l:result
endfunction
" }}}1

function! s:get_matching_delims(down, stopline) dict " {{{1
  " called as:   a:delim.get_matching(...)
  " called from: matchup#delim#get_matching <- matchparen, motion
  "   from: matchup#delim#get_surrounding <- matchparen, motion, text_obj

  call matchup#perf#tic('get_matching_delims')

  " first, we figure out what the furthest match is, which will be
  " either the open or close depending on the direction
  let [l:re, l:flags, l:stopline] = a:down
      \ ? [self.regextwo.close, 'W', line('.') + a:stopline]
      \ : [self.regextwo.open, 'bW', max([line('.') - a:stopline, 1])]

  " these are the anchors for searchpairpos
  let l:open = self.regexone.open     " TODO is this right? BADLOGIC
  let l:close = self.regexone.close

  " if we're searching up, we anchor by the augment, if it exists
  if !a:down && !empty(self.augment)
    let l:open = self.augment.str
  endif

  " TODO temporary workaround for BADLOGIC
  if a:down && self.side ==# 'mid'
    let l:open = self.regextwo.open
  endif

  " turn \(\) into \%(\) for searchpairpos
  let l:open  = matchup#loader#remove_capture_groups(l:open)
  let l:close = matchup#loader#remove_capture_groups(l:close)

  " fill in back-references
  " TODO: BADLOGIC2: when going up we don't have these groups yet..
  " the second anchor needs to be mid/self for mid self
  let l:open = matchup#delim#fill_backrefs(l:open, self.groups, 0)
  let l:close = matchup#delim#fill_backrefs(l:close, self.groups, 0)

  let s:invert_skip = self.skip
  if empty(b:matchup_delim_skip)
    let l:skip = 'matchup#delim#skip_default()'
  else
    let l:skip = 'matchup#delim#skip0()'
  endif

  " disambiguate matches for languages like julia, matlab, ruby, etc
  if !empty(self.midmap)
    let l:midmap = self.midmap.elements
    if self.side ==# 'mid'
      let l:idx = filter(range(len(l:midmap)),
            \ 'self.match =~# l:midmap[v:val][1]')
    else
      let l:syn = synIDattr(synID(self.lnum, self.cnum, 0), 'name')
      let l:idx = filter(range(len(l:midmap)),
            \ 'l:syn =~# l:midmap[v:val][0]')
    endif
    if len(l:idx)
      let l:valid = l:midmap[l:idx[0]]
      let l:skip = printf('matchup#delim#skip1(%s, %s)',
            \ string(l:midmap[l:idx[0]]), string(l:skip))
    else
      let l:skip = printf('matchup#delim#skip2(%s, %s)',
            \ string(self.midmap.strike), string(l:skip))
    endif
  endif

  if matchup#perf#timeout_check() | return [['', 0, 0]] | endif

  " improves perceptual performance in insert mode
  if mode() ==# 'i' || mode() ==# 'R'
    if !g:matchup_matchparen_deferred
      sleep 1m
    endif
  endif

  " use b:match_ignorecase
  let l:ic = get(b:, 'match_ignorecase', 0) ? '\c' : '\C'
  let l:open = l:ic . l:open
  let l:close = l:ic . l:close

  let [l:lnum_corr, l:cnum_corr] = searchpairpos(l:open, '', l:close,
        \ 'n'.l:flags, l:skip, l:stopline, matchup#perf#timeout())

  call matchup#perf#toc('get_matching_delims', 'initial_pair')

  " if nothing found, bail immediately
  if l:lnum_corr == 0
    " reset ignorecase (defunct)

    return [['', 0, 0]]
  endif

  " when highlighting, respect hlend
  let l:extra_entry = self.regextwo.extra_list[a:down ? -1 : 0]
  if self.highlighting && has_key(l:extra_entry, 'hlend')
    let l:re = s:process_hlend(l:re, -1)
  endif

  " get the match and groups
  let l:has_zs = self.regextwo.extra_info.has_zs
  let l:re_anchored = l:ic . s:anchor_regex(l:re, l:cnum_corr, l:has_zs)
  let l:matches = matchlist(getline(l:lnum_corr), l:re_anchored)
  let l:match_corr = l:matches[0]

  " reset ignorecase (defunct)

  " store these in these groups
  if a:down
    " let l:id = len(self.regextwo.mid_list)+1
    " for [l:from, l:to] in items(self.regextwo.grp_renu[l:id])
    "   let self.groups[l:to] = l:matches[l:from]
    " endfor
  else
    for l:to in range(1,9)
      if !has_key(self.groups, l:to) && !empty(l:matches[l:to])
        let self.groups[l:to] = l:matches[l:to]
      endif
    endfor
  endif

  call matchup#perf#toc('get_matching_delims', 'get_matches')

  " fill in additional groups
  let l:mids = matchup#loader#remove_capture_groups(self.regexone.mid)
  let l:mids = matchup#delim#fill_backrefs(l:mids, self.groups, 1)

  " if there are no mids, we're done
  if empty(l:mids)
    return [[l:match_corr, l:lnum_corr, l:cnum_corr]]
  endif

  let l:re = l:mids

  " when highlighting, respect hlend
  if get(self.regextwo.extra_info, 'mid_hlend') && self.highlighting
    let l:re = s:process_hlend(l:re, -1)
  endif

  " use b:match_ignorecase
  let l:mid = l:ic . l:mids
  let l:re = l:ic . l:re

  let l:list = []
  while 1
    if matchup#perf#timeout_check() | break | endif

    let [l:lnum, l:cnum] = searchpairpos(l:open, l:mids, l:close,
          \ l:flags, l:skip, l:lnum_corr, matchup#perf#timeout())
    if l:lnum <= 0 | break | endif

    if a:down
      if l:lnum > l:lnum_corr || l:lnum == l:lnum_corr
          \ && l:cnum >= l:cnum_corr | break | endif
    else
      if l:lnum < l:lnum_corr || l:lnum == l:lnum_corr
          \ && l:cnum <= l:cnum_corr | break | endif
    endif

    let l:re_anchored = s:anchor_regex(l:re, l:cnum, l:has_zs)
    let l:matches = matchlist(getline(l:lnum), l:re_anchored)
    if empty(l:matches)
      " this should never happen
      continue
    endif
    let l:match = l:matches[0]

    call add(l:list, [l:match, l:lnum, l:cnum])
  endwhile

  " reset ignorecase (defunct)

  call add(l:list, [l:match_corr, l:lnum_corr, l:cnum_corr])

  if !a:down
    call reverse(l:list)
  endif

  return l:list
endfunction
" }}}1

function! matchup#delim#skip(...) " {{{1
  if a:0 >= 2
    let [l:lnum, l:cnum] = [a:1, a:2]
  else
    let [l:lnum, l:cnum] = matchup#pos#get_cursor()[1:2]
  endif

  if empty(get(b:, 'matchup_delim_skip', ''))
    return matchup#util#in_comment_or_string(l:lnum, l:cnum)
          \ ? !s:invert_skip : s:invert_skip
  endif

  let s:eff_curpos = [l:lnum, l:cnum]
  execute 'return' (s:invert_skip ? '!(' : '(') b:matchup_delim_skip ')'
endfunction

function! matchup#delim#skip_default()
  return matchup#util#in_comment_or_string(line('.'), col('.'))
        \ ? !s:invert_skip : s:invert_skip
endfunction

function! matchup#delim#skip0()
  let s:eff_curpos = [line('.'), col('.')]
  execute 'return' (s:invert_skip ? '!(' : '(') b:matchup_delim_skip ')'
endfunction

""
" advanced mid/syntax skip when found in midmap
" {val} is a 2 element array of allowed [syntax, words]
" {def} is the fallback skip expression
function! matchup#delim#skip1(val, def)
  if getline('.')[col('.')-1:] =~# '^'.a:val[1]
    return eval(a:def)
  endif
  let l:s = synIDattr(synID(line('.'),col('.'), 0), 'name')
  return l:s !~# a:val[0] || eval(a:def)
endfunction

""
" advanced mid/syntax skip when word is not in midmap
" {strike} pattern of disallowed mid words
" {def} is the fallback skip expression
function! matchup#delim#skip2(strike, def)
  return getline('.')[col('.')-1:] =~# '^' . a:strike || eval(a:def)
endfunction

let s:invert_skip = 0
let s:eff_curpos = [1, 1]

" effective column/line
function! s:effline(expr)
  return a:expr ==# '.' ? s:eff_curpos[0] : line(a:expr)
endfunction

function! s:effcol(expr)
  return a:expr ==# '.' ? s:eff_curpos[1] : col(a:expr)
endfunction

function! s:geteffline(expr)
  return a:expr ==# '.' ? getline(s:effline(a:expr)) : getline(a:expr)
endfunction

" }}}1

function! matchup#delim#fill_backrefs(re, groups, warn) " {{{1
  return substitute(a:re, g:matchup#re#backref,
        \ '\=s:get_backref(a:groups, submatch(1), a:warn)', 'g')
        " \ '\=get(a:groups, submatch(1), "")', 'g')
endfunction

function! s:get_backref(groups, bref, warn)
  if !has_key(a:groups, a:bref)
    if a:warn
      echohl WarningMsg
      echo 'match-up: requested invalid backreference \'.a:bref
      echohl None
    endif
    return ''
  endif
  return '\V'.escape(get(a:groups, a:bref), '\').'\m'
endfunction

"}}}1

function! s:anchor_regex(re, cnum, method) " {{{1
  if a:method
    " trick to re-match at a particular column
    " handles the case where pattern contains \ze, \zs, and assertions
    " but doesn't work with overlapping matches and is possibly slower
    return '\%<'.(a:cnum+1).'c\%('.a:re.'\)\%>'.(a:cnum).'c'
  else
    " fails to match with \zs
    return '\%'.(a:cnum).'c\%('.a:re.'\)'
  endif
endfunction

" }}}1
function! s:process_hlend(re, cursorpos) " {{{1
  " first replace all \ze with \%>{cursorpos}c
  let l:re = substitute(a:re, g:matchup#re#ze,
        \ a:cursorpos < 0 ? '' : '\\%>'.a:cursorpos.'c', 'g')
  " next convert hlend mark to \ze
  return substitute(l:re, '\V\\%(hlend\\)\\{0}', '\\ze', 'g')
endfunction

" }}}1

" initialize script variables
let s:stopline = get(g:, 'matchup_delim_stopline', 1500)

let s:basetypes = {
      \ 'delim_tex': {
      \   'parser'       : function('s:parser_delim_new'),
      \   'get_matching' : function('s:get_matching_delims'),
      \ },
      \}

let s:types = {
      \ 'all'       : [ s:basetypes.delim_tex ],
      \ 'delim_all' : [ s:basetypes.delim_tex ],
      \ 'delim_tex' : [ s:basetypes.delim_tex ],
      \}

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

