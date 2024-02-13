"=============================================================================
" chinese.vim --- SpaceVim chinese layer
" Copyright (c) 2016-2024 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section Chinese, layers-chinese
" @parentsection layers
" `chinese` layer provides Chinese specific function for SpaceVim.
" This layer is not loaded by default, to use this layer, add following
" snippet into your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'chinese'
" <
"
" @subsection key bindings
" >
"   Key binding     Description
"   SPC l c         check with ChineseLinter
"   SPC x g t       translate current word
"   SPC n c d       convert chinese number to digit 
" <
" 


function! SpaceVim#layers#chinese#plugins() abort
  let plugins = [
        \ ['yianwillis/vimcdoc'          , {'merged' : 0}],
        \ ['NamelessUzer/Vim-Natural-Language-Number-Translator'          , {'merged' : 0}],
        \ ['voldikss/vim-translator' , {'merged' : 0, 'on_cmd' : ['Translate', 'TranslateW', 'TranslateR', 'TranslateX']}],
        \ ['wsdjeg/ChineseLinter.vim'    , {'merged' : 0, 'on_cmd' : 'CheckChinese', 'on_ft' : ['markdown', 'text']}],
        \ ]
  if SpaceVim#layers#isLoaded('ctrlp')
    call add(plugins, ['vimcn/ctrlp.cnx', {'merged' : 0}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#chinese#config() abort
  if has_key(g:_spacevim_mappings_space.x, 't')
    let g:_spacevim_mappings_space.x.t.name = '+Transpose/Translate'
  else
    let g:_spacevim_mappings_space.x.t = {'name' : '+Translate'}
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 't'], 'Translate'         , 'translate-current-word'  , 1)
  if !has_key(g:_spacevim_mappings_space.x, 'g')
    let g:_spacevim_mappings_space.x.g = {'name' : '+Grammarous'}
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'g', 'c']     , 'CheckChinese', 'check-with-ChineseLinter', 1)
  let g:_spacevim_mappings_space.n.c = {'name' : '+Convert'}
  call SpaceVim#mapping#space#def('nmap', ['n', 'c', 'd'], '<Plug>ConvertChineseNumberToDigit', 'convert Chinese number to digit', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['n', 'c', 'z'], '<Plug>ConvertDigitToChineseNumberLower', 'convert digit to Lower Chinese number', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['n', 'c', 'Z'], '<Plug>ConvertDigitToChineseNumberUpper', 'convert digit to Upper Chinese number', 0, 1)
  " do not load vimcdoc plugin 
  let g:loaded_vimcdoc = 1
endfunction

function! SpaceVim#layers#chinese#health() abort
  call SpaceVim#layers#chinese#plugins()
  call SpaceVim#layers#chinese#config()
  return 1
endfunction

command! -nargs=0 -range ConvertChineseNumberToDigit :<line1>,<line2>call s:ConvertChineseNumberToDigit()
nnoremap <silent> <Plug>ConvertChineseNumberToDigit  :ConvertChineseNumberToDigit<cr>
vnoremap <silent> <Plug>ConvertChineseNumberToDigit  :ConvertChineseNumberToDigit<cr>
function! s:ConvertChineseNumberToDigit() range
  let save_cursor = getcurpos()
  let ChineseNumberPattern = '[〇一二三四五六七八九十百千万亿兆零壹贰叁肆伍陆柒捌玖拾佰仟萬億两点]\+'
  if mode() ==? 'n' && a:firstline == a:lastline
    let cword = expand('<cword>')
    let cword = substitute(cword, ChineseNumberPattern, '\=Zh2Num#Translator(submatch(0))', "g")
    let save_register_k = getreg("k")
    call setreg("k", cword)
    normal! viw"kp
    call setreg("k", save_register_k)
  else
    silent execute a:firstline . "," . a:lastline . 'substitute/' . ChineseNumberPattern . '/\=Zh2Num#Translator(submatch(0))/g'
  endif
  call setpos('.', save_cursor)
endfunction

command! -nargs=0 -range ConvertDigitToChineseNumberLower :<line1>,<line2>call s:ConvertDigitToChineseNumber("lower")
nnoremap <silent> <Plug>ConvertDigitToChineseNumberLower  :ConvertDigitToChineseNumberLower<cr>
vnoremap <silent> <Plug>ConvertDigitToChineseNumberLower  :ConvertDigitToChineseNumberLower<cr>

command! -nargs=0 -range ConvertDigitToChineseNumberUpper :<line1>,<line2>call s:ConvertDigitToChineseNumber("upper")
nnoremap <silent> <Plug>ConvertDigitToChineseNumberUpper  :ConvertDigitToChineseNumberUpper<cr>
vnoremap <silent> <Plug>ConvertDigitToChineseNumberUpper  :ConvertDigitToChineseNumberUpper<cr>

function! s:ConvertDigitToChineseNumber(style) range
  let save_cursor = getcurpos()
  let NumberPattern = '\v\d+(\.\d+)?'
  if mode() ==? 'n' && a:firstline == a:lastline
    let cword = expand('<cword>')
    " 在这里使用双引号和 . 连接符来正确地引用 a:style
    let cword = substitute(cword, NumberPattern, '\=Num2Zh#Translator(submatch(0), "'.a:style.'")', "g")
    let save_register_k = getreg("k")
    call setreg("k", cword)
    normal! viw"kp
    call setreg("k", save_register_k)
  else
    " 在执行替换的字符串中正确使用 a:style 参数
    silent execute a:firstline . "," . a:lastline . 'substitute/' . NumberPattern . '/\=Num2Zh#Translator(submatch(0), "'.a:style.'")/g'
  endif
  call setpos('.', save_cursor)
endfunction
" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

" vim:set et nowrap sw=2 cc=80:
