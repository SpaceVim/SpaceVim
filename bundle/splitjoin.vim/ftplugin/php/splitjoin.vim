let b:splitjoin_split_callbacks = [
      \ 'sj#php#SplitMethodChain',
      \ 'sj#php#SplitArray',
      \ 'sj#php#SplitIfClause',
      \ 'sj#php#SplitElseClause',
      \ 'sj#php#SplitBraces',
      \ 'sj#html#SplitTags',
      \ 'sj#php#SplitPhpMarker',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#php#JoinPhpMarker',
      \ 'sj#php#JoinMethodChain',
      \ 'sj#php#JoinArray',
      \ 'sj#php#JoinBraces',
      \ 'sj#php#JoinIfClause',
      \ 'sj#php#JoinElseClause',
      \ 'sj#php#JoinHtmlTags',
      \ ]
