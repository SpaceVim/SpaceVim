"=============================================================================
" FILE: vimfiler.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_vimfiler')
  finish
elseif v:version < 703
  echomsg 'vimfiler does not work this version of Vim "' . v:version . '".'
  finish
endif

" Global options definition.
let g:vimfiler_as_default_explorer =
      \ get(g:, 'vimfiler_as_default_explorer', 0)
let g:vimfiler_define_wrapper_commands =
      \ get(g:, 'vimfiler_define_wrapper_commands', 0)


" Plugin keymappings
nnoremap <silent> <Plug>(vimfiler_split_switch)
      \ :<C-u><SID>call_vimfiler({ 'split' : 1 }, '')<CR>
nnoremap <silent> <Plug>(vimfiler_split_create)
      \ :<C-u>VimFilerSplit<CR>
nnoremap <silent> <Plug>(vimfiler_switch)
      \ :<C-u>VimFiler<CR>
nnoremap <silent> <Plug>(vimfiler_create)
      \ :<C-u>VimFilerCreate<CR>
nnoremap <silent> <Plug>(vimfiler_simple)
      \ :<C-u>VimFilerSimple<CR>


command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFiler
      \ call vimfiler#init#_command({}, <q-args>)
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerDouble
      \ call vimfiler#init#_command({ 'double' : 1 }, <q-args>)
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerCurrentDir
      \ call vimfiler#init#_command({}, <q-args> . ' ' . getcwd())
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerBufferDir
      \ call vimfiler#init#_command({}, <q-args> . ' ' .
      \ vimfiler#helper#_get_buffer_directory(bufnr('%')))
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerCreate
      \ call vimfiler#init#_command({ 'create' : 1 }, <q-args>)
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerSimple
      \ call vimfiler#init#_command({ 'simple' : 1, 'split' : 1, 'create' : 1 }, <q-args>)
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerSplit
      \ call vimfiler#init#_command({ 'split' : 1, }, <q-args>)
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerTab
      \ call vimfiler#init#_command({ 'tab' : 1 }, <q-args>)
command! -nargs=? -bar -complete=customlist,vimfiler#complete VimFilerExplorer
      \ call vimfiler#init#_command({ 'explorer' : 1, }, <q-args>)
command! -nargs=1 -bar VimFilerClose call vimfiler#mappings#close(<q-args>)

augroup vimfiler
  autocmd BufEnter,VimEnter,BufNew,BufWinEnter,BufRead,BufCreate
        \ * call s:browse_check(expand('<amatch>'))
augroup END

if g:vimfiler_define_wrapper_commands
  " Define wrapper commands.
  command! -bang -bar -complete=customlist,vimfiler#complete -nargs=*
        \ VimFilerEdit  edit<bang> <args>
  command! -bang -bar -complete=customlist,vimfiler#complete -nargs=*
        \ VimFilerRead  read<bang> <args>
  command! -bang -bar -complete=customlist,vimfiler#complete -nargs=1
        \ VimFilerSource  source<bang> <args>
  command! -bang -bar -complete=customlist,vimfiler#complete -nargs=* -range=%
        \ VimFilerWrite  <line1>,<line2>write<bang> <args>
endif

function! s:browse_check(path) abort
  if !g:vimfiler_as_default_explorer
        \ || a:path == ''
        \ || bufnr('%') != expand('<abuf>')
    return
  endif

  " Disable netrw.
  augroup FileExplorer
    autocmd!
  augroup END

  let path = a:path
  " For ":edit ~".
  if fnamemodify(path, ':t') ==# '~'
    let path = '~'
  endif

  if &filetype ==# 'vimfiler' && line('$') != 1
    return
  endif

  if isdirectory(vimfiler#util#expand(path))
    call vimfiler#handler#_event_handler('BufReadCmd')
  endif
endfunction

let g:loaded_vimfiler = 1
