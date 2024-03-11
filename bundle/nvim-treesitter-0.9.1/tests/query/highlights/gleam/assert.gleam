pub fn main() {
  assert Ok(i) = parse_int("123")
  // <- exception
  //     ^^ constructor
  //       ^ punctuation.bracket
  //        ^ variable
  //         ^ punctuation.bracket
  //           ^ operator
  //             ^^^^^^^^^ function.call
  //                      ^ punctuation.bracket
  //                       ^^^^^ string
  //                            ^ punctuation.bracket
}
