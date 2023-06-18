import gleam/io
// <- include
//     ^ namespace
//          ^ operator
//           ^ namespace

import cat as kitten
// <- include
//     ^ namespace
//         ^ keyword
//            ^ namespace

import animal/cat.{Cat, stroke}
// <- include
//     ^ namespace
//           ^ operator
//               ^ punctuation.delimiter
//                ^ punctuation.bracket
//                 ^^^ type
//                    ^ punctuation.delimiter
//                      ^^^^^^ function
//                            ^ punctuation.bracket
