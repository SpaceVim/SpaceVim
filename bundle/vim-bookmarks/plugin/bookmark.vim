if exists('g:bm_has_any') || !has('signs') || &cp
  finish
endif
scriptencoding utf-8

let g:bm_has_any = 0
let g:bm_sign_index = 9500
let g:bm_current_file = ''

" Configuration {{{

function! s:set(var, default)
  if !exists(a:var)
    if type(a:default)
      execute 'let' a:var '=' string(a:default)
    else
      execute 'let' a:var '=' a:default
    endif
  endif
endfunction

call s:set('g:bookmark_highlight_lines',      0 )
call s:set('g:bookmark_sign',                '⚑')
call s:set('g:bookmark_annotation_sign',     '☰')
call s:set('g:bookmark_show_warning',         1 )
call s:set('g:bookmark_show_toggle_warning',  1 )
call s:set('g:bookmark_save_per_working_dir', 0 )
call s:set('g:bookmark_auto_save',            1 )
call s:set('g:bookmark_manage_per_buffer',    0 )
call s:set('g:bookmark_auto_save_file',       $HOME .'/.vim-bookmarks')
call s:set('g:bookmark_auto_close',           0 )
call s:set('g:bookmark_center',               0 )
call s:set('g:bookmark_location_list',        0 )
call s:set('g:bookmark_disable_ctrlp',        0 )

function! s:init(file)
  if g:bookmark_auto_save ==# 1 || g:bookmark_manage_per_buffer ==# 1
    augroup bm_vim_enter
      autocmd!
      autocmd BufEnter * call s:set_up_auto_save(expand('<afile>:p'))
    augroup END
  endif
  if a:file !=# ''
    call s:set_up_auto_save(a:file)
  elseif g:bookmark_manage_per_buffer ==# 0 && g:bookmark_save_per_working_dir ==# 0
    call BookmarkLoad(s:bookmark_save_file(''), 1, 1)
  endif
endfunction

" }}}


" Commands {{{

function! BookmarkToggle()
  call s:refresh_line_numbers()
  let file = expand("%:p")
  if file ==# ""
    return
  endif
  let current_line = line('.')
  if bm#has_bookmark_at_line(file, current_line)
    if g:bookmark_show_toggle_warning ==# 1 && bm#is_bookmark_has_annotation_by_line(file, current_line)
      let delete = confirm("Delete Annotated bookmarks?", "&Yes\n&No", 2)
      if (delete !=# 1)
        echo "Ignore!"
        return
      endif
    endif
    call s:bookmark_remove(file, current_line)
    echo "Bookmark removed"
  else
    call s:bookmark_add(file, current_line)
    echo "Bookmark added"
  endif
endfunction
command! ToggleBookmark call CallDeprecatedCommand('BookmarkToggle', [])
command! BookmarkToggle call BookmarkToggle()
function! BookmarkAnnotate(...)
  call s:refresh_line_numbers()
  let file = expand("%:p")
  if file ==# ""
    return
  endif

  let current_line = line('.')
  let has_bm = bm#has_bookmark_at_line(file, current_line)
  let bm = has_bm ? bm#get_bookmark_by_line(file, current_line) : 0
  let old_annotation = has_bm ? bm['annotation'] : ""
  let new_annotation = a:0 ># 0 ? a:1 : ""

  " Get annotation from user input if not passed in
  if new_annotation ==# ""
    let input_msg = old_annotation !=# "" ? "Edit" : "Enter"
    let new_annotation = input(input_msg ." annotation: ", old_annotation)
    execute ":redraw!"
  endif

  " Nothing changed, bail out
  if new_annotation ==# "" && old_annotation ==# new_annotation
    return

  " Update annotation
  elseif has_bm
    call bm#update_annotation(file, bm['sign_idx'], new_annotation)
    let result_msg = (new_annotation ==# "")
          \ ? "removed"
          \ : old_annotation !=# ""
          \   ? "updated: ". new_annotation
          \   : "added: ". new_annotation
    call bm_sign#update_at(file, bm['sign_idx'], bm['line_nr'], bm['annotation'] !=# "")
    echo "Annotation ". result_msg

  " Create bookmark with annotation
  elseif new_annotation !=# ""
    call s:bookmark_add(file, current_line, new_annotation)
    echo "Bookmark added with annotation: ". new_annotation
  endif
endfunction
command! -nargs=* Annotate call CallDeprecatedCommand('BookmarkAnnotate', [<q-args>, 0])
command! -nargs=* BookmarkAnnotate call BookmarkAnnotate(<q-args>, 0)

function! BookmarkClear()
  call s:refresh_line_numbers()
  let file = expand("%:p")
  let lines = bm#all_lines(file)
  for line_nr in lines
    call s:bookmark_remove(file, line_nr)
  endfor
  echo "Bookmarks removed"
endfunction
command! ClearBookmarks call CallDeprecatedCommand('BookmarkClear', [])
command! BookmarkClear call BookmarkClear()

function! BookmarkClearAll(silent)
  call s:refresh_line_numbers()
  let files = bm#all_files()
  let file_count = len(files)
  let delete = 1
  let in_multiple_files = file_count ># 1
  let supports_confirm = has("dialog_con") || has("dialog_gui")
  if (in_multiple_files && g:bookmark_show_warning ==# 1 && supports_confirm && !a:silent)
    let delete = confirm("Delete ". bm#total_count() ." bookmarks in ". file_count . " buffers?", "&Yes\n&No")
  endif
  if (delete ==# 1)
    call s:remove_all_bookmarks()
    if (!a:silent)
      execute ":redraw!"
      echo "All bookmarks removed"
    endif
  endif
endfunction
command! ClearAllBookmarks call CallDeprecatedCommand('BookmarkClearAll', [0])
command! BookmarkClearAll call BookmarkClearAll(0)

function! BookmarkNext()
  call s:refresh_line_numbers()
  call s:jump_to_bookmark('next')
endfunction
command! NextBookmark call CallDeprecatedCommand('BookmarkNext')
command! BookmarkNext call BookmarkNext()

function! BookmarkPrev()
  call s:refresh_line_numbers()
  call s:jump_to_bookmark('prev')
endfunction
command! PrevBookmark call CallDeprecatedCommand('BookmarkPrev')
command! BookmarkPrev call BookmarkPrev()
command! CtrlPBookmark call ctrlp#init(ctrlp#bookmarks#id()) 

function! BookmarkShowAll()
  if s:is_quickfix_win()
    q
  else
    call s:refresh_line_numbers()
    if exists(':Unite')
      exec ":Unite vim_bookmarks"
    elseif exists(':CtrlP') == 2 && g:bookmark_disable_ctrlp == 0
      exec ":CtrlPBookmark"
    else
      let oldformat = &errorformat    " backup original format
      let &errorformat = "%f:%l:%m"   " custom format for bookmarks
      if g:bookmark_location_list
        lgetexpr bm#location_list()
        belowright lopen
      else
        cgetexpr bm#location_list()
        belowright copen
      endif
      augroup BM_AutoCloseCommand
        autocmd!
        autocmd WinLeave * call s:auto_close()
      augroup END
      let &errorformat = oldformat    " re-apply original format
    endif
  endif
endfunction
command! ShowAllBookmarks call CallDeprecatedCommand('BookmarkShowAll')
command! BookmarkShowAll call BookmarkShowAll()

function! BookmarkSave(target_file, silent)
  call s:refresh_line_numbers()
  if (bm#total_count() > 0 || (!g:bookmark_save_per_working_dir && !g:bookmark_manage_per_buffer))
    let serialized_bookmarks = bm#serialize()
    call writefile(serialized_bookmarks, a:target_file)
    if (!a:silent)
      echo "All bookmarks saved"
    endif
  elseif (g:bookmark_save_per_working_dir || g:bookmark_manage_per_buffer)
    call delete(a:target_file) " remove file, if no bookmarks
  endif
endfunction
command! -nargs=1 SaveBookmarks call CallDeprecatedCommand('BookmarkSave', [<f-args>, 0])
command! -nargs=1 BookmarkSave call BookmarkSave(<f-args>, 0)

function! BookmarkLoad(target_file, startup, silent)
  let supports_confirm = has("dialog_con") || has("dialog_gui")
  let has_bookmarks = bm#total_count() ># 0
  let confirmed = 1
  if (supports_confirm && has_bookmarks && !a:silent)
    let confirmed = confirm("Do you want to override your ". bm#total_count() ." bookmarks?", "&Yes\n&No")
  endif
  if (confirmed ==# 1)
    call s:remove_all_bookmarks()
    try
      let data = readfile(a:target_file)
      let new_entries = bm#deserialize(data)
      if !a:startup
        for entry in new_entries
          call bm_sign#add_at(entry['file'], entry['sign_idx'], entry['line_nr'], entry['annotation'] !=# "")
        endfor
        if (!a:silent)
          echo "Bookmarks loaded"
        endif
        return 1
      endif
    catch
      if (!a:startup && !a:silent)
        echo "Failed to load/parse file"
      endif
      return 0
    endtry
  endif
endfunction
command! -nargs=1 LoadBookmarks call CallDeprecatedCommand('BookmarkLoad', [<f-args>, 0, 0])
command! -nargs=1 BookmarkLoad call BookmarkLoad(<f-args>, 0, 0)

function! CallDeprecatedCommand(fun, args)
  echo "Warning: Deprecated command, please use ':". a:fun ."' instead"
  let Fn = function(a:fun)
  return call(Fn, a:args)
endfunction

function! BookmarkModify(diff)
  let current_line = line('.')
  let new_line_nr = current_line + a:diff
  call BookmarkMoveToLine(new_line_nr)
endfunction



function! BookmarkMoveToLine(target)
  call s:refresh_line_numbers()

  let file = expand("%:p")
  if file ==# ""
    return
  endif

  let current_line = line('.')
  if a:target == current_line
    return
  endif

  if bm#has_bookmark_at_line(file, current_line)
    "ensure we're trying to move to a valid line nr
    let max_line_nr = line('$')
    if a:target <= 0 || a:target > max_line_nr
      echo "Can't move bookmark beyond file bounds"
      return
    endif
    if bm#has_bookmark_at_line(file, a:target)
      echo "Hit another bookmark"
      return
    endif

    let bookmark = bm#get_bookmark_by_line(file, current_line)
    call bm_sign#update_at(file, bookmark['sign_idx'], a:target, bookmark['annotation'] !=# "")

    let bufnr = bufnr(file)
    let line_content = getbufline(bufnr, a:target)
    let content = len(line_content) > 0 ? line_content[0] : ' '
    call bm#update_bookmark_for_sign(file, bookmark['sign_idx'], a:target, content)
    call cursor(a:target, 1)
    normal! ^
  else
    return
  endif
endfunction

command! -nargs=? BookmarkMoveUp call s:move_relative(<q-args>, -1)
command! -nargs=? BookmarkMoveDown call s:move_relative(<q-args>, 1)
command! -nargs=? BookmarkMoveToLine call s:move_absolute(<q-args>)

" }}}


" Private {{{

" arg is always a string
" direction is {-1,1}
function! s:move_relative(arg, direction)
  if !s:has_bookmark_at_cursor()
    echo 'No bookmark at current line'
    return
  endif
  " ''        => direction
  " '0'       => direction
  " '\d+'     => number * direction
  " 'v:count' => v:count * direction
  " negative/abc arg naturally rejected
  if empty(a:arg)
    let delta = a:direction
  elseif a:arg =~# '\v^v:count1?$'
    let delta = eval(a:arg) * a:direction
  elseif a:arg =~# '\v^\d+$'
    let delta = str2nr(a:arg) * a:direction
  else
    echo 'Invalid line count'
    return
  endif
  let delta = (delta == 0) ? a:direction : delta
  " at this point we're guaranteed to have integer target != 0
  call BookmarkModify(delta)
endfunction

" arg is always a string
function! s:move_absolute(arg)
  if !s:has_bookmark_at_cursor()
    echo 'No bookmark at current line'
    return
  endif
  " ''              => prompt
  " 'v:count' == 0  => prompt
  " 'v:count'       => use
  " '\d+'           => use
  " negative/abc arg naturally rejected
  if empty(a:arg)
    let target = 0
  elseif a:arg =~# '\v^v:count1?$'
    let target = eval(a:arg)
  elseif a:arg =~# '\v^\d+$'
    let target = str2nr(a:arg)
  else
    echo 'Invalid line number'
    return
  endif
  if target == 0
      let target = input("Enter target line number: ")
      " clear the line for subsequent messages
      echo "\r"
      " if 'abc<Esc>' or '<empty><Enter>' (indistinguishable), cancel with no error message
      if empty(target)
        return
      endif
      if target !~# '\v^\d+$'
        echo "Invalid line number"
        return
      endif
      let target = str2nr(target)
  endif
  " at this point we're guaranteed to have integer target > 0
  call BookmarkMoveToLine(target)
endfunction

function! s:has_bookmark_at_cursor()
  let file = expand("%:p")
  let current_line = line('.')
  if file ==# ""
    return
  endif
  return bm#has_bookmark_at_line(file, current_line)
endfunction


function! s:lazy_init()
  if g:bm_has_any ==# 0
    augroup bm_refresh
      autocmd!
      autocmd ColorScheme * call bm_sign#define_highlights()
      autocmd BufLeave * call s:refresh_line_numbers()
    augroup END
    let g:bm_has_any = 1
  endif
endfunction

function! s:refresh_line_numbers()
  call s:lazy_init()
  let file = expand("%:p")
  if file ==# "" || !bm#has_bookmarks_in_file(file)
    return
  endif
  let bufnr = bufnr(file)
  let sign_line_map = bm_sign#lines_for_signs(file)
  for sign_idx in keys(sign_line_map)
    let line_nr = sign_line_map[sign_idx]
    let line_content = getbufline(bufnr, line_nr)
    let content = len(line_content) > 0 ? line_content[0] : ' '
    call bm#update_bookmark_for_sign(file, sign_idx, line_nr, content)
  endfor
endfunction

function! s:bookmark_add(file, line_nr, ...)
  let annotation = (a:0 ==# 1) ? a:1 : ""
  let sign_idx = bm_sign#add(a:file, a:line_nr, annotation !=# "")
  call bm#add_bookmark(a:file, sign_idx, a:line_nr, getline(a:line_nr), annotation)
endfunction

function! s:bookmark_remove(file, line_nr)
  let bookmark = bm#get_bookmark_by_line(a:file, a:line_nr)
  call bm_sign#del(a:file, bookmark['sign_idx'])
  call bm#del_bookmark_at_line(a:file, a:line_nr)
endfunction

function! s:jump_to_bookmark(type)
  let file = expand("%:p")
  let line_nr = bm#{a:type}(file, line("."))
  if line_nr ==# 0
    echo "No bookmarks found"
  else
    call cursor(line_nr, 1)
    normal! ^
    if g:bookmark_center ==# 1
      normal! zz
    endif
    let bm = bm#get_bookmark_by_line(file, line_nr)
    let annotation = bm['annotation'] !=# "" ? " (". bm['annotation'] . ")" : ""
    execute ":redraw!"
    echo "Jumped to bookmark". annotation
  endif
endfunction

function! s:remove_all_bookmarks()
  let files = bm#all_files()
  for file in files
    let lines = bm#all_lines(file)
    for line_nr in lines
      call s:bookmark_remove(file, line_nr)
    endfor
  endfor
endfunction

function! s:startup_load_bookmarks(file)
  call BookmarkLoad(s:bookmark_save_file(a:file), 1, 1)
  call s:add_missing_signs(a:file)
endfunction

function! s:bookmark_save_file(file)
  " Managing bookmarks per buffer implies saving them to a location based on the
  " open file (working dir doesn't make much sense unless auto changing the
  " working directory based on current file location is turned on - but this is
  " a serious dependency to try and require), so the function used to customize
  " the bookmarks file location must be based on the current file.
  " For backwards compatibility reasons, a new function is used.
  if (g:bookmark_manage_per_buffer ==# 1)
    return exists("*g:BMBufferFileLocation") ? g:BMBufferFileLocation(a:file) : s:default_file_location()
  elseif (g:bookmark_save_per_working_dir)
    return exists("*g:BMWorkDirFileLocation") ? g:BMWorkDirFileLocation() : s:default_file_location()
  else
    return g:bookmark_auto_save_file
  endif
endfunction

function! s:default_file_location()
  return getcwd(). '/.vim-bookmarks'
endfunction

" should only be called from autocmd!
function! s:add_missing_signs(file)
  let bookmarks = values(bm#all_bookmarks_by_line(a:file))
  for bookmark in bookmarks
    call bm_sign#add_at(a:file, bookmark['sign_idx'], bookmark['line_nr'], bookmark['annotation'] !=# "")
  endfor
endfunction

function! s:is_quickfix_win()
  return getbufvar(winbufnr('.'), '&buftype') == 'quickfix'
endfunction

function! s:auto_close()
  if s:is_quickfix_win()
    if (g:bookmark_auto_close)
      " Setting 'splitbelow' before closing the quickfix window will ensure
      " that its space is given back to the window above rather than to the
      " window below.
      let l:sb = &sb
      set splitbelow
      q
      let &sb = l:sb
    endif
    call s:remove_auto_close()
  endif
endfunction

function! s:remove_auto_close()
  augroup BM_AutoCloseCommand
    autocmd!
  augroup END
endfunction

function! s:auto_save()
  if g:bm_current_file !=# ''
    call BookmarkSave(s:bookmark_save_file(g:bm_current_file), 1)
  endif
  augroup bm_auto_save
    autocmd!
  augroup END
endfunction

function! s:set_up_auto_save(file)
  if g:bookmark_auto_save ==# 1 || g:bookmark_manage_per_buffer ==# 1
    call s:startup_load_bookmarks(a:file)
    let g:bm_current_file = a:file
    augroup bm_auto_save
      autocmd!
      autocmd BufWinEnter * call s:add_missing_signs(expand('<afile>:p'))
      autocmd BufLeave,VimLeave,BufReadPre * call s:auto_save()
    augroup END
  endif
endfunction

" }}}


" Maps {{{

function! s:register_mapping(command, shortcut, has_count)
  if a:has_count
    execute "nnoremap <silent> <Plug>". a:command ." :<C-u>". a:command ." v:count<CR>"
  else
    execute "nnoremap <silent> <Plug>". a:command ." :". a:command ."<CR>"
  endif
  if !hasmapto("<Plug>". a:command)
        \ && !get(g:, 'bookmark_no_default_key_mappings', 0)
        \ && maparg(a:shortcut, 'n') ==# ''
    execute "nmap ". a:shortcut ." <Plug>". a:command
  endif
endfunction

call s:register_mapping('BookmarkShowAll',    'ma',  0)
call s:register_mapping('BookmarkToggle',     'mm',  0)
call s:register_mapping('BookmarkAnnotate',   'mi',  0)
call s:register_mapping('BookmarkNext',       'mn',  0)
call s:register_mapping('BookmarkPrev',       'mp',  0)
call s:register_mapping('BookmarkClear',      'mc',  0)
call s:register_mapping('BookmarkClearAll',   'mx',  0)
call s:register_mapping('BookmarkMoveUp',     'mkk', 1)
call s:register_mapping('BookmarkMoveDown',   'mjj', 1)
call s:register_mapping('BookmarkMoveToLine', 'mg',  1)

" }}}

" Init {{{

if has('vim_starting')
  autocmd VimEnter * call s:init(expand('<afile>:p'))
else
  call s:init(expand('%:p'))
endif
