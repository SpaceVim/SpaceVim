if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#ruby#SplitModuleNamespace',
        \ 'sj#ruby#SplitArray',
        \ 'sj#ruby#SplitArrayLiteral',
        \ 'sj#ruby#SplitProcShorthand',
        \ 'sj#ruby#SplitBlock',
        \ 'sj#ruby#SplitIfClause',
        \ 'sj#ruby#SplitCachingConstruct',
        \ 'sj#ruby#SplitWhenThen',
        \ 'sj#ruby#SplitCase',
        \ 'sj#ruby#SplitTernaryClause',
        \ 'sj#ruby#SplitOptions',
        \ 'sj#ruby#SplitString',
        \ 'sj#ruby#SplitEndlessDef',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#ruby#JoinModuleNamespace',
        \ 'sj#ruby#JoinArray',
        \ 'sj#ruby#JoinArrayLiteral',
        \ 'sj#ruby#JoinBlock',
        \ 'sj#ruby#JoinHash',
        \ 'sj#ruby#JoinIfClause',
        \ 'sj#ruby#JoinTernaryClause',
        \ 'sj#ruby#JoinCachingConstruct',
        \ 'sj#ruby#JoinContinuedMethodCall',
        \ 'sj#ruby#JoinHeredoc',
        \ 'sj#ruby#JoinWhenThen',
        \ 'sj#ruby#JoinCase',
        \ 'sj#ruby#JoinOnelineDef',
        \ ]
endif
