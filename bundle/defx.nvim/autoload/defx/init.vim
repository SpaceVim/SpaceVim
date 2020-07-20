"=============================================================================
" FILE: init.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! defx#init#_initialize() abort
  if exists('g:defx#_channel_id')
    return
  endif

  call defx#init#_channel()

  augroup defx
    autocmd!
  augroup END

  let g:defx#_histories = []
endfunction
function! defx#init#_channel() abort
  if !has('python3')
    call defx#util#print_error(
          \ 'defx requires Python3 support("+python3").')
    return v:true
  endif
  if has('nvim') && !has('nvim-0.3.0')
    call defx#util#print_error('defx requires nvim 0.3.0+.')
    return v:true
  endif
  if !has('nvim') && v:version < 801
    call defx#util#print_error('defx requires Vim 8.1+.')
    return v:true
  endif

  try
    if defx#util#has_yarp()
      let g:defx#_yarp = yarp#py3('defx')
      call g:defx#_yarp.request('_defx_init')
      let g:defx#_channel_id = 1
    else
      " rplugin.vim may not be loaded on VimEnter
      if !exists('g:loaded_remote_plugins')
        runtime! plugin/rplugin.vim
      endif

      call _defx_init()
    endif
  catch
    call defx#util#print_error(v:exception)
    call defx#util#print_error(v:throwpoint)

    let python_version_check = defx#init#_python_version_check()
    if python_version_check
      call defx#util#print_error(
            \ 'defx requires Python 3.6.1+.')
    endif

    if defx#util#has_yarp()
      if !has('nvim') && !exists('*neovim_rpc#serveraddr')
        call defx#util#print_error(
              \ 'defx requires vim-hug-neovim-rpc plugin in Vim.')
      endif

      if !exists('*yarp#py3')
        call defx#util#print_error(
              \ 'defx requires nvim-yarp plugin.')
      endif
    else
      call defx#util#print_error(
          \ 'defx failed to load. '
          \ .'Try the :UpdateRemotePlugins command and restart Neovim. '
          \ .'See also :checkhealth.')
    endif

    return v:true
  endtry
endfunction
function! defx#init#_check_channel() abort
  return exists('g:defx#_channel_id')
endfunction

function! defx#init#_python_version_check() abort
  python3 << EOF
import vim
import sys
vim.vars['defx#_python_version_check'] = (
    sys.version_info.major,
    sys.version_info.minor,
    sys.version_info.micro) < (3, 6, 1)
EOF
  return g:defx#_python_version_check
endfunction
function! defx#init#_user_options() abort
  return {
        \ 'auto_cd': v:false,
        \ 'auto_recursive_level': 0,
        \ 'buffer_name': 'default',
        \ 'columns': 'mark:indent:icon:filename:type',
        \ 'direction': '',
        \ 'ignored_files': '.*',
        \ 'listed': v:false,
        \ 'new': v:false,
        \ 'profile': v:false,
        \ 'resume': v:false,
        \ 'root_marker': '[in]: ',
        \ 'search': '',
        \ 'session_file': '',
        \ 'show_ignored_files': v:false,
        \ 'split': 'no',
        \ 'sort': 'filename',
        \ 'toggle': v:false,
        \ 'wincol': &columns / 4,
        \ 'winheight': 30,
        \ 'winrelative': 'editor',
        \ 'winrow': &lines / 3,
        \ 'winwidth': 90,
        \ }
endfunction
function! s:internal_options() abort
  return {
        \ 'cursor': line('.'),
        \ 'drives': [],
        \ 'prev_bufnr': bufnr('%'),
        \ 'prev_last_bufnr': bufnr('#'),
        \ 'prev_winid': win_getid(),
        \ 'visual_start': getpos("'<")[1],
        \ 'visual_end': getpos("'>")[1],
        \ }
endfunction
function! defx#init#_context(user_context) abort
  let buffer_name = get(a:user_context, 'buffer_name', 'default')
  let context = s:internal_options()
  call extend(context, defx#init#_user_options())
  let custom = defx#custom#_get()
  if has_key(custom.option, '_')
    call extend(context, custom.option['_'])
  endif
  if has_key(custom.option, buffer_name)
    call extend(context, custom.option[buffer_name])
  endif
  call extend(context, a:user_context)
  return context
endfunction
