<<A1>>
newtype T1 = ?shape(
//     TODO: ?operator (? not captureable at the moment)
  ?'int' => int
//       ^ operator
);

<<A3(1), A2(2,3,)>>
//       ^ attribute
type T2 = (function(T1): string);
//    ^ type
//          TODO: keyword.function (currently not in AST)

<<A4(1), A5, A6(1,3,4)>>
newtype T3 as int = int;
