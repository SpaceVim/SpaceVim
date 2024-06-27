if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#lua#SplitTable',
        \ 'sj#lua#SplitFunction',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#lua#JoinTable',
        \ 'sj#lua#JoinFunction',
        \ ]
endif
