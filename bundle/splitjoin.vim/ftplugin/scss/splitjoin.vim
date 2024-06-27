if !exists('b:splitjoin_split_callbacks')
  let b:splitjoin_split_callbacks = [
        \ 'sj#css#SplitMultilineSelector',
        \ 'sj#scss#SplitNestedDefinition',
        \ 'sj#css#SplitDefinition',
        \ ]
endif

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#scss#JoinNestedDefinition',
        \ 'sj#css#JoinDefinition',
        \ 'sj#css#JoinMultilineSelector',
        \ ]
endif
