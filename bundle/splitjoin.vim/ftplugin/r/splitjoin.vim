if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#r#SplitFuncall'
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#r#JoinFuncall',
        \ 'sj#r#JoinSmart'
        \ ]
endif
