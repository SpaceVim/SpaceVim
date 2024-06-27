if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#perl#SplitSuffixIfClause',
        \ 'sj#perl#SplitPrefixIfClause',
        \ 'sj#perl#SplitAndClause',
        \ 'sj#perl#SplitOrClause',
        \ 'sj#perl#SplitHash',
        \ 'sj#perl#SplitWordList',
        \ 'sj#perl#SplitSquareBracketedList',
        \ 'sj#perl#SplitRoundBracketedList',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#perl#JoinIfClause',
        \ 'sj#perl#JoinHash',
        \ 'sj#perl#JoinWordList',
        \ 'sj#perl#JoinSquareBracketedList',
        \ 'sj#perl#JoinRoundBracketedList',
        \ ]
endif
