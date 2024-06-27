let b:splitjoin_split_callbacks = [
      \ 'sj#go#SplitImports',
      \ 'sj#go#SplitVars',
      \ 'sj#go#SplitFunc',
      \ 'sj#go#SplitFuncCall',
      \ 'sj#go#SplitStruct',
      \ 'sj#go#SplitSingleLineCurlyBracketBlock',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#go#JoinImports',
      \ 'sj#go#JoinVars',
      \ 'sj#go#JoinStructDeclaration',
      \ 'sj#go#JoinStruct',
      \ 'sj#go#JoinFuncCallOrDefinition',
      \ 'sj#go#JoinSingleLineFunctionBody',
      \ ]
