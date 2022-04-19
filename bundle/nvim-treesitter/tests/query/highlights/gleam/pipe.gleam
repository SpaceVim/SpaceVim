pub fn run() {
  1
  // <- number
  |> add(_, 2)
  // <- operator
  // ^ function
  //    ^ punctuation.bracket
  //     ^ comment
  //      ^ punctuation.delimiter
  //        ^ number
  //         ^ punctuation.bracket
  |> add(3)
  // <- operator
  // ^ function
  //    ^ punctuation.bracket
  //     ^ number
  //      ^ punctuation.bracket
}
