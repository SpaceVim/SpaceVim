let b:splitjoin_split_callbacks = [
      \ 'sj#eruby#SplitHtmlTags',
      \ 'sj#eruby#SplitIfClause',
      \ 'sj#ruby#SplitOptions',
      \ 'sj#eruby#SplitHtmlAttributes',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#eruby#JoinIfClause',
      \ 'sj#ruby#JoinHash',
      \ 'sj#html#JoinAttributes',
      \ 'sj#html#JoinTags',
      \ ]
