pub type Cat {
// <- keyword
//  ^ keyword.function
//       ^ type
//           ^ punctuation.bracket
  Cat(name: String, cuteness: Int)
  // <- type
  // ^ punctuation.bracket
  //  ^ property
  //      ^ property
  //        ^ type
  //              ^ punctuation.delimiter
  //                ^ property
  //                        ^ property
  //                          ^ type
  //                             ^ punctuation.bracket
}

fn cats() {
  Cat(name: "Nubi", cuteness: 2001)
  // <- type
  // ^ punctuation.bracket
  //  ^ property
  //      ^ property
  //        ^ string
  //              ^ punctuation.delimiter
  //                ^ property
  //                        ^ property
  //                          ^ number
  Cat("Ginny", 1950)
  // <- type
  // ^ punctuation.bracket
  //  ^ string
  //         ^ punctuation.delimiter
  //           ^ number
  //               ^ punctuation.bracket
}

type Box(inner_type) {
// <- keyword.function
//   ^ type
//      ^ punctuation.bracket
//       ^ parameter
//                 ^ punctuation.bracket
//                   ^ punctuation.bracket
  Box(inner: inner_type)
  // <- type
  // ^ punctuation.bracket
  //  ^ property
  //       ^ property
  //         ^ type
  //                   ^ punctuation.bracket
}

pub opaque type Counter {
// <- keyword
//  ^ keyword
//         ^ keyword.function
//              ^ type
//                      ^ punctuation.bracket
  Counter(value: Int)
}

pub fn have_birthday(person) {
  Person(..person, age: person.age + 1, is_happy: True)
  // <- type
  //    ^ punctuation.bracket
  //     ^ operator
  //       ^ variable
  //             ^ punctuation.delimiter
  //               ^ property
  //                  ^ property
  //                    ^ variable
  //                          ^ punctuation.delimiter
  //                           ^ property
  //                               ^ operator
  //                                 ^ number
  //                                  ^ punctuation.delimiter
  //                                    ^ property
  //                                            ^ property
  //                                              ^ boolean
  //                                                  ^ punctuation.bracket
}
