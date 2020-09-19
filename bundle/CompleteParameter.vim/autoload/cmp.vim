"==============================================================
"    file: complete_parameter.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-07 20:29:10
"==============================================================

let s:complete_parameter = {'index': 0, 'items': [], 'complete_pos': [], 'success': 0, 'echos': []}
let g:complete_parameter_last_failed_insert = ''

let s:log_index = 0

function! cmp#init() abort "{{{
  runtime! cm_parser/*.vim

  " ultisnips will remove all smaps, this will without this plugin
  let g:UltiSnipsMappingsToIgnore = get(g:, 'UltiSnipsMappingsToIgnore', []) + ["complete_parameter"]
  " neosnippet will remove all smaps
  let g:neosnippet#disable_select_mode_mappings = 0

  " 4 error
  " 2 error + debug
  " 1 erro + debug + trace
  let g:complete_parameter_log_level = get(g:, 'complete_parameter_log_level', 5)

  let g:complete_parameter_use_ultisnips_mappings = get(g:, 'complete_parameter_use_ultisnips_mappings', 0)
endfunction "}}}

function! cmp#default_echos(completed_item)
  return []
endfunction

let s:ftfunc_prefix = 'cm_parser#'
let s:ftfunc = {'ft': ''}
function! cmp#new_ftfunc(filetype) abort "{{{
  if empty(a:filetype)
    throw 'filetype is empty'
  endif

  let ftfunc = deepcopy(s:ftfunc)
  let ftfunc['ft'] = a:filetype
  try
    let ftfunc['parameters'] = function(s:ftfunc_prefix . a:filetype .'#parameters')
    let ftfunc['parameter_delim'] = function(s:ftfunc_prefix . a:filetype . '#parameter_delim')
    let ftfunc['parameter_begin'] = function(s:ftfunc_prefix. a:filetype . '#parameter_begin')
    let ftfunc['parameter_end'] = function(s:ftfunc_prefix . a:filetype . '#parameter_end')
    if exists('*'.s:ftfunc_prefix.a:filetype.'#echos')
      let ftfunc['echos'] = function(s:ftfunc_prefix.a:filetype.'#echos')
    else
      let ftfunc['echos'] = function('cmp#default_echos')
    endif
  catch /^E700/
    throw 'the function should be defined: ' . v:exception
  endtry

  return ftfunc
endfunction "}}}

function! s:filetype_func_exist(filetype) abort "{{{
  let filetype_func_prefix = s:ftfunc_prefix.a:filetype.'#'
  let parameters_func_name = filetype_func_prefix.'parameters'
  let parameter_delim_func_name = filetype_func_prefix.'parameter_delim'
  let parameter_begin_func_name = filetype_func_prefix.'parameter_begin'
  let parameter_end_func_name = filetype_func_prefix.'parameter_end'

  if !exists('*'.parameters_func_name) ||
        \!exists('*'.parameter_delim_func_name) ||
        \!exists('*'.parameter_begin_func_name) ||
        \!exists('*'.parameter_end_func_name)
    return 0
  endif
  return 1
endfunction "}}}

function! cmp#filetype_func_check(ftfunc) abort "{{{
  if !<SID>filetype_func_exist(a:ftfunc['ft'])
    return 0
  endif

  " let parameters = a:ftfunc.parameters(v:completed_item)
  " if type(parameters) != 3
  "     return 0
  " endif

  if !exists('*'.string(a:ftfunc.parameter_delim))
    return 0
  endif
  let delim = a:ftfunc.parameter_delim()
  if type(delim) != 1 || empty(delim)
    return 0
  endif

  if !exists('*'.string(a:ftfunc.parameter_begin))
    return 0
  endif
  let begin = a:ftfunc.parameter_begin()
  if type(begin) != 1 || empty(begin)
    return 0
  endif

  if !exists('*'.string(a:ftfunc.parameter_end))
    return 0
  endif
  let end = a:ftfunc.parameter_end()
  if type(end) != 1 || empty(end)
    return 0
  endif
  return 1
endfunction "}}}

" check v:completed_item is empty or not
function! s:empty_completed_item() abort "{{{
  let completed_item = v:completed_item
  if empty(completed_item)
    return 1
  endif
  let menu = get(completed_item, 'menu', '')
  let info = get(completed_item, 'info', '')
  let kind = get(completed_item, 'kind', '')
  let abbr = get(completed_item, 'abbr', '')
  return empty(menu) && empty(info) && empty(kind) && empty(abbr)
endfunction "}}}

" select an item if need, and the check need to revert or not
" else call the complete function
function! cmp#pre_complete(failed_insert) abort "{{{
  let s:log_index = <SID>timenow_ms()

  if !pumvisible()
    return <SID>failed_event(a:failed_insert)
  endif

  let completed_word = get(v:completed_item, 'word', '')

  if <SID>empty_completed_item() && pumvisible()
    let feed = printf("\<C-r>=cmp#check_revert_select('%s', '%s')\<ENTER>", a:failed_insert, completed_word)
    call feedkeys(feed, 'n')
    return "\<C-n>"
  else
    return cmp#complete(a:failed_insert)
  endif
endfunction "}}}

function! cmp#default_failed_insert(failed_insert) "{{{
  if a:failed_insert =~# '()$'
    return "\<LEFT>"
  else
    return ''
  endif
endfunction "}}}

function! s:failed_event(failed_insert) abort "{{{ return the text to insert and toggle event
  let keys = ''
  if exists('*CompleteParameterFailed')
    let keys =  CompleteParameterFailed(a:failed_insert)
  else
    let keys =  cmp#default_failed_insert(a:failed_insert)
  endif
  let content = getline(line('.'))
  let parameter = a:failed_insert
  let pos = col('.') - 2
  if pos > 0
    let posEnd = pos + len(parameter) - 1
    if content[pos : posEnd] !=# parameter &&
          \content[pos] ==# parameter[0] 
      let parameter = substitute(parameter, '\m.\(.*\)', '\1', '')
    endif
  endif

  let keys = parameter . keys
  call <SID>trace_log(keys)

  return keys
endfunction "}}}

" if the select item is not match with completed_word, the revert
" else call the complete function
function! cmp#check_revert_select(failed_insert, completed_word) abort "{{{
  let select_complete_word = get(v:completed_item, 'word', '')
  call <SID>trace_log('s:completed_word: ' . a:completed_word)
  call <SID>trace_log('select_complete_word: ' . select_complete_word)
  redraw!
  if select_complete_word !=# a:completed_word
    return <SID>failed_event("\<C-p>".a:failed_insert)
  else
    let keys = cmp#complete(a:failed_insert)
    return keys
  endif
endfunction "}}}

function! cmp#check_parameter_return(parameter, parameter_begin, parameter_end) abort "{{{
  if len(a:parameter) < 2
    return 0
  endif
  " echom printf('mb, begin: %s, p[0]: %s, result: %d', a:parameter_begin, a:parameter[0], match(a:parameter_begin, a:parameter[0]) != -1)
  " echom printf('me, end: %s, p[-1]: %s, result: %d', a:parameter_end, a:parameter[-1], match(a:parameter_end, a:parameter[len(a:parameter)-1]) != -1)
  return match(a:parameter_begin, a:parameter[0]) != -1 &&
        \match(a:parameter_end, a:parameter[len(a:parameter)-1]) != -1
endfunction "}}}

function! cmp#complete(failed_insert) abort "{{{
  call <SID>trace_log(string(v:completed_item))
  if <SID>empty_completed_item()
    call <SID>debug_log('v:completed_item is empty')
    return <SID>failed_event(a:failed_insert)
  endif

  let filetype = &ft
  if empty(filetype)
    call <SID>debug_log('filetype is empty')
    return <SID>failed_event(a:failed_insert)
  endif

  try
    let ftfunc = cmp#new_ftfunc(filetype)
  catch
    call <SID>debug_log('new_ftfunc failed. '.string(v:exception))
    return <SID>failed_event(a:failed_insert)
  endtry
  if !cmp#filetype_func_check(ftfunc)
    call <SID>error_log('ftfunc check failed')
    return <SID>failed_event(a:failed_insert)
  endif


  " example: the complete func like this`func Hello(param1 int, param2 string) int`
  " the parsed must be a list and the element of the list is a dictional,
  " the dictional must have the below keys
  " text: the text to be complete -> `(param1, param2)`
  " delim: the delim of parameters -> `,`
  " prefix: the begin of text -> `(`
  " suffix: the end of the text -> `)`
  let parseds = ftfunc.parameters(v:completed_item)
  call <SID>debug_log(string(parseds))
  if type(parseds) != 3
    call <SID>error_log('return type error')
    return <SID>failed_event(a:failed_insert)
  endif

  let parameter_begin = ftfunc.parameter_begin()
  let parameter_end = ftfunc.parameter_end()

  if empty(parseds) || len(parseds[0]) < 2 || !cmp#check_parameter_return(parseds[0], parameter_begin, parameter_end)
    call <SID>debug_log("parseds is empty")
    return <SID>failed_event(a:failed_insert)
  endif

  let s:complete_parameter['index'] = 0
  let s:complete_parameter['items'] = parseds

  let s:complete_parameter['complete_pos'] = [line('.'), col('.')]
  let col = s:complete_parameter['complete_pos'][1]
  let s:complete_parameter['success'] = 1
  if get(g:, 'complete_parameter_echo_signature', 1)
    let s:complete_parameter['echos'] = ftfunc.echos(v:completed_item)
  endif

  " if the first char of parameter was inserted, remove it from the parameter
  let content = getline(line('.'))
  let parameter = s:complete_parameter['items'][0]
  if col > 1
    if content[col-2] ==# parameter[0]
      let parameter = substitute(parameter, '\m.\(.*\)', '\1', '')
      let s:complete_parameter['complete_pos'][1] = col - 1
    endif
  endif

  " must be insert mode
  " the cursor is in the last char+1,col('$')
  " we need the pass the last char col, so col('.')-1
  return cmp#goto_first_param(parameter, content, col('.')-1)
endfunction "}}}

function! cmp#goto_first_param(parameter, content, current_col) abort "{{{
  let old_ei = &ei
  set ei=InsertLeave,InsertEnter,TextChanged
  if s:complete_parameter['success']
    call <SID>trace_log(printf('content:[%s] current_col:%d, left:[%s], right:[%s]', a:content, a:current_col, a:content[:a:current_col-1], a:content[a:current_col:]))
    let content = a:content[:a:current_col-1] . a:parameter . a:content[a:current_col:]
    call <SID>trace_log("content: " . content)
    call <SID>trace_log("current_col: " . a:current_col)
    " the current_col is no in the `()`
    " show we need to add 1
    let keys = cmp#goto_next_param_keys(1, content, a:current_col+1)
    let keys = printf("%s\<ESC>%s", a:parameter, keys)
    call <SID>trace_log("keys: ". keys)

    let index = s:complete_parameter['index']
    if len(s:complete_parameter['echos']) > index && s:complete_parameter['echos'][index] !=# ''
      echon s:complete_parameter['echos'][index]
    endif
    let &ei=old_ei
    return keys
  else
    let &ei=old_ei
    return a:parameter
  endif
endfunction "}}}

function! cmp#goto_next_param_keys(forward, content, current_col) abort "{{{
  let filetype = &ft
  if empty(filetype)
    call <SID>debug_log('filetype is empty')
    return ''
  endif

  try
    let ftfunc = cmp#new_ftfunc(filetype)
  catch
    call <SID>debug_log('new ftfunc failed')
    return ''
  endtry
  if !cmp#filetype_func_check(ftfunc)
    return ''
  endif

  let step = a:forward ? 1 : -1

  let delim = ftfunc.parameter_delim()
  let border_begin = a:forward ? ftfunc.parameter_begin() : ftfunc.parameter_end()
  let border_end = a:forward ? ftfunc.parameter_end() : ftfunc.parameter_begin()

  " if in the insert mode
  " go back to the first none space
  " this can select the parameter after cursor
  let pos = a:current_col-1
  let scope_end = step > 0 ? -1 : len(a:content)
  if mode() ==# 'i'
    while pos != scope_end && 
          \(a:content[pos-1] =~# '['.delim.border_begin.']' || 
          \ a:content[pos-1] ==# ' ')
      let pos -= 1
      if a:content[pos] =~# '['.delim.border_begin.']'
        break
      endif
    endwhile
  endif

  let [word_begin, word_end] = cmp#parameter_position(a:content, pos+1, delim, border_begin, border_end, step)
  call <SID>trace_log(printf('content:[%s],current_col:%d,word_begin:%d,word_end:%d', a:content, a:current_col, word_begin, word_end))
  if word_begin == 0 && word_end == 0
    call <SID>debug_log('word_begin and word_end is 0')
    return ''
  endif
  let word_len = word_end - word_begin
  call <SID>trace_log('word_len:'.word_len)
  let keys = printf("\<ESC>0%dl", word_begin-2)
  if word_len == 0
    if a:forward
      return keys . "a\<RIGHT>"
    endif
  else
    let keys .= "lv"
    if &selection ==# 'exclusive'
      let right_len = word_len
    else
      let right_len = word_len - 1
    endif
    if right_len > 0
      let keys .= right_len
      let keys .= "l"
    endif
    let keys .= "\<C-G>"
    return keys
  endif
  return ''
endfunction "}}}

function! cmp#goto_next_param(forward) abort "{{{
  let s:log_index = <sid>timenow_ms()

  let filetype = &ft
  if empty(filetype)
    call <SID>debug_log('filetype is empty')
    return ''
  endif

  try
    let ftfunc = cmp#new_ftfunc(filetype)
  catch
    call <SID>debug_log('new ftfunc failed')
    return ''
  endtry
  if !cmp#filetype_func_check(ftfunc)
    return ''
  endif

  let step = a:forward ? 1 : -1

  let border_end = a:forward ? ftfunc.parameter_end() : ftfunc.parameter_begin()

  let lnum = line('.')
  let content = getline(lnum)
  let current_col = col('.')

  let pos = current_col - 1

  let parameter_delim = ftfunc.parameter_delim()
  if !a:forward && &selection==#'exclusive' && 
        \(match(parameter_delim, content[pos])!=-1 || 
        \ match(ftfunc.parameter_end(), content[pos])!=-1)
    let current_col -= 1
    let pos -= 1
  endif

  " if the selected is an object and the cursor char is an border_end
  " go back to border_begin and it can select the item in the object. 
  if mode() == 'n' && match(border_end, content[pos]) != -1
    normal %
    let current_col = col('.')
  endif


  let keys = cmp#goto_next_param_keys(a:forward, content, current_col)
  call feedkeys(keys, 'n')
  return ''
endfunction "}}}

" items: all overload complete function parameters
" current_line: current line content
" complete_pos: the pos where called complete
" forward: down or up
" [success, item, next_index, old_item_len]
function! cmp#next_overload_content(items, current_index, current_line, complete_pos, forward) abort "{{{
  if len(a:items) <= 1 || 
        \a:current_index >= len(a:items) || 
        \empty(a:current_line) || 
        \len(a:current_line) < a:complete_pos[1]
    return [0]
  endif

  let current_overload_len = len(a:items[a:current_index])

  let pos = a:complete_pos[1] - 1
  let pos_end = pos+current_overload_len-1
  let content = a:current_line[ pos : pos_end ]
  if content !=# a:items[a:current_index]
    return [0]
  endif
  let overload_len = len(a:items)
  if a:forward
    let next_index = (a:current_index + 1) % overload_len
  else
    let next_index = (a:current_index+overload_len-1)%overload_len
  endif
  return [1, a:items[next_index], next_index, len(a:items[a:current_index])]
endfunction "}}}

function! s:timenow_us()
  let t = reltime()
  return t[0] * 1000000 + t[1]
endfunction

function! s:timenow_ms()
  return <SID>timenow_us()
endfunction

function! cmp#overload_next(forward) abort "{{{
  let s:log_index = <SID>timenow_ms()

  let overload_len = len(s:complete_parameter['items'])
  if overload_len <= 1
    return
  endif
  let complete_pos = s:complete_parameter['complete_pos']
  let current_line = line('.')
  let current_col = col('.')
  " if no in the complete content
  " then return
  if current_line != complete_pos[0] || current_col < complete_pos[1]
    call <SID>trace_log('no more overload')
    return
  endif

  let current_index = s:complete_parameter['index']
  let current_line = getline(current_line)
  let result = cmp#next_overload_content(
        \s:complete_parameter['items'], 
        \current_index, 
        \current_line, 
        \s:complete_parameter['complete_pos'], 
        \a:forward)
  if result[0] == 0
    call <SID>debug_log('get overload content failed')
    return
  endif

  let current_overload_len = result[3]

  call cursor(complete_pos[0], complete_pos[1])
  call <sid>trace_log(printf('pos: %d %d', complete_pos[0], complete_pos[1]))

  exec 'normal! d'.current_overload_len.'l'

  let next_content = result[1]

  let s:complete_parameter['index'] = result[2]
  let s:complete_parameter['success'] = 1
  let content = getline(line('.'))
  let current_col = col('.')
  let insert_method = 'a'
  if current_col != col('$')-1
    " if no the last char
    " the cursor in the last complete char+1
    " we need to -1
    let current_col -= 1
    let insert_method = 'i'
  endif
  let ret = insert_method.cmp#goto_first_param(next_content, content, current_col)
  call <SID>trace_log(ret)
  call feedkeys(ret, 'n')
endfunction "}}}

let s:stack = {'data':[]}

function! s:new_stack() abort "{{{
  return deepcopy(s:stack)
endfunction "}}}

function! s:stack.push(e) abort dict "{{{
  call add(self.data, a:e)
endfunction "}}}

function! s:stack.len() abort dict "{{{
  return len(self.data)
endfunction "}}}

function! s:stack.empty() abort dict "{{{
  return self.len() == 0
endfunction "}}}

function! s:stack.top() abort dict "{{{
  if self.empty()
    throw "stack is empty"
  endif
  return self.data[-1]
endfunction "}}}

function! s:stack.pop() abort dict "{{{
  if self.empty()
    throw "stack is empty"
  endif
  call remove(self.data, -1)
endfunction "}}}

function! s:stack.str() abort dict "{{{
  let str = 'stack size:'.self.len()
  for d in self.data
    let str .= "\n"
    let str .= 'stack elem:'.d
  endfor
  return str
endfunction "}}}

function! s:in_scope(content, pos, border, step, end) abort "{{{
  " echom printf('content: %s, pos: %d, border: %s, step: %d, end: %d', a:content, a:pos, a:border, a:step, a:end)
  let i = a:pos
  while i != a:end
    if a:content[i] =~# '\m['.a:border.']'
      return 1
    endif
    let i += a:step
  endwhile
  return 0
endfunction "}}}

function! cmp#jumpable(forward) abort "{{{ can jump to next parameter or not
  let filetype = &ft
  try
    let ftfunc = cmp#new_ftfunc(filetype)
  catch
    call <SID>debug_log('new ftfunc failed')
    return 0
  endtry
  if !cmp#filetype_func_check(ftfunc)
    call <SID>debug_log('func check failed')
    return 0
  endif

  let delim = ftfunc.parameter_delim()
  let border = a:forward > 0 ? ftfunc.parameter_begin() : ftfunc.parameter_end()
  let step = a:forward > 0 ? -1 : 1

  let lnum = line('.')
  let content = getline(lnum)
  let current_pos = col('.') - 1

  let end = a:forward > 0 ? -1 : len(content)
  return <SID>in_scope(content, current_pos, border, step, end)
endfunction "}}}

" content: string, the content to parse
" current_col: int, current col
" delim:  string, split the paramter letter
" return: [int, int] begin_col, end_col
"
" col: base 1
" pos: base 0
function! cmp#parameter_position(content, current_col, delim, border_begin, border_end, step) abort "{{{
  "{{{2
  if empty(a:content) || 
        \a:current_col==0 ||
        \empty(a:delim) ||
        \empty(a:border_begin) ||
        \empty(a:border_end) ||
        \len(a:border_begin) != len(a:border_end) ||
        \a:step==0
    call <SID>debug_log('parameter_position param error')
    return [0, 0]
  endif "}}}2
  let step = a:step > 0 ? 1 : -1
  let current_pos = a:current_col - 1
  let content_len = len(a:content)
  let end = a:step > 0 ? content_len : -1
  if current_pos >= content_len
    let current_pos = content_len-1
  endif

  " check current pos is in the scope or not
  let scope_end = step > 0 ? -1 : content_len
  if !<SID>in_scope(a:content, current_pos, a:border_begin, -step, scope_end)
    call <SID>trace_log(printf("no in scope, content: %s, current_pos: %d, a:border_begin: %s, step: %d, scope_end: %d", a:content, current_pos, a:border_begin, -step, scope_end))
    retur [0, 0]
  endif

  let stack = <SID>new_stack()
  let pos = current_pos

  let border_matcher = {}
  let border_begin_chars = split(a:border_begin, '\zs')
  let border_end_chars = split(a:border_end, '\zs')
  let i = 0
  while i < len(border_end_chars)
    let border_matcher[border_begin_chars[i]] = '\m['.a:delim.border_end_chars[i].']'
    let i += 1
  endwhile

  " let border_matcher[a:border_begin] = '\m['.a:delim.a:border_end.']'
  let border_matcher[a:delim] = '\m['.a:delim.a:border_end.']'
  let border_matcher['"'] = '"'
  let border_matcher["'"] = "'"
  let border_matcher["`"] = "`"
  let begin_pos = 0
  let end_pos = 0

  " check has previous quote
  let quote_test_content_pos = pos
  if a:content[quote_test_content_pos] =~# '\m["''`]'
    let quote_test_content_pos -= step
  endif
  let quote_test_content = a:content[:quote_test_content_pos]
  let quote_test_content = substitute(quote_test_content, '\m\\.', '', 'g')
  let quote_test_content = substitute(quote_test_content, '\m[^"''`]', '', 'g')
  let quotes = split(quote_test_content, '\zs')
  for quote in quotes
    if stack.empty()
      call stack.push(quote)
    elseif border_matcher[stack.top()] ==# quote
      call stack.pop()
    endif
  endfor

  while pos != end "{{{2
    if step < 0
      if pos + step != end && a:content[pos+step] == '\'
        let pos += 2*step 
        continue
      endif
    endif

    " if top of stack is quote and current letter is not a quote
    " the letter should be ignore
    if !stack.empty() && stack.top() =~# '\m["`'']' && a:content[pos] !~# '\m["`''\\]'
      let pos += step
      continue
    endif

    if a:content[pos] ==# '"' || a:content[pos] ==# "'" || a:content[pos] ==# '`'
      if stack.empty() || border_matcher[stack.top()] !=# a:content[pos]
        call stack.push(a:content[pos])
      else
        call stack.pop()
      endif
    elseif a:content[pos] ==# '\'
      let pos += step
    elseif a:content[pos] ==# '='
      if step > 0
        if stack.len() > 1
          " if stack more than 1, current maybe in the nest scope, ignore it
          let pos += step 
          continue
        endif
        let pos += step
        let pos = <SID>find_first_not_space(a:content, pos, end, step)
        if pos == end
          break
        endif
        let begin_pos = pos
        if stack.len() == 0
          " let = as a delim, it's the next begining
          call stack.push(a:delim[0])
        endif
        continue
      else
        " backword
        " if stack is empty, we need to find the first begin or delim
        " if stack more than 1, current maybe in the nest scope, ignore it
        if stack.len() != 1 
          let pos += step
          continue
        else
          " if stack len is 1, and current pos must be want to select
          break
        endif
      endif
    elseif stridx(a:border_begin, a:content[pos]) != -1
      if a:content[pos] ==# '>' && step < 0
        " check if there are is a '<' or not
        let tmppos = pos + step
        while tmppos >= 0 && a:content[tmppos] !=# '<'
          let tmppos += step
        endwhile
        if tmppos < 0
          let pos += step
          continue
        endif
      endif

      call stack.push(a:content[pos])
      if stack.len() == 1
        " begin
        let pos += step
        let pos = <SID>find_first_not_space(a:content, pos, end, step)
        if pos == end
          break
        endif
        let begin_pos = pos
        " no need to step forward
        " goto the beginning of the loop
        continue
      endif
    elseif a:content[pos] ==# a:delim
      if stack.empty()
        call stack.push(a:content[pos])
        let pos += step
        let pos = <SID>find_first_not_space(a:content, pos, end, step)
        if pos == end
          break
        endif
        let begin_pos = pos
        " no need to step forward
        " goto the beginning of the loop
        continue
      elseif stack.len() == 1 && a:content[pos] =~# border_matcher[stack.top()]
        call stack.pop()
        if stack.empty()
          " match delim
          break
        endif
      endif
    elseif stridx(a:border_end, a:content[pos]) != -1
      if a:content[pos] ==# '<' && step > 0
        " check if there are is a '>' or not
        let tmppos = pos + step
        while tmppos < content_len && a:content[tmppos] !=# '>'
          let tmppos += step
        endwhile
        if tmppos >= content_len
          let pos += step
          continue
        endif
      endif

      if stack.empty()
        let begin_pos = pos
        let end_pos = pos
      else
        if a:content[pos] =~# border_matcher[stack.top()]
          " border match, then pop
          call stack.pop()
          if stack.empty()
            " match delim
            break
          endif
        endif
      endif
    endif
    let pos += step
  endwhile "}}}2
  if pos == end
    if begin_pos != 0 && end_pos != 0
      return [begin_pos+1,end_pos+1]
    else
      return [0, 0]
    endif
  endif

  if begin_pos != pos
    let pos -= step
    " find previous no space
    while pos != begin_pos && a:content[pos] =~# '\s'
      let pos -= step
    endwhile
  endif

  let end_pos = pos
  if begin_pos == end_pos && stridx(a:border_end, a:content[end_pos]) != -1
    return [begin_pos+1, end_pos+1]
  endif

  if end_pos < begin_pos
    let [begin_pos, end_pos] = [end_pos, begin_pos]
  endif
  return [begin_pos+1, end_pos+2]
endfunction "}}}

function! s:find_first_not_space(content, pos, end, step) abort "{{{
  let pos = a:pos
  if pos == -1 ||
        \pos==len(a:content)
    return pos == a:end
  endif
  if a:step == 0
    throw 'step is 0'
  endif
  while pos != a:end && a:content[pos] =~# '\s'
    let pos += a:step
  endwhile
  return pos
endfunction "}}}

function! s:log(level, msg) abort "{{{
  echom printf("[CompleteParameter][%s][%s][%d] %s", strftime("%T"), a:level, s:log_index, a:msg)
endfunction "}}}

function! s:error_log(msg) abort "{{{
  if g:complete_parameter_log_level <= 4
    echohl ErrorMsg 
    call <SID>log('ERROR', a:msg)
    echohl None
  endif
endfunction "}}}

function! s:debug_log(msg) abort "{{{
  if g:complete_parameter_log_level <= 2
    call <SID>log('DEBUG', a:msg)
  endif
endfunction "}}}

function! s:trace_log(msg) abort "{{{
  if g:complete_parameter_log_level <= 1
    call <SID>log('TRACE', a:msg)
  endif
endfunction "}}}


