"=============================================================================
" FILE: vimfiler/drive.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let g:vimfiler_detect_drives =
      \ get(g:, 'vimfiler_detect_drives', unite#util#is_windows() ? [
      \     'A:/', 'B:/', 'C:/', 'D:/', 'E:/', 'F:/', 'G:/',
      \     'H:/', 'I:/', 'J:/', 'K:/', 'L:/', 'M:/', 'N:/',
      \     'O:/', 'P:/', 'Q:/', 'R:/', 'S:/', 'T:/', 'U:/',
      \     'V:/', 'W:/', 'X:/', 'Y:/', 'Z:/'
      \ ] : [expand('~'), expand('~/Downloads/')])

function! unite#sources#vimfiler_drive#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'vimfiler/drive',
      \ 'description' : 'candidates from vimfiler drive',
      \ 'default_action' : 'lcd',
      \ 'is_listed' : 0,
      \ }

function! s:source.gather_candidates(args, context) abort
  if !exists('s:drives') || a:context.is_redraw
    " Detect mounted drive.
    let s:drives = copy(g:vimfiler_detect_drives)
    if unite#util#is_mac()
      let s:drives += split(glob('/Volumes/*'), '\n')
    elseif !unite#util#is_windows()
      let s:drives += split(glob('/mnt/*'), '\n')
            \ + split(glob('/media/*'), '\n')
            \ + split(glob('/media/' . $USER . '/*'), '\n')
    endif
    call filter(s:drives, 'isdirectory(v:val)')

    if !empty(unite#get_all_sources('ssh'))
      " Add network drive.
      let s:drives += map(unite#sources#ssh#complete_host('', '', 0),
            \ "'ssh://'.v:val.'/'")
    endif

    let s:drives = unite#util#uniq(s:drives)
  endif

  return map(copy(s:drives), "{
        \ 'word' : v:val,
        \ 'action__path' : v:val,
        \ 'action__directory' : v:val,
        \ 'kind' : (v:val =~ '^ssh://' ?
        \     'directory/ssh' : 'directory'),
        \ }")
endfunction
