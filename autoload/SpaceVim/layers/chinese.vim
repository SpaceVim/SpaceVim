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
        \ ]
  call add(plugins, [g:_spacevim_root_dir . 'bundle/ChineseLinter.vim'    , {'merged' : 0, 'on_cmd' : 'CheckChinese', 'on_ft' : ['markdown', 'text']}])
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


" 定义快捷键映射
nnoremap <silent> <Plug>ConvertChineseNumberToDigit  :call <sid>ConvertChineseNumberToDigit('normal')<cr>
vnoremap <silent> <Plug>ConvertChineseNumberToDigit  :call <sid>ConvertChineseNumberToDigit('visual')<cr>

" 函数定义
function! s:ConvertChineseNumberToDigit(mode) range
  let save_cursor = getcurpos()
  let save_register = @k
  if a:mode == 'normal'
    " 正常模式处理
    let cword = expand('<cword>')
    let rst = substitute(cword, Zh2Num#getZhNumPattern(), '\=Zh2Num#Translator(submatch(0))', "g")
    if rst != cword
      let @k = rst
      normal! viw"kp
    endif
  else
    " 可视模式处理
    normal! gv
    if mode() == "\<C-V>"
      " 块选择模式
      let [line_start, column_start] = getpos("'<")[1:2]
      let [line_end, column_end] = getpos("'>")[1:2]
      if column_end < column_start
        let [column_start, column_end] = [column_end, column_start]
      endif
      for line_num in range(line_start, line_end)
        let line = getline(line_num)
        let line_utf8 = iconv(line, &encoding, 'UTF-8')
        let selectedText = line_utf8[column_start - 1: column_end - 1]
        let translatedText = substitute(selectedText, Zh2Num#getZhNumPattern(), '\=Zh2Num#Translator(submatch(0))', 'g')
        let newLine = line[:column_start - 2] . translatedText . line[column_end:]
        call setline(line_num, newLine)
      endfor
    else
      " 其他可视模式
      normal! "ky
      let selectedText = iconv(@k, &encoding, 'UTF-8')
      let translatedText = substitute(selectedText, Zh2Num#getZhNumPattern(), '\=Zh2Num#Translator(submatch(0))', 'g')
      if translatedText != selectedText
        call setreg('k', translatedText)
        normal! gv"kp
      endif
    endif
  endif
  call setpos('.', save_cursor)
  let @k = save_register
endfunction

nnoremap <silent> <Plug>ConvertDigitToChineseNumberLower  :call <sid>ConvertDigitToChineseNumber('normal', "lower")<cr>
vnoremap <silent> <Plug>ConvertDigitToChineseNumberLower  :call <sid>ConvertDigitToChineseNumber('visual', "lower")<cr>

nnoremap <silent> <Plug>ConvertDigitToChineseNumberUpper  :call <sid>ConvertDigitToChineseNumber('normal', "upper")<cr>
vnoremap <silent> <Plug>ConvertDigitToChineseNumberUpper  :call <sid>ConvertDigitToChineseNumber('visual', "upper")<cr>

function! s:ConvertDigitToChineseNumber(mode, caseType) abort
  let save_cursor = getcurpos()
  let save_register = @k
  let cword = expand('<cword>')
  if a:mode == 'normal'
    if !empty(cword)
      let rst = substitute(cword, Num2Zh#getNumberPattern(), '\=Num2Zh#Translator(submatch(0), "'. a:caseType .'")', "g")
      if rst != cword
          let @k = rst
          normal! viw"kp
      endif
    endif
    " 如果是block模式，则特别处理
  elseif a:mode == 'visual'
    normal! gv
    if mode() == "\<C-V>"
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
        if column_end < column_start
            let [column_start, column_end] = [column_end, column_start]
        endif
        for line_num in range(line_start, line_end)
            let line = getline(line_num)
            " 将行文本转换为UTF-8编码
            let line_utf8 = iconv(line, &encoding, 'UTF-8')
            let selectedText = line_utf8[column_start - 1: column_end - 1]
            let translatedText = substitute(selectedText, Num2Zh#getNumberPattern(), '\=Num2Zh#Translator(submatch(0), "' . a:caseType . '")', 'g')
            let newLine = line[:column_start - 2] . translatedText . line[column_end:]
            call setline(line_num, newLine)
        endfor
    else
        " 对其他模式的处理
        if mode() == 'line'
            normal! '[V']
        elseif mode() == 'char'
            normal! `[v`]
        elseif mode() ==? 'v'
            normal! gv
        else
            normal! '[v']
        endif

        " 获取选择的文本，将其保存在寄存器t中
        normal! "ky
        let selectedText = iconv(@k, &encoding, 'UTF-8')

        " 转换文本
        let translatedText = substitute(selectedText, Num2Zh#getNumberPattern(), '\=Num2Zh#Translator(submatch(0), "' . a:caseType . '")', 'g')

        if translatedText != selectedText
          " 替换原文本
          call setreg('k', translatedText)
          normal! gv"kp
        endif
    endif
  endif
  call setpos('.', save_cursor)
  let @k = save_register
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
