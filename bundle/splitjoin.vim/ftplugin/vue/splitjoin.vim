let b:splitjoin_split_callbacks = [
      \ 'sj#html#SplitTags',
      \ 'sj#html#SplitAttributes',
      \ 'sj#vue#SplitCssDefinition',
      \ 'sj#vue#SplitCssMultilineSelector',
      \ 'sj#js#SplitObjectLiteral',
      \ 'sj#js#SplitFatArrowFunction',
      \ 'sj#js#SplitArray',
      \ 'sj#js#SplitFunction',
      \ 'sj#js#SplitOneLineIf',
      \ 'sj#js#SplitArgs',
\ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#html#JoinAttributes',
      \ 'sj#html#JoinTags',
      \ 'sj#vue#JoinCssDefinition',
      \ 'sj#vue#JoinCssMultilineSelector',
      \ 'sj#js#JoinFatArrowFunction',
      \ 'sj#js#JoinArray',
      \ 'sj#js#JoinArgs',
      \ 'sj#js#JoinFunction',
      \ 'sj#js#JoinOneLineIf',
      \ 'sj#js#JoinObjectLiteral',
\ ]
