"=============================================================================
" FILE: init.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Global options definition.
let g:vimfiler_directory_display_top =
      \ get(g:, 'vimfiler_directory_display_top', 1)
let g:vimfiler_max_directories_history =
      \ get(g:, 'vimfiler_max_directories_history', 50)
let g:vimfiler_safe_mode_by_default =
      \ get(g:, 'vimfiler_safe_mode_by_default', 1)
let g:vimfiler_force_overwrite_statusline =
      \ get(g:, 'vimfiler_force_overwrite_statusline', 1)
let g:vimfiler_time_format =
      \ get(g:, 'vimfiler_time_format', '%y/%m/%d %H:%M')
let g:vimfiler_tree_leaf_icon =
      \ get(g:, 'vimfiler_tree_leaf_icon', '|')
let g:vimfiler_tree_opened_icon =
      \ get(g:, 'vimfiler_tree_opened_icon', '-')
let g:vimfiler_tree_closed_icon =
      \ get(g:, 'vimfiler_tree_closed_icon', '+')
let g:vimfiler_tree_indentation =
      \ get(g:, 'vimfiler_tree_indentation', 1)
let g:vimfiler_file_icon =
      \ get(g:, 'vimfiler_file_icon', ' ')
let g:vimfiler_readonly_file_icon =
      \ get(g:, 'vimfiler_readonly_file_icon', 'X')
let g:vimfiler_marked_file_icon =
      \ get(g:, 'vimfiler_marked_file_icon', '*')
let g:vimfiler_quick_look_command =
      \ get(g:, 'vimfiler_quick_look_command', '')
let g:vimfiler_ignore_pattern =
      \ get(g:, 'vimfiler_ignore_pattern', ['^\.'])
let g:vimfiler_expand_jump_to_first_child =
      \ get(g:, 'vimfiler_expand_jump_to_first_child', 1)
let g:vimfiler_restore_alternate_file =
      \ get(g:, 'vimfiler_restore_alternate_file', 1)
let g:vimfiler_ignore_filters =
      \ get(g:, 'vimfiler_ignore_filters', ['matcher_ignore_pattern'])

let g:vimfiler_execute_file_list =
      \ get(g:, 'vimfiler_execute_file_list', {})

" Set extensions.
let g:vimfiler_extensions =
      \ get(g:, 'vimfiler_extensions', {})
if !has_key(g:vimfiler_extensions, 'text')
  call vimfiler#set_extensions('text',
        \ 'txt,cfg,ini')
endif
if !has_key(g:vimfiler_extensions, 'image')
  call vimfiler#set_extensions('image',
        \ 'bmp,png,gif,jpg,jpeg,jp2,tif,ico,wdp,cur,ani')
endif
if !has_key(g:vimfiler_extensions, 'archive')
  call vimfiler#set_extensions('archive',
        \ 'lzh,zip,gz,bz2,cab,rar,7z,tgz,tar')
endif
if !has_key(g:vimfiler_extensions, 'system')
  call vimfiler#set_extensions('system',
        \ 'inf,sys,reg,dat,spi,a,so,lib,dll')
endif
if !has_key(g:vimfiler_extensions, 'multimedia')
  call vimfiler#set_extensions('multimedia',
        \ 'avi,asf,wmv,mpg,flv,swf,divx,mov,mpa,m1a,'.
        \ 'm2p,m2a,mpeg,m1v,m2v,mp2v,mp4,qt,ra,rm,ram,'.
        \ 'rmvb,rpm,smi,mkv,mid,wav,mp3,ogg,wma,au,flac'
        \ )
endif


let s:manager = vimfiler#util#get_vital_buffer()

let s:loaded_columns = {}
let s:loaded_filters = {}

function! vimfiler#init#_initialize() abort
  " Dummy initialize
endfunction
function! vimfiler#init#_command(default, args) abort
  let args = []
  let options = a:default
  for arg in split(a:args, '\%(\\\@<!\s\)\+')
    let arg = substitute(arg, '\\\( \)', '\1', 'g')

    let arg_key = substitute(arg, '=\zs.*$', '', '')
    let matched_list = filter(copy(vimfiler#variables#options()),
          \  'v:val ==# arg_key')
    for option in matched_list
      let key = substitute(substitute(option, '-', '_', 'g'),
            \ '=$', '', '')[1:]
      let options[key] = (option =~ '=$') ?
            \ arg[len(option) :] : 1
      break
    endfor

    if empty(matched_list)
      call add(args, arg)
    endif
  endfor

  call vimfiler#init#_start(join(args), options)
endfunction
function! vimfiler#init#_context(context) abort
  let default_context = extend(copy(vimfiler#variables#default_context()),
        \ vimfiler#custom#get_profile('default', 'context'))

  if get(a:context, 'explorer', 0)
    " Change default value.
    let default_context.buffer_name = 'explorer'
    let default_context.profile_name = 'explorer'
    let default_context.split = 1
    let default_context.parent = 0
    let default_context.toggle = 1
    let default_context.quit = 0
    let default_context.winwidth = 35
  endif

  let profile_name = get(a:context, 'profile_name',
        \ get(a:context, 'buffer_name', 'default'))

  if profile_name !=# 'default'
    " Overwrite default_context by profile context.
    call extend(default_context,
          \ unite#custom#get_profile(profile_name, 'context'))
  endif

  let context = extend(default_context, a:context)

  " Generic no.
  for option in map(filter(items(context),
        \ "stridx(v:val[0], 'no_') == 0 && v:val[1]"), 'v:val[0]')
    let context[option[3:]] = 0
  endfor

  let context.profile_name = profile_name
  if context.toggle && context.find
    " Disable toggle feature.
    let context.toggle = 0
  endif
  if context.tab
    " Force create new vimfiler buffer.
    let context.create = 1
    let context.alternate_buffer = -1
  endif
  if context.explorer
    let context.columns = context.explorer_columns
  endif

  return context
endfunction
function! vimfiler#init#_vimfiler_directory(directory, context)
  " Set current unite.
  let b:vimfiler.unite = unite#get_current_unite()

  " Set current directory.
  let current = vimfiler#util#substitute_path_separator(a:directory)
  let b:vimfiler.current_dir = current
  if b:vimfiler.current_dir !~ '[:/]$'
    let b:vimfiler.current_dir .= '/'
  endif
  let b:vimfiler.all_files = []
  let b:vimfiler.current_files = []
  let b:vimfiler.original_files = []
  let b:vimfiler.all_files_len = 0

  let b:vimfiler.is_visible_ignore_files = 0
  let b:vimfiler.simple = a:context.simple
  let b:vimfiler.directory_cursor_pos = {}
  let b:vimfiler.current_mask = ''

  let b:vimfiler.column_names = split(a:context.columns, ':')
  let b:vimfiler.columns = vimfiler#init#_columns(
        \ b:vimfiler.column_names, b:vimfiler.context)
  let b:vimfiler.syntaxes = []
  let b:vimfiler.filters = vimfiler#init#_filters(
        \ g:vimfiler_ignore_filters, b:vimfiler.context)

  let b:vimfiler.global_sort_type = a:context.sort_type
  let b:vimfiler.local_sort_type = a:context.sort_type
  let b:vimfiler.is_safe_mode = a:context.safe
  let b:vimfiler.winwidth = winwidth(0)
  let b:vimfiler.another_vimfiler_bufnr = -1
  let b:vimfiler.prompt_linenr =
        \ b:vimfiler.context.status + b:vimfiler.context.parent
  let b:vimfiler.all_files_len = 0
  let b:vimfiler.status = ''
  let b:vimfiler.statusline =
        \ (b:vimfiler.context.explorer ?  '' : '*vimfiler* : ')
        \ . '%{vimfiler#get_status_string()}'
        \ . "\ %=%{exists('b:vimfiler') ? printf('%4d/%d',line('.'),
        \    b:vimfiler.prompt_linenr+b:vimfiler.all_files_len) : ''}"

  call vimfiler#default_settings()
  call vimfiler#mappings#define_default_mappings(a:context)

  set filetype=vimfiler

  if a:context.split && has('vim_starting') && isdirectory(bufname('%'))
    execute a:context.direction
          \ (a:context.horizontal ? 'split' : 'vsplit')

    enew
    wincmd p
  endif

  if b:vimfiler.context.double
    " Create another vimfiler.
    call vimfiler#mappings#create_another_vimfiler()
    wincmd p
  endif

  call vimfiler#handler#_event_bufwin_enter(bufnr('%'))

  call vimfiler#view#_define_syntax()
  call vimfiler#view#_force_redraw_all_vimfiler()

  " Initialize cursor position.
  call cursor(b:vimfiler.prompt_linenr+1, 0)

  if a:context.auto_cd
    " Change current directory.
    call vimfiler#mappings#_change_vim_current_dir()
  endif

  call vimfiler#mappings#cd(b:vimfiler.current_dir)
endfunction
function! vimfiler#init#_vimfiler_file(path, lines, dict)
  " Set current unite.
  let b:vimfiler.unite = unite#get_current_unite()

  " Set current directory.
  let b:vimfiler.current_path = a:path
  let b:vimfiler.current_file = a:dict

  " Clean up the screen.
  silent % delete _

  augroup vimfiler
    autocmd! * <buffer>
    autocmd BufWriteCmd <buffer>
          \ call vimfiler#handler#_event_handler('BufWriteCmd')
  augroup END

  call setline(1, a:lines)

  setlocal buftype=acwrite
  setlocal noswapfile

  " For filetype detect.
  execute 'doautocmd BufRead' fnamemodify(a:path[-1], ':t')

  let &fileencoding = get(a:dict, 'vimfiler__encoding', '')

  setlocal nomodified
endfunction
function! vimfiler#init#_candidates(candidates, source_name) abort
  let default = {
        \ 'vimfiler__is_directory' : 0,
        \ 'vimfiler__is_executable' : 0,
        \ 'vimfiler__is_writable' : 1,
        \ 'vimfiler__filesize' : -1,
        \ 'vimfiler__filetime' : 0,
        \}
  " Set default vimfiler property.
  for candidate in a:candidates
    let candidate = extend(candidate, default, 'keep')

    if !has_key(candidate, 'vimfiler__filename')
      let candidate.vimfiler__filename = candidate.word
    endif
    if !has_key(candidate, 'vimfiler__abbr')
      let candidate.vimfiler__abbr = candidate.word
    endif
    if !has_key(candidate, 'vimfiler__datemark')
      let candidate.vimfiler__datemark = vimfiler#get_datemark(candidate)
    endif
    if !has_key(candidate, 'vimfiler__extension')
      let candidate.vimfiler__extension =
            \ candidate.vimfiler__is_directory ?
            \ '' : fnamemodify(candidate.vimfiler__filename, ':e')
    endif
    if !has_key(candidate, 'vimfiler__filetype')
      let candidate.vimfiler__filetype = vimfiler#get_filetype(candidate)
    endif

    let candidate.vimfiler__is_marked = 0
    let candidate.source = a:source_name
    let candidate.unite__abbr = candidate.vimfiler__abbr
  endfor

  return a:candidates
endfunction
function! vimfiler#init#_columns(columns, context) abort
  let columns = []

  for column in a:columns
    if !has_key(s:loaded_columns, column)
      let name = substitute(column, '^[^/_]\+\zs[/_].*$', '', '')

      for define in map(split(globpath(&runtimepath,
            \ 'autoload/vimfiler/columns/'.name.'*.vim'), '\n'),
            \ "vimfiler#columns#{fnamemodify(v:val, ':t:r')}#define()")
        for dict in vimfiler#util#convert2list(define)
          if !empty(dict) && !has_key(s:loaded_columns, dict.name)
            let s:loaded_columns[dict.name] = dict
          endif
        endfor
        unlet define
      endfor
    endif

    if has_key(s:loaded_columns, column)
      call add(columns, s:loaded_columns[column])
    endif
  endfor

  return columns
endfunction
function! vimfiler#init#_filters(filters, context) abort
  let filters = []

  for column in a:filters
    if !has_key(s:loaded_filters, column)
      let name = substitute(column, '^[^/_]\+\zs[/_].*$', '', '')

      for define in map(split(globpath(&runtimepath,
            \ 'autoload/vimfiler/filters/'.name.'*.vim'), '\n'),
            \ "vimfiler#filters#{fnamemodify(v:val, ':t:r')}#define()")
        for dict in vimfiler#util#convert2list(define)
          if !empty(dict) && !has_key(s:loaded_filters, dict.name)
            let s:loaded_filters[dict.name] = dict
          endif
        endfor
        unlet define
      endfor
    endif

    if has_key(s:loaded_filters, column)
      call add(filters, s:loaded_filters[column])
    endif
  endfor

  return filters
endfunction

function! vimfiler#init#_start(path, ...) abort
  if vimfiler#util#is_cmdwin()
    call vimfiler#util#print_error(
          \ 'Command line buffer is detected!')
    call vimfiler#util#print_error(
          \ 'Please close command line buffer.')
    return
  endif

  let path = a:path
  if vimfiler#util#is_win_path(path)
    let path = vimfiler#util#substitute_path_separator(
          \ fnamemodify(vimfiler#util#expand(path), ':p'))
  endif

  let context = vimfiler#initialize_context(get(a:000, 0, {}))
  if (!&l:hidden && &l:modified)
        \ || (&l:hidden && &l:bufhidden =~# 'unload\|delete\|wipe')
    " Split automatically.
    let context.split = 1
  endif

  if context.toggle && !context.create
    if vimfiler#mappings#close(context.buffer_name)
      return
    endif
  endif

  if context.project
    let path = vimfiler#util#path2project_directory(path)
  endif

  if !context.create
    if filereadable(path)
      let source_name = 'file'
      let source_args = [path]
    else
      let ret = vimfiler#parse_path(path)
      let source_name = ret[0]
      let source_args = ret[1:]
    endif
    let ret = unite#vimfiler_check_filetype(
          \ [insert(source_args, source_name)])

    if empty(ret) || ret[0] ==# 'directory' || context.find
      " Search vimfiler buffer.
      for bufnr in filter(insert(range(1, bufnr('$')), bufnr('%')),
            \ "bufloaded(v:val) &&
            \ getbufvar(v:val, '&filetype') =~# 'vimfiler'")
        let vimfiler = getbufvar(bufnr, 'vimfiler')
        if type(vimfiler) == type({})
              \ && vimfiler.context.buffer_name ==# context.buffer_name
              \ && (exists('t:vimfiler') && has_key(t:vimfiler, bufnr))
              \ && (!context.invisible || bufwinnr(bufnr) < 0)
          call vimfiler#init#_switch_vimfiler(bufnr, context, path)
          return
        endif

        unlet vimfiler
      endfor
    endif
  endif

  call s:create_vimfiler_buffer(path, context)
endfunction
function! vimfiler#init#_switch_vimfiler(bufnr, context, directory) abort
  if a:bufnr < 0
    call s:create_vimfiler_buffer(a:directory, a:context)
    return
  endif

  let search_path = fnamemodify(bufname('%'), ':p')

  let context = vimfiler#initialize_context(a:context)
  let context.vimfiler__prev_bufnr = bufnr('%')
  let context.vimfiler__prev_winnr = winnr()

  if bufwinnr(a:bufnr) < 0
    if !context.tab
      let context.alternate_buffer = bufnr('%')
      let context.prev_winsaveview = winsaveview()
    endif

    if context.split
      execute context.direction
            \ (context.horizontal ? 'split' : 'vsplit')
    endif

    execute 'buffer' . a:bufnr
  else
    " Move to vimfiler window.
    call vimfiler#util#winmove(bufwinnr(a:bufnr))
  endif

  " Set window local options
  call s:buffer_default_settings()

  let b:vimfiler.context = extend(b:vimfiler.context, context)
  let b:vimfiler.prompt_linenr =
        \ b:vimfiler.context.status + b:vimfiler.context.parent

  let directory = vimfiler#util#substitute_path_separator(
        \ a:directory)

  call vimfiler#handler#_event_bufwin_enter(a:bufnr)

  " Set current directory.
  if directory != ''
    if directory =~ ':'
      " Parse path.
      let ret = vimfiler#parse_path(directory)
      let b:vimfiler.source = ret[0]
      let directory = join(ret[1:], ':')
    endif

    call vimfiler#mappings#cd(directory)
  endif

  if a:context.find
    call vimfiler#mappings#search_cursor(
          \ substitute(vimfiler#helper#_get_cd_path(
          \ search_path), '/$', '', ''))
  endif

  if a:context.double
    " Create another vimfiler.
    call vimfiler#mappings#create_another_vimfiler()
    wincmd p
  endif

  call vimfiler#view#_force_redraw_all_vimfiler()

  if !context.focus
    if winbufnr(winnr('#')) > 0
      wincmd p
    else
      call vimfiler#util#winmove(
            \ bufwinnr(a:context.alternate_buffer))
      keepjumps call winrestview(a:context.prev_winsaveview)
    endif
  endif
endfunction
function! s:create_vimfiler_buffer(path, context) abort
  let search_path = fnamemodify(bufname('%'), ':p')
  let path = a:path
  if path == ''
    " Use current directory.
    let path = vimfiler#util#substitute_path_separator(getcwd())
  endif

  let context = a:context

  if context.project
    let path = vimfiler#util#path2project_directory(path)
  endif

  if (!&l:hidden && &l:modified)
        \ || (&l:hidden && &l:bufhidden =~# 'unload\|delete\|wipe')
    " Split automatically.
    let context.split = 1
  endif

  " Create new buffer name.
  let prefix = 'vimfiler:'
  let prefix .= context.buffer_name
  if a:path =~ ':' && a:path !~ '/$'
    let prefix .= '@' . a:path
  endif

  let postfix = vimfiler#init#_get_postfix(prefix, 1)

  let bufname = prefix . postfix

  if context.split
    execute context.direction
          \ (context.horizontal ? 'split' : 'vsplit')
  endif

  if context.tab
    tabnew
  endif

  " Save swapfile option.
  let swapfile_save = &l:swapfile

  if !exists('t:vimfiler')
    let t:vimfiler = {}
  endif
  " Save alternate buffer.
  let t:vimfiler[bufnr('%')] = 1

  try
    setlocal noswapfile
    let loaded = s:manager.open(bufname, 'silent edit')
  finally
    let &l:swapfile = swapfile_save
  endtry

  let t:vimfiler[bufnr('%')] = 1

  if !loaded
    call vimfiler#echo_error(
          \ '[vimfiler] Failed to open Buffer "'. bufname .'".')
    return
  endif

  let context.path = path
  " echomsg path

  call vimfiler#handler#_event_handler('BufReadCmd', context)

  call vimfiler#handler#_event_bufwin_enter(bufnr('%'))

  if context.find
    call vimfiler#mappings#search_cursor(
          \ substitute(vimfiler#helper#_get_cd_path(
          \ search_path), '/$', '', ''))
  endif

  if !context.focus
    if winbufnr(winnr('#')) > 0
      wincmd p
    else
      call vimfiler#util#winmove(
            \ bufwinnr(a:context.alternate_buffer))
    endif
  endif
endfunction

function! vimfiler#init#_default_settings() abort
  call s:buffer_default_settings()

  " Set autocommands.
  augroup vimfiler
    autocmd BufEnter,WinEnter <buffer>
          \ call vimfiler#handler#_event_bufwin_enter(expand('<abuf>'))
    autocmd BufLeave,WinLeave <buffer>
          \ call vimfiler#handler#_event_bufwin_leave(expand('<abuf>'))
    autocmd CursorMoved <buffer>
          \ call vimfiler#handler#_event_cursor_moved()
    autocmd FocusGained <buffer>
          \ call vimfiler#view#_force_redraw_all_vimfiler()
    autocmd WinEnter,VimResized,CursorHold <buffer>
          \ call vimfiler#view#_redraw_all_vimfiler()
  augroup end
endfunction

function! s:buffer_default_settings() abort
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal noreadonly
  setlocal nowrap
  setlocal nospell
  setlocal bufhidden=hide
  setlocal foldcolumn=0
  setlocal nofoldenable
  setlocal nowrap
  setlocal nomodifiable
  setlocal nomodified
  setlocal nolist

  if exists('&colorcolumn')
    setlocal colorcolumn=
  endif

  if has('conceal')
    if &l:conceallevel < 2
      setlocal conceallevel=2
    endif
    setlocal concealcursor=nvc
  endif

  if b:vimfiler.context.explorer
    setlocal nobuflisted
  endif

  if g:vimfiler_force_overwrite_statusline
        \ && &l:statusline !=# b:vimfiler.statusline
    let &l:statusline = b:vimfiler.statusline
  endif
endfunction

function! vimfiler#init#_get_postfix(prefix, is_create) abort
  let buffers = get(a:000, 0, range(1, bufnr('$')))
  let buflist = vimfiler#util#sort_by(filter(map(buffers,
        \ 'bufname(v:val)'), 'stridx(v:val, a:prefix) >= 0'),
        \ "str2nr(matchstr(v:val, '\\d\\+$'))")
  if empty(buflist)
    return ''
  endif

  let num = matchstr(buflist[-1], '@\zs\d\+$')
  return num == '' && !a:is_create ? '' :
        \ '@' . (a:is_create ? (num + 1) : num)
endfunction
function! vimfiler#init#_get_filetype(file) abort
  let ext = tolower(a:file.vimfiler__extension)

  if (vimfiler#util#is_windows() && ext ==? 'LNK')
        \ || get(a:file, 'vimfiler__ftype', '') ==# 'link'
    " Symbolic link.
    return '[L]'
  elseif a:file.vimfiler__is_directory
    " Directory.
    return '[D]'
  elseif has_key(g:vimfiler_extensions.text, ext)
    " Text.
    return '[T]'
  elseif has_key(g:vimfiler_extensions.image, ext)
    " Image.
    return '[I]'
  elseif has_key(g:vimfiler_extensions.archive, ext)
    " Archive.
    return '[A]'
  elseif has_key(g:vimfiler_extensions.multimedia, ext)
    " Multimedia.
    return '[M]'
  elseif a:file.vimfiler__filename =~ '^\.'
        \ || has_key(g:vimfiler_extensions.system, ext)
    " System.
    return '[S]'
  elseif a:file.vimfiler__is_executable
    " Execute.
    return '[X]'
  else
    " Others filetype.
    return '   '
  endif
endfunction
function! vimfiler#init#_get_datemark(file) abort
  let time = localtime() - a:file.vimfiler__filetime
  if time < 86400
    " 60 * 60 * 24
    return '!'
  elseif time < 604800
    " 60 * 60 * 24 * 7
    return '#'
  else
    return '~'
  endif
endfunction
