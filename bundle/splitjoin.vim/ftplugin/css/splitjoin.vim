if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#css#SplitDefinition',
        \ 'sj#css#SplitMultilineSelector',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#css#JoinDefinition',
        \ 'sj#css#JoinMultilineSelector',
        \ ]
endif
