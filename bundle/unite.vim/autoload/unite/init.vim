"=============================================================================
" FILE: init.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Global options definition. "{{{
let g:unite_force_overwrite_statusline =
      \ get(g:, 'unite_force_overwrite_statusline', 1)
let g:unite_ignore_source_files =
      \ get(g:, 'unite_ignore_source_files', [])
let g:unite_quick_match_table =
      \ get(g:, 'unite_quick_match_table', {
      \     'a' : 0, 's' : 1, 'd' : 2, 'f' : 3, 'g' : 4, 'h' : 5, 'j' : 6, 'k' : 7, 'l' : 8, ';' : 9,
      \     'q' : 10, 'w' : 11, 'e' : 12, 'r' : 13, 't' : 14, 'y' : 15, 'u' : 16, 'i' : 17, 'o' : 18, 'p' : 19,
      \     '1' : 20, '2' : 21, '3' : 22, '4' : 23, '5' : 24, '6' : 25, '7' : 26, '8' : 27, '9' : 28, '0' : 29,
      \ })
let g:unite_redraw_hold_candidates =
      \ get(g:, 'unite_redraw_hold_candidates',
      \     (unite#util#has_lua() ? 20000 : 10000))
let g:unite_enable_auto_select =
      \ get(g:, 'unite_enable_auto_select', 1)
let g:unite_restore_alternate_file =
      \ get(g:, 'unite_restore_alternate_file', 1)
"}}}

function! unite#init#_context(context, ...) abort "{{{
  let source_names = get(a:000, 0, [])

  let default_context = extend(copy(unite#variables#default_context()),
        \ unite#custom#get_context('default'))

  if len(source_names) == 1
    " Overwrite source context by profile.
    call extend(default_context, unite#custom#get_context(
          \ 'source/' . source_names[0]))
  endif

  if get(a:context, 'script', 0)
    " Set profile-name automatically.
    let a:context.profile_name = 'script/' . join(source_names, ':')
  endif
  let profile_name = get(a:context, 'profile_name',
        \    get(a:context, 'buffer_name', 'default'))
  if profile_name !=# 'default'
    " Overwrite context by profile.
    call extend(default_context, unite#custom#get_context(profile_name))
  endif

  " Generic no.
  for option in map(filter(items(a:context),
        \ "stridx(v:val[0], 'no_') == 0 && v:val[1]"), 'v:val[0]')
    let a:context[option[3:]] = 0
  endfor

  let context = extend(default_context, a:context)

  if context.temporary || context.script
    " User can overwrite context by profile context.
    let context = extend(context, unite#custom#get_context(profile_name))
  endif

  " Complex initializer.
  if context.complete
    let context.start_insert = 1
  endif
  if context.horizontal
    " Disable vertically.
    let context.vertical = 0
  endif
  if context.immediately
    " Ignore empty unite buffer.
    let context.empty = 0
  endif
  if context.tab
    let context.split = 0
  endif
  if context.here
    " Set direction.
    let context.horizontal = 1
    let context.direction = 'botright'
  endif
  if (!&l:hidden && &l:modified)
        \ || (&l:hidden && &l:bufhidden =~# 'unload\|delete\|wipe')
    " Split automatically.
    let context.split = 1
  endif
  if context.prompt_direction == ''
    let context.prompt_direction =
          \ (context.direction =~# 'bel\|bot')
          \  && !context.vertical && !context.log ? 'below' : 'top'
  endif
  if context.prompt_direction ==# 'below'
        \ && !get(context, 'no_auto_resize', 0)
    let context.auto_resize = 1
  endif
  if context.path != ''
    " Expand "~".
    let context.path = unite#util#expand(context.path)

    if context.path !~ '/$'
      let context.path .= '/'
    endif
  endif
  if len(source_names) == 1
        \ && !get(context, 'no_hide_source_names', 0)
    let context.hide_source_names = 1
  endif

  let context.is_changed = 0

  return context
endfunction"}}}

function! unite#init#_unite_buffer() abort "{{{
  let current_unite = unite#variables#current_unite()
  let is_bufexists = bufexists(current_unite.real_buffer_name)
  let current_unite.context.real_buffer_name =
        \ current_unite.real_buffer_name

  let context = current_unite.context

  if !context.temporary && context.tab
    tabnew
  endif

  call unite#view#_switch_unite_buffer(
        \ current_unite.buffer_name, context)

  let b:unite = current_unite
  let unite = unite#get_current_unite()

  let unite.bufnr = bufnr('%')
  let unite.prev_line = line('.')

  " Note: If unite buffer initialize is incomplete, &modified or &modifiable.
  if !is_bufexists || &modified || &modifiable
    " Basic settings.
    setlocal bufhidden=hide
    setlocal buftype=nofile
    setlocal nolist
    setlocal nobuflisted
    if has('cursorbind')
      setlocal nocursorbind
    endif
    setlocal noscrollbind
    setlocal noswapfile
    setlocal nospell
    setlocal noreadonly
    setlocal nofoldenable
    setlocal nomodeline
    setlocal nonumber
    setlocal foldcolumn=0
    setlocal iskeyword+=-,+,\\,!,~
    setlocal matchpairs-=<:>
    setlocal completefunc=unite#dummy_completefunc
    setlocal omnifunc=
    match
    if has('conceal')
      setlocal conceallevel=3
      setlocal concealcursor=niv
    endif
    if exists('+cursorcolumn')
      setlocal nocursorcolumn
    endif
    if exists('+colorcolumn')
      setlocal colorcolumn=0
    endif
    if exists('+relativenumber')
      setlocal norelativenumber
    endif

    if context.split
      if context.vertical
        setlocal winfixwidth
      else
        setlocal winfixheight
      endif
    endif

    " Autocommands.
    augroup plugin-unite
      autocmd! * <buffer>
      autocmd InsertEnter <buffer>
            \ call unite#handlers#_on_insert_enter()
      autocmd InsertLeave <buffer>
            \ call unite#handlers#_on_insert_leave()
      autocmd CursorMovedI <buffer>
            \ call unite#handlers#_on_cursor_moved_i()
      autocmd CursorMoved,CursorMovedI <buffer>  nested
            \ call unite#handlers#_on_cursor_moved()
      autocmd BufUnload,BufHidden <buffer>
            \ call unite#handlers#_on_buf_unload(expand('<afile>'))
      autocmd WinEnter,BufWinEnter <buffer>
            \ call unite#handlers#_on_bufwin_enter(bufnr(expand('<abuf>')))
    augroup END

    if v:version > 703 || v:version == 703 && has('patch418')
      " Enable auto narrow feature.
      autocmd plugin-unite InsertCharPre <buffer>
            \ call unite#handlers#_on_insert_char_pre()
    endif
    if v:version > 703 || v:version == 703 && has('patch867')
      " Enable auto narrow feature.
      autocmd plugin-unite TextChanged <buffer>
            \ call unite#handlers#_on_text_changed()
    endif
    if !unite#util#has_timers()
      autocmd plugin-unite CursorHoldI <buffer>
            \ call unite#handlers#_on_cursor_hold_i()
    else
      call unite#handlers#_init_timer()
    endif

    if context.prompt != ''
      execute printf(
            \ 'silent! sign define unite_prompt text=%s texthl=unitePrompt',
            \ unite.context.prompt)
    endif
  endif

  if context.wipe
    setlocal bufhidden=wipe
  endif

  call unite#mappings#define_default_mappings()

  let &l:wrap = context.wrap

  call unite#handlers#_save_updatetime()

  " User's initialization.
  setlocal nomodifiable
  set sidescrolloff=0
  setlocal nocursorline
  setfiletype unite
endfunction"}}}

function! unite#init#_current_unite(sources, context) abort "{{{
  let context = a:context

  " Overwrite previous unite buffer.
  if !context.create && !context.temporary
        \ && context.unite__is_interactive
    let winnr = unite#helper#get_unite_winnr(context.buffer_name)
    if winnr > 0
      execute winnr 'wincmd w'
    endif
  endif

  " The current buffer is initialized.
  let buffer_name = '[unite] - '
  let buffer_name .= context.buffer_name

  let winnr = winnr()
  let win_rest_cmd = winrestcmd()

  " Check sources.
  let sources = unite#init#_loaded_sources(a:sources, a:context)

  " Set parameters.
  let unite = {}
  let unite.winnr = winnr
  let unite.winmax = winnr('$')
  let unite.win_rest_cmd = (!context.unite__direct_switch) ?
        \ win_rest_cmd : ''
  let unite.context = context
  let unite.current_candidates = []
  let unite.sources = sources
  let unite.source_names = unite#helper#get_source_names(sources)
  let unite.buffer_name = (context.buffer_name == '') ?
        \ 'default' : context.buffer_name
  let unite.profile_name =
        \ (context.profile_name != '') ? context.profile_name :
        \ unite.buffer_name
  let unite.prev_bufnr =
        \ (exists('b:unite') && !context.split) ?
        \ b:unite.prev_bufnr : bufnr('%')
  let unite.prev_pos =
        \ exists('b:unite') ? b:unite.prev_pos : getpos('.')
  let unite.alternate_bufnr =
        \ exists('b:unite') ? b:unite.alternate_bufnr : bufnr('#')
  let unite.prev_winnr = winnr()
  let unite.prev_winsaveview = winsaveview()
  let unite.prev_line = 0
  let unite.update_time_save = &updatetime
  let unite.statusline = unite#view#_get_status_string(unite)
  let unite.original_context = deepcopy(a:context)

  " Create new buffer name.
  let postfix = unite#helper#get_postfix(
        \ buffer_name, unite.context.create)
  let unite.buffer_name .= postfix

  let unite.real_buffer_name = buffer_name . postfix
  let unite.input = context.input
  let unite.last_input = context.input
  let unite.last_path = context.path
  let unite.sidescrolloff_save = &sidescrolloff
  let unite.init_prompt_linenr = 1
  let unite.prompt_linenr =
        \ (!context.prompt_visible
        \  && context.input == '' && !context.start_insert) ?
        \ 0 : unite.init_prompt_linenr
  let unite.is_async =
        \ len(filter(copy(sources),
        \  'v:val.unite__context.is_async')) > 0
  let unite.access_time = localtime()
  let unite.is_finalized = 0
  let unite.previewed_buffer_list = []
  let unite.current_matchers = []
  let unite.current_sorters = []
  let unite.current_converters = []
  let unite.preview_candidate = {}
  let unite.highlight_candidate = {}
  let unite.max_source_name = 0
  let unite.candidates_pos = 0
  let unite.candidates = []
  let unite.candidates_len = 0
  let unite.candidate_cursor = -1
  let unite.max_source_candidates = 0
  let unite.is_multi_line = 0
  let unite.args = unite#helper#get_source_args(a:sources)
  let unite.msgs = []
  let unite.err_msgs = []
  let unite.redraw_hold_candidates = g:unite_redraw_hold_candidates
  let unite.disabled_max_candidates = 0
  let unite.cursor_line_time = reltime()
  let unite.sign_offset = 0
  let unite.is_initialized = 0

  if has('nvim') && exists(':UniteInitializePython')
    UniteInitializePython
  endif

  if context.here
    let context.winheight = winheight(0) - winline() + 1
    if context.winheight < 5
      let context.winheight = 5
    endif
  endif

  " Preview windows check.
  let unite.has_preview_window =
        \ exists('b:unite') ?
        \ b:unite.has_preview_window :
        \ len(filter(range(1, winnr('$')),
        \  'getwinvar(v:val, "&previewwindow")')) > 0

  call unite#set_current_unite(unite)
  call unite#set_context(context)

  if !context.unite__is_complete
    call unite#helper#call_hook(sources, 'on_init')
  endif
  let unite.is_initialized = 1

  return unite
endfunction"}}}

" @vimlint(EVL102, 1, l:max_source_name)
function! unite#init#_candidates(candidates) abort "{{{
  let unite = unite#get_current_unite()
  let context = unite.context
  let [max_width, max_source_name] = unite#helper#adjustments(
        \ winwidth(0), unite.max_source_name, 2)
  let is_multiline = 0

  let candidates = []
  for candidate in a:candidates
    let candidate.unite__abbr =
          \ get(candidate, 'abbr', candidate.word)

    " Delete too long abbr.
    if !&l:wrap && (candidate.is_multiline || context.multi_line)
      let candidate.unite__abbr =
            \ candidate.unite__abbr[: max_width *
            \  (context.max_multi_lines + 1)+10]
    elseif len(candidate.unite__abbr) > max_width * 2 && !context.wrap
      let candidate.unite__abbr =
            \ candidate.unite__abbr[: max_width * 2]
    endif

    " Substitute tab.
    if candidate.unite__abbr =~ '\t'
      let candidate.unite__abbr = substitute(
            \ candidate.unite__abbr, '\t',
            \ repeat(' ', &tabstop), 'g')
    endif

    if context.wrap || (!candidate.is_multiline && !context.multi_line)
      call add(candidates, candidate)
      continue
    endif

    if candidate.unite__abbr !~ '\n'
      " Auto split.
      let abbr = candidate.unite__abbr
      let candidate.unite__abbr = ''

      while abbr != ''
        let trunc_abbr = unite#util#strwidthpart(
              \ abbr, max_width)
        let candidate.unite__abbr .= trunc_abbr . "~\n"
        let abbr = abbr[len(trunc_abbr):]
      endwhile

      let candidate.unite__abbr =
            \ substitute(candidate.unite__abbr,
            \    '\~\n$', '', '')
    else
      let candidate.unite__abbr =
            \ substitute(candidate.unite__abbr,
            \    '\r\?\n$', '^@', '')
    endif

    if candidate.unite__abbr !~ '\n'
      let candidate.is_multiline = 0
      call add(candidates, candidate)
      continue
    endif

    " Convert multi line.
    let cnt = 0
    for multi in split(
          \ candidate.unite__abbr, '\r\?\n', 1)[:
          \   context.max_multi_lines-1]
      let candidate_multi = (cnt != 0) ?
            \ deepcopy(candidate) : candidate
      let candidate_multi.unite__abbr = multi

      if cnt != 0
        let candidate_multi.is_dummy = 1
      endif

      let is_multiline = 1
      call add(candidates, candidate_multi)

      let cnt += 1
    endfor
  endfor

  " Multiline check.
  if is_multiline || context.multi_line
    let unite.is_multi_line = 1
  endif

  return candidates
endfunction"}}}
" @vimlint(EVL102, 0, l:max_source_name)

function! unite#init#_candidates_source(candidates, source_name) abort "{{{
  let source = unite#variables#loaded_sources(a:source_name)
  if empty(source)
    return []
  endif

  let default_candidate = {
        \ 'kind' : source.default_kind,
        \ 'is_dummy' : 0,
        \ 'is_matched' : 1,
        \ 'is_multiline' : 0,
        \ 'unite__is_marked' : 0,
        \ }

  let candidates = []
  for candidate in a:candidates
    let candidate = extend(candidate, default_candidate, 'keep')
    let candidate.source = a:source_name

    call add(candidates, candidate)
  endfor

  return candidates
endfunction"}}}

function! unite#init#_default_scripts(kind, names) abort "{{{
  let names = empty(a:names) ? [''] : a:names
  if a:kind ==# 'sources' && !empty(a:names)
    call add(names, 'alias')
  endif

  let loaded_defaults = unite#variables#loaded_defaults()

  if get(loaded_defaults, a:kind, '') ==# &runtimepath
    return
  endif

  let static = unite#variables#static()

  for name in names
    if name != '' && has_key(static[a:kind], name)
          \ || (a:kind ==# 'sources' && name ==# 'alias' &&
          \     has_key(loaded_defaults, 'alias'))
      continue
    endif

    if name == ''
      let loaded_defaults[a:kind] = &runtimepath
    elseif a:kind ==# 'sources' && name ==# 'alias'
      let loaded_defaults.alias = 1
    endif

    " Search files by prefix or postfix.
    if a:kind ==# 'filters'
      let prefix_name = substitute(name,
            \'^\%(matcher\|sorter\|converter\)_[^/_-]\+\zs[/_-].*$', '', '')
      let postfix_name = ''
      let postfix_name2 = ''
    else
      let prefix_name = matchstr(name, '^[^/_-]\+')
      let postfix_name = matchstr(name, '[^/_-]\+$')
      let postfix_name2 = matchstr(name, '^[^/_-]\+[/_-]\+\zs[^/_-]\+')
    endif

    let files = []
    for prefix in filter(unite#util#uniq([
          \ prefix_name, postfix_name, postfix_name2]),
          \ "name == '' || v:val != ''")
      let files += split(globpath(&runtimepath,
            \ 'autoload/unite/'.a:kind.'/'.prefix.'*.vim', 1), '\n')
    endfor

    if a:kind == 'sources'
      call filter(files, "index(g:unite_ignore_source_files,
            \ fnamemodify(v:val, ':t')) < 0")
    endif

    try
      for file in files
        let define = unite#{a:kind}#{fnamemodify(file, ':t:r')}#define()
        for dict in filter(unite#util#convert2list(define),
              \ '!empty(v:val) && !has_key(static[a:kind], v:val.name)')
          let static[a:kind][dict.name] = dict
        endfor
        unlet define
      endfor
    catch
      call unite#print_error(v:throwpoint)
      call unite#print_error(v:exception)
      call unite#print_error(
            \ 'Error occurred in source initialization!')
      call unite#print_error(
            \ 'Source name is ' . file)
    endtry
  endfor
endfunction"}}}

function! unite#init#_kinds() abort "{{{
  let kinds = extend(copy(unite#variables#static().kinds),
        \ unite#variables#dynamic().kinds)
  for kind in values(filter(copy(kinds),
        \ '!has_key(v:val, "is_initialized")'))
    let kind.is_initialized = 1
    if !has_key(kind, 'action_table')
      let kind.action_table = {}
    endif
    if !has_key(kind, 'alias_table')
      let kind.alias_table = {}
    endif
    if !has_key(kind, 'parents')
      let kind.parents = ['common']
    endif
  endfor

  return kinds
endfunction"}}}
function! unite#init#_filters() abort "{{{
  return extend(copy(unite#variables#static().filters),
        \ unite#variables#dynamic().filters)
endfunction"}}}

function! unite#init#_loaded_sources(sources, context) abort "{{{
  let all_sources = unite#init#_sources(
        \ unite#helper#get_source_names(a:sources))
  let sources = []

  let number = 0
  for [source, args] in unite#helper#get_source_args(a:sources)
    if type(source) == type('')
      let source_name = source
      unlet source
      if !has_key(all_sources, source_name)
        if a:context.unite__is_vimfiler || a:context.unite__is_complete
          " Ignore error.
          continue
        endif

        if source_name =~ '^-'
          call unite#util#print_error(
                \ 'Invalid option "' .
                \ source_name . '" is detected.')
          throw 'unite.vim: Invalid option'
        else
          call unite#util#print_error(
                \ 'Invalid source name "' .
                \ source_name . '" is detected.')
          if source_name ==# 'file_mru' || source_name ==# 'directory_mru'
            call unite#util#print_error(
                  \ 'To use MRU features, you must install neomru from ' .
                  \ 'https://github.com/Shougo/neomru.vim.')
          endif
          throw 'unite.vim: Invalid source'
        endif
      endif

      let source = deepcopy(all_sources[source_name])
    else
      " Use source dictionary.
      call unite#init#_sources(source)
    endif

    let source.args = args
    let source.unite__is_invalidate = 1

    let source.unite__context = deepcopy(a:context)
    let source.unite__context.is_async =
          \ has_key(source, 'async_gather_candidates')
    let source.unite__context.source = source
    let source.unite__candidates = []
    let source.unite__cached_candidates = []
    let source.unite__cached_change_candidates = []
    let source.unite__number = number
    let number += 1

    call add(sources, source)

    unlet source
  endfor

  return sources
endfunction"}}}

function! unite#init#_sources(...) abort "{{{
  " args: source_names or source_definition

  " Initialize load.
  if type(get(a:000, 0, [])) != type({})
    let source_names = type(get(a:000, 0, [])) == type([]) ?
          \ get(a:000, 0, []) : []
    let head_name = get(a:000, 1, '')
    if empty(source_names) && head_name != ''
      let source_names = [head_name]
    endif
    call unite#init#_default_scripts('sources', source_names)
  endif

  let default_source = {
        \ 'is_volatile' : 0,
        \ 'is_listed' : 1,
        \ 'is_forced' : 0,
        \ 'action_table' : {},
        \ 'default_action' : {},
        \ 'default_kind' : 'common',
        \ 'alias_table' : {},
        \ 'parents' : [],
        \ 'description' : '',
        \ 'syntax' : '',
        \ }

  let sources = {}
  let sources = extend(sources,
        \ unite#variables#static().sources)
  let sources = extend(sources,
        \ unite#variables#dynamic().sources)
  if type(get(a:000, 0, [])) == type({})
    let sources[a:1.name] = a:1
  endif

  let custom = unite#custom#get()

  for source in type(sources) == type([]) ?
        \ sources : values(sources)
    try
      if !get(source, 'is_initialized', 0)
        let source.is_initialized = 1

        if !has_key(source, 'hooks')
          let source.hooks = {}
        elseif has_key(source.hooks, 'on_pre_init')
          " Call pre_init hook.

          " Set dummy value.
          let source.args = []
          let source.unite__context = { 'source' : source }

          " Overwrite source values.
          call unite#helper#call_hook([source], 'on_pre_init')
        endif

        let source = extend(source, default_source, 'keep')
        if source.syntax == ''
          " Set default syntax.
          let source.syntax = 'uniteSource__' .
                \ substitute(substitute(source.name,
                \   '\%(^\|[^[:alnum:]]\+\)\zs[[:alnum:]]',
                \   '\u\0', 'g'), '[^[:alnum:]]', '', 'g')
        endif

        if !empty(source.action_table)
          let action = values(source.action_table)[0]

          " Check if '*' action_table?
          if has_key(action, 'func')
                \ && type(action.func) == type(function('type'))
            " Syntax sugar.
            let source.action_table = { '*' : source.action_table }
          endif
        endif

        if type(source.default_action) == type('')
          " Syntax sugar.
          let source.default_action = { '*' : source.default_action }
        endif

        if !empty(source.alias_table)
          " Check if '*' alias_table?
          if type(values(source.alias_table)[0]) == type('')
            " Syntax sugar.
            let source.alias_table = { '*' : source.alias_table }
          endif
        endif
        if source.is_volatile
              \ && !has_key(source, 'change_candidates')
          let source.change_candidates = source.gather_candidates
          call remove(source, 'gather_candidates')
        endif
      endif

      " For custom sources.
      let custom_source = get(custom.sources, source.name, {})

      " Set filters.
      if has_key(custom_source, 'filters')
        call unite#print_error(
              \ 'Custom filters feature is removed.'.
              \ '  You must use matchers/sorters/converters feature.')
      endif

      let source.matchers = unite#util#convert2list(
            \ get(custom_source, 'matchers',
            \   get(source, 'matchers', 'matcher_default')))
      let source.sorters = unite#util#convert2list(
            \ get(custom_source, 'sorters',
            \   get(source, 'sorters', 'sorter_default')))
      let source.converters = unite#util#convert2list(
            \ get(custom_source, 'converters',
            \   get(source, 'converters', 'converter_default')))

      let source.max_candidates =
            \ get(custom_source, 'max_candidates',
            \    get(source, 'max_candidates', 0))
      let source.ignore_pattern =
            \ get(custom_source, 'ignore_pattern',
            \    get(source, 'ignore_pattern', ''))
      let source.ignore_globs = unite#util#convert2list(
            \ get(custom_source, 'ignore_globs',
            \    get(source, 'ignore_globs', [])))
      let source.white_globs = unite#util#convert2list(
            \ get(custom_source, 'white_globs',
            \    get(source, 'white_globs', [])))
      let source.syntax = get(custom_source, 'syntax',
            \    get(source, 'syntax', ''))
      let source.required_pattern_length =
            \ get(custom_source, 'required_pattern_length',
            \    get(source, 'required_pattern_length', 0))

      let source.unite__len_candidates = 0
      let source.unite__orig_len_candidates = 0
      let source.unite__candidates = []
    catch
      call unite#print_error(v:throwpoint)
      call unite#print_error(v:exception)
      call unite#print_error(
            \ 'Error occurred in source initialization!')
      call unite#print_error(
            \ 'Source name is ' . source.name)
    endtry
  endfor

  return sources
endfunction"}}}

function! unite#init#_tab_variables() abort "{{{
  if !exists('t:unite')
    let t:unite = { 'last_unite_bufnr' : -1 }
  endif
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
