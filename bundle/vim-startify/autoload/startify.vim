" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-startify
" Description: A fancy start screen for Vim.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists('g:autoloaded_startify') || &compatible
  finish
endif
let g:autoloaded_startify = 1

" Function: #get_lastline {{{1
function! startify#get_lastline() abort
  return b:startify.lastline + 1
endfunction

" Function: #get_separator {{{1
function! startify#get_separator() abort
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction

" Function: #get_session_path {{{1
function! startify#get_session_path() abort
  if exists('g:startify_session_dir')
    let path = g:startify_session_dir
  elseif has('nvim')
    let path = has('nvim-0.3.1')
          \ ? stdpath('data').'/session'
          \ : has('win32')
          \   ? '~/AppData/Local/nvim-data/session'
          \   : '~/.local/share/nvim/session'
  else " Vim
    let path = has('win32')
          \ ? '~/vimfiles/session'
          \ : '~/.vim/session'
  endif

  return resolve(expand(path))
endfunction

" Function: #insane_in_the_membrane {{{1
function! startify#insane_in_the_membrane(on_vimenter) abort
  " Handle vim -y, vim -M.
  if a:on_vimenter && (&insertmode || !&modifiable)
    return
  endif

  if !&hidden && &modified
    call s:warn('Save your changes first.')
    return
  endif

  if !empty(v:servername) && exists('g:startify_skiplist_server')
    for servname in g:startify_skiplist_server
      if servname == v:servername
        return
      endif
    endfor
  endif

  if line2byte('$') != -1
    noautocmd enew
  endif

  silent! setlocal
        \ bufhidden=wipe
        \ colorcolumn=
        \ foldcolumn=0
        \ matchpairs=
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ nonumber
        \ norelativenumber
        \ nospell
        \ noswapfile
        \ signcolumn=no
        \ synmaxcol&
  if empty(&statusline)
    setlocal statusline=\ startify
  endif

  " Must be global so that it can be read by syntax/startify.vim.
  let g:startify_header = exists('g:startify_custom_header')
        \ ? s:set_custom_section(g:startify_custom_header)
        \ : (exists('*strwidth') ? startify#pad(startify#fortune#cowsay()) : [])
  if !empty(g:startify_header)
    let g:startify_header += ['']  " add blank line
  endif
  call append('$', g:startify_header)

  let b:startify = {
        \ 'entries':   {},
        \ 'indices':   [],
        \ 'leftmouse': 0,
        \ 'tick':      0,
        \ }

  if s:show_special
    call append('$', [s:padding_left .'[e]  <empty buffer>', ''])
  endif
  call s:register(line('$')-1, 'e', 'special', 'enew', '')

  let b:startify.entry_number = 0
  if filereadable('Session.vim')
    call append('$', [s:padding_left .'[0]  '. getcwd() . s:sep .'Session.vim', ''])
    call s:register(line('$')-1, '0', 'session',
          \ 'call startify#session_delete_buffers() | source', 'Session.vim')
    let b:startify.entry_number = 1
    let l:show_session = 1
  endif

  if empty(v:oldfiles)
    call s:warn("Can't read viminfo file. Read :help startify-faq-02")
  endif

  let b:startify.section_header_lines = []

  let lists = s:get_lists()
  call s:show_lists(lists)

  silent $delete _

  if s:show_special
    call append('$', ['', s:padding_left .'[q]  <quit>'])
    call s:register(line('$'), 'q', 'special', 'call s:close()', '')
  else
    " Don't overwrite the last regular entry, thus +1
    call s:register(line('$')+1, 'q', 'special', 'call s:close()', '')
  endif

  " compute first line offset
  let b:startify.firstline = 2
  let b:startify.firstline += len(g:startify_header)
  " no special, no local Session.vim, but a section header
  if !s:show_special && !exists('l:show_session') && has_key(lists[0], 'header')
    let b:startify.firstline += len(lists[0].header) + 1
  endif

  let b:startify.lastline = line('$')

  let footer = exists('g:startify_custom_footer')
        \ ? s:set_custom_section(g:startify_custom_footer)
        \ : []
  if !empty(footer)
    let footer = [''] + footer
  endif
  call append('$', footer)

  setlocal nomodifiable nomodified

  call s:set_mappings()
  call cursor(b:startify.firstline, 5)
  autocmd startify CursorMoved <buffer> call s:set_cursor()

  silent! %foldopen!
  normal! zb
  set filetype=startify

  if exists('##DirChanged')
    let b:startify.cwd = getcwd()
    autocmd startify DirChanged <buffer> if getcwd() !=# get(get(b:, 'startify', {}), 'cwd') | Startify | endif
  endif
  if exists('#User#Startified')
    doautocmd <nomodeline> User Startified
  endif
  if exists('#User#StartifyReady')
    doautocmd <nomodeline> User StartifyReady
  endif
endfunction

" Function: #session_load {{{1
function! startify#session_load(source_last_session, ...) abort
  if !isdirectory(s:session_dir)
    echomsg 'The session directory does not exist: '. s:session_dir
    return
  elseif empty(startify#session_list_as_string(''))
    echomsg 'There are no sessions...'
    return
  endif

  let session_path = s:session_dir . s:sep

  if a:0
    let session_path .= a:1
  elseif a:source_last_session && !has('win32')
    let session_path .= '__LAST__'
  else
    call inputsave()
    let session_path .= input(
          \ 'Load this session: ',
          \ fnamemodify(v:this_session, ':t'),
          \ 'custom,startify#session_list_as_string') | redraw
    call inputrestore()
  endif

  if filereadable(session_path)
    if get(g:, 'startify_session_persistence') && filewritable(v:this_session)
      call startify#session_write(fnameescape(v:this_session))
    endif
    call startify#session_delete_buffers()
    execute 'source '. fnameescape(session_path)
    call s:create_last_session_link(session_path)
  else
    echo 'No such file: '. session_path
  endif
endfunction

" Function: #session_save {{{1
function! startify#session_save(bang, ...) abort
  if !isdirectory(s:session_dir)
    if exists('*mkdir')
      echo 'The session directory does not exist: '. s:session_dir .'. Create it?  [y/n]'
      if (nr2char(getchar()) == 'y')
        call mkdir(s:session_dir, 'p')
      else
        echo
        return
      endif
    else
      echo 'The session directory does not exist: '. s:session_dir
      return
    endif
  endif

  call inputsave()
  let this_session = fnamemodify(v:this_session, ':t')
  if this_session ==# '__LAST__'
    let this_session = ''
  endif
  let session_name = exists('a:1')
        \ ? a:1
        \ : input('Save under this session name: ', this_session, 'custom,startify#session_list_as_string') | redraw
  call inputrestore()

  if empty(session_name)
    echo 'You gave an empty name!'
    return
  endif

  let session_path = s:session_dir . s:sep . session_name
  if !filereadable(session_path)
    call startify#session_write(fnameescape(session_path))
    echo 'Session saved under: '. session_path
    return
  endif

  echo 'Session already exists. Overwrite?  [y/n]' | redraw
  if a:bang || nr2char(getchar()) == 'y'
    call startify#session_write(fnameescape(session_path))
    echo 'Session saved under: '. session_path
  else
    echo 'Did NOT save the session!'
  endif
endfunction

" Function: #session_close {{{1
function! startify#session_close() abort
  if exists('v:this_session') && filewritable(v:this_session)
    call startify#session_write(fnameescape(v:this_session))
    let v:this_session = ''
  endif
  call startify#session_delete_buffers()
  Startify
endfunction

" Function: #session_write {{{1
function! startify#session_write(session_path)
  " preserve existing variables from savevars
  if exists('g:startify_session_savevars')
    let savevars = map(filter(copy(g:startify_session_savevars), 'exists(v:val)'), '"let ". v:val ." = ". strtrans(string(eval(v:val)))')
  endif

  " if this function is called while being in the Startify buffer
  " (by loading another session or running :SSave/:SLoad directly)
  " switch back to the previous buffer before saving the session
  if &filetype == 'startify'
    let callingbuffer = bufnr('#')
    if callingbuffer > 0
      execute 'buffer' callingbuffer
    endif
  endif
  " prevent saving already deleted buffers that were in the arglist
  for arg in argv()
    if !buflisted(arg)
      execute 'silent! argdelete' fnameescape(arg)
    endif
  endfor
  " clean up session before saving it
  for cmd in get(g:, 'startify_session_before_save', [])
    execute cmd
  endfor

  let ssop = &sessionoptions
  set sessionoptions-=options
  try
    execute 'mksession!' a:session_path
  catch
    echohl ErrorMsg
    echomsg v:exception
    echohl NONE
    return
  finally
    let &sessionoptions = ssop
  endtry

  if exists('g:startify_session_remove_lines')
        \ || exists('g:startify_session_savevars')
        \ || exists('g:startify_session_savecmds')
    silent execute 'split' a:session_path

    " remove lines from the session file
    if exists('g:startify_session_remove_lines')
      for pattern in g:startify_session_remove_lines
        execute 'silent global/'. pattern .'/delete _'
      endfor
    endif

    " put variables from savevars into session file
    if exists('savevars') && !empty(savevars)
      call append(line('$')-3, savevars)
    endif

    " put commands from savecmds into session file
    if exists('g:startify_session_savecmds')
      call append(line('$')-3, g:startify_session_savecmds)
    endif

    setlocal bufhidden=delete
    silent update
    silent hide
  endif

  call s:create_last_session_link(a:session_path)
endfunction

" Function: #session_delete {{{1
function! startify#session_delete(bang, ...) abort
  if !isdirectory(s:session_dir)
    echo 'The session directory does not exist: '. s:session_dir
    return
  elseif empty(startify#session_list_as_string(''))
    echo 'There are no sessions...'
    return
  endif

  call inputsave()
  let session_path = s:session_dir . s:sep . (exists('a:1')
        \ ? a:1
        \ : input('Delete this session: ', fnamemodify(v:this_session, ':t'), 'custom,startify#session_list_as_string'))
  call inputrestore()

  if !filereadable(session_path)
    redraw | echo 'No such session: '. session_path
    return
  endif

  redraw | echo 'Really delete '. session_path .'? [y/n]' | redraw
  if a:bang || nr2char(getchar()) == 'y'
    if delete(session_path) == 0
      echo 'Deleted session '. session_path .'!'
    else
      echo 'Deletion failed!'
    endif
  else
    echo 'Deletion aborted!'
  endif
endfunction

" Function: #session_delete_buffers {{{1
function! startify#session_delete_buffers()
  if get(g:, 'startify_session_delete_buffers', 1)
    silent! %bdelete!
  endif
endfunction

" Function: #session_list {{{1
function! startify#session_list(lead, ...) abort
  return filter(map(split(globpath(s:session_dir, '*'.a:lead.'*'), '\n'), 'fnamemodify(v:val, ":t")'), 'v:val !=# "__LAST__"')
endfunction

" Function: #session_list_as_string {{{1
function! startify#session_list_as_string(lead, ...) abort
  return join(filter(map(split(globpath(s:session_dir, '*'.a:lead.'*'), '\n'), 'fnamemodify(v:val, ":t")'), 'v:val !=# "__LAST__"'), "\n")
endfunction

" Function: #debug {{{1
function! startify#debug()
  if exists('b:startify.entries')
    for k in sort(keys(b:startify.entries))
      echomsg '['. k .'] = '. string(b:startify.entries[k])
    endfor
  else
    call s:warn('This is no Startify buffer!')
  endif
endfunction

" Function: #open_buffers {{{1
function! startify#open_buffers(...) abort
  if exists('a:1')  " used in mappings
    let entry = b:startify.entries[a:1]
    if !empty(s:batchmode) && entry.type == 'file'
      call startify#set_mark(s:batchmode, a:1)
    else
      call s:open_buffer(entry)
    endif
    return
  endif

  let marked = filter(copy(b:startify.entries), 'v:val.marked')
  if empty(marked)  " open current entry
    call s:open_buffer(b:startify.entries[line('.')])
    return
  endif

  enew
  setlocal nobuflisted

  " Open all marked entries.
  for entry in sort(values(marked), 's:sort_by_tick')
    call s:open_buffer(entry)
  endfor

  wincmd =

  if exists('#User#StartifyAllBuffersOpened')
    doautocmd <nomodeline> User StartifyAllBuffersOpened
  endif
endfunction

" Function: #pad {{{1
function! startify#pad(lines) abort
  return map(copy(a:lines), 's:padding_left . v:val')
endfunction

" Function: #center {{{1
function! startify#center(lines) abort
  let longest_line = max(map(copy(a:lines), 'strwidth(v:val)'))
  return map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2) - 1) . v:val')
endfunction

" Function: s:get_lists {{{1
function! s:get_lists() abort
  if exists('g:startify_lists')
    return g:startify_lists
  elseif exists('g:startify_list_order')
    " Convert old g:startify_list_order format to newer g:startify_lists format.
    let lists = []
    for item in g:startify_list_order
      if type(item) == type([])
        let header = item
      else
        if exists('header')
          let lists += [{ 'type': item, 'header': header }]
          unlet header
        else
          let lists += [{ 'type': item }]
        endif
      endif
      unlet item
    endfor
    return lists
  else
    return [
          \ { 'header': [s:padding_left .'MRU'],            'type': 'files' },
          \ { 'header': [s:padding_left .'MRU '. getcwd()], 'type': 'dir' },
          \ { 'header': [s:padding_left .'Sessions'],       'type': 'sessions' },
          \ { 'header': [s:padding_left .'Bookmarks'],      'type': 'bookmarks' },
          \ { 'header': [s:padding_left .'Commands'],       'type': 'commands' },
          \ ]
  endif
endfunction

" Function: s:show_lists {{{1
function! s:show_lists(lists) abort
  for list in a:lists
    if !has_key(list, 'type')
      continue
    endif

    let b:startify.indices = copy(get(list, 'indices', []))

    if type(list.type) == type('')
      if has_key(list, 'header')
        let s:last_message = list.header
      endif
      call s:show_{list.type}()
    elseif type(list.type) == type(function('tr'))
      try
        let entries = list.type()
      catch
        call s:warn(v:exception)
        continue
      endtry
      if empty(entries)
        unlet! s:last_message
        continue
      endif

      if has_key(list, 'header')
        let s:last_message = list.header
        call s:print_section_header()
      endif

      for entry in entries
        let cmd  = get(entry, 'cmd', 'edit')
        let path = get(entry, 'path', '')
        let type = get(entry, 'type', empty(path) ? 'special' : 'file')
        let index = s:get_index_as_string()
        call append('$', s:padding_left .'['. index .']'. repeat(' ', (3 - strlen(index))) . entry.line)
        call s:register(line('$'), index, type, cmd, path)
      endfor
      call append('$', '')
    else
      call s:warn('Wrong format for g:startify_lists: '. string(list))
    endif
  endfor
endfunction

" Function: s:open_buffer {{{1
function! s:open_buffer(entry)
  if a:entry.type == 'special'
    execute a:entry.cmd
  elseif a:entry.type == 'session'
    execute a:entry.cmd a:entry.path
  elseif a:entry.type == 'file'
    if line2byte('$') == -1
      execute 'edit' a:entry.path
    else
      if a:entry.cmd == 'tabnew'
        wincmd =
      endif
      execute a:entry.cmd a:entry.path
    endif
    call s:check_user_options(a:entry.path)
  endif
  if exists('#User#StartifyBufferOpened')
    doautocmd <nomodeline> User StartifyBufferOpened
  endif
endfunction

" Function: s:set_custom_section {{{1
function! s:set_custom_section(section) abort
  if type(a:section) == type([])
    return copy(a:section)
  elseif type(a:section) == type('')
    return empty(a:section) ? [] : eval(a:section)
  endif
  return []
endfunction

" Function: s:display_by_path {{{1
function! s:display_by_path(path_prefix, path_format, use_env) abort
  let oldfiles = call(get(g:, 'startify_enable_unsafe') ? 's:filter_oldfiles_unsafe' : 's:filter_oldfiles',
        \ [a:path_prefix, a:path_format, a:use_env])

  let entry_format = "s:padding_left .'['. index .']'. repeat(' ', (3 - strlen(index))) ."
  if exists('*StartifyEntryFormat')
    let entry_format .= StartifyEntryFormat()
  else
    let entry_format .= 'entry_path'
  endif

  if !empty(oldfiles)
    if exists('s:last_message')
      call s:print_section_header()
    endif

    for [absolute_path, entry_path] in oldfiles
      let index = s:get_index_as_string()
      call append('$', eval(entry_format))
      if has('win32')
        let absolute_path = substitute(absolute_path, '\[', '\[[]', 'g')
      endif
      call s:register(line('$'), index, 'file', 'edit', absolute_path)
    endfor

    call append('$', '')
  endif
endfunction

" Function: s:filter_oldfiles {{{1
function! s:filter_oldfiles(path_prefix, path_format, use_env) abort
  let path_prefix = '\V'. escape(a:path_prefix, '\')
  let counter     = s:numfiles
  let entries     = {}
  let oldfiles    = []

  for fname in v:oldfiles
    if counter <= 0
      break
    endif

    if s:is_in_skiplist(fname)
      " https://github.com/mhinz/vim-startify/issues/353
      continue
    endif

    let absolute_path = fnamemodify(resolve(fname), ":p")
    " filter duplicates, bookmarks and entries from the skiplist
    if has_key(entries, absolute_path)
          \ || !filereadable(absolute_path)
          \ || s:is_in_skiplist(absolute_path)
          \ || match(absolute_path, path_prefix)
      continue
    endif

    let entry_path = ''
    if s:tf
      let entry_path = s:transform(absolute_path)
    endif
    if empty(entry_path)
      let entry_path = fnamemodify(absolute_path, a:path_format)
    endif

    let entries[absolute_path]  = 1
    let counter                -= 1
    let oldfiles += [[fnameescape(absolute_path), entry_path]]
  endfor

  if a:use_env
    call s:init_env()
    for i in range(len(oldfiles))
      for [k,v] in s:env
        let p = oldfiles[i][0]
        if !stridx(tolower(p), tolower(v))
          let oldfiles[i][1] = printf('$%s%s', k, p[len(v):])
          break
        endif
      endfor
    endfor
  endif

  return oldfiles
endfunction

" Function: s:filter_oldfiles_unsafe {{{1
function! s:filter_oldfiles_unsafe(path_prefix, path_format, use_env) abort
  let path_prefix = '\V'. escape(a:path_prefix, '\')
  let counter     = s:numfiles
  let entries     = {}
  let oldfiles    = []
  let is_dir      = escape(s:sep, '\') . '$'

  for fname in v:oldfiles
    if counter <= 0
      break
    endif

    if s:is_in_skiplist(fname)
      " https://github.com/mhinz/vim-startify/issues/353
      continue
    endif

    let absolute_path = glob(fnamemodify(fname, ":p"))
    if empty(absolute_path)
          \ || has_key(entries, absolute_path)
          \ || (absolute_path =~ is_dir)
          \ || match(absolute_path, path_prefix)
          \ || s:is_in_skiplist(absolute_path)
      continue
    endif

    let entry_path              = fnamemodify(absolute_path, a:path_format)
    let entries[absolute_path]  = 1
    let counter                -= 1
    let oldfiles               += [[fnameescape(absolute_path), entry_path]]
  endfor

  return oldfiles
endfunction

" Function: s:show_dir {{{1
function! s:show_dir() abort
  return s:display_by_path(getcwd() . s:sep, ':.', 0)
endfunction

" Function: s:show_files {{{1
function! s:show_files() abort
  return s:display_by_path('', s:relative_path, get(g:, 'startify_use_env'))
endfunction

" Function: s:show_sessions {{{1
function! s:show_sessions() abort
  let limit = get(g:, 'startify_session_number', 999) - 1
  if limit <= -1
    return
  endif

  let sfiles = split(globpath(s:session_dir, '*'), '\n')
  let sfiles = filter(sfiles, 'v:val !~# "__LAST__$"')
  let sfiles = filter(sfiles,
        \ '!(v:val =~# "x\.vim$" && index(sfiles, v:val[:-6].".vim") >= 0)')
  if empty(sfiles)
    if exists('s:last_message')
      unlet s:last_message
    endif
    return
  endif

  if exists('s:last_message')
    call s:print_section_header()
  endif

  if get(g:, 'startify_session_sort')
    function! s:sort_by_mtime(foo, bar)
      let foo = getftime(a:foo)
      let bar = getftime(a:bar)
      return foo == bar ? 0 : (foo < bar ? 1 : -1)
    endfunction
    call sort(sfiles, 's:sort_by_mtime')
  endif

  for i in range(len(sfiles))
    let index = s:get_index_as_string()
    let fname = fnamemodify(sfiles[i], ':t')
    let dname = sfiles[i] ==# v:this_session ? fname.' (*)' : fname
    call append('$', s:padding_left .'['. index .']'. repeat(' ', (3 - strlen(index))) . dname)
    if has('win32')
      let fname = substitute(fname, '\[', '\[[]', 'g')
    endif
    call s:register(line('$'), index, 'session', 'SLoad', fname)
    if i == limit
      break
    endif
  endfor

  call append('$', '')
endfunction

" Function: s:show_bookmarks {{{1
function! s:show_bookmarks() abort
  if !exists('g:startify_bookmarks') || empty(g:startify_bookmarks)
    return
  endif

  if exists('s:last_message')
    call s:print_section_header()
  endif

  for bookmark in g:startify_bookmarks
    if type(bookmark) == type({})
      let [index, path] = items(bookmark)[0]
    else  " string
      let [index, path] = [s:get_index_as_string(), bookmark]
    endif

    let entry_path = ''
    if s:tf
      let entry_path = s:transform(fnamemodify(resolve(expand(path)), ':p'))
    endif
    if empty(entry_path)
      let entry_path = path
    endif
    call append('$', s:padding_left .'['. index .']'. repeat(' ', (3 - strlen(index))) . entry_path)

    if has('win32')
      let path = substitute(path, '\[', '\[[]', 'g')
    endif
    call s:register(line('$'), index, 'file', 'edit', fnameescape(expand(path)))

    unlet bookmark  " avoid type mismatch for heterogeneous lists
  endfor

  call append('$', '')
endfunction

" Function: s:show_commands {{{1
function! s:show_commands() abort
  if !exists('g:startify_commands') || empty(g:startify_commands)
    return
  endif

  if exists('s:last_message')
    call s:print_section_header()
  endif

  for entry in g:startify_commands
    if type(entry) == type({})  " with custom index
      let [index, command] = items(entry)[0]
    else
      let command = entry
      let index = s:get_index_as_string()
    endif
    " If no list is given, the description is the command itself.
    let [desc, cmd] = type(command) == type([]) ? command : [command, command]

    call append('$', s:padding_left .'['. index .']'. repeat(' ', (3 - strlen(index))) . desc)
    call s:register(line('$'), index, 'special', cmd, '')

    unlet entry command
  endfor

  call append('$', '')
endfunction

" Function: s:is_in_skiplist {{{1
function! s:is_in_skiplist(arg) abort
  for regexp in s:skiplist
    try
      if a:arg =~# regexp
        return 1
      endif
    catch
      call s:warn('Pattern '. string(regexp) .' threw an exception. Read :help g:startify_skiplist')
    endtry
  endfor
endfunction

" Function: s:set_cursor {{{1
function! s:set_cursor() abort
  let b:startify.oldline = exists('b:startify.newline') ? b:startify.newline : 2 + len(s:padding_left)
  let b:startify.newline = line('.')

  " going up (-1) or down (1)
  if b:startify.oldline == b:startify.newline
        \ && col('.') != s:fixed_column
        \ && !b:startify.leftmouse
    let movement = 2 * (col('.') > s:fixed_column) - 1
    let b:startify.newline += movement
  else
    let movement = 2 * (b:startify.newline > b:startify.oldline) - 1
    let b:startify.leftmouse = 0
  endif

  " skip section headers lines until an entry is found
  while index(b:startify.section_header_lines, b:startify.newline) != -1
    let b:startify.newline += movement
  endwhile

  " skip blank lines between lists
  if empty(getline(b:startify.newline))
    let b:startify.newline += movement
  endif

  " don't go beyond first or last entry
  let b:startify.newline = max([b:startify.firstline, min([b:startify.lastline, b:startify.newline])])

  call cursor(b:startify.newline, s:fixed_column)
endfunction

" Function: s:set_mappings {{{1
function! s:set_mappings() abort
  nnoremap <buffer><nowait><silent> i             :enew <bar> startinsert<cr>
  nnoremap <buffer><nowait><silent> <insert>      :enew <bar> startinsert<cr>
  nnoremap <buffer><nowait><silent> b             :call startify#set_mark('B')<cr>
  nnoremap <buffer><nowait><silent> s             :call startify#set_mark('S')<cr>
  nnoremap <buffer><nowait><silent> t             :call startify#set_mark('T')<cr>
  nnoremap <buffer><nowait><silent> v             :call startify#set_mark('V')<cr>
  nnoremap <buffer><nowait><silent> B             :call startify#set_batchmode('B')<cr>
  nnoremap <buffer><nowait><silent> S             :call startify#set_batchmode('S')<cr>
  nnoremap <buffer><nowait><silent> T             :call startify#set_batchmode('T')<cr>
  nnoremap <buffer><nowait><silent> V             :call startify#set_batchmode('V')<cr>
  nnoremap <buffer><nowait><silent> <cr>          :call startify#open_buffers()<cr>
  nnoremap <buffer><nowait><silent> <LeftMouse>   :call <sid>leftmouse()<cr>
  nnoremap <buffer><nowait><silent> <2-LeftMouse> :call startify#open_buffers()<cr>
  nnoremap <buffer><nowait><silent> <MiddleMouse> :enew <bar> execute 'normal! "'.(v:register=='"'?'*':v:register).'gp'<cr>

  " Without these mappings n/N wouldn't work properly, since autocmds always
  " force the cursor back on the index.
  nnoremap <buffer><expr> n ' j'[v:searchforward].'n'
  nnoremap <buffer><expr> N 'j '[v:searchforward].'N'

  function! s:leftmouse()
    " feedkeys() triggers CursorMoved which calls s:set_cursor() which checks
    " .leftmouse.
    let b:startify.leftmouse = 1
    call feedkeys("\<LeftMouse>", 'nt')
  endfunction

  function! s:compare_by_index(foo, bar)
    return a:foo.index - a:bar.index
  endfunction

  for entry in sort(values(b:startify.entries), 's:compare_by_index')
    execute 'nnoremap <buffer><silent><nowait>' entry.index
          \ ':call startify#open_buffers('. string(entry.line) .')<cr>'
  endfor
endfunction

" Function: #set_batchmode {{{1
function! startify#set_batchmode(batchmode) abort
  let s:batchmode = (a:batchmode == s:batchmode) ? '' : a:batchmode
  echo empty(s:batchmode) ? 'Batchmode off' : 'Batchmode: '. s:batchmode
endfunction

" Function: #set_mark {{{1
function! startify#set_mark(type, ...) abort
  if a:0
    let entryline = a:1
  else
    call startify#set_batchmode('')
    let entryline = line('.')
  endif
  let entry = b:startify.entries[entryline]

  if entry.type != 'file'
    return
  endif

  let default_cmds = {
        \ 'B': 'edit',
        \ 'S': 'split',
        \ 'V': 'vsplit',
        \ 'T': 'tabnew',
        \ }

  let origline = line('.')
  execute entryline
  let index = expand('<cword>')
  setlocal modifiable

  if entry.marked && index[0] == a:type
    let entry.cmd = 'edit'
    let entry.marked = 0
    execute 'normal! ci]'. entry.index
  else
    let entry.cmd = default_cmds[a:type]
    let entry.marked = 1
    let entry.tick = b:startify.tick
    let b:startify.tick += 1
    execute 'normal! ci]'. repeat(a:type, len(index))
  endif

  setlocal nomodifiable nomodified
  " Reset cursor to fixed column, which is important for s:set_cursor().
  call cursor(origline, s:fixed_column)
endfunction

" Function: s:sort_by_tick {{{1
function! s:sort_by_tick(one, two)
  return a:one.tick - a:two.tick
endfunction

" Function: s:check_user_options {{{1
function! s:check_user_options(path) abort
  let session = a:path . s:sep .'Session.vim'

  if get(g:, 'startify_session_autoload') && filereadable(glob(session))
    execute 'silent bwipeout' a:path
    call startify#session_delete_buffers()
    execute 'source' session
    return
  endif

  if get(g:, 'startify_change_to_vcs_root') && s:cd_to_vcs_root(a:path)
    return
  endif

  if get(g:, 'startify_change_to_dir', 1)
    if isdirectory(a:path)
      execute 'lcd' a:path
    else
      let dir = fnamemodify(a:path, ':h')
      if isdirectory(dir)
        execute 'lcd' dir
      else
        " Do nothing. E.g. a:path == `scp://foo/bar`
      endif
    endif
  endif
endfunction

" Function: s:cd_to_vcs_root {{{1
function! s:cd_to_vcs_root(path) abort
  let dir = fnamemodify(a:path, ':p:h')
  for vcs in [ '.git', '.hg', '.bzr', '.svn' ]
    let root = finddir(vcs, dir .';')
    if !empty(root)
      execute 'lcd' fnameescape(fnamemodify(root, ':h'))
      return 1
    endif
  endfor
  return 0
endfunction

" Function: s:close {{{1
function! s:close() abort
  if len(filter(range(0, bufnr('$')), 'buflisted(v:val)')) - &buflisted
    if bufloaded(bufnr('#')) && bufnr('#') != bufnr('%')
      buffer #
    else
      bnext
    endif
  else
    quit
  endif
endfunction

" Function: s:get_index_as_string {{{1
function! s:get_index_as_string() abort
  if !empty(b:startify.indices)
    return remove(b:startify.indices, 0)
  elseif exists('g:startify_custom_indices')
    let listlen = len(g:startify_custom_indices)
    if b:startify.entry_number < listlen
      let idx = g:startify_custom_indices[b:startify.entry_number]
    else
      let idx = string(b:startify.entry_number - listlen)
    endif
  else
    let idx = string(b:startify.entry_number)
  endif

  let b:startify.entry_number += 1

  return idx
endfunction

" Function: s:print_section_header {{{1
function! s:print_section_header() abort
  $
  let curline = line('.')

  for lnum in range(curline, curline + len(s:last_message) + 1)
    call add(b:startify.section_header_lines, lnum)
  endfor

  call append('$', s:last_message + [''])
  unlet s:last_message
endfunction

" Function: s:register {{{1
function! s:register(line, index, type, cmd, path)
  let b:startify.entries[a:line] = {
        \ 'index':  a:index,
        \ 'type':   a:type,
        \ 'line':   a:line,
        \ 'cmd':    a:cmd,
        \ 'path':   a:path,
        \ 'marked': 0,
        \ }
endfunction

" Function: s:create_last_session_link {{{1
function! s:create_last_session_link(session_path)
  if !has('win32') && a:session_path !~# '__LAST__$'
    let cmd = printf('ln -sf %s %s',
          \ shellescape(fnamemodify(a:session_path, ':t')),
          \ shellescape(s:session_dir .'/__LAST__'))
    call system(cmd)
    if v:shell_error
      call s:warn("Can't create 'last used session' symlink.")
    endif
  endif
endfunction

" Function: s:init_env {{{1
function! s:init_env()
  let s:env = []
  let ignore = {
        \ 'HOME':   1,
        \ 'OLDPWD': 1,
        \ 'PWD':    1,
        \ }

  if exists('*environ')
    let env = items(environ())
  else
    redir => s
      silent! execute "norm!:ec$\<c-a>'\<c-b>\<right>\<right>\<del>'\<cr>"
    redir END
    redraw
    let env = map(split(s), '[v:val, eval("$".v:val)]')
  endif

  for [var, val] in env
    if has('win32') ? (val[1] != ':') : (val[0] != '/')
          \ || has_key(ignore, var)
          \ || len(var) > len(val)
      continue
    endif
    call insert(s:env, [var, val], 0)
  endfor

  function! s:compare_by_key_len(foo, bar)
    return len(a:foo[0]) - len(a:bar[0])
  endfunction
  function! s:compare_by_val_len(foo, bar)
    return len(a:bar[1]) - len(a:foo[1])
  endfunction

  let s:env = sort(s:env, 's:compare_by_key_len')
  let s:env = sort(s:env, 's:compare_by_val_len')
endfunction

" Function: s:transform {{{1
function s:transform(absolute_path)
  for [k,V] in g:startify_transformations
    if a:absolute_path =~ k
      return type(V) == type('') ? V : V(a:absolute_path)
    endif
    unlet V
  endfor
  return ''
endfunction

" Function: s:warn {{{1
function! s:warn(msg) abort
  echohl WarningMsg
  echomsg 'startify: '. a:msg
  echohl NONE
endfunction

" Init: values {{{1
let s:sep = startify#get_separator()

let s:numfiles = get(g:, 'startify_files_number', 10)
let s:show_special = get(g:, 'startify_enable_special', 1)
let s:relative_path = get(g:, 'startify_relative_path') ? ':~:.' : ':p:~'
let s:tf = exists('g:startify_transformations')
let s:session_dir = startify#get_session_path()

let s:skiplist = get(g:, 'startify_skiplist', [
      \ 'runtime/doc/.*\.txt',
      \ 'bundle/.*/doc/.*\.txt',
      \ 'plugged/.*/doc/.*\.txt',
      \ '/.git/',
      \ 'fugitiveblame$',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc/.*\.txt',
      \ ])

let s:padding_left = repeat(' ', get(g:, 'startify_padding_left', 3))
let s:fixed_column = len(s:padding_left) + 2
let s:batchmode = ''
