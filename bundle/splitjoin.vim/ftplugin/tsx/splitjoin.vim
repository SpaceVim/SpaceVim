let b:splitjoin_split_callbacks = [
      \ 'sj#jsx#SplitJsxExpression',
      \ 'sj#html#SplitTags',
      \ 'sj#html#SplitAttributes',
      \ 'sj#js#SplitObjectLiteral',
      \ 'sj#js#SplitFatArrowFunction',
      \ 'sj#js#SplitArray',
      \ 'sj#js#SplitFunction',
      \ 'sj#js#SplitOneLineIf',
      \ 'sj#js#SplitArgs',
      \ 'sj#jsx#SplitSelfClosingTag'
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#jsx#JoinJsxExpression',
      \ 'sj#html#JoinAttributes',
      \ 'sj#jsx#JoinHtmlTag',
      \ 'sj#js#JoinFatArrowFunction',
      \ 'sj#js#JoinArray',
      \ 'sj#js#JoinArgs',
      \ 'sj#js#JoinFunction',
      \ 'sj#js#JoinOneLineIf',
      \ 'sj#js#JoinObjectLiteral',
      \ ]
