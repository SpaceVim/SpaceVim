pub fn add(x: Int, y: Int) -> Int {
// <- keyword
//  ^ keyword.function
//     ^ function
//        ^ punctuation.bracket
//         ^ parameter
//          ^ parameter
//            ^ type
//               ^ punctuation.delimiter
//                 ^ parameter
//                  ^ parameter
//                    ^ type
//                       ^ punctuation.bracket
//                         ^ operator
//                            ^ type
//                                ^ punctuation.bracket
}
// <- punctuation.bracket

pub fn twice(f: fn(t) -> t, x: t) -> t {
// <- keyword
//  ^ keyword.function
//     ^ function
//          ^ punctuation.bracket
//           ^ parameter
//            ^ parameter
//              ^ keyword.function
//                ^ punctuation.bracket
//                 ^ type
//                  ^ punctuation.bracket
//                    ^ operator
//                       ^ type
//                        ^ punctuation.delimiter
//                          ^ parameter
//                           ^ parameter
//                             ^ type
//                              ^ punctuation.bracket
//                                ^ operator
//                                   ^ type
//                                     ^ punctuation.bracket
}
// <- punctuation.bracket

fn list_of_two(my_value: a) -> List(a) {
// <- keyword.function
// ^ function
//            ^ punctuation.bracket
//             ^ parameter
//                     ^ parameter
//                       ^ type
//                        ^ punctuation.bracket
//                          ^ operator
//                             ^ type
//                                 ^ punctuation.bracket
//                                  ^ type
//                                   ^ punctuation.bracket
//                                     ^ punctuation.bracket
}
// <- punctuation.bracket

fn replace(
// <- keyword.function
// ^ function
//        ^ punctuation.bracket
  in string: String,
  // <- symbol
  // ^ parameter
  //       ^ parameter
  //         ^ type
  //               ^ punctuation.delimiter
  each pattern: String,
  // <- symbol
  //   ^ parameter
  //          ^ parameter
  //            ^ type
  //                  ^ punctuation.delimiter
  with replacement: String,
  // <- symbol
  //   ^ parameter
  //              ^ parameter
  //                ^ type
  //                      ^ punctuation.delimiter
) {
  replace(in: "A,B,C", each: ",", with: " ")
  // <- function
  //     ^ punctuation.bracket
  //      ^ symbol
  //        ^ symbol
  //          ^ string
  //                 ^ punctuation.delimiter
  //                   ^ symbol
  //                       ^ symbol
  //                         ^ string
  //                            ^ punctuation.delimiter
  //                              ^ symbol
  //                                  ^ symbol
  //                                    ^ string
  //                                       ^ punctuation.bracket
}
// <- punctuation.bracket

pub external fn random_float() -> Float = "rand" "uniform"
// <- keyword
//  ^ keyword
//           ^ keyword.function
//              ^ function
//                          ^ punctuation.bracket
//                           ^ punctuation.bracket
//                             ^ operator
//                                ^ type
//                                      ^ operator
//                                        ^ namespace
//                                               ^ function

pub external fn inspect(a) -> a = "Elixir.IO" "inspect"
// <- keyword
//  ^ keyword
//           ^ keyword.function
//              ^ function
//                     ^ punctuation.bracket
//                      ^ type
//                       ^ punctuation.bracket
//                         ^ operator
//                            ^ type
//                              ^ operator
//                                ^ namespace
//                                            ^ function
