" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

function! matchup#loader#init_module() abort " {{{1
  augroup matchup_filetype
    au!
    autocmd FileType * call matchup#loader#init_buffer()
    if g:matchup_delim_start_plaintext
      autocmd BufWinEnter,CmdWinEnter * call matchup#loader#bufwinenter()
    endif
  augroup END
endfunction

" }}}1
function! matchup#loader#init_buffer() abort " {{{1
  call matchup#perf#tic('loader_init_buffer')

  " initialize lists of delimiter pairs and regular expressions
  " this is the data obtained from parsing b:match_words
  let b:matchup_delim_lists = s:init_delim_lists()

  " this is the combined set of regular expressions used for matching
  " its structure is matchup_delim_re[type][open,close,both,mid,both_all]
  let b:matchup_delim_re = s:init_delim_regexes()

  " process match_skip
  let b:matchup_delim_skip = s:init_delim_skip()

  " enable/disable for this buffer
  let b:matchup_delim_enabled = !empty(b:matchup_delim_lists.all.regex)

  call matchup#perf#toc('loader_init_buffer', 'done')
endfunction

" }}}1
function! matchup#loader#bufwinenter() abort " {{{1
  if get(b:, 'matchup_delim_enabled', 0)
    return
  endif
  call matchup#loader#init_buffer()
endfunction

" }}}1
function! matchup#loader#refresh_match_words() abort " {{{1
  if get(b:, 'match_words', ':') !~# ':'
    call matchup#perf#tic('refresh')

    " protect the cursor from the match_words function
    let l:save_pos = matchup#pos#get_cursor()
    execute 'let l:match_words = ' b:match_words
    if l:save_pos != matchup#pos#get_cursor()
      call matchup#pos#set_cursor(l:save_pos)
    endif

    call matchup#perf#toc('refresh', 'function')

    if has_key(s:match_word_cache, l:match_words)
      let b:matchup_delim_lists
            \ = s:match_word_cache[l:match_words].delim_lists
      let b:matchup_delim_re
            \ = s:match_word_cache[l:match_words].delim_regexes
      call matchup#perf#toc('refresh', 'cache_hit')
    else
      " re-parse match words
      let b:matchup_delim_lists = s:init_delim_lists()
      let b:matchup_delim_re = s:init_delim_regexes()
      let s:match_word_cache[l:match_words] = {
            \ 'delim_lists'  : b:matchup_delim_lists,
            \ 'delim_regexes': b:matchup_delim_re,
            \}
      call matchup#perf#toc('refresh', 'parse')
    endif
  endif
endfunction

let s:match_word_cache = {}

" }}}1

function! s:init_delim_lists(...) abort " {{{1
  let l:lists = {
        \ 'delim_tex': {
        \   'regex': [],
        \   'regex_capture': [],
        \   'midmap': {},
        \ },
        \}

  " very tricky examples:
  " good: let b:match_words = '\(\(foo\)\(bar\)\):\3\2:end\1'
  " bad:  let b:match_words = '\(foo\)\(bar\):more\1:and\2:end\1\2'

  " *subtlety*: there is a huge assumption in matchit:
  "   ``It should be possible to resolve back references
  "     from any pattern in the group.''
  " we don't explicitly check this, but the behavior might
  " be unpredictable if such groups are encountered.. (ref-1)

  if exists('g:matchup_hotfix') && has_key(g:matchup_hotfix, &filetype)
    call call(g:matchup_hotfix[&filetype], [])
  elseif exists('g:matchup_hotfix_'.&filetype)
    call call(g:matchup_hotfix_{&filetype}, [])
  elseif exists('b:matchup_hotfix')
    call call(b:matchup_hotfix, [])
  endif

  " parse matchpairs and b:match_words
  let l:match_words = a:0 ? a:1 : get(b:, 'match_words', '')
  if !empty(l:match_words) && l:match_words !~# ':'
    if a:0
      echohl ErrorMsg
      echo 'match-up: function b:match_words error'
      echohl None
      let l:match_words = ''
    else
      execute 'let l:match_words =' b:match_words
      " echohl ErrorMsg
      " echo 'match-up: function b:match_words not supported'
      " echohl None
      " let l:match_words = ''
    endif
  endif
  let l:simple = empty(l:match_words)

  let l:mps = escape(&matchpairs, '[$^.*~\\/?]')
  if !get(b:, 'matchup_delim_nomatchpairs', 0) && !empty(l:mps)
    let l:match_words .= (l:simple ? '' : ',').l:mps
  endif

  if l:simple
    return s:init_delim_lists_fast(l:match_words)
  endif

  let l:sets = split(l:match_words, g:matchup#re#not_bslash.',')

  " do not duplicate whole groups of match words
  let l:seen = {}
  for l:s in l:sets
    " very special case, escape bare [:]
    " TODO: the bare [] bug might show up in other places too
    if l:s ==# '[:]' || l:s ==# '\[:\]'
      let l:s = '\[:]'
    endif

    if has_key(l:seen, l:s) | continue | endif
    let l:seen[l:s] = 1

    if l:s =~# '^\s*$' | continue | endif

    let l:words = split(l:s, g:matchup#re#not_bslash.':')

    if len(l:words) < 2 | continue | endif

    " stores series-level information
    let l:extra_info = {}

    " stores information for each word
    let l:extra_list = map(range(len(l:words)), '{}')

    " pre-process various \g{special} instructions
    let l:replacement = {
          \ 'hlend': '\%(hlend\)\{0}',
          \ 'syn': ''
          \}
    for l:i in range(len(l:words))
      let l:special_flags = []
      let l:words[l:i] = substitute(l:words[l:i],
            \ g:matchup#re#gspec,
            \ '\=[get(l:replacement,submatch(1),""),'
            \ . 'add(l:special_flags,'
            \ . '[submatch(1),submatch(2)])][0]', 'g')
      for [l:f, l:a] in l:special_flags
        let l:extra_list[l:i][l:f] = len(l:a) ? l:a : 1
      endfor
    endfor

    " we will resolve backrefs to produce two sets of words,
    " one with \(foo\)s and one with \1s, along with a set of
    " bookkeeping structures
    let l:words_backref = copy(l:words)

    " *subtlety*: backref numbers refer to the capture groups
    " in the 'open' pattern so we have to carefully keep track
    " of the group renumbering
    let l:group_renumber = {}
    let l:augment_comp = {}
    let l:all_needed_groups = {}

    " *subtlety*: when replacing things like \1 with \(...\)
    " the insertion could possibly contain back references of
    " its own; this poses a very difficult bookkeeping problem,
    " so we just disallow it.. (ref-2)

    " get the groups like \(foo\) in the 'open' pattern
    let l:cg = matchup#loader#get_capture_groups(l:words[0])

    " if any of these contain \d raise a warning
    " and substitute it out (ref-2)
    for l:cg_i in keys(l:cg)
      if l:cg[l:cg_i].str =~# g:matchup#re#backref
        echohl WarningMsg
        echom 'match-up: capture group' l:cg[l:cg_i].str
              \ 'should not contain backrefs (ref-2)'
        echohl None
        let l:cg[l:cg_i].str = substitute(l:cg[l:cg_i].str,
              \ g:matchup#re#backref, '', 'g')
      endif
    endfor

    " for the 'open' pattern, create a series of replacements
    " of the capture groups with \9, \8, ..., \1
    " this must be done deepest to shallowest
    let l:augments = {}
    let l:order = matchup#loader#capture_group_replacement_order(l:cg)

    let l:curaug = l:words[0]
    " TODO: \0 should match the whole pattern..
    " augments[0] is the original words[0] with original capture groups
    let l:augments[0] = l:curaug " XXX does putting this in 0 make sense?
    for l:j in l:order
      " these indexes are not invalid because we work backwards
      let l:curaug = strpart(l:curaug, 0, l:cg[l:j].pos[0])
            \ .('\'.l:j).strpart(l:curaug, l:cg[l:j].pos[1])
      let l:augments[l:j] = l:curaug
    endfor

    " TODO this logic might be bad BADLOGIC
    " should we not fill groups that aren't needed?
    " dragons: create the augmentation operators from the
    " open pattern- this is all super tricky!!
    " TODO we should be building the augment later, so
    " we can remove augments that can never be filled

    " now for the rest of the words...
    for l:i in range(1, len(l:words)-1)

      " first get rid of the capture groups in this pattern
      let l:words_backref[l:i] = matchup#loader#remove_capture_groups(
            \ l:words_backref[l:i])

      " get the necessary \1, \2, etc back-references
      let l:needed_groups = []
      call substitute(l:words_backref[l:i], g:matchup#re#backref,
            \ '\=len(add(l:needed_groups, submatch(1)))', 'g')
      call filter(l:needed_groups,
            \ 'index(l:needed_groups, v:val) == v:key')

      " warn if the back-referenced groups don't actually exist
      for l:ng in l:needed_groups
        if has_key(l:cg, l:ng)
          let l:all_needed_groups[l:ng] = 1
        else
          echohl WarningMsg
          echom 'match-up: backref \' . l:ng 'requested but no '
                \ . 'matching capture group provided'
          echohl None
        endif
      endfor

      " substitute capture groups into the backrefs and keep
      " track of the mapping to the original backref number
      let l:group_renumber[l:i] = {}

      let l:cg2 = {}
      for l:bref in l:needed_groups

        " turn things like \1 into \(...\)
        " replacement is guaranteed to exist and not contain \d
        let l:words_backref[l:i] = substitute(l:words_backref[l:i],
              \ g:matchup#re#backref,
              \ '\='''.l:cg[l:bref].str."'", '')    " not global!!

        " complicated: need to count the number of inserted groups
        let l:prev_max = max(keys(l:cg2))
        let l:cg2 = matchup#loader#get_capture_groups(l:words_backref[l:i])

        for l:cg2_i in sort(keys(l:cg2), s:Nsort)
          if l:cg2_i > l:prev_max
            " maps capture groups to 'open' back reference numbers
            let l:group_renumber[l:i][l:cg2_i] = l:bref
                  \ + (l:cg2_i - 1 - l:prev_max)
          endif
        endfor

        " if any backrefs remain, replace with re-numbered versions
        let l:words_backref[l:i] = substitute(l:words_backref[l:i],
              \ g:matchup#re#not_bslash.'\\'.l:bref,
              \ '\\\=l:group_renumber[l:i][submatch(1)]', 'g')
      endfor

      " mostly a sanity check
      if matchup#util#has_duplicate_str(values(l:group_renumber[l:i]))
          echohl ErrorMsg
          echom 'match-up: duplicate bref in set ' l:s ':' l:i
          echohl None
      endif

      " compile the augment list for this set of backrefs, going
      " deepest first and combining as many steps as possible
      let l:resolvable = {}
      let l:dependency = {}

      let l:instruct = []
      for l:j in l:order
        " the in group is the local number from this word pattern
        let l:in_grp_l = keys(filter(
              \ deepcopy(l:group_renumber[l:i]), 'v:val == l:j'))

        if empty(l:in_grp_l) | continue | endif
        let l:in_grp = l:in_grp_l[0]

        " if anything depends on this, flush out the current resolvable
        if has_key(l:dependency, l:j)
          call add(l:instruct, copy(l:resolvable))
          let l:dependency = {}
        endif

        " walk up the tree marking any new dependency
        let l:node = l:j
        for l:dummy in range(11)
          let l:node = l:cg[l:node].parent
          if l:node == 0 | break | endif
          let l:dependency[l:node] = 1
        endfor

        " mark l:j as resolvable
        let l:resolvable[l:j] = l:in_grp
      endfor

      if !empty(l:resolvable)
        call add(l:instruct, copy(l:resolvable))
      endif

      " *note*: recall that l:augments[2] is the result of augments
      " up to and including 2

      " this is a set of instructions of which brefs to resolve
      let l:augment_comp[l:i] = []
      for l:instr in l:instruct
        " the smallest key is the greediest, due to l:order
        let l:minkey = min(keys(l:instr))
        call insert(l:augment_comp[l:i], {
              \ 'inputmap': {},
              \ 'outputmap': {},
              \ 'str': l:augments[l:minkey],
              \})

        let l:remaining_out = {}
        for l:out_grp in keys(l:cg)
          let l:remaining_out[l:out_grp] = 1
        endfor

        " input map turns this word pattern numbers into 'open' numbers
        for [l:out_grp, l:in_grp] in items(l:instr)
          let l:augment_comp[l:i][0].inputmap[l:in_grp] = l:out_grp
          if has_key(l:remaining_out, l:out_grp)
            call remove(l:remaining_out, l:out_grp)
          endif
        endfor

        " output map turns remaining group numbers into 'open' numbers
        let l:counter = 1
        for l:out_grp in sort(keys(l:remaining_out), s:Nsort)
          let l:augment_comp[l:i][0].outputmap[l:counter] = l:out_grp
          let l:counter += 1
        endfor
      endfor

      " if l:instruct was empty, there are no constraints
      if empty(l:instruct) && !empty(l:augments)
        let l:augment_comp[l:i] = [{
              \ 'inputmap': {},
              \ 'outputmap': {},
              \ 'str': l:augments[0],
              \}]
        for l:cg_i in keys(l:cg)
          let l:augment_comp[l:i][0].outputmap[l:cg_i] = l:cg_i
        endfor
      endif
    endfor

    " strip out unneeded groups in output maps
    for l:i in keys(l:augment_comp)
      for l:aug in l:augment_comp[l:i]
        call filter(l:aug.outputmap,
              \ 'has_key(l:all_needed_groups, v:key)')
      endfor
    endfor

    " TODO should l:words[0] actually be used? BADLOGIC
    " the last element in the order gives the most augmented string
    " this includes groups that might not actually be needed elsewhere
    " as a concrete example,
    " l:augments = { '0': '\<\(wh\%[ile]\|for\)\>', '1': '\<\1\>'}
    " l:words[0] = \<\1\> (bad)
    " instead, get the furthest out needed augment.. Heuristic TODO
    for l:g in add(reverse(copy(l:order)), 0)
      if has_key(l:all_needed_groups, l:g)
        let l:words[0] = l:augments[l:g]
        break
      endif
    endfor

    " check whether any of these patterns has \zs
    let l:extra_info.has_zs
          \ = match(l:words_backref, g:matchup#re#zs) >= 0

    if !empty(filter(copy(l:extra_list[1:-2]),
          \ 'get(v:val, "hlend")'))
      let l:extra_info.mid_hlend = 1
    endif

    " this is the original set of words plus the set of augments
    " TODO this should probably be renamed
    " (also called regexone)
    call add(l:lists.delim_tex.regex, {
      \ 'open'     : l:words[0],
      \ 'close'    : l:words[-1],
      \ 'mid'      : join(l:words[1:-2], '\|'),
      \ 'mid_list' : l:words[1:-2],
      \ 'augments' : l:augments,
      \})

    " this list has \(groups\) and we also stuff recapture data
    " TODO this should probably be renamed
    " (also called regextwo)
    call add(l:lists.delim_tex.regex_capture, {
      \ 'open'     : l:words_backref[0],
      \ 'close'    : l:words_backref[-1],
      \ 'mid'      : join(l:words_backref[1:-2], '\|'),
      \ 'mid_list' : l:words_backref[1:-2],
      \ 'need_grp' : l:all_needed_groups,
      \ 'grp_renu' : l:group_renumber,
      \ 'aug_comp' : l:augment_comp,
      \ 'extra_list' : l:extra_list,
      \ 'extra_info' : l:extra_info,
      \})
  endfor

  " load info for advanced mid-mapper
  if exists('b:match_midmap') && type(b:match_midmap) == type([])
    let l:elems = deepcopy(b:match_midmap)
    let l:lists.delim_tex.midmap = {
          \ 'elements': l:elems,
          \ 'strike': '\%(' . join(map(range(len(l:elems)),
          \   '"\\(".l:elems[v:val][1]."\\)"'), '\|') . '\)'
          \}
  endif

  " generate combined lists
  let l:lists.delim_all = {}
  let l:lists.all = {}
  for l:k in ['regex', 'regex_capture', 'midmap']
    let l:lists.delim_all[l:k] = l:lists.delim_tex[l:k]
    let l:lists.all[l:k] = l:lists.delim_all[l:k]
  endfor

  return l:lists
endfunction

" }}}1
function! s:init_delim_lists_fast(mps) abort " {{{1
  let l:lists = { 'delim_tex': { 'regex': [], 'regex_capture': [] } }

  let l:sets = split(a:mps, ',')
  let l:seen = {}

  for l:s in l:sets
    if l:s =~# '^\s*$' | continue | endif

    if l:s ==# '[:]' || l:s ==# '\[:\]'
      let l:s = '\[:]'
    endif

    if has_key(l:seen, l:s) | continue | endif
    let l:seen[l:s] = 1

    let l:words = split(l:s, ':')
    if len(l:words) < 2 | continue | endif

    call add(l:lists.delim_tex.regex, {
      \ 'open'     : l:words[0],
      \ 'close'    : l:words[-1],
      \ 'mid'      : '',
      \ 'mid_list' : [],
      \ 'augments' : {},
      \})
    call add(l:lists.delim_tex.regex_capture, {
      \ 'open'     : l:words[0],
      \ 'close'    : l:words[-1],
      \ 'mid'      : '',
      \ 'mid_list' : [],
      \ 'need_grp' : {},
      \ 'grp_renu' : {},
      \ 'aug_comp' : {},
      \ 'has_zs'   : 0,
      \ 'extra_list' : [{}, {}],
      \ 'extra_info' : { 'has_zs': 0, },
      \})
  endfor

  " TODO if this is empty!

  " generate combined lists
  let l:lists.delim_all = {}
  let l:lists.all = {}
  for l:k in ['regex', 'regex_capture']
    let l:lists.delim_all[l:k] = l:lists.delim_tex[l:k]
    let l:lists.all[l:k] = l:lists.delim_all[l:k]
  endfor

  return l:lists
endfunction

" }}}1
function! s:init_delim_regexes() abort " {{{1
  let l:re = {}
  let l:re.delim_all = {}
  let l:re.all = {}

  let l:re.delim_tex = s:init_delim_regexes_generator('delim_tex')
  let l:re.delim_tex._engine_info = { 'has_zs': {} }

  " use a flag for b:match_ignorecase
  let l:ic = get(b:, 'match_ignorecase', 0) ? '\c' : '\C'

  " if a particular engine is specified, use that for the patterns
  " (currently only applied to delim_re TODO)
  let l:eng = string(get(b:, 'matchup_regexpengine', 0))
  let l:eng = l:eng > 0 ? '\%#='.l:eng : ''

  for l:k in keys(s:sidedict)
    let l:re.delim_tex._engine_info.has_zs[l:k]
          \ = l:re.delim_tex[l:k] =~# g:matchup#re#zs

    if l:re.delim_tex[l:k] ==# '\%(\)'
      let l:re.delim_tex[l:k] = ''
    else
      " since these patterns are used in searchpos(),
      " be explicit about regex mode (set magic mode and ignorecase)
      let l:re.delim_tex[l:k] = l:eng . '\m' . l:ic . l:re.delim_tex[l:k]
    endif

    let l:re.delim_all[l:k] = l:re.delim_tex[l:k]
    let l:re.all[l:k] = l:re.delim_all[l:k]
  endfor

  let l:re.delim_all._engine_info = l:re.delim_tex._engine_info
  let l:re.all._engine_info = l:re.delim_all._engine_info

  return l:re
endfunction

" }}}1
function! s:init_delim_regexes_generator(list_name) abort " {{{1
  let l:list = b:matchup_delim_lists[a:list_name].regex_capture

  " build the full regex strings: order matters here
  let l:regexes = {}
  for [l:key, l:sidelist] in items(s:sidedict)
    let l:relist = []

    for l:set in l:list
      for l:side in l:sidelist
        if strlen(l:set[l:side])
          call add(l:relist, l:set[l:side])
        endif
      endfor
    endfor

    let l:regexes[l:key] = matchup#loader#remove_capture_groups(
          \ '\%(' . join(l:relist, '\|') . '\)')
  endfor

  return l:regexes
endfunction

" }}}1

function! matchup#loader#capture_group_replacement_order(cg) abort " {{{1
  let l:order = reverse(sort(keys(a:cg), s:Nsort))
  call sort(l:order, 's:capture_group_sort', a:cg)
  return l:order
endfunction

function! s:capture_group_sort(a, b) abort dict
  return self[a:b].depth - self[a:a].depth
endfunction

" }}}1
function! matchup#loader#get_capture_groups(str, ...) abort " {{{1
  let l:allow_percent = a:0 ? a:1 : 0
  let l:pat = g:matchup#re#not_bslash . '\(\\%(\|\\(\|\\)\)'

  let l:start = 0

  let l:brefs = {}
  let l:stack = []
  let l:counter = 0
  while 1
    let l:match = s:matchstrpos(a:str, l:pat, l:start)
    if l:match[1] < 0 | break | endif
    let l:start = l:match[2]

    if l:match[0] ==# '\(' || (l:match[0] ==# '\%(' && l:allow_percent)
      let l:counter += 1
      call add(l:stack, l:counter)
      let l:cgstack = filter(copy(l:stack), 'v:val > 0')
      let l:brefs[l:counter] = {
        \ 'str': '',
        \ 'depth': len(l:cgstack),
        \ 'parent': (len(l:cgstack) > 1 ? l:cgstack[-2] : 0),
        \ 'pos': [l:match[1], 0],
        \}
    elseif l:match[0] ==# '\%('
      call add(l:stack, 0)
    else
      if empty(l:stack) | break | endif
      let l:i = remove(l:stack, -1)
      if l:i < 1 | continue | endif
      let l:j = l:brefs[l:i].pos[0]
      let l:brefs[l:i].str = strpart(a:str, l:j, l:match[2]-l:j)
      let l:brefs[l:i].pos[1] = l:match[2]
    endif
  endwhile

  call filter(l:brefs, 'has_key(v:val, "str")')

  return l:brefs
endfunction

" compatibility
if exists('*matchstrpos')
  function! s:matchstrpos(expr, pat, start) abort
    return matchstrpos(a:expr, a:pat, a:start)
  endfunction
else
  function! s:matchstrpos(expr, pat, start) abort
    return [matchstr(a:expr, a:pat, a:start),
          \ match(a:expr, a:pat, a:start),
          \ matchend(a:expr, a:pat, a:start)]
  endfunction
endif

" }}}1
function! matchup#loader#remove_capture_groups(re) abort "{{{1
  let l:sub_grp = '\(\\\@<!\(\\\\\)*\)\@<=\\('
  return substitute(a:re, l:sub_grp, '\\%(', 'g')
endfunction

"}}}1

function! s:init_delim_skip() abort "{{{1
  let l:skip = get(b:, 'match_skip', '')
  if empty(l:skip) | return '' | endif

  " s:foo becomes (current syntax item) =~ foo
  " S:foo becomes (current syntax item) !~ foo
  " r:foo becomes (line before cursor) =~ foo
  " R:foo becomes (line before cursor) !~ foo
  let l:cursyn = "synIDattr(synID(s:effline('.'),s:effcol('.'),1),'name')"
  let l:preline = "strpart(s:geteffline('.'),0,s:effcol('.'))"

  if l:skip =~# '^[sSrR]:'
    let l:syn = strpart(l:skip, 2)

    let l:skip = {
          \ 's': l:cursyn."=~?'".l:syn."'",
          \ 'S': l:cursyn."!~?'".l:syn."'",
          \ 'r': l:preline."=~?'".l:syn."'",
          \ 'R': l:preline."!~?'".l:syn."'",
          \}[l:skip[0]]
  endif

  for [l:pat, l:str] in [
        \ [ '\<col\ze(', 's:effcol'   ],
        \ [ '\<line\ze(', 's:effline' ],
        \ [ '\<getline\ze(', 's:geteffline' ],
        \]
    let l:skip = substitute(l:skip, l:pat, l:str, 'g')
  endfor

  return l:skip
endfunction

"}}}1

function! s:Nsort_func(a, b) abort " {{{1
  let l:a = type(a:a) == type('') ? str2nr(a:a) : a:a
  let l:b = type(a:b) == type('') ? str2nr(a:b) : a:b
  return l:a == l:b ? 0 : l:a > l:b ? 1 : -1
endfunction

" }}}1

let s:sidedict = {
      \ 'open'     : ['open'],
      \ 'mid'      : ['mid'],
      \ 'close'    : ['close'],
      \ 'both'     : ['close', 'open'],
      \ 'both_all' : ['close', 'mid', 'open'],
      \ 'open_mid' : ['mid', 'open'],
      \}

function! matchup#loader#sidedict() abort
  return s:sidedict
endfunction

" in case the 'N' sort flag is not available (compatibility for 7.4.898)
let s:Nsort = has('patch-7.4.951') ? 'N' : 's:Nsort_func'

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

