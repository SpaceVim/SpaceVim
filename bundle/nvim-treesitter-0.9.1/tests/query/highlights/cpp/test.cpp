#include <iostream>
#include <cstdlib>
//    ^ include
//       ^ string

auto main( int argc, char** argv ) -> int
// ^ type.builtin
      //       ^ parameter
      //    ^ type.builtin
      //    ^ type.builtin
      //                  ^ operator
{
    std::cout << "Hello world!" << std::endl;
    //  ^ punctuation.delimiter
    
    return EXIT_SUCCESS;
    // ^ keyword.return
    //      ^ constant
}
