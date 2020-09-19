"=============================================================================
" FILE: exrename.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" EDITOR: Alisue <lambdalisue at hashnote.net>
" License: MIT license
"=============================================================================

let s:PREFIX = has('win32') ? '[exrename]' : '*exrename*'

function! defx#exrename#create_buffer(candidates, ...) abort
  let options = extend({
        \ 'cwd': getcwd(),
        \ 'bufnr': bufnr('%'),
        \ 'buffer_name': '',
        \ 'post_rename_callback': v:null,
        \}, get(a:000, 0, {}))
  if options.cwd !~# '/$'
    " current working directory MUST end with a trailing slash
    let options.cwd .= '/'
  endif
  if options.buffer_name ==# ''
    let options.buffer_name = s:PREFIX
  else
    let options.buffer_name = s:PREFIX . ' - ' . options.buffer_name
  endif

  vsplit
  redraw
  execute 'edit' fnameescape(options.buffer_name)

  setlocal buftype=acwrite
  setlocal noswapfile
  setfiletype defx_exrename

  syntax match defxExrenameModified '^.*$'

  highlight def link defxExrenameModified Todo
  highlight def link defxExrenameOriginal Normal

  let b:exrename = options

  call defx#util#cd(b:exrename.cwd)

  nnoremap <buffer><silent> q :<C-u>call <SID>exit(bufnr('%'))<CR>
  augroup defx-exrename
    autocmd! * <buffer>
    autocmd BufHidden <buffer> call s:exit(expand('<abuf>'))
    autocmd BufWriteCmd <buffer> call s:do_rename()
    autocmd CursorMoved,CursorMovedI <buffer> call s:check_lines()
  augroup END

  " Clean up the screen.
  silent % delete _
  silent! syntax clear defxExrenameOriginal

  " validate candidates and register
  let unique_filenames = []
  let b:exrename.candidates = []
  let b:exrename.filenames = []
  let cnt = 1
  for candidate in a:candidates
    " make sure that the 'action__path' is absolute path
    if !s:is_absolute(candidate.action__path)
      let candidate.action__path = b:exrename.cwd . candidate.action__path
    endif
    " make sure that the 'action__path' exists
    if !filewritable(candidate.action__path)
          \ && !isdirectory(candidate.action__path)
      redraw
      echo candidate.action__path 'does not exist. Skip.'
      continue
    endif
    " make sure that the 'action__path' is unique
    if index(unique_filenames, candidate.action__path) != -1
      redraw
      echo candidate.action__path 'is duplicated. Skip.'
      continue
    endif
    " create filename
    let filename = candidate.action__path
    if stridx(filename, b:exrename.cwd) == 0
      let filename = filename[len(b:exrename.cwd) :]
    endif
    " directory should end with a trailing slash (to distinguish easily)
    if isdirectory(candidate.action__path)
      let filename .= '/'
    endif

    execute 'syntax match defxExrenameOriginal'
          \ '/'.printf('^\%%%dl%s$', cnt,
          \ escape(s:escape_pattern(filename), '/')).'/'
    " register
    call add(unique_filenames, candidate.action__path)
    call add(b:exrename.candidates, candidate)
    call add(b:exrename.filenames, filename)
    let cnt += 1
  endfor
  " write filenames
  let [undolevels, &undolevels] = [&undolevels, -1]
  try
    call setline(1, b:exrename.filenames)
  finally
    let &undolevels = undolevels
  endtry
  setlocal nomodified
endfunction

function! s:escape_pattern(str) abort
  return escape(a:str, '~"\.^$[]*')
endfunction

function! s:is_absolute(path) abort
  return a:path =~# '^\%(\a\a\+:\)\|^\%(\a:\|/\)'
endfunction

function! s:do_rename() abort
  if line('$') != len(b:exrename.filenames)
    echohl Error | echo 'Invalid rename buffer!' | echohl None
    return
  endif

  " Rename files.
  let linenr = 1
  let max = line('$')
  while linenr <= max
    let filename = b:exrename.filenames[linenr - 1]

    redraw
    echo printf('(%'.len(max).'d/%d): %s -> %s',
          \ linenr, max, filename, getline(linenr))

    if filename !=# getline(linenr)
      let old_file = b:exrename.candidates[linenr - 1].action__path
      let new_file = expand(getline(linenr))
      if new_file !~# '^\%(\a\a\+:\)\|^\%(\a:\|/\)'
        let new_file = b:exrename.cwd . new_file
      endif

      if rename(old_file, new_file)
        " Rename error
        continue
      endif

      " update b:exrename
      let b:exrename.filenames[linenr - 1] = getline(linenr)
      let b:exrename.candidates[linenr - 1].action__path = new_file
    endif
    let linenr += 1
  endwhile

  redraw
  echo 'Rename done!'

  setlocal nomodified

  if b:exrename.post_rename_callback != v:null
    call b:exrename.post_rename_callback(b:exrename)
  endif
endfunction

function! s:exit(bufnr) abort
  if !bufexists(a:bufnr)
    return
  endif

  " Switch buffer.
  if winnr('$') != 1
    close
  else
    call s:custom_alternate_buffer()
  endif
  silent execute 'bdelete!' a:bufnr
endfunction

function! s:check_lines() abort
  if !exists('b:exrename')
    return
  endif

  if line('$') != len(b:exrename.filenames)
    echohl Error | echo 'Invalid rename buffer!' | echohl None
    return
  endif
endfunction

function! s:custom_alternate_buffer() abort
  if bufnr('%') != bufnr('#') && buflisted(bufnr('#'))
    buffer #
  endif

  let cnt = 0
  let pos = 1
  let current = 0
  while pos <= bufnr('$')
    if buflisted(pos)
      if pos == bufnr('%')
        let current = cnt
      endif

      let cnt += 1
    endif

    let pos += 1
  endwhile

  if current > cnt / 2
    bprevious
  else
    bnext
  endif
endfunction
