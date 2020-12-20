"=============================================================================
" FILE: raw.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! dein#types#raw#define() abort
  return s:type
endfunction

let s:type = {
      \ 'name': 'raw',
      \ }

function! s:type.init(repo, options) abort
  " No auto detect.
  if a:repo !~# '^https://.*\.vim$' || !has_key(a:options, 'script_type')
    return {}
  endif

  let directory = substitute(fnamemodify(a:repo, ':h'), '\.git$', '', '')
  let directory = substitute(directory, '^https:/\+\|^git@', '', '')
  let directory = substitute(directory, ':', '/', 'g')

  return { 'name': dein#parse#_name_conversion(a:repo), 'type' : 'raw',
        \  'path': dein#util#_get_base_path().'/repos/'.directory }
endfunction

function! s:type.get_sync_command(plugin) abort
  let path = a:plugin.path
  if !isdirectory(path)
    " Create script type directory.
    call mkdir(path, 'p')
  endif

  let outpath = path . '/' . fnamemodify(a:plugin.repo, ':t')
  return dein#util#_download(a:plugin.repo, outpath)
endfunction
