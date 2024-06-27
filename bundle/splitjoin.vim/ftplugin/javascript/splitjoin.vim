if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#js#SplitFunction',
        \ 'sj#js#SplitObjectLiteral',
        \ 'sj#js#SplitFatArrowFunction',
        \ 'sj#js#SplitArray',
        \ 'sj#js#SplitOneLineIf',
        \ 'sj#js#SplitArgs',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#js#JoinFatArrowFunction',
        \ 'sj#js#JoinArray',
        \ 'sj#js#JoinArgs',
        \ 'sj#js#JoinFunction',
        \ 'sj#js#JoinOneLineIf',
        \ 'sj#js#JoinObjectLiteral',
        \ ]
endif
