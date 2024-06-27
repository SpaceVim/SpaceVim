let b:splitjoin_split_callbacks = [
      \ 'sj#rust#SplitBlockClosure',
      \ 'sj#rust#SplitExprClosure',
      \ 'sj#rust#SplitMatchExpression',
      \ 'sj#rust#SplitMatchClause',
      \ 'sj#rust#SplitQuestionMark',
      \ 'sj#rust#SplitCurlyBrackets',
      \ 'sj#rust#SplitImportList',
      \ 'sj#rust#SplitUnwrapIntoEmptyMatch',
      \ 'sj#rust#SplitIfLetIntoMatch',
      \ 'sj#rust#SplitArray',
      \ 'sj#rust#SplitArgs',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#rust#JoinEmptyMatchIntoIfLet',
      \ 'sj#rust#JoinMatchClause',
      \ 'sj#rust#JoinMatchStatement',
      \ 'sj#rust#JoinClosure',
      \ 'sj#rust#JoinCurlyBrackets',
      \ 'sj#rust#JoinImportList',
      \ 'sj#rust#JoinArray',
      \ 'sj#rust#JoinArgs',
      \ ]
