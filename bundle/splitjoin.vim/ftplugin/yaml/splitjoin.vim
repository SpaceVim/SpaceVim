if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#yaml#SplitArray',
        \ 'sj#yaml#SplitMap'
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#yaml#JoinArray',
        \ 'sj#yaml#JoinMap'
        \ ]
endif
