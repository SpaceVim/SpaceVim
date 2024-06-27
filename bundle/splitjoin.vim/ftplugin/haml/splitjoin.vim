let b:splitjoin_split_callbacks = [
      \ 'sj#haml#SplitInterpolation',
      \ 'sj#haml#SplitInlineInterpolation',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#haml#JoinInterpolation',
      \ 'sj#haml#JoinToInlineInterpolation',
      \ ]
