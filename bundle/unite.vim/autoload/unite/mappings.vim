"=============================================================================
" FILE: mappings.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Define default mappings.
function! unite#mappings#define_default_mappings() abort "{{{
  " Plugin keymappings "{{{
  nnoremap <silent><buffer> <Plug>(unite_exit)
        \ :<C-u>call <SID>exit()<CR>
  nnoremap <silent><buffer> <Plug>(unite_all_exit)
        \ :<C-u>call <SID>all_exit()<CR>
  nnoremap <silent><buffer> <Plug>(unite_choose_action)
        \ :<C-u>call <SID>choose_action()<CR>
  if b:unite.prompt_linenr == 0
    nnoremap <silent><buffer> <Plug>(unite_insert_enter)
          \ :<C-u>call <SID>insert_enter2()<CR>
    nnoremap <silent><buffer> <Plug>(unite_insert_head)
          \ :<C-u>call <SID>insert_enter2()<CR>
    nnoremap <silent><buffer> <Plug>(unite_append_enter)
          \ :<C-u>call <SID>insert_enter2()<CR>
    nnoremap <silent><buffer> <Plug>(unite_append_end)
          \ :<C-u>call <SID>insert_enter2()<CR>
  else
    nnoremap <expr><buffer> <Plug>(unite_insert_enter)
          \ <SID>insert_enter('i')
    nnoremap <expr><buffer> <Plug>(unite_insert_head)
          \ <SID>insert_enter('A'.
          \  (repeat("\<Left>", len(substitute(
          \    unite#helper#get_input(), '.', 'x', 'g')))))
    nnoremap <expr><buffer> <Plug>(unite_append_enter)
          \ <SID>insert_enter('a')
    nnoremap <expr><buffer> <Plug>(unite_append_end)
          \ <SID>insert_enter('A')
  endif
  nnoremap <silent><buffer> <Plug>(unite_toggle_mark_current_candidate)
        \ :<C-u>call <SID>toggle_mark('j')<CR>
  nnoremap <silent><buffer> <Plug>(unite_toggle_mark_current_candidate_up)
        \ :<C-u>call <SID>toggle_mark('k')<CR>
  nnoremap <silent><buffer> <Plug>(unite_redraw)
        \ :<C-u>call <SID>redraw()<CR>
  nnoremap <silent><buffer> <Plug>(unite_rotate_next_source)
        \ :<C-u>call <SID>rotate_source(1)<CR>
  nnoremap <silent><buffer> <Plug>(unite_rotate_previous_source)
        \ :<C-u>call <SID>rotate_source(0)<CR>
  nnoremap <silent><buffer> <Plug>(unite_print_candidate)
        \ :<C-u>call <SID>print_candidate()<CR>
  nnoremap <silent><buffer> <Plug>(unite_print_message_log)
        \ :<C-u>call <SID>print_message_log()<CR>
  nnoremap <silent><buffer> <Plug>(unite_cursor_top)
        \ :<C-u>call <SID>cursor_top()<CR>
  nnoremap <silent><buffer> <Plug>(unite_cursor_bottom)
        \ :<C-u>call <SID>cursor_bottom()<CR>
  nnoremap <buffer><silent> <Plug>(unite_next_screen)
        \ :<C-u>call <SID>move_screen(1)<CR>
  nnoremap <buffer><silent> <Plug>(unite_next_half_screen)
        \ :<C-u>call <SID>move_half_screen(1)<CR>
  nnoremap <silent><buffer> <Plug>(unite_quick_match_default_action)
        \ :<C-u>call unite#mappings#_quick_match(0)<CR>
  nnoremap <silent><buffer> <Plug>(unite_quick_match_jump)
        \ :<C-u>call unite#mappings#_quick_match(1)<CR>
  nnoremap <silent><buffer> <Plug>(unite_input_directory)
        \ :<C-u>call <SID>input_directory()<CR>
  nnoremap <silent><buffer><expr> <Plug>(unite_do_default_action)
        \ unite#do_action(unite#get_current_unite().context.default_action)
  nnoremap <silent><buffer> <Plug>(unite_delete_backward_path)
        \ :<C-u>call <SID>delete_backward_path()<CR>
  nnoremap <silent><buffer> <Plug>(unite_restart)
        \ :<C-u>call <SID>restart()<CR>
  nnoremap <buffer><silent> <Plug>(unite_toggle_mark_all_candidates)
        \ :<C-u>call <SID>toggle_mark_all_candidates()<CR>
  nnoremap <buffer><silent> <Plug>(unite_toggle_transpose_window)
        \ :<C-u>call <SID>toggle_transpose_window()<CR>
  nnoremap <buffer><silent> <Plug>(unite_toggle_auto_preview)
        \ :<C-u>call <SID>toggle_auto_preview()<CR>
  nnoremap <buffer><silent> <Plug>(unite_toggle_auto_highlight)
        \ :<C-u>call <SID>toggle_auto_highlight()<CR>
  nnoremap <buffer><silent> <Plug>(unite_narrowing_input_history)
        \ :<C-u>call <SID>narrowing_input_history()<CR>
  nnoremap <buffer><silent> <Plug>(unite_narrowing_dot)
        \ :<C-u>call <SID>narrowing_dot()<CR>
  nnoremap <buffer><silent> <Plug>(unite_disable_max_candidates)
        \ :<C-u>call <SID>disable_max_candidates()<CR>
  nnoremap <buffer><silent> <Plug>(unite_quick_help)
        \ :<C-u>call <SID>quick_help()<CR>
  nnoremap <buffer><silent> <Plug>(unite_new_candidate)
        \ :<C-u>call <SID>do_new_candidate_action()<CR>
  nnoremap <buffer><silent> <Plug>(unite_smart_preview)
        \ :<C-u>call <SID>smart_preview()<CR>

  vnoremap <buffer><silent> <Plug>(unite_toggle_mark_selected_candidates)
        \ :<C-u>call <SID>toggle_mark_candidates(
        \      getpos("'<")[1], getpos("'>")[1])<CR>

  inoremap <silent><buffer> <Plug>(unite_exit)
        \ <ESC>:<C-u>call <SID>exit()<CR>
  inoremap <silent><buffer> <Plug>(unite_insert_leave)
        \ <ESC>:<C-u>call <SID>insert_leave()<CR>
  inoremap <silent><expr><buffer> <Plug>(unite_delete_backward_char)
        \ <SID>smart_imap((unite#helper#get_input() == '' ?
        \ "\<ESC>:\<C-u>call \<SID>all_exit()\<CR>" : "\<C-h>"))
  inoremap <silent><expr><buffer> <Plug>(unite_delete_backward_line)
        \ <SID>smart_imap(repeat("\<C-h>",
        \     unite#util#strchars(unite#helper#get_input())))
  inoremap <silent><expr><buffer> <Plug>(unite_delete_backward_word)
        \ <SID>smart_imap("\<C-w>")
  inoremap <silent><buffer> <Plug>(unite_delete_backward_path)
        \ <C-o>:<C-u>call <SID>delete_backward_path()<CR>
  inoremap <expr><buffer> <Plug>(unite_select_next_page)
        \ pumvisible() ? "\<PageDown>" : repeat("\<Down>", winheight(0))
  inoremap <expr><buffer> <Plug>(unite_select_previous_page)
        \ pumvisible() ? "\<PageUp>" : repeat("\<Up>", winheight(0))
  inoremap <silent><buffer> <Plug>(unite_toggle_mark_current_candidate)
        \ <C-o>:<C-u>call <SID>toggle_mark('j')<CR>
  inoremap <silent><buffer> <Plug>(unite_toggle_mark_current_candidate_up)
        \ <C-o>:<C-u>call <SID>toggle_mark('k')<CR>
  inoremap <silent><buffer> <Plug>(unite_choose_action)
        \ <C-o>:<C-u>call <SID>choose_action()<CR>
  inoremap <expr><buffer> <Plug>(unite_move_head)
        \ <SID>smart_imap(repeat("\<Left>", len(substitute(
        \     unite#helper#get_input(), '.', 'x', 'g'))))
  inoremap <expr><buffer> <Plug>(unite_move_left)
        \ <SID>smart_imap("\<Left>")
  inoremap <expr><buffer> <Plug>(unite_move_right)
        \ <SID>smart_imap2("\<Right>")
  inoremap <silent><buffer> <Plug>(unite_quick_match_default_action)
        \ <C-o>:<C-u>call unite#mappings#_quick_match(0)<CR>
  inoremap <silent><buffer> <Plug>(unite_quick_match_jump)
        \ <C-o>:<C-u>call unite#mappings#_quick_match(1)<CR>
  inoremap <silent><buffer> <Plug>(unite_input_directory)
        \ <C-o>:<C-u>call <SID>input_directory()<CR>
  inoremap <silent><buffer><expr> <Plug>(unite_do_default_action)
        \ unite#do_action(unite#get_current_unite().context.default_action)
  inoremap <silent><buffer> <Plug>(unite_toggle_transpose_window)
        \ <C-o>:<C-u>call <SID>toggle_transpose_window()<CR>
  inoremap <silent><buffer> <Plug>(unite_toggle_auto_preview)
        \ <C-o>:<C-u>call <SID>toggle_auto_preview()<CR>
  inoremap <silent><buffer> <Plug>(unite_toggle_auto_highlight)
        \ <C-o>:<C-u>call <SID>toggle_auto_highlight()<CR>
  inoremap <silent><buffer> <Plug>(unite_narrowing_input_history)
        \ <C-o>:<C-u>call <SID>narrowing_input_history()<CR>
  inoremap <silent><buffer> <Plug>(unite_disable_max_candidates)
        \ <C-o>:<C-u>call <SID>disable_max_candidates()<CR>
  inoremap <silent><buffer> <Plug>(unite_redraw)
        \ <C-o>:<C-u>call <SID>redraw()<CR>
  inoremap <buffer><silent> <Plug>(unite_new_candidate)
        \ <C-o>:<C-u>call <SID>do_new_candidate_action()<CR>
  inoremap <silent><buffer> <Plug>(unite_print_message_log)
        \ <C-o>:<C-u>call <SID>print_message_log()<CR>
  inoremap <expr><silent><buffer> <Plug>(unite_complete)
        \ <SID>complete()
  "}}}

  if exists('g:unite_no_default_keymappings')
        \ && g:unite_no_default_keymappings
    return
  endif

  " Normal mode key-mappings.
  execute s:nowait_map('n') 'i'
        \ '<Plug>(unite_insert_enter)'
  execute s:nowait_map('n') 'I'
        \ '<Plug>(unite_insert_head)'
  execute s:nowait_map('n') 'A'
        \ '<Plug>(unite_append_end)'
  execute s:nowait_map('n') 'q'
        \ '<Plug>(unite_exit)'
  execute s:nowait_map('n') '<C-g>'
        \ '<Plug>(unite_exit)'
  execute s:nowait_map('n') 'Q'
        \ '<Plug>(unite_all_exit)'
  execute s:nowait_map('n') 'g<C-g>'
        \ '<Plug>(unite_all_exit)'
  execute s:nowait_map('n') '<CR>'
        \ '<Plug>(unite_do_default_action)'
  execute s:nowait_map('n') '<Space>'
        \ '<Plug>(unite_toggle_mark_current_candidate)'
  execute s:nowait_map('n') '<S-Space>'
        \ '<Plug>(unite_toggle_mark_current_candidate_up)'
  execute s:nowait_map('n') '<Tab>'
        \ '<Plug>(unite_choose_action)'
  execute s:nowait_map('n') '<C-n>'
        \ '<Plug>(unite_rotate_next_source)'
  execute s:nowait_map('n') '<C-p>'
        \ '<Plug>(unite_rotate_previous_source)'
  execute s:nowait_map('n') '<C-a>'
        \ '<Plug>(unite_print_message_log)'
  execute s:nowait_map('n') '<C-k>'
        \ '<Plug>(unite_print_candidate)'
  execute s:nowait_map('n') '<C-l>'
        \ '<Plug>(unite_redraw)'
  execute s:nowait_map('n') 'gg'
        \ '<Plug>(unite_cursor_top)'
  execute s:nowait_map('n') '<C-Home>'
        \ '<Plug>(unite_cursor_top)'
  execute s:nowait_map('n') 'G'
        \ '<Plug>(unite_cursor_bottom)'
  execute s:nowait_map('n') '<C-End>'
        \ '<Plug>(unite_cursor_bottom)$'
  execute s:nowait_map('n') 'j'
        \ '<Plug>(unite_loop_cursor_down)'
  execute s:nowait_map('n') '<Down>'
        \ '<Plug>(unite_loop_cursor_down)'
  execute s:nowait_map('n') 'k'
        \ '<Plug>(unite_loop_cursor_up)'
  execute s:nowait_map('n') '<Up>'
        \ '<Plug>(unite_loop_cursor_up)'
  execute s:nowait_map('n') 'J'
        \ '<Plug>(unite_skip_cursor_down)'
  execute s:nowait_map('n') 'K'
        \ '<Plug>(unite_skip_cursor_up)'
  execute s:nowait_map('n') '<C-h>'
        \ '<Plug>(unite_delete_backward_path)'
  execute s:nowait_map('n') '<C-r>'
        \ '<Plug>(unite_restart)'
  execute s:nowait_map('n') '*'
        \ '<Plug>(unite_toggle_mark_all_candidates)'
  execute s:nowait_map('n') 'M'
        \ '<Plug>(unite_disable_max_candidates)'
  execute s:nowait_map('n') 'g?'
        \ '<Plug>(unite_quick_help)'
  execute s:nowait_map('n') 'N'
        \ '<Plug>(unite_new_candidate)'
  execute s:nowait_map('n') '.'
        \ '<Plug>(unite_narrowing_dot)'
  execute s:nowait_map('n') 'p'
        \ '<Plug>(unite_smart_preview)'
  execute s:nowait_map('n') '<2-LeftMouse>'
        \ '<Plug>(unite_do_default_action)'
  execute s:nowait_map('n') '<RightMouse>'
        \ '<Plug>(unite_exit)'

  execute s:nowait_expr('nmap') 'a'
        \ 'unite#smart_map("\<Plug>(unite_append_enter)",
        \                 "\<Plug>(unite_choose_action)")'
  execute s:nowait_expr('nnoremap') 'd'
        \ 'unite#smart_map(''d'', unite#do_action(''delete''))'
  execute s:nowait_expr('nnoremap') 'b'
        \ 'unite#smart_map(''b'', unite#do_action(''bookmark''))'
  execute s:nowait_expr('nnoremap') 'e'
        \ 'unite#smart_map(''e'', unite#do_action(''edit''))'
  execute s:nowait_expr('nmap') 'x'
        \ 'unite#smart_map(''x'', "\<Plug>(unite_quick_match_default_action)")'
  execute s:nowait_expr('nnoremap') 't'
        \ 'unite#smart_map(''t'', unite#do_action(''tabopen''))'
  execute s:nowait_expr('nnoremap') 'yy'
        \ 'unite#smart_map(''yy'', unite#do_action(''yank''))'
  execute s:nowait_expr('nnoremap') 'o'
        \ 'unite#smart_map(''o'', unite#do_action(''open''))'

  " Visual mode key-mappings.
  xmap <buffer> <Space>
        \ <Plug>(unite_toggle_mark_selected_candidates)

  " Insert mode key-mappings.
  imap <buffer><expr> <TAB>
        \ pumvisible() ? '<TAB>'   : '<Plug>(unite_choose_action)'
  imap <buffer><expr> <C-n>
        \ pumvisible() ? '<C-n>'   : '<Plug>(unite_select_next_line)'
  imap <buffer><expr> <Down>
        \ pumvisible() ? '<Down>'  : '<Plug>(unite_select_next_line)'
  imap <buffer><expr> <C-p>
        \ pumvisible() ? '<C-p>'   : '<Plug>(unite_select_previous_line)'
  imap <buffer><expr> <Up>
        \ pumvisible() ? '<Up>'    : '<Plug>(unite_select_previous_line)'
  imap <buffer><expr> <C-f>
        \ pumvisible() ? '<C-f>'   : '<Plug>(unite_select_next_page)'
  imap <buffer><expr> <C-b>
        \ pumvisible() ? '<C-b>'   : '<Plug>(unite_select_previous_page)'
  imap <buffer><expr> <CR>
        \ pumvisible() ? '<C-Y>'   : '<Plug>(unite_do_default_action)'
  imap <buffer><expr> <C-h>
        \ pumvisible() ? '<C-h>'   : '<Plug>(unite_delete_backward_char)'
  imap <buffer><expr> <BS>
        \ pumvisible() ? '<BS>'    : '<Plug>(unite_delete_backward_char)'
  imap <buffer><expr> <C-u>
        \ pumvisible() ? '<C-u>'   : '<Plug>(unite_delete_backward_line)'
  imap <buffer><expr> <C-w>
        \ pumvisible() ? '<C-w>'   : '<Plug>(unite_delete_backward_word)'
  imap <buffer><expr> <C-a>
        \ pumvisible() ? '<C-a>'   : '<Plug>(unite_move_head)'
  imap <buffer><expr> <Home>
        \ pumvisible() ? '<Home>'  : '<Plug>(unite_move_head)'
  imap <buffer><expr> <Left>
        \ pumvisible() ? '<Left>'  : '<Plug>(unite_move_left)'
  imap <buffer><expr> <Right>
        \ pumvisible() ? '<Right>' : '<Plug>(unite_move_right)'
  imap <buffer><expr> <C-l>
        \ pumvisible() ? '<C-l>'   : '<Plug>(unite_redraw)'

  if has('gui_running')
    imap <buffer><expr> <ESC>
          \ pumvisible() ? '<ESC>' : '<Plug>(unite_insert_leave)'
  endif

  execute s:nowait_map('i') '<C-g>'
        \ '<Plug>(unite_exit)'

  imap <buffer><expr> <2-LeftMouse>
        \ pumvisible() ? '<2-LeftMouse>' : '<Plug>(unite_do_default_action)'
  imap <buffer><expr> <RightMouse>
        \ pumvisible() ? '<RightMouse>'  : '<Plug>(unite_exit)'

  imap <silent><buffer><expr> <Space>
        \ pumvisible()
        \ ? '<Space>'
        \ : unite#smart_map(' ', "\<Plug>(unite_toggle_mark_current_candidate)")
  imap <silent><buffer><expr> <S-Space>
        \ pumvisible()
        \ ? '<S-Space>'
        \ : unite#smart_map(' ', "\<Plug>(unite_toggle_mark_current_candidate_up)")

  inoremap <silent><buffer><expr> <C-d>
        \ pumvisible() ? '<C-d>' : unite#do_action("delete")
  inoremap <silent><buffer><expr> <C-e>
        \ pumvisible() ? '<C-e>' : unite#do_action("edit")
  inoremap <silent><buffer><expr> <C-t>
        \ pumvisible() ? '<C-t>' : unite#do_action("tabopen")
  inoremap <silent><buffer><expr> <C-y>
        \ pumvisible() ? '<C-y>' : unite#do_action("yank")
  inoremap <silent><buffer><expr> <C-o>
        \ pumvisible() ? '<C-o>' : unite#do_action("open")
endfunction"}}}

function! s:nowait_map(mode) abort "{{{
  return a:mode.'map <buffer>'
        \ . ((v:version > 703 || (v:version == 703 && has('patch1261'))) ?
        \ '<nowait>' : '')
endfunction "}}}

function! s:nowait_expr(map) abort "{{{
  return a:map . ' <buffer><silent><expr>'
        \ . ((v:version > 703 || (v:version == 703 && has('patch1261'))) ?
        \ '<nowait>' : '')
endfunction "}}}

function! unite#mappings#narrowing(word, ...) abort "{{{
  let is_escape = get(a:000, 0, 1)

  setlocal modifiable
  let unite = unite#get_current_unite()

  let unite.input = is_escape ? escape(a:word, ' *') : a:word
  let unite.context.input = unite.input

  call unite#handlers#_on_insert_enter()
  call unite#view#_redraw_prompt()
  call unite#helper#cursor_prompt()
  call unite#view#_bottom_cursor()
  startinsert!
endfunction"}}}

function! unite#mappings#do_action(...) abort "{{{
  return call('unite#action#do', a:000)
endfunction"}}}

function! unite#mappings#set_current_matchers(matchers) abort "{{{
  let unite = unite#get_current_unite()
  let unite.current_matchers = a:matchers
  let unite.context.is_redraw = 1
  return mode() ==# 'i' ? "a\<BS>" : "g\<ESC>"
endfunction"}}}
function! unite#mappings#set_current_sorters(sorters) abort "{{{
  let unite = unite#get_current_unite()
  let unite.current_sorters = a:sorters
  let unite.context.is_redraw = 1
  return mode() ==# 'i' ? "a\<BS>" : "g\<ESC>"
endfunction"}}}
function! unite#mappings#set_current_converters(converters) abort "{{{
  let unite = unite#get_current_unite()
  let unite.current_converters = a:converters
  let unite.context.is_redraw = 1
  return mode() ==# 'i' ? "a\<BS>" : "g\<ESC>"
endfunction"}}}
function! unite#mappings#get_current_matchers() abort "{{{
  return unite#get_current_unite().current_matchers
endfunction"}}}
function! unite#mappings#get_current_sorters() abort "{{{
  return unite#get_current_unite().current_sorters
endfunction"}}}
function! unite#mappings#get_current_converters() abort "{{{
  return unite#get_current_unite().current_converters
endfunction"}}}

function! s:smart_imap(map) abort "{{{
  call s:clear_complete()
  if line('.') == b:unite.prompt_linenr
        \ && col('.') <= len(b:unite.context.prompt)
    return ''
  else
    return (line('.') != b:unite.prompt_linenr ?
          \     "\<ESC>" . b:unite.prompt_linenr . 'Gzb$a' : '') . a:map
  endif
endfunction"}}}
function! s:smart_imap2(map) abort "{{{
  call s:clear_complete()
  if line('.') == b:unite.prompt_linenr
        \ && col('.') >= col('$')
    return ''
  else
    return (line('.') != b:unite.prompt_linenr ?
          \     "\<ESC>" . b:unite.prompt_linenr . 'Gzb$a' : '') . a:map
  endif
endfunction"}}}

function! s:do_new_candidate_action() abort "{{{
  if empty(unite#helper#get_current_candidate())
    " Get source name.
    if len(unite#get_sources()) != 1
      call unite#print_error('No candidates and multiple sources.')
      return
    endif

    " Dummy candidate.
    let candidates = unite#init#_candidates_source([{}],
          \ unite#get_sources()[0].name)
  else
    let candidates = [unite#helper#get_current_candidate()]
  endif

  return unite#action#do('unite__new_candidate', candidates)
endfunction"}}}

" key-mappings functions.
function! s:exit() abort "{{{
  let context = unite#get_context()

  call unite#force_quit_session()

  if context.tab && winnr('$') == 1 && !context.temporary
    " Close window.
    close
  endif
endfunction"}}}
function! s:all_exit() abort "{{{
  call unite#all_quit_session()
endfunction"}}}
function! s:restart() abort "{{{
  let unite = unite#get_current_unite()
  let context = unite.context
  let context.resume = 0
  let context.unite__is_restart = 1
  let sources = map(deepcopy(unite.sources),
        \ 'empty(v:val.args) ? v:val.name : [v:val.name] + v:val.args')
  call unite#force_quit_session()
  call unite#start(sources, context)
endfunction"}}}
function! s:delete_backward_path() abort "{{{
  let context = unite#get_context()
  if context.input != ''
    call unite#mappings#narrowing(
          \ substitute(context.input, '[^/ ]*.$', '', ''), 0)
  else
    let context.path = substitute(context.path, '[^/ ]*.$', '', '')
    call unite#redraw()
  endif
endfunction"}}}
function! s:toggle_mark(map) abort "{{{
  call unite#helper#skip_prompt()

  let candidate = unite#helper#get_current_candidate()
  if empty(candidate)
    return
  endif
  if !get(candidate, 'is_dummy', 0)
    let candidate.unite__is_marked = !candidate.unite__is_marked
    let candidate.unite__marked_time = has('reltime') && has('float') ?
          \ str2float(reltimestr(reltime())) : localtime()

    call unite#view#_redraw_line()
  endif

  let context = unite#get_context()
  execute 'normal!' (a:map ==# 'j' && context.prompt_direction !=# 'below'
        \ || a:map ==# 'k' && context.prompt_direction ==# 'below') ?
        \ unite#mappings#cursor_down(1) : unite#mappings#cursor_up(1)
endfunction"}}}
function! s:toggle_mark_all_candidates() abort "{{{
  call unite#view#_redraw_all_candidates()
  call s:toggle_mark_candidates(1, line('$'))
endfunction"}}}
function! s:toggle_mark_candidates(start, end) abort "{{{
  if a:start < 0
    " Ignore.
    return
  endif

  let unite = unite#get_current_unite()

  let pos = getpos('.')
  try
    call cursor(a:start, 1)
    let prev = -1
    for _ in range(a:start, a:end)
      if line('.') == prev || line('.') < a:start || line('.') > a:end
        break
      endif
      let prev = line('.')
      if line('.') == unite.prompt_linenr
        call unite#helper#skip_prompt()
      else
        let context = unite#get_context()
        if context.prompt_direction ==# 'below'
          call s:toggle_mark('k')
        else
          call s:toggle_mark('j')
        endif
      endif
    endfor
  finally
    call setpos('.', pos)
    call unite#view#_bottom_cursor()
  endtry
endfunction"}}}
function! s:quick_help() abort "{{{
  call unite#start_temporary([['mapping', bufnr('%')]], {}, 'mapping-help')
endfunction"}}}
function! s:choose_action() abort "{{{
  let candidates = unite#helper#get_marked_candidates()
  if empty(candidates)
    if empty(unite#helper#get_current_candidate())
      return
    endif

    let candidates = [ unite#helper#get_current_candidate() ]
  endif

  call unite#mappings#_choose_action(candidates)
endfunction"}}}
function! unite#mappings#_choose_action(candidates, ...) abort "{{{
  call filter(a:candidates,
        \ '!has_key(v:val, "is_dummy") || !v:val.is_dummy')
  if empty(a:candidates)
    return
  endif

  let context = deepcopy(get(a:000, 0, {}))
  let context.source__sources = unite#init#_loaded_sources(
        \ unite#util#uniq(map(copy(a:candidates),
        \                 'v:val.source')), context)
  let context.buffer_name = 'action'
  let context.profile_name = 'action'
  let context.default_action = 'default'
  let context.start_insert = 1
  let context.truncate = 1

  call call((has_key(context, 'vimfiler__current_directory')
        \    || &filetype !=# 'unite' ?
        \ 'unite#start' : 'unite#start_temporary'),
        \ [[[unite#sources#action#define(), a:candidates]], context])
endfunction"}}}
function! s:insert_enter(key) abort "{{{
  setlocal modifiable

  let unite = unite#get_current_unite()

  return (line('.') != unite.prompt_linenr) ?
        \ (unite.context.prompt_focus ?
        \     unite.prompt_linenr.'GA' : 'gI') :
        \ (a:key == 'i' && col('.') <= 1
        \     || a:key == 'a' && col('.') < 1) ?
        \     'A' :
        \     a:key
endfunction"}}}
function! s:insert_enter2() abort "{{{
  nnoremap <expr><buffer> <Plug>(unite_insert_enter)
        \ <SID>insert_enter('i')
  nnoremap <expr><buffer> <Plug>(unite_insert_head)
        \ <SID>insert_enter('A'.
        \  (repeat("\<Left>", len(substitute(
        \    unite#helper#get_input(), '.', 'x', 'g')))))
  nnoremap <expr><buffer> <Plug>(unite_append_enter)
        \ <SID>insert_enter('a')
  nnoremap <expr><buffer> <Plug>(unite_append_end)
        \ <SID>insert_enter('A')

  setlocal modifiable

  " Restore prompt
  call unite#handlers#_on_insert_enter()

  let unite = unite#get_current_unite()
  call cursor(unite.init_prompt_linenr, 0)
  call unite#view#_bottom_cursor()
  startinsert!
endfunction"}}}
function! s:insert_leave() abort "{{{
  call unite#helper#skip_prompt()
endfunction"}}}
function! s:redraw() abort "{{{
  call unite#clear_message()
  call unite#force_redraw()
endfunction"}}}
function! s:rotate_source(is_next) abort "{{{
  let unite = unite#get_current_unite()

  for _ in unite#loaded_sources_list()
    let unite.sources = a:is_next ?
          \ add(unite.sources[1:], unite.sources[0]) :
          \ insert(unite.sources[: -2], unite.sources[-1])

    if !empty(unite.sources[0].unite__candidates)
      break
    endif
  endfor

  let unite.statusline = unite#view#_get_status_string(unite)
  let &l:statusline = unite.statusline

  call unite#view#_redraw_candidates()
endfunction"}}}
function! s:print_candidate() abort "{{{
  let candidate = unite#helper#get_current_candidate()
  if empty(candidate)
    " Ignore.
    return
  endif

  echo 'abbr: ' . candidate.unite__abbr
  echo 'word: ' . candidate.word
endfunction"}}}
function! s:print_message_log() abort "{{{
  for msg in unite#get_current_unite().msgs
    echohl Comment | echo msg | echohl None
  endfor
  for msg in unite#get_current_unite().err_msgs
    echohl WarningMsg | echo msg | echohl None
  endfor
endfunction"}}}
function! s:cursor_top() abort "{{{
  let unite = unite#get_current_unite()
  if v:count == 0
    execute 'normal!' (unite.prompt_linenr == 1 ? '2' : '') . 'gg0z.'
  else
    if v:count > len(unite.current_candidates) + (unite.prompt_linenr == 1)
      call unite#view#_redraw_all_candidates()
    endif
    execute 'normal!' v:count . 'gg0z.'
  endif
endfunction"}}}
function! s:cursor_bottom() abort "{{{
  if v:count == 0
    call unite#view#_redraw_all_candidates()
    normal! G
  else
    let unite = unite#get_current_unite()
    if v:count > len(unite.current_candidates) + (unite.prompt_linenr == 1)
      call unite#view#_redraw_all_candidates()
    endif
    execute 'normal!' v:count . 'G'
  endif
endfunction"}}}
function! s:insert_selected_candidate() abort "{{{
  let candidate = unite#helper#get_current_candidate()
  if empty(candidate)
    " Ignore.
    return
  endif

  call unite#mappings#narrowing(candidate.word)
endfunction"}}}
function! unite#mappings#_quick_match(is_jump) abort "{{{
  if !empty(unite#helper#get_marked_candidates())
    call unite#util#print_error('Marked candidates is detected.')
    return
  endif

  let unite = unite#get_current_unite()

  let quick_match_table = s:get_quick_match_table()
  call unite#view#_quick_match_redraw(quick_match_table, 1)

  if mode() !~# '^c'
    echo 'Input quick match key: '
  endif
  let char = ''

  while char == ''
    let char = nr2char(getchar())
  endwhile

  redraw
  echo ''

  stopinsert
  call unite#view#_quick_match_redraw(quick_match_table, 0)

  let num = get(quick_match_table, char, -1)
  let candidate = unite#helper#get_current_candidate(num)
  if num < 0 || empty(candidate)
    call unite#util#print_error('Canceled.')

    if unite.context.quick_match && char == "\<ESC>"
      call unite#force_quit_session()
    endif
    return
  endif

  if candidate.is_dummy
    call unite#util#print_error('Dummy.')
    return
  endif

  if a:is_jump
    call unite#view#_search_cursor(candidate)
  else
    call unite#action#do(
          \ unite.context.default_action, [candidate])
  endif
endfunction"}}}
function! s:input_directory() abort "{{{
  let path = unite#util#substitute_path_separator(
        \ input('Input narrowing directory: ',
        \         unite#helper#get_input(), 'dir'))
  let path = path.(path == '' || path =~ '/$' ? '' : '/')
  call unite#mappings#narrowing(path)
endfunction"}}}
function! unite#mappings#loop_cursor_up(mode) abort "{{{
  " Loop.
  call unite#view#_redraw_all_candidates()

  if a:mode ==# 'i'
    noautocmd startinsert
  endif

  call cursor(line('$'), 1)
endfunction"}}}
function! unite#mappings#loop_cursor_down(mode) abort "{{{
  " Loop.
  call unite#view#_redraw_all_candidates()

  if a:mode ==# 'i'
    noautocmd startinsert
  endif

  call cursor(1, 1)
endfunction"}}}
function! unite#mappings#cursor_up(is_skip_not_matched) abort "{{{
  let is_insert = mode() ==# 'i'
  let prompt_linenr = unite#get_current_unite().prompt_linenr

  let num = line('.') - 1
  let cnt = 1
  let offset = prompt_linenr == 1 ? 1 : 0
  if line('.') == prompt_linenr && g:unite_enable_auto_select
    let cnt += 1
  endif

  while 1
    let candidate = get(unite#get_unite_candidates(), num - offset - cnt, {})
    if num >= cnt && !empty(candidate) && (candidate.is_dummy
          \ || (a:is_skip_not_matched && !candidate.is_matched))
      let cnt += 1
      continue
    endif

    break
  endwhile

  if is_insert
    return repeat("\<Up>", cnt) .
        \ (unite#helper#is_prompt(line('.') - cnt) ? "\<End>" : "\<Home>")
  else
    let cnt += v:count == 0 ? 0 : (v:count - 1)
    return (v:count ? "\<Esc>" : '') . (cnt == 1 ? 'k' : cnt.'k')
  endif
endfunction"}}}
function! unite#mappings#cursor_down(is_skip_not_matched) abort "{{{
  let is_insert = mode() ==# 'i'
  let prompt_linenr = unite#get_current_unite().prompt_linenr

  let num = line('.') - 1
  let cnt = 1
  let offset = prompt_linenr == 1 ? 1 : 0
  if line('.') == prompt_linenr && g:unite_enable_auto_select
    let cnt += 1
  endif

  while 1
    let candidate = get(unite#get_unite_candidates(), num - offset + cnt, {})
    if !empty(candidate) && (candidate.is_dummy
          \ || (a:is_skip_not_matched && !candidate.is_matched))
      let cnt += 1
      continue
    endif

    break
  endwhile

  if is_insert
    return repeat("\<Down>", cnt) .
          \ (unite#helper#is_prompt(line('.') + cnt) ? "\<End>" : "\<Home>")
  else
    let cnt += v:count == 0 ? 0 : (v:count - 1)
    return (v:count ? "\<Esc>" : '') . (cnt == 1 ? 'j' : cnt.'j')
  endif
endfunction"}}}
function! s:smart_preview() abort "{{{
  if b:unite.preview_candidate !=#
        \ unite#helper#get_current_candidate()
    call unite#view#_do_auto_preview()
  else
    call unite#view#_close_preview_window()
  endif

  call unite#view#_resize_window()
endfunction"}}}
function! s:toggle_transpose_window() abort "{{{
  " Toggle vertical/horizontal view.
  let context = unite#get_context()
  let direction = context.vertical ?
        \ (context.direction ==# 'topleft' ? 'K' : 'J') :
        \ (context.direction ==# 'topleft' ? 'H' : 'L')

  execute 'silent wincmd ' . direction

  let context.vertical = !context.vertical
endfunction"}}}
function! s:toggle_auto_preview() abort "{{{
  let unite = unite#get_current_unite()
  let context = unite#get_context()
  let context.auto_preview = !context.auto_preview
  let unite.preview_candidate = {}

  if context.auto_preview
    call unite#view#_do_auto_preview()
  elseif !context.auto_preview
        \ && !unite#get_current_unite().has_preview_window
    " Close preview window.
    call unite#view#_close_preview_window()
  endif

  call unite#view#_resize_window()
endfunction"}}}
function! s:toggle_auto_highlight() abort "{{{
  let context = unite#get_context()
  let context.auto_highlight = !context.auto_highlight
endfunction"}}}
function! s:disable_max_candidates() abort "{{{
  let unite = unite#get_current_unite()
  let unite.disabled_max_candidates = 1

  call unite#force_redraw()
  call unite#view#_redraw_all_candidates()
endfunction"}}}
function! s:narrowing_input_history() abort "{{{
  call unite#start_temporary(
        \ [unite#sources#history_input#define()],
        \ { 'old_source_names_string' : unite#loaded_source_names_string() },
        \ 'history/input')
endfunction"}}}
function! s:narrowing_dot() abort "{{{
  call unite#mappings#narrowing(unite#helper#get_input().'.')
endfunction"}}}
function! s:get_quick_match_table() abort "{{{
  let unite = unite#get_current_unite()
  let offset = unite.context.prompt_direction ==# 'below' ?
        \ (unite.prompt_linenr == 0 ?
        \  line('$') - line('.') :
        \  unite.prompt_linenr - line('.') - 1) :
        \ line('.')
  if line('.') == unite.prompt_linenr
    let offset = (unite.context.prompt_direction ==# 'below' ?
          \  0 : 2)
  elseif unite.context.prompt_direction ==# 'below'
    let offset = offset * -1
  endif

  let table = deepcopy(g:unite_quick_match_table)
  if unite.context.prompt_direction ==# 'below'
    let max = len(unite.current_candidates)
    call map(table, 'max - v:val + offset')
  else
    for key in keys(table)
      let table[key] = unite#helper#get_current_candidate_linenr(
            \ table[key]+offset-1)
    endfor
  endif
  return table
endfunction"}}}

function! s:complete() abort "{{{
  let unite = unite#get_current_unite()
  let input = matchstr(unite#get_input(), '\h\w*$')
  let cur_text = unite#get_input()[: -len(input)-1]

  if !has_key(unite, 'complete_cur_text')
        \ || cur_text !=# unite.complete_cur_text
        \ || index(unite.complete_candidates, input) < 0
    " Recache
    let start = reltime()
    let unite.complete_candidates =
          \ unite#complete#gather(unite.current_candidates, input)
    echomsg string(reltimestr(reltime(start)))
    let unite.complete_candidate_num = 0
    let unite.complete_cur_text = cur_text
    let unite.complete_input = input
  endif

  call unite#view#_redraw_echo(printf('match %d of %d : %s',
        \ unite.complete_candidate_num+1, len(unite.complete_candidates),
        \ join(unite.complete_candidates[unite.complete_candidate_num+1 :
        \      unite.complete_candidate_num + 10])))

  let candidate = get(unite.complete_candidates,
        \ unite.complete_candidate_num, input)
  let unite.complete_candidate_num += 1
  if unite.complete_candidate_num >= len(unite.complete_candidates)
    " Cycle
    let unite.complete_candidate_num = 0
  endif

  return repeat("\<C-h>", unite#util#strchars(input)) . candidate
endfunction"}}}
function! s:clear_complete() abort "{{{
  let unite = unite#get_current_unite()
  if has_key(unite, 'complete_cur_text')
    call remove(unite, 'complete_cur_text')
    redraw
    echo ''
  endif

  return ''
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
