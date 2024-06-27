let b:splitjoin_split_callbacks = [
      \ 'sj#html#SplitTags',
      \ 'sj#html#SplitAttributes',
      \ 'sj#handlebars#SplitBlockComponent',
      \ 'sj#handlebars#SplitComponent',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#html#JoinAttributes',
      \ 'sj#html#JoinTags',
      \ 'sj#handlebars#JoinBlockComponent',
      \ 'sj#handlebars#JoinComponent',
      \ ]
