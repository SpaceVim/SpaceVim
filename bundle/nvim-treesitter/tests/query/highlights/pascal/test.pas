program foobar;
// ^ keyword

var
// <- keyword
  foo: bar;
// ^ variable
//     ^ type
  foo: foo.bar<t>;
// ^ variable
//     ^ type
//         ^ type
//             ^ type
begin
// ^ keyword
  foo := bar;
// ^ variable
//       ^ variable
  foo;
// ^ function
  foo();
// ^ function
  foo(bar(xyz));
// ^ function
//    ^ function
//        ^ variable
  xx + yy;
// ^ variable
//     ^ variable
  xx := y + z + func(a, b, c);
// ^ variable
//      ^ variable
//          ^ variable
//              ^ function
//                   ^ variable
//                      ^ variable
//                         ^ variable
end.
// <- keyword
