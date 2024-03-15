" 使い方
" このファイルを :source する
" test_files に保存されているファイルを開き、:ContextFiletypeTest
" マッチしない filetype があれば quickfix へと出力される

" テストファイルの作り方
" コンテキストが書かれたコード記述する
" context_filetype#get() が返してほしい位置で filetype を `filetype` で記述する


function! s:checker(filename)
  try
    let pos = '.'->getpos()
    let filetype_pattern = '`\w\+`'
    let result = ''

    normal! gg0
    while filetype_pattern->search('W')
      if context_filetype#get_filetype() !=# '<cword>'->expand()
        let result ..= printf("%s:%d: bad context filetype\n",
              \               a:filename, '.'->line())
      endif
    endwhile

    cgetexpr result
    cwindo
  finally
    call setpos('.', pos)
  endtry
endfunction

command! ContextFiletypeTest call s:checker('%:p'->expand())
