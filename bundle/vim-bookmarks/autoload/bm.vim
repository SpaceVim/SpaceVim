if !exists("g:line_map")
  let g:line_map = {}  "  'line_nr'  => 'bookmark'
  let g:sign_map = {}  "  'sign_idx' => 'line_nr'
endif

" Bookmark Model {{{

function! bm#has_bookmarks_in_file(file)
  if !has_key(g:line_map, a:file)
    return 0
  endif
  return len(keys(g:line_map[a:file])) > 0
endfunction

function! bm#has_bookmark_at_line(file, line_nr)
  if !has_key(g:line_map, a:file)
    return 0
  endif
  return has_key(g:line_map[a:file], a:line_nr)
endfunction

function! bm#get_bookmark_by_line(file, line_nr)
  return g:line_map[a:file][a:line_nr]
endfunction

function! bm#is_bookmark_has_annotation_by_line(file, line_nr)
  return g:line_map[a:file][a:line_nr]['annotation'] !=# "" 
endfunction

function! bm#get_bookmark_by_sign(file, sign_idx)
  let line_nr = g:sign_map[a:file][a:sign_idx]
  return bm#get_bookmark_by_line(a:file, line_nr)
endfunction

function! bm#add_bookmark(file, sign_idx, line_nr, content, ...)
  if !has_key(g:line_map, a:file)
    let g:line_map[a:file] = {}
    let g:sign_map[a:file] = {}
  endif
  let annotation = a:0 ==# 1 ? a:1 : ""
  let entry = {'sign_idx': a:sign_idx, 'line_nr': a:line_nr, 'content': a:content, 'annotation': annotation}
  let g:line_map[a:file][a:line_nr]  = entry
  let g:sign_map[a:file][a:sign_idx] = a:line_nr
  return entry
endfunction

function! bm#update_bookmark_for_sign(file, sign_idx, new_line_nr, new_content)
  let bookmark = bm#get_bookmark_by_sign(a:file, a:sign_idx)
  call bm#del_bookmark_at_line(a:file, bookmark['line_nr'])
  call bm#add_bookmark(a:file, a:sign_idx, a:new_line_nr, a:new_content, bookmark['annotation'])
endfunction

function! bm#update_annotation(file, sign_idx, annotation)
  let bookmark = bm#get_bookmark_by_sign(a:file, a:sign_idx)
  let bookmark['annotation'] = a:annotation
endfunction

function! bm#next(file, current_line_nr)
  let line_nrs = sort(bm#all_lines(a:file), "bm#compare_lines")
  if empty(line_nrs)
    return 0
  endif
  if a:current_line_nr >=# line_nrs[-1] || a:current_line_nr <# line_nrs[0]
    return line_nrs[0] + 0
  else
    let idx = 0
    let lines_count = len(line_nrs)
    while idx <# lines_count-1
      let cur_bookmark = line_nrs[idx]
      let next_bookmark = line_nrs[idx+1]
      if a:current_line_nr >=# cur_bookmark && a:current_line_nr <# next_bookmark
        return next_bookmark + 0
      endif
      let idx = idx+1
    endwhile
  endif
  return 0
endfunction

function! bm#prev(file, current_line_nr)
  let line_nrs = sort(bm#all_lines(a:file), "bm#compare_lines")
  if empty(line_nrs)
    return 0
  endif
  let lines_count = len(line_nrs)
  let idx = lines_count-1
  if a:current_line_nr <=# line_nrs[0] || a:current_line_nr ># line_nrs[-1]
    return line_nrs[idx] + 0
  else
    while idx >=# 0
      let cur_bookmark = line_nrs[idx]
      let next_bookmark = line_nrs[idx-1]
      if a:current_line_nr <=# cur_bookmark && a:current_line_nr ># next_bookmark
        return next_bookmark + 0
      endif
      let idx = idx-1
    endwhile
  endif
  return 0
endfunction

function! bm#del_bookmark_at_line(file, line_nr)
  let bookmark = bm#get_bookmark_by_line(a:file, a:line_nr)
  unlet g:line_map[a:file][a:line_nr]
  unlet g:sign_map[a:file][bookmark['sign_idx']]
  if empty(g:line_map[a:file])
    unlet g:line_map[a:file]
    unlet g:sign_map[a:file]
  endif
endfunction

function! bm#total_count()
  return len(bm#location_list())
endfunction

function! bm#all_bookmarks_by_line(file)
  if !has_key(g:line_map, a:file)
    return {}
  endif
  return g:line_map[a:file]
endfunction

function! bm#all_lines(file)
  if !has_key(g:line_map, a:file)
    return []
  endif
  return keys(g:line_map[a:file])
endfunction

function! bm#location_list()
  let files = sort(bm#all_files())
  let locations = []
  for file in files
    let line_nrs = sort(bm#all_lines(file), "bm#compare_lines")
    for line_nr in line_nrs
      let bookmark = bm#get_bookmark_by_line(file, line_nr)
      let content = bookmark['annotation'] !=# ''
            \ ? "Annotation: ". bookmark['annotation']
            \ : (bookmark['content'] !=# ""
            \   ? bookmark['content']
            \   : "empty line")
      call add(locations, file .":". line_nr .":". content)
    endfor
  endfor
  return locations
endfunction

function! bm#all_files()
  return keys(g:line_map)
endfunction

function! bm#del_all()
  for file in bm#all_files()
    for line_nr in bm#all_lines(file)
      call bm#del_bookmark_at_line(file, line_nr)
    endfor
  endfor
endfunction

function! bm#serialize()
  let file_version = "let l:bm_file_version = 1"
  let sessions  = "let l:bm_sessions = {'default': {"
  for file in bm#all_files()
    let sessions .= "'". file ."': ["
    for bm in values(bm#all_bookmarks_by_line(file))
      let escaped_content = substitute(bm['content'], "'", "''", "g")
      let escaped_annotation = substitute(bm['annotation'], "'", "''", "g")
      let annotation = bm['annotation'] !=# "" ? ", 'annotation': '". escaped_annotation ."'" : ""
      let sessions .= "{'sign_idx': ". bm['sign_idx'] .", 'line_nr': ". bm['line_nr'] .", 'content': '". escaped_content ."'". annotation ."},"
    endfor
    let sessions .= "],"
  endfor
  let sessions .= "}}"
  let current_session = "let l:bm_current_session = 'default'"
  return [file_version, sessions, current_session]
endfunction

function! bm#deserialize(data)
    exec join(a:data, " | ")
    let ses = l:bm_sessions["default"]
    let result = []
    for file in keys(ses)
      for bm in ses[file]
        let annotation = has_key(bm, 'annotation') ? bm['annotation'] : ''
         call add(result, 
            \ extend(
              \ copy(
                \ bm#add_bookmark(file, bm['sign_idx'], bm['line_nr'], bm['content'], annotation)
              \ ),
              \ {'file': file}
            \ ))
      endfor
    endfor
    return result
endfunction

" }}}


" Private {{{

function! bm#compare_lines(line_str1, line_str2)
  let line1 = str2nr(a:line_str1)
  let line2 = str2nr(a:line_str2)
  return line1 ==# line2 ? 0 : line1 > line2 ? 1 : -1
endfunc

" }}}
