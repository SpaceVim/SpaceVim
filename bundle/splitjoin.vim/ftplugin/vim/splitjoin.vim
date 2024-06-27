if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#vim#SplitIfClause',
        \ 'sj#vim#Split',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#vim#JoinIfClause',
        \ 'sj#vim#Join',
        \ ]
endif
