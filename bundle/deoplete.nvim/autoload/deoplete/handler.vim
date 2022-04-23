"=============================================================================
" FILE: handler.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! deoplete#handler#_init() abort
  augroup deoplete
    autocmd!
    autocmd InsertLeave * call s:on_insert_leave()
    autocmd CompleteDone * call s:on_complete_done()
  augroup END

  for event in [
        \ 'InsertEnter', 'InsertLeave',
        \ 'BufReadPost', 'BufWritePost',
        \ 'VimLeavePre', 'FileType',
        \ ]
    call s:define_on_event(event)
  endfor

  if deoplete#custom#_get_option('on_text_changed_i')
    call s:define_completion_via_timer('TextChangedI')
  endif
  if deoplete#custom#_get_option('on_insert_enter')
    call s:define_completion_via_timer('InsertEnter')
  endif
  if deoplete#custom#_get_option('refresh_always')
    call s:define_completion_via_timer('TextChangedP')
  endif

  " Note: Vim 8 GUI(MacVim and Win32) is broken
  " dummy timer call is needed before complete()
  if !has('nvim') && has('gui_running')
        \ && (has('gui_macvim') || has('win32'))
    let s:dummy_timer = timer_start(200, {timer -> 0}, {'repeat': -1})
  endif

  if deoplete#util#has_yarp()
    " To fix "RuntimeError: Event loop is closed" issue
    " Note: Workaround
    autocmd deoplete VimLeavePre * call s:kill_yarp()
  endif
endfunction

function! deoplete#handler#_do_complete() abort
  let context = g:deoplete#_context
  let event = get(context, 'event', '')
  if s:is_exiting() || v:insertmode !=# 'i' || s:check_input_method()
        \ || !has_key(context, 'candidates')
    return
  endif

  let prev = g:deoplete#_prev_completion
  let prev.event = context.event
  let prev.input = context.input
  let prev.candidates = context.candidates
  let prev.complete_position = context.complete_position
  let prev.linenr = line('.')
  let prev.time = context.time

  if context.event ==# 'Manual'
    let context.event = ''
  endif

  let auto_popup = deoplete#custom#_get_option(
        \ 'auto_complete_popup') !=# 'manual'

  " Enable auto refresh when popup is displayed
  if deoplete#util#check_popup()
    let auto_popup = v:true
  endif

  if auto_popup
    " Note: completeopt must be changed before complete() and feedkeys()
    call deoplete#mapping#_set_completeopt(g:deoplete#_context.is_async)

    call feedkeys("\<Plug>_", 'i')
  endif
endfunction

function! deoplete#handler#_check_omnifunc(context) abort
  let prev = g:deoplete#_prev_completion
  let blacklist = ['LanguageClient#complete']
  if a:context.event ==# 'Manual'
        \ || &l:omnifunc ==# ''
        \ || index(blacklist, &l:omnifunc) >= 0
        \ || prev.input ==# a:context.input
        \ || s:check_input_method()
        \ || deoplete#custom#_get_option('auto_complete_popup') ==# 'manual'
    return
  endif

  for filetype in a:context.filetypes
    for pattern in deoplete#util#convert2list(
          \ deoplete#custom#_get_filetype_option(
          \   'omni_patterns', filetype, ''))
      if pattern !=# '' && a:context.input =~# '\%('.pattern.'\)$'
        let g:deoplete#_context.candidates = []

        let prev.event = a:context.event
        let prev.input = a:context.input
        let prev.candidates = []

        call deoplete#mapping#_set_completeopt(v:true)
        call feedkeys("\<C-x>\<C-o>", 'in')
      endif
    endfor
  endfor
endfunction

function! s:completion_timer_start(event) abort
  if exists('s:completion_timer')
    call s:completion_timer_stop()
  endif

  let delay = deoplete#custom#_get_option('auto_complete_delay')
  if delay > 0
    let s:completion_timer = timer_start(
          \ delay, {-> deoplete#handler#_completion_begin(a:event)})
  else
    call deoplete#handler#_completion_begin(a:event)
  endif
endfunction
function! s:completion_timer_stop() abort
  if !exists('s:completion_timer')
    return
  endif

  call timer_stop(s:completion_timer)
  unlet s:completion_timer
endfunction

function! deoplete#handler#_check_prev_completion(event) abort
  let prev = g:deoplete#_prev_completion
  if a:event ==# 'Async' || a:event ==# 'Update' || mode() !=# 'i'
        \ || empty(get(prev, 'candidates', []))
        \ || s:check_input_method()
    return
  endif

  let input = deoplete#util#get_input(a:event)
  let complete_str = matchstr(input, '\w\+$')
  let min_pattern_length = deoplete#custom#_get_option('min_pattern_length')
  if prev.linenr != line('.') || len(complete_str) < min_pattern_length
    return
  endif

  let mode = deoplete#custom#_get_option('prev_completion_mode')
  let candidates = copy(prev.candidates)

  if mode ==# 'filter' || mode ==# 'length'
    let input = input[prev.complete_position :]
    let escaped_input = escape(input, '~\.^$[]*')
    let pattern = substitute(escaped_input, '\w', '\\w*\0', 'g')
    call filter(candidates, { _, val -> val.word =~? pattern })
    if mode ==# 'length'
      call filter(candidates, { _, val -> len(val.word) > len(input) })
    endif
  elseif mode ==# 'mirror'
    " pass
  else
    return
  endif

  let g:deoplete#_filtered_prev = {
        \ 'complete_position': prev.complete_position,
        \ 'candidates': candidates,
        \ }
  return 1
endfunction

function! deoplete#handler#_async_timer_start() abort
  let delay = deoplete#custom#_get_option('auto_refresh_delay')
  if delay <= 0
    return
  endif

  call timer_start(max([20, delay]), {-> deoplete#auto_complete()})
endfunction

function! deoplete#handler#_completion_begin(event) abort
  call deoplete#custom#_update_cache()

  let auto_popup = deoplete#custom#_get_option(
        \ 'auto_complete_popup') !=# 'manual'
  let prev_input = get(g:deoplete#_context, 'input', '')
  let cur_input = deoplete#util#get_input(a:event)

  let check_back_space = auto_popup
        \ && cur_input !=# prev_input
        \ && len(cur_input) + 1 ==# len(prev_input)
        \ && stridx(prev_input, cur_input) == 0
  let refresh_backspace = deoplete#custom#_get_option('refresh_backspace')

  if s:is_skip(a:event) || (check_back_space && !refresh_backspace)
    let g:deoplete#_context.candidates = []
    let g:deoplete#_context.input = cur_input
    return
  endif

  if auto_popup && deoplete#handler#_check_prev_completion(a:event)
    call feedkeys("\<Plug>+", 'i')
  endif

  if a:event !=# 'Update' && a:event !=# 'Async'
    call deoplete#init#_prev_completion()
  endif

  call deoplete#util#rpcnotify(
        \ 'deoplete_auto_completion_begin', {'event': a:event})

  " For <BS> popup flicker
  if check_back_space && empty(v:completed_item)
    call feedkeys("\<Plug>_", 'i')
  endif
endfunction
function! s:is_skip(event) abort
  if a:event ==# 'TextChangedP' && !empty(v:completed_item)
    return 1
  endif

  " Note: The check is needed for <C-y> mapping
  if s:is_skip_prev_text(a:event)
    return 1
  endif

  if s:is_skip_text(a:event)
    " Close the popup
    if deoplete#util#check_popup()
      call feedkeys("\<Plug>_", 'i')
    endif

    return 1
  endif

  " Check nofile buffers
  if &l:buftype =~# 'nofile' && bufname('%') !=# '[Command Line]'
    let nofile_complete_filetypes = deoplete#custom#_get_option(
          \ 'nofile_complete_filetypes')
    if index(nofile_complete_filetypes, &l:filetype) < 0
      return 1
    endif
  endif

  let auto_complete = deoplete#custom#_get_option('auto_complete')

  if &paste
        \ || (a:event !=# 'Manual' && a:event !=# 'Update' && !auto_complete)
        \ || v:insertmode !=# 'i'
    return 1
  endif

  return 0
endfunction
function! s:is_skip_prev_text(event) abort
  let input = deoplete#util#get_input(a:event)

  " Note: Use g:deoplete#_context is needed instead of
  " g:deoplete#_prev_completion
  let prev_input = get(g:deoplete#_context, 'input', '')
  if input ==# prev_input
        \ && input !=# ''
        \ && a:event !=# 'Manual'
        \ && a:event !=# 'Async'
        \ && a:event !=# 'Update'
        \ && a:event !=# 'TextChangedP'
    return 1
  endif

  " Note: It fixes insert first candidate automatically problem
  if a:event ==# 'Update' && prev_input !=# '' && input !=# prev_input
    return 1
  endif

  return 0
endfunction
function! s:is_skip_text(event) abort
  let input = deoplete#util#get_input(a:event)
  if !has('nvim') && iconv(iconv(input, 'utf-8', 'utf-16'),
        \ 'utf-16', 'utf-8') !=# input
    " In Vim8, invalid bytes brokes nvim-yarp.
    return 1
  endif

  let lastchar = matchstr(input, '.$')
  let skip_multibyte = deoplete#custom#_get_option('skip_multibyte')
  if skip_multibyte && len(lastchar) != strwidth(lastchar)
        \ && empty(get(b:, 'eskk', []))
    return 1
  endif

  let displaywidth = strdisplaywidth(input) + 1
  let is_virtual = virtcol('.') >= displaywidth
  if &l:formatoptions =~# '[tca]' && &l:textwidth > 0
        \     && displaywidth >= &l:textwidth
    if &l:formatoptions =~# '[ta]'
          \ || !empty(filter(deoplete#util#get_syn_names(),
          \                  { _, val -> val ==# 'Comment' }))
          \ || is_virtual
      return 1
    endif
  endif

  if a:event =~# '^TextChanged' && s:matched_indentkeys(input) !=# ''
    call deoplete#util#indent_current_line()
    return 1
  endif

  let skip_chars = deoplete#custom#_get_option('skip_chars')

  return (a:event !=# 'Manual' && input !=# ''
        \     && index(skip_chars, input[-1:]) >= 0)
endfunction
function! s:check_input_method() abort
  return exists('*getimstatus') && getimstatus()
endfunction
function! s:matched_indentkeys(input) abort
  if &l:indentexpr ==# ''
    " Disable auto indent
    return ''
  endif

  " Note: check the last word
  let checkstr = matchstr(a:input, '\w\+$')

  for word in filter(map(split(&l:indentkeys, ','),
        \ { _, val -> matchstr(val, 'e\|=\zs.*') }),
        \ { _, val -> val !=# '' && val =~# '\h\w*' })

    if word ==# 'e'
      let word = 'else'
    endif

    let lastpos = len(a:input) - len(word)
    if checkstr ==# word || (word =~# '^\W\+$' &&
          \ lastpos >= 0 && strridx(a:input, word) == lastpos)
      return word
    endif
  endfor

  return ''
endfunction

function! s:define_on_event(event) abort
  if !exists('##' . a:event)
    return
  endif

  execute 'autocmd deoplete' a:event
        \ '* call deoplete#send_event('.string(a:event).')'
endfunction
function! s:define_completion_via_timer(event) abort
  if !exists('##' . a:event)
    return
  endif

  execute 'autocmd deoplete' a:event
        \ '* call s:completion_timer_start('.string(a:event).')'
endfunction

function! s:on_insert_leave() abort
  call deoplete#mapping#_restore_completeopt()
  let g:deoplete#_context = {}
  call deoplete#init#_prev_completion()

  if &cpoptions =~# '$'
    " If 'cpoptions' includes '$' with popup, redraw problem exists.
    redraw
  endif
endfunction

function! s:on_complete_done() abort
  if get(v:completed_item, 'word', '') ==# ''
        \ || !has_key(g:deoplete#_context, 'complete_str')
    return
  endif

  call deoplete#handler#_skip_next_completion()

  let max_used = 100
  let g:deoplete#_recently_used = insert(
        \ g:deoplete#_recently_used,
        \ tolower(v:completed_item.word),
        \ )
  let min_pattern_length = deoplete#custom#_get_option('min_pattern_length')
  if len(g:deoplete#_context['complete_str']) > min_pattern_length
    let g:deoplete#_recently_used = insert(
          \ g:deoplete#_recently_used,
          \ tolower(g:deoplete#_context['complete_str']),
          \ )
  endif
  let g:deoplete#_recently_used = deoplete#util#uniq(
        \ g:deoplete#_recently_used)[: max_used]

  let user_data = get(v:completed_item, 'user_data', '')
  if type(user_data) !=# v:t_string || user_data ==# ''
    return
  endif

  try
    call s:substitute_suffix(json_decode(user_data))
  catch /.*/
  endtry
endfunction
function! s:substitute_suffix(user_data) abort
  if !deoplete#custom#_get_option('complete_suffix')
        \ || !has_key(a:user_data, 'old_suffix')
        \ || !has_key(a:user_data, 'new_suffix')
    return
  endif
  let old_suffix = a:user_data.old_suffix
  let new_suffix = a:user_data.new_suffix

  let next_text = deoplete#util#get_next_input('CompleteDone')
  if stridx(next_text, old_suffix) != 0
    return
  endif

  let next_text = new_suffix . next_text[len(old_suffix):]
  call setline('.', deoplete#util#get_input('CompleteDone') . next_text)
endfunction

function! deoplete#handler#_skip_next_completion() abort
  if !exists('g:deoplete#_context')
    return
  endif

  let input = deoplete#util#get_input('CompleteDone')
  if input !~# '[/.]$'
    let g:deoplete#_context.input = input
  endif
  call deoplete#mapping#_restore_completeopt()
  call deoplete#init#_prev_completion()
endfunction

function! s:is_exiting() abort
  return exists('v:exiting') && v:exiting != v:null
endfunction

function! s:kill_yarp() abort
  if !exists('g:deoplete#_yarp')
    return
  endif

  if g:deoplete#_yarp.job_is_dead
    return
  endif

  let job = g:deoplete#_yarp.job
  if !has('nvim') && !exists('g:yarp_jobstart')
    " Get job object from vim-hug-neovim-rpc
    let job = g:_neovim_rpc_jobs[job].job
  endif

  if has('nvim')
    call jobstop(job)
  else
    call job_stop(job, 'kill')
  endif

  let g:deoplete#_yarp.job_is_dead = 1
endfunction
