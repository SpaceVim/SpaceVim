"=============================================================================
" chinese.vim --- SpaceVim chinese layer
" Copyright (c) 2016-2021 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
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
        \ ['voldikss/vim-translator' , {'merged' : 0, 'on_cmd' : ['Translate', 'TranslateW', 'TranslateR', 'TranslateX']}],
        \ ['wsdjeg/ChineseLinter.vim'    , {'merged' : 0, 'on_cmd' : 'CheckChinese', 'on_ft' : ['markdown', 'text']}],
        \ ]
  if SpaceVim#layers#isLoaded('ctrlp')
    call add(plugins, ['vimcn/ctrlp.cnx', {'merged' : 0}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#chinese#config() abort
  let g:_spacevim_mappings_space.x.g = {'name' : '+translate'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'g', 't'], 'Translate'         , 'translate current word'  , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['l', 'c']     , 'CheckChinese', 'Check with ChineseLinter', 1)
  let g:_spacevim_mappings_space.n.c = {'name' : '+Convert'}
  call SpaceVim#mapping#space#def('nnoremap', ['n', 'c', 'd'], 'silent call call('
        \ . string(s:_function('s:ConvertChineseNumberUnderCursorToDigit')) . ', [])',
        \ 'Convert Chinese Number to Digit', 1)
  " do not load vimcdoc plugin 
  let g:loaded_vimcdoc = 1
endfunction

function! SpaceVim#layers#chinese#health() abort
  call SpaceVim#layers#chinese#plugins()
  call SpaceVim#layers#chinese#config()
  return 1
endfunction

function! s:ConvertChineseNumberUnderCursorToDigit() abort
  let cword = expand('<cword>')
  let ChineseNumberPattern = "[〇一二三四五六七八九零壹贰叁肆伍陆柒捌玖貮两点]\+"
  while cword =~ ChineseNumberPattern
    let matchword = matchstr(cword, ChineseNumberPattern)
    let cword = substitute(cword, matchword, s:Chinese2Digit(matchword))
  endwhile
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = cword
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

let s:list = SpaceVim#api#import('data#list')
function! s:Chinese2Digit(cnDigitString) abort
  let CN_NUM = {
        \ '〇': 0, '一': 1, '二': 2, '三': 3, '四': 4, '五': 5, '六': 6, '七': 7, '八': 8, '九': 9,
        \ '零': 0, '壹': 1, '贰': 2, '叁': 3, '肆': 4, '伍': 5, '陆': 6, '柒': 7, '捌': 8, '玖': 9,
        \ '貮': 2, '两': 2
        \ }
  let CN_UNIT = {
        \ '十': 10, '拾': 10, '百': 100, '佰': 100, '千': 1000, '仟': 1000, '万': 10000, '萬': 10000,
        \ '亿': 100000000, '億': 100000000, '兆': 1000000000000
        \ }

  let cnList = split(a:cnDigitString, "点")
  let integer = cnList[0]  " 整数部分
  let decimal = len(cnList) == 2 ? cnList[1] : [] " 小数部分
  let unit = 0  " 当前单位
  let parse = []  " 解析数组
  let i = len(integer)
  while i >= 0
    let i -= 1
    let x = integer[i]
    if has_key(CN_UNIT, x)
      " 当前字符是单位
      let unit = CN_UNIT[x]
      if unit == 10000 " 万位
        s:list.push(parse, "w")
        let unit = 1
      elseif unit == 100000000 " 亿位
        s:list.push(parse, "y")
        let unit = 1
      elseif unit == 1000000000000  " 兆位
        s:list.push(parse, "z")
        let unit = 1
        continue
      endif
    else
      " 当前字符是数字
      let dig = CN_NUM[x]
      if unit
        let dig = dig * unit
        let unit = 0
      endif
      s:list.push(parse, dig)
    endif
  endwhile

  if unit == 10  " 处理10-19的数字
    s:list.push(parse, 10)
  endif
  let result = 0
  let tmp = 0
  while parse
    let x = s:list.pop(parse)
    if x == 'w'
        let tmp *= 10000
        let result += tmp
        let tmp = 0
    elseif x == 'y'
        let tmp *= 100000000
        let result += tmp
        let tmp = 0
    elseif x == 'z'
        let tmp *= 1000000000000
        let result += tmp
        let tmp = 0
    else
        let tmp += x
    endif
    let result += tmp
  endwhile

  if !empth(decimal)
    for [k, v] in items(CN_NUM)
      let decimal = substitute(decimal, k, v, 'g')
    endfor
    let decimal = "0." + decimal
    let result += eval(decimal)
  endif
  return result
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
