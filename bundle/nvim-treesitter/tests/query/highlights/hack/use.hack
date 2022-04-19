use const Space\Const\C;
//  ^ keyword
//                    ^ constant
use function Space\Func\F as E;
//                           ^ function
//                      ^ function
use type Space\Type\T;
//  ^ keyword
use namespace Space\Name\N as M;
//  ^ keyword
//             ^ namespace

use namespace Space\Name2\N2, Space\Nothing\N3 as N8, type Space\Type2\N4,;
//                        ^ namespace
//                                                                      ^ type
use namespace Space\Name\N10\{A as A2, B\};
//                        ^ namespace
//                                     ^ namespace
//                                 ^ namespace
use namespace Space\Name\{\C, Slash as Forward};

use \What\Is\This\{function A as A2, B, const H\S\L as stdlib, function F};

use type \{kind,};
use Q\B\{kind2,};
//    ^ namespace
use type Q\B\{kind3,};
// <- include
