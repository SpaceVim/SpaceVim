"=============================================================================
" FILE: action.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#action#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'action',
      \ 'description' : 'candidates from unite action',
      \ 'action_table' : {},
      \ 'hooks' : {},
      \ 'default_action' : 'do',
      \ 'syntax' : 'uniteSource__Action',
      \ 'is_listed' : 0,
      \}

function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__ActionDescriptionLine / -- .*$/
        \ contained containedin=uniteSource__Action
  syntax match uniteSource__ActionDescription /.*$/
        \ contained containedin=uniteSource__ActionDescriptionLine
  syntax match uniteSource__ActionMarker / -- /
        \ contained containedin=uniteSource__ActionDescriptionLine
  syntax match uniteSource__ActionKind /(.\{-}) /
        \ contained containedin=uniteSource__ActionDescriptionLine
  highlight default link uniteSource__ActionMarker Special
  highlight default link uniteSource__ActionDescription Comment
  highlight default link uniteSource__ActionKind Type
endfunction"}}}

" @vimlint(EVL102, 1, l:sources)
function! s:source.gather_candidates(args, context) abort "{{{
  if empty(a:args)
    return []
  endif

  let candidates = copy(a:args[0])

  " Print candidates.
  call unite#print_source_message(map(copy(candidates),
        \ "'candidates: '.get(v:val, 'unite__abbr',
        \                     get(v:val, 'abbr', v:val.word))
        \  .'('.v:val.source.')'"), self.name)

  " Print default action.
  let default_actions = []
  for candidate in candidates
    let default_action = unite#action#get_default_action(
          \ candidate.source, candidate.kind)
    if default_action != ''
      call add(default_actions, default_action)
    endif
  endfor
  let default_actions = unite#util#uniq(default_actions)
  if len(default_actions) == 1
    call unite#print_source_message(
          \ 'default_action: ' . default_actions[0], self.name)
  endif

  " Process alias and uniq.
  let uniq_actions = {}
  for action in values(s:get_actions(candidates,
        \ a:context.source__sources))
    if !has_key(action, action.name)
      let uniq_actions[action.name] = action
    endif
  endfor

  let actions = filter(values(uniq_actions), 'v:val.is_listed')

  let max_name = max(map(copy(actions), 'len(v:val.name)'))
  let max_kind = max(map(copy(actions), 'len(v:val.from)')) + 2

  let sources = map(copy(candidates), 'v:val.source')

  return sort(map(actions, "{
        \   'word' : v:val.name,
        \   'abbr' : printf('%-".max_name."s %s -- %-".max_kind."s %s',
        \          v:val.name, (v:val.is_quit ? '!' : ' '),
        \          '('.v:val.from.')', v:val.description),
        \   'source__candidates' : candidates,
        \   'action__action' : v:val,
        \   'source__context' : a:context,
        \   'source__source_names' : sources,
        \ }"), 's:compare_word')
endfunction"}}}
" @vimlint(EVL102, 0, l:sources)

function! s:compare_word(i1, i2) abort
  return (a:i1.word ># a:i2.word) ? 1 : -1
endfunction

" Actions "{{{
let s:source.action_table.do = {
      \ 'description' : 'do action',
      \ }
function! s:source.action_table.do.func(candidate) abort "{{{
  let context = a:candidate.source__context

  if !empty(context.unite__old_buffer_info)
    " Restore buffer_name and profile_name.
    let buffer_name =
          \ get(get(context.unite__old_buffer_info, 0, {}), 'buffer_name', '')
    if buffer_name != ''
      let context.buffer_name = buffer_name
    endif
    let profile_name =
          \ get(get(context.unite__old_buffer_info, 0, {}), 'profile_name', '')
    if profile_name != ''
      let context.profile_name = profile_name
    endif
  endif

  if a:candidate.action__action.is_quit &&
        \ !a:candidate.action__action.is_start
    call unite#all_quit_session(0)
  endif

  call unite#action#do(a:candidate.word,
   \ a:candidate.source__candidates, context, context.source__sources)

  " Check quit flag.
  if !a:candidate.action__action.is_quit
        \ && context.temporary
    let input = unite#get_current_unite().input

    call unite#start#resume_from_temporary(context)

    if input != ''
      " Apply previous input changes
      call unite#mappings#narrowing(input, 0)
    endif

    " Check invalidate cache flag.
    if a:candidate.action__action.is_invalidate_cache
      for source_name in a:candidate.source__source_names
        call unite#helper#invalidate_cache(source_name)
      endfor

      call unite#force_redraw()
    endif
  endif
endfunction"}}}
"}}}

function! s:get_actions(candidates, sources) abort "{{{
  let actions = unite#action#_get_candidate_action_table(
        \ a:candidates[0], a:sources)

  for candidate in a:candidates[1:]
    let action_table = unite#action#_get_candidate_action_table(
          \ candidate, a:sources)
    " Filtering unique items and check selectable flag.
    call filter(actions, 'has_key(action_table, v:key)
          \ && action_table[v:key].is_selectable')
  endfor

  return actions
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
