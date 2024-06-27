let b:splitjoin_split_callbacks = [
      \ 'sj#coffee#SplitString',
      \ 'sj#python#SplitStatement',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#python#JoinStatement',
      \ 'sj#coffee#JoinString',
      \ ]
