scriptencoding utf-8
let s:system = {}

let s:system['isWindows'] = has('win16') || has('win32') || has('win64')

let s:system['isLinux'] = has('unix') && !has('macunix') && !has('win32unix')

let s:system['isOSX'] = has('macunix')

function! s:name() abort
  if s:system.isLinux
    return 'Linux'
  elseif s:system.isWindows
    return 'Windows'
  else
    return 'OSX'
  endif
endfunction

let s:system['name'] = function('s:name')

function! s:isDarwin() abort
  if exists('s:is_darwin')
    return s:is_darwin
  endif

  if has('macunix')
    let s:is_darwin = 1
    return s:is_darwin
  endif

  if ! has('unix')
    let s:is_darwin = 0
    return s:is_darwin
  endif

  if system('uname -s') ==# "Darwin\n"
    let s:is_darwin = 1
  else
    let s:is_darwin = 0
  endif

  return s:is_darwin
endfunction

let s:system['isDarwin'] = function('s:isDarwin')

function! s:fileformat() abort
  let fileformat = ''

  if &fileformat ==? 'dos'
    let fileformat = ''
  elseif &fileformat ==? 'unix'
    if s:isDarwin()
      let fileformat = ''
    else
      let fileformat = ''
    endif
  elseif &fileformat ==? 'mac'
    let fileformat = ''
  endif

  return fileformat
endfunction

let s:system['fileformat'] = function('s:fileformat')


function! SpaceVim#api#system#get() abort
  return deepcopy(s:system)
endfunction

" vim:set et sw=2:
