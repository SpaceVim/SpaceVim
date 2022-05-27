class C extends Superclass implements Iface {
//      ^ keyword          ^ keyword
  use Trait;
  // < include
  const type X = shape(
  // <- keyword ^ type.builtin
    "a" => int,
  // ^ string
    "b" => string,
  //       ^ type.builtin
  );
}
