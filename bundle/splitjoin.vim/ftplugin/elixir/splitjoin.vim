let b:splitjoin_split_callbacks = [
      \ 'sj#elixir#SplitDoBlock',
      \ 'sj#elixir#SplitArray',
      \ 'sj#elixir#SplitPipe',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#elixir#JoinDoBlock',
      \ 'sj#elixir#JoinArray',
      \ 'sj#elixir#JoinCommaDelimitedItems',
      \ 'sj#elixir#JoinPipe',
      \ ]
