"=============================================================================
" FILE: unite.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_unite')
  finish
elseif v:version < 703
  echoerr 'unite.vim does not work this version of Vim "' . v:version . '".'
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" Wrapper commands.
command! -nargs=* -range -complete=customlist,unite#complete#source
      \ Unite
      \ call unite#helper#call_unite('Unite', <q-args>, <line1>, <line2>)
command! -nargs=* -range -complete=customlist,unite#complete#source
      \ UniteWithCurrentDir
      \ call unite#helper#call_unite('UniteWithCurrentDir', <q-args>, <line1>, <line2>)
command! -nargs=* -range -complete=customlist,unite#complete#source
      \ UniteWithBufferDir
      \ call unite#helper#call_unite('UniteWithBufferDir', <q-args>, <line1>, <line2>)
command! -nargs=* -range -complete=customlist,unite#complete#source
      \ UniteWithProjectDir
      \ call unite#helper#call_unite('UniteWithProjectDir', <q-args>, <line1>, <line2>)
command! -nargs=* -range -complete=customlist,unite#complete#source
      \ UniteWithInputDirectory
      \ call unite#helper#call_unite('UniteWithInputDirectory', <q-args>, <line1>, <line2>)
command! -nargs=* -range -complete=customlist,unite#complete#source
      \ UniteWithCursorWord
      \ call unite#helper#call_unite('UniteWithCursorWord', <q-args>, <line1>, <line2>)
command! -nargs=* -range -complete=customlist,unite#complete#source
      \ UniteWithInput
      \ call unite#helper#call_unite('UniteWithInput', <q-args>, <line1>, <line2>)
command! -nargs=* -complete=customlist,unite#complete#buffer_name
      \ UniteResume
      \ call unite#helper#call_unite_resume(<q-args>)

command! -nargs=? -bar -complete=customlist,unite#complete#buffer_name
      \ UniteClose call unite#view#_close(<q-args>)

command! -count=1 -bar -nargs=? -complete=customlist,unite#complete#buffer_name
      \ UniteNext call unite#start#_pos(<q-args>, 'next', expand('<count>'))
command! -count=1 -bar -nargs=? -complete=customlist,unite#complete#buffer_name
      \ UnitePrevious call unite#start#_pos(<q-args>, 'previous', expand('<count>'))
command! -nargs=? -bar -complete=customlist,unite#complete#buffer_name
      \ UniteFirst call unite#start#_pos(<q-args>, 'first', 1)
command! -nargs=? -bar -complete=customlist,unite#complete#buffer_name
      \ UniteLast call unite#start#_pos(<q-args>, 'last', 1)
command! -nargs=1 -complete=command
      \ UniteDo call unite#start#_do_command(<q-args>)

let g:loaded_unite = 1

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
