bring cloud;
// <- keyword

class Foo {
// <- keyword
//    ^   variable
//        ^ punctuation.bracket
  name: str;
//^    field
//      ^   type.builtin
//         ^ punctuation.delimiter
  init(name:  str) {
//^    keyword
//     ^    variable
    this.name = name;
//      ^ punctuation.delimiter
//            ^ operator
  }
}
