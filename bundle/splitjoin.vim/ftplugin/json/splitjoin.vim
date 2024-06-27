let b:splitjoin_split_callbacks = [
      \ 'sj#js#SplitObjectLiteral',
      \ 'sj#js#SplitArray',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#js#JoinArray',
      \ 'sj#js#JoinObjectLiteral',
      \ ]

" JSON does not support trailing commas
let b:splitjoin_trailing_comma = 0
