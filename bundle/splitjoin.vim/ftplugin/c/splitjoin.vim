if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#c#SplitIfClause',
        \ 'sj#c#SplitFuncall',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#c#JoinFuncall',
        \ 'sj#c#JoinIfClause',
        \ ]
endif
