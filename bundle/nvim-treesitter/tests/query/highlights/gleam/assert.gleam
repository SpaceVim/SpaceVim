pub fn main() {
  assert Ok(i) = parse_int("123")
  // <- exception
  //     ^ type
  //       ^ punctuation.bracket
  //        ^ variable
  //         ^ punctuation.bracket
  //           ^ operator
  //             ^ function
  //                      ^ punctuation.bracket
  //                       ^ string
  //                            ^ punctuation.bracket
}
