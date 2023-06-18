pub type Cat {
// <- type.qualifier
//  ^^^^ keyword
//       ^^^ type
//           ^ punctuation.bracket
  Cat(name: String, cuteness: Int)
  // <- constructor
  // ^ punctuation.bracket
  //  ^^^^ property
  //      ^ punctuation.delimiter
  //        ^^^^^^ type.builtin
  //              ^ punctuation.delimiter
  //                ^^^^^^^^ property
  //                        ^ punctuation.delimiter
  //                          ^^^ type.builtin
  //                             ^ punctuation.bracket
}

fn cats() {
  Cat(name: "Nubi", cuteness: 2001)
  // <- type
  // ^ punctuation.bracket
  //  ^^^^ property
  //      ^ punctuation.delimiter
  //        ^^^^^^ string
  //              ^ punctuation.delimiter
  //                ^^^^^^^^ property
  //                        ^ punctuation.delimiter
  //                          ^^^^ number
  //                              ^ punctuation.bracket
  Cat("Ginny", 1950)
  // <- constructor
  // ^ punctuation.bracket
  //  ^^^^^^^ string
  //         ^ punctuation.delimiter
  //           ^^^^ number
  //               ^ punctuation.bracket
}

type Box(inner_type) {
// <- keyword
//   ^^^ type
//      ^ punctuation.bracket
//       ^^^^^^^^^^ type
//                 ^ punctuation.bracket
//                   ^ punctuation.bracket
  Box(inner: inner_type)
  // <- constructor
  // ^ punctuation.bracket
  //  ^^^^^ property
  //       ^ punctuation.delimiter
  //         ^^^^^^^^^^ type
  //                   ^ punctuation.bracket
}

pub opaque type Counter {
// <- type.qualifier
//  ^^^^^^ type.qualifier
//         ^^^^ keyword
//              ^^^^^^^ type
//                      ^ punctuation.bracket
  Counter(value: Int)
}

pub fn have_birthday(person) {
  Person(..person, age: person.age + 1, is_happy: True)
  // <- constructor
  //    ^ punctuation.bracket
  //     ^^ operator
  //       ^^^^^^ variable
  //             ^ punctuation.delimiter
  //               ^^^ property
  //                  ^ punctuation.delimiter
  //                    ^^^^^^ variable
  //                          ^ punctuation.delimiter
  //                           ^^^ property
  //                               ^ operator
  //                                 ^ number
  //                                  ^ punctuation.delimiter
  //                                    ^^^^^^^^ property
  //                                            ^ punctuation.delimiter
  //                                              ^^^^ boolean
  //                                                  ^ punctuation.bracket
}
