let b:splitjoin_split_callbacks = [
      \ 'sj#sh#SplitBySemicolon',
      \ 'sj#sh#SplitWithBackslash',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#sh#JoinBackslashedLine',
      \ 'sj#sh#JoinWithSemicolon',
      \ ]
