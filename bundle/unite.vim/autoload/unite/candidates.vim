"=============================================================================
" FILE: candidates.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#candidates#_recache(input, is_force) abort "{{{
  let unite = unite#get_current_unite()

  " Save options.
  let ignorecase_save = &ignorecase

  let context = unite.context

  try
    if context.smartcase
      let &ignorecase = a:input !~ '\u'
    else
      let &ignorecase = context.ignorecase
    endif

    let context.is_redraw = a:is_force || context.is_redraw
    let context.is_changed = a:input !=# unite.last_input
          \ || context.path !=# unite.last_path

    if empty(unite.args)
      if a:input !~ '^.\{-}\%(\\\@<!\s\)\+'
        " Use interactive source.
        let sources = unite#init#_loaded_sources(['interactive'], context)
      else
        " Use specified source.
        let args = unite#helper#parse_options_args(
              \ matchstr(a:input, '^.\{-}\%(\\\@<!\s\)\+'))[0]
        try
          " Ignore source name
          let context.input = matchstr(context.input,
                \ '^.\{-}\%(\\\@<!\s\)\+\zs.*')

          let sources = unite#init#_loaded_sources(args, context)
        catch
          let sources = []
        finally
          let context.input = a:input
        endtry
      endif

      if get(unite.sources, 0, {'name' : ''}).name
            \   !=# get(sources, 0, {'name' : ''}).name
        " Finalize previous sources.
        call unite#helper#call_hook(unite.sources, 'on_close')

        let unite.sources = sources
        let unite.source_names = unite#helper#get_source_names(sources)

        let prev_winnr = winnr()
        try
          execute bufwinnr(unite.prev_bufnr).'wincmd w'

          " Initialize.
          call unite#helper#call_hook(sources, 'on_init')
        finally
          if winnr() != prev_winnr
            execute prev_winnr . 'wincmd w'
          endif
        endtry

        if &filetype ==# 'unite'
          call unite#view#_set_syntax()
        endif
      endif
    endif

    for source in unite.sources
      let source.unite__candidates = []
    endfor

    let inputs = unite#helper#get_substitute_input(a:input)
    let context.is_list_input = len(inputs) > 1
    for input in inputs
      let context.input = input
      call s:recache_candidates_loop(context, a:is_force)
    endfor

    " Restore prompt input
    let context.input = a:input

    let filtered_count = 0

    for source in unite.sources
      let source.unite__is_invalidate = 0

      if !context.unite__not_buffer && source.max_candidates != 0
            \ && context.unite__is_interactive
            \ && !unite.disabled_max_candidates
            \ && len(source.unite__candidates) > source.max_candidates
        " Filtering too many candidates.
        let source.unite__candidates =
              \ source.unite__candidates[: source.max_candidates - 1]

        if context.verbose && filtered_count < &cmdheight
          echohl WarningMsg | echomsg printf(
                \ '[%s] Filtering too many candidates.', source.name)
                \ | echohl None
          let filtered_count += 1
        endif
      endif

      " Call post_filter hook.
      let source.unite__context.candidates =
            \ source.unite__candidates
      call unite#helper#call_hook([source], 'on_post_filter')

      let source.unite__candidates =
            \ unite#init#_candidates_source(
            \   source.unite__context.candidates, source.name)
      let source.unite__len_candidates = len(source.unite__candidates)
    endfor

    " Update async state.
    let unite.is_async =
          \ len(filter(copy(unite.sources),
          \           'v:val.unite__context.is_async')) > 0
  finally
    let &ignorecase = ignorecase_save
    let context.is_redraw = 0
  endtry

  call unite#handlers#_save_updatetime()
endfunction"}}}

function! unite#candidates#gather(...) abort "{{{
  let is_gather_all = get(a:000, 0, 0)

  let unite = unite#get_current_unite()
  let unite.candidates = []
  for source in unite.sources
    let unite.candidates += source.unite__candidates
  endfor

  if unite.context.prompt_direction ==# 'below'
    let unite.candidates = reverse(unite.candidates)
  endif

  if unite.context.unique
    " Uniq filter.
    let unite.candidates = unite#util#uniq_by(unite.candidates,
          \ "string(v:val.kind) . ' ' . v:val.word")
  endif

  if is_gather_all || unite.context.prompt_direction ==# 'below'
        \ || unite.context.quick_match
    let unite.candidates_pos = len(unite.candidates)
  elseif unite.context.is_redraw || unite.candidates_pos == 0
    let unite.candidates_pos = line('.') + winheight(0)
  endif

  let candidates = unite#init#_candidates(
        \ unite.candidates[: unite.candidates_pos-1])

  if empty(candidates) && unite.prompt_linenr == 0
    let unite.prompt_linenr = 1
  endif

  let unite.context.unite__max_candidates = 0
  let unite.context.input_list =
        \ split(unite.context.input, '\\\@<! ', 1)

  let unite.candidates_len = len(candidates) +
        \ len(unite.candidates[unite.candidates_pos :])

  if unite.context.prompt_direction ==# 'below'
    if unite.prompt_linenr == 0
      let unite.init_prompt_linenr = unite.candidates_len + 1
    else
      let unite.prompt_linenr = unite.candidates_len
      if unite.prompt_linenr == 0
        let unite.prompt_linenr = 1
      endif
    endif
  endif

  return candidates
endfunction"}}}

function! unite#candidates#_gather_pos(offset) abort "{{{
  let unite = unite#get_current_unite()
  if unite.context.is_redraw || unite.candidates_pos == 0
    return []
  endif

  let unite = unite#get_current_unite()
  let candidates = unite.candidates[unite.candidates_pos :
        \ unite.candidates_pos + a:offset - 1]

  let unite.candidates_pos += len(candidates)

  return unite#init#_candidates(candidates)
endfunction"}}}

function! s:recache_candidates_loop(context, is_force) abort "{{{
  let unite = unite#get_current_unite()

  let input_len = unite#util#strchars(a:context.input)

  let candidate_sources = []
  let unite.max_source_candidates = 0
  for source in unite.sources
    " Set context.
    let context = source.unite__context
    let context.input = a:context.input
    let context.path = a:context.path
    let context.source_name = source.name

    " Check required pattern length.
    if input_len < source.required_pattern_length
          \ && !context.unite__is_vimfiler
      continue
    endif

    if source.required_pattern_length > 0
          \ && !source.is_forced
      " Forced redraw.
      let context.is_redraw = 1
      let source.is_forced = 1
    else
      let context.is_redraw = a:context.is_redraw
    endif
    let context.is_changed = a:context.is_changed
    let context.is_invalidate = source.unite__is_invalidate
    let context.is_list_input = a:context.is_list_input
    let context.input_list =
          \ unite#helper#get_input_list(context.input)
    let context.unite__max_candidates =
          \ (unite.disabled_max_candidates ? 0 : source.max_candidates)
    if context.unite__is_vimfiler
      " Disable ignore feature.
      let source.ignore_pattern = ''
      let source.ignore_globs = []
    endif

    " let start = reltime()
    let source_candidates = s:get_source_candidates(source)
    " echomsg string(reltimestr(reltime(start)))

    " Call pre_filter hook.
    let context.candidates = source_candidates
    call unite#helper#call_hook([source], 'on_pre_filter')

    " Restore current filters.
    if empty(unite.current_matchers)
      let unite.current_matchers = unite#util#convert2list(
            \ unite#custom#get_profile(unite.profile_name, 'matchers'))
    endif
    if empty(unite.current_sorters)
      let unite.current_sorters = unite#util#convert2list(
            \ unite#custom#get_profile(unite.profile_name, 'sorters'))
    endif
    if empty(unite.current_converters)
      let unite.current_converters = unite#util#convert2list(
            \ unite#custom#get_profile(unite.profile_name, 'converters'))
    endif

    " Set filters.
    let matchers = !empty(unite.current_matchers) ?
          \ unite.current_matchers : source.matchers
    let sorters = !empty(unite.current_sorters) ?
          \ unite.current_sorters : source.sorters
    let converters = !empty(unite.current_converters) ?
          \ unite.current_converters : source.converters
    if sorters ==# ['sorter_nothing']
          \ || unite.context.unite__is_vimfiler
      let sorters = []
    endif

    let context.unite__is_sort_nothing =
          \ empty(sorters) && context.unite__is_interactive
    let source.unite__orig_len_candidates = len(source_candidates)
    let unite.max_source_candidates +=
          \ (context.unite__is_sort_nothing
          \    && context.unite__max_candidates > 0) ?
          \ source.max_candidates : source.unite__orig_len_candidates

    if !unite.context.unite__is_vimfiler
      " Call filters.
      let source_candidates = unite#helper#call_source_filters(
            \ matchers + sorters + converters,
            \ source_candidates, context, source)
      if context.unite__max_candidates > 0
        let source_candidates = source_candidates[:
              \ context.unite__max_candidates - 1]
      endif
    endif

    " Get execute_command.
    let a:context.execute_command = context.execute_command

    let source.unite__candidates += source_candidates
    if !empty(source_candidates)
      call add(candidate_sources,
            \ unite#helper#convert_source_name(source.name))
    endif
  endfor

  if !a:context.hide_source_names
    let unite.max_source_name =
          \ max(map(candidate_sources, 'len(v:val)')) + 1
  endif
endfunction"}}}

function! s:get_source_candidates(source) abort "{{{
  let custom_source = get(unite#custom#get().sources, a:source.name, {})
  let context_ignore = {
        \ 'path' : a:source.unite__context.path,
        \ 'ignore_pattern' : get(custom_source,
        \    'ignore_pattern', a:source.ignore_pattern),
        \ 'ignore_globs' : get(custom_source,
        \    'ignore_globs', a:source.ignore_globs),
        \ 'white_globs' : get(custom_source,
        \    'white_globs', a:source.white_globs),
        \ }
  let context = extend(a:source.unite__context, context_ignore)

  let funcname = 's:get_source_candidates()'
  try
    if context.unite__is_vimfiler
      if context.vimfiler__is_dummy
        let funcname = 'vimfiler_dummy_candidates'
        return has_key(a:source, 'vimfiler_dummy_candidates') ?
              \ copy(a:source.vimfiler_dummy_candidates(
              \           a:source.args, a:source.unite__context)) : []
      else
        let funcname = 'vimfiler_gather_candidates'
        return has_key(a:source, 'vimfiler_gather_candidates') ?
              \ copy(a:source.vimfiler_gather_candidates(
              \           a:source.args, a:source.unite__context)) : []
      endif
    endif

    " Recaching.
    if (context.is_redraw || a:source.unite__is_invalidate)
          \ && (!has_key(a:source, 'async_gather_candidates')
          \     || has_key(a:source, 'gather_candidates'))
      " Note: If the source has not gather_candidates, the recaching is
      " disabled.

      let a:source.unite__cached_candidates = []

      let funcname = 'gather_candidates'
      if has_key(a:source, 'gather_candidates')
        let a:source.unite__cached_candidates +=
              \ unite#helper#ignore_candidates(copy(
              \  a:source.gather_candidates(a:source.args,
              \  a:source.unite__context)), context_ignore)
      endif
    endif

    if has_key(a:source, 'change_candidates')
          \ && (context.is_redraw || context.is_changed
          \     || a:source.unite__is_invalidate)
      " Recaching.
      let funcname = 'change_candidates'
      let a:source.unite__cached_change_candidates =
            \ unite#helper#ignore_candidates(a:source.change_candidates(
            \     a:source.args, a:source.unite__context), context_ignore)
    endif

    if a:source.unite__context.is_async
      " Get asynchronous candidates.
      let funcname = 'async_gather_candidates'
      while 1
        let a:source.unite__cached_candidates +=
              \ unite#helper#ignore_candidates(
              \  a:source.async_gather_candidates(a:source.args, context),
              \  context_ignore)

        if (!context.sync && context.unite__is_interactive)
              \ || !a:source.unite__context.is_async
          break
        endif
      endwhile
    endif
  catch
    call unite#print_error(v:throwpoint)
    call unite#print_error(v:exception)
    call unite#print_error(
          \ 'Error occurred in ' . funcname . '!')
    call unite#print_error(
          \ 'Source name is ' . a:source.name)

    return []
  endtry

  return a:source.unite__cached_candidates
        \ + a:source.unite__cached_change_candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
