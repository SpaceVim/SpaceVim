"=============================================================================
" FILE: start.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#start#standard(sources, ...) abort "{{{
  " Check command line window.
  if unite#util#is_cmdwin()
    call unite#print_error(
          \ 'Command line buffer is detected! '.
          \ 'Please close command line buffer.')
    return
  endif

  let context = get(a:000, 0, {})
  let context = unite#init#_context(context,
        \ unite#helper#get_source_names(a:sources))

  if context.resume
    " Check resume buffer.
    let resume_bufnr = s:get_resume_buffer(context.buffer_name)
    if resume_bufnr > 0 &&
          \ getbufvar(resume_bufnr, 'unite').source_names ==#
          \    unite#helper#get_source_names(a:sources)
      return unite#start#resume(context.buffer_name, get(a:000, 0, {}))
    endif
  endif

  call unite#variables#enable_current_unite()

  if context.toggle "{{{
    if unite#view#_close(context.buffer_name)
      return
    endif
  endif"}}}

  if empty(a:sources)
    echohl Comment
    call unite#view#_redraw_echo(
          \ '[unite.vim] interactive mode: Please input source name')
    echohl None
  endif

  try
    call unite#init#_current_unite(a:sources, context)
  catch /^unite.vim: Invalid /
    call unite#print_error(v:exception)
    return
  endtry

  " Caching.
  let current_unite = unite#variables#current_unite()
  let current_unite.last_input = context.input
  let current_unite.input = context.input
  let current_unite.last_path = context.path
  call unite#candidates#_recache(context.input, context.is_redraw)

  if !context.buffer
    call unite#variables#disable_current_unite()
    return
  endif

  if !current_unite.is_async &&
        \ (context.force_immediately
        \ || context.immediately || !context.empty) "{{{
    let candidates = unite#candidates#gather()

    if empty(candidates)
      " Ignore.
      call unite#view#_print_warning(
            \ 'unite buffer "'
            \ . current_unite.buffer_name.'" candidates are empty')
      call unite#variables#disable_current_unite()
      return
    elseif (context.immediately && len(candidates) == 1)
          \ || context.force_immediately
      " Immediately action.
      call unite#action#do(
            \ context.default_action, [candidates[0]])
      call unite#variables#disable_current_unite()
      return
    endif
  endif"}}}

  call unite#init#_unite_buffer()

  call unite#variables#disable_current_unite()

  setlocal modifiable

  if context.force_redraw
    call unite#force_redraw()
  else
    call unite#view#_redraw_candidates()
  endif

  call unite#handlers#_on_bufwin_enter(bufnr('%'))

  call unite#view#_init_cursor()
endfunction"}}}

function! unite#start#script(sources, ...) abort "{{{
  " Start unite from script.

  let context = get(a:000, 0, {})

  let context.script = 1

  return &filetype == 'unite' ?
        \ unite#start#temporary(a:sources, context) :
        \ unite#start#standard(a:sources, context)
endfunction"}}}

function! unite#start#temporary(sources, ...) abort "{{{
  " Get current context.
  let old_context = unite#get_context()
  let unite = unite#get_current_unite()

  if !empty(unite) && !empty(old_context)
    let context = deepcopy(old_context)
    let context.unite__old_buffer_info = insert(context.unite__old_buffer_info, {
          \ 'buffer_name' : unite.buffer_name,
          \ 'pos' : getpos('.'),
          \ 'profile_name' : unite.profile_name,
          \ })

    if unite.context.unite__is_manual
      call unite#sources#history_unite#add(unite)
    endif
  else
    let context = {}
    let context = unite#init#_context(context,
          \ unite#helper#get_source_names(a:sources))
    let context.unite__old_buffer_info = []
  endif

  let context.input = ''
  let context.path = ''

  let new_context = get(a:000, 0, {})

  " Overwrite context.
  let context = extend(context, new_context)

  let context.temporary = 1
  let context.unite__direct_switch = 1
  let context.auto_preview = 0
  let context.auto_highlight = 0
  let context.unite__is_vimfiler = 0
  let context.unite__old_winwidth = 0
  let context.unite__old_winheight = 0
  let context.unite__is_resize = 0
  let context.quick_match = 0
  let context.resume = 0
  let context.force_redraw = 0

  if context.script
    " Set buffer-name automatically.
    let context.buffer_name =
          \ join(unite#helper#get_source_names(a:sources))
  endif

  let buffer_name = get(a:000, 1,
        \ substitute(context.buffer_name, '-\d\+$', '', '')
        \ . '-' . len(context.unite__old_buffer_info))

  let context.buffer_name = buffer_name

  let unite_save = unite#get_current_unite()

  let cwd = getcwd()

  call unite#start#standard(a:sources, context)

  " Overwrite unite.
  let unite = unite#get_current_unite()
  let unite.prev_bufnr = unite_save.prev_bufnr
  let unite.prev_winnr = unite_save.prev_winnr
  let unite.args = a:sources
  if has_key(unite, 'update_time_save')
    let unite.update_time_save = unite_save.update_time_save
  endif
  let unite.winnr = unite_save.winnr
  let unite.has_preview_window = unite_save.has_preview_window
  let unite.prev_winsaveview = unite_save.prev_winsaveview
  let unite.win_rest_cmd = unite_save.win_rest_cmd

  " Restore current directory.
  execute 'lcd' fnameescape(cwd)
endfunction"}}}

function! unite#start#vimfiler_check_filetype(sources, ...) abort "{{{
  let context = get(a:000, 0, {})
  let context = unite#init#_context(context,
        \ unite#helper#get_source_names(a:sources))
  let context.unite__is_vimfiler = 1
  let context.unite__is_interactive = 0
  if !has_key(context, 'vimfiler__is_dummy')
    let context.vimfiler__is_dummy = 0
  endif

  try
    call unite#init#_current_unite(a:sources, context)
  catch /^unite.vim: Invalid /
    return []
  endtry

  for source in filter(copy(unite#loaded_sources_list()),
        \ "has_key(v:val, 'vimfiler_check_filetype')")
    let ret = source.vimfiler_check_filetype(source.args, context)
    if empty(ret)
      continue
    endif

    let [type, info] = ret
    if type ==# 'file'
      call unite#init#_candidates_source([info[1]], source.name)
    elseif type ==# 'directory'
      " nop
    elseif type ==# 'error'
      call unite#print_error(info)
      return []
    else
      call unite#print_error('Invalid filetype : ' . type)
    endif

    return [type, info]
  endfor

  " Not found.
  return []
endfunction"}}}

function! unite#start#get_candidates(sources, ...) abort "{{{
  let unite_save = unite#get_current_unite()

  try
    let context = get(a:000, 0, {})
    let context = unite#init#_context(context,
          \ unite#helper#get_source_names(a:sources))
    let context.buffer = 0
    let context.unite__is_interactive = 0

    " Finalize.
    let candidates = s:get_candidates(a:sources, context)

    " Call finalize functions.
    call unite#helper#call_hook(unite#loaded_sources_list(), 'on_close')
    let unite = unite#get_current_unite()
    let unite.is_finalized = 1
  finally
    call unite#set_current_unite(unite_save)
  endtry

  return candidates
endfunction"}}}

function! unite#start#get_vimfiler_candidates(sources, ...) abort "{{{
  let unite_save = unite#get_current_unite()

  try
    let context = get(a:000, 0, {})
    let context = unite#init#_context(context,
          \ unite#helper#get_source_names(a:sources))
    let context.unite__not_buffer = 1
    let context.unite__is_vimfiler = 1
    let context.unite__is_interactive = 0
    if !has_key(context, 'vimfiler__is_dummy')
      let context.vimfiler__is_dummy = 0
    endif

    let candidates = s:get_candidates(a:sources, context)

    " Converts utf-8-mac to the current encoding.
    if unite#util#is_mac() && has('iconv')
      for item in filter(copy(candidates),
            \ "v:val.action__path =~# '[^\\x00-\\x7f]'")
        let item.action__path = unite#util#iconv(
              \ item.action__path, 'utf-8-mac', &encoding)
        let item.word = unite#util#iconv(item.word, 'utf-8-mac', &encoding)
        let item.abbr = unite#util#iconv(item.abbr, 'utf-8-mac', &encoding)
        let item.vimfiler__filename = unite#util#iconv(
              \ item.vimfiler__filename, 'utf-8-mac', &encoding)
        let item.vimfiler__abbr = unite#util#iconv(
              \ item.vimfiler__abbr, 'utf-8-mac', &encoding)
      endfor
    endif
  finally
    call unite#set_current_unite(unite_save)
  endtry

  return candidates
endfunction"}}}

function! unite#start#resume(buffer_name, ...) abort "{{{
  " Check command line window.
  if unite#util#is_cmdwin()
    call unite#print_error(
          \ 'Command line buffer is detected! '.
          \ 'Please close command line buffer.')
    return
  endif

  let bufnr = s:get_unite_buffer(a:buffer_name)
  if bufnr < 0
    return
  endif

  let context = getbufvar(bufnr, 'unite').context

  let prev_bufnr = bufnr('%')
  let winnr = winnr()
  let prev_winsaveview = winsaveview()
  let win_rest_cmd = context.unite__direct_switch ||
        \ unite#helper#get_unite_winnr(context.buffer_name) > 0 ?
        \ '' : winrestcmd()

  let new_context = get(a:000, 0, {})
  " Generic no.
  for option in map(filter(items(new_context),
        \ "stridx(v:val[0], 'no_') == 0 && v:val[1]"), "v:val[0]")
    let new_context[option[3:]] = 0
  endfor
  call extend(context, new_context)

  call unite#view#_switch_unite_buffer(context.buffer_name, context)

  " Set parameters.
  let unite = b:unite
  let unite.winnr = winnr
  let unite.prev_bufnr = prev_bufnr
  let unite.prev_winnr = winnr
  let unite.prev_winsaveview = prev_winsaveview
  if !context.unite__direct_switch
    let unite.win_rest_cmd = win_rest_cmd
  endif
  let unite.access_time = localtime()
  let unite.context = context
  let unite.is_finalized = 0
  let unite.preview_candidate = {}
  let unite.highlight_candidate = {}
  let unite.context.resume = 1
  let unite.context.buffer_name =
        \ (a:buffer_name == '' ? 'default' : a:buffer_name)
  if context.winwidth != 0
    let unite.context.unite__old_winwidth = 0
  endif
  if context.winheight != 0
    let unite.context.unite__old_winheight = 0
  endif

  call unite#set_current_unite(unite)

  if context.force_redraw
    call unite#force_redraw()
  endif

  if has_key(new_context, 'input')
    call unite#mappings#narrowing(new_context.input)
    call unite#redraw()
  endif

  call unite#view#_resize_window()
  call unite#view#_init_cursor()
endfunction"}}}

function! unite#start#resume_from_temporary(context) abort  "{{{
  if empty(a:context.unite__old_buffer_info)
    return
  endif

  call unite#handlers#_on_buf_unload(a:context.buffer_name)

  let unite_save = unite#get_current_unite()

  " Resume unite buffer.
  let buffer_info = a:context.unite__old_buffer_info[0]
  call unite#start#resume(buffer_info.buffer_name,
        \ {'unite__direct_switch' : 1})
  let a:context.unite__old_buffer_info = a:context.unite__old_buffer_info[1:]

  " Overwrite unite.
  let unite = unite#get_current_unite()
  let unite.prev_bufnr = unite_save.prev_bufnr
  let unite.prev_winnr = unite_save.prev_winnr

  " Restore the previous position
  call setpos('.', buffer_info.pos)
  if line('.') == unite.prompt_linenr && unite.context.start_insert
    startinsert!
  endif

  call unite#redraw()
endfunction"}}}

function! unite#start#complete(sources, ...) abort "{{{
  let sources = type(a:sources) == type('') ?
        \ [a:sources] : a:sources
  let context = {
        \ 'col' : col('.'), 'complete' : 1,
        \ 'direction' : 'rightbelow',
        \ 'buffer_name' : 'completion',
        \ 'profile_name' : 'completion',
        \ 'here' : 1,
        \ }
  call extend(context, get(a:000, 0, {}))

  return printf("\<C-o>:\<C-u>call unite#start(%s, %s)\<CR>",
        \  string(sources), string(context))
endfunction "}}}

function! unite#start#_pos(buffer_name, direction, count) abort "{{{
  let bufnr = s:get_unite_buffer(a:buffer_name)
  if bufnr < 0
    return
  endif

  let unite = getbufvar(bufnr, 'unite')

  let next =
        \ (a:direction ==# 'first') ? 0 :
        \ (a:direction ==# 'last') ? len(unite.candidates)-1 :
        \ (a:direction ==# 'next') ? unite.candidate_cursor+a:count :
        \ unite.candidate_cursor-a:count
  if next < 0 || next >= len(unite.candidates)
    " Ignore.
    call unite#view#_print_error('No more items')
    return
  endif

  let candidate = unite.candidates[next]

  " Immediately action.
  silent call unite#action#do_candidates(
        \ unite.context.default_action, [candidate],
        \ unite.context, unite.sources)

  let unite.candidate_cursor = next

  call unite#view#_redraw_echo(printf('[%d/%d] %s',
        \ unite.candidate_cursor+1, len(unite.candidates),
        \ get(candidate, 'abbr', candidate.word)))

  let winnr = unite#helper#get_unite_winnr(unite.context.buffer_name)
  if winnr < 0
    return
  endif

  " Move cursor
  let prev_winnr = winnr()
  try
    execute winnr . 'wincmd w'
    call cursor(unite#helper#get_current_candidate_linenr(next), 0)
    call unite#view#_set_cursor_line()
    call unite#view#_save_position()
  finally
    execute prev_winnr . 'wincmd w'
  endtry
endfunction"}}}

function! unite#start#_do_command(cmd)
  let bufnr = s:get_unite_buffer('')
  if bufnr < 0
    return
  endif

  let unite = getbufvar(bufnr, 'unite')
  if empty(unite.candidates)
    return
  endif

  " The step by step is done backwards because, if the command happens to
  " include or exclude lines in the file, the remaining candidates don't have
  " its position changed when the default action is applied.

  silent! UniteLast
  silent! execute a:cmd
  while unite.candidate_cursor > 0
    silent! UnitePrevious
    silent! execute a:cmd
  endwhile
endfunction

function! s:get_candidates(sources, context) abort "{{{
  try
    let current_unite = unite#init#_current_unite(a:sources, a:context)
  catch /^unite.vim: Invalid /
    return []
  endtry

  " Caching.
  let current_unite.last_input = a:context.input
  let current_unite.input = a:context.input
  let current_unite.last_path = a:context.path
  call unite#set_current_unite(current_unite)
  call unite#set_context(a:context)

  call unite#variables#enable_current_unite()

  call unite#candidates#_recache(a:context.input, a:context.is_redraw)

  let candidates = []
  for source in current_unite.sources
    if !empty(source.unite__candidates)
      let candidates += source.unite__candidates
    endif
  endfor

  return candidates
endfunction"}}}

function! s:get_unite_buffer(buffer_name) abort "{{{
  if a:buffer_name == ''
    " Use last unite buffer.
    if !exists('t:unite') ||
          \ !bufexists(t:unite.last_unite_bufnr)
      call unite#util#print_error('No unite buffer.')
      return -1
    endif

    let bufnr = t:unite.last_unite_bufnr
  else
    let bufnr = s:get_resume_buffer(a:buffer_name)
  endif

  if bufnr > 0 && type(getbufvar(bufnr, 'unite')) != type({})
    " Unite buffer is released.
    call unite#util#print_error(
          \ printf('Invalid unite buffer(%d) is detected.', bufnr))
    return -1
  endif

  return bufnr
endfunction"}}}
function! s:get_resume_buffer(buffer_name) abort "{{{
  let buffer_name = a:buffer_name
  if buffer_name !~ '@\d\+$'
    " Add postfix.
    let prefix = '[unite] - '
    let prefix .= buffer_name
    let buffer_name .= unite#helper#get_postfix(prefix, 0)
  endif

  let buffer_dict = {}
  for unite in map(filter(range(1, bufnr('$')),
        \ "getbufvar(v:val, '&filetype') ==# 'unite' &&
        \  type(getbufvar(v:val, 'unite')) == type({})"),
        \ "getbufvar(v:val, 'unite')")
    let buffer_dict[unite.buffer_name] = unite.bufnr
  endfor

  return get(buffer_dict, buffer_name, -1)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
