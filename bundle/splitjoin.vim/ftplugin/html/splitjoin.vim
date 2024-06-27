if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#html#SplitTags',
        \ 'sj#html#SplitAttributes'
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#html#JoinAttributes',
        \ 'sj#html#JoinTags'
        \ ]
endif
