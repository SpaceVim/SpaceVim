enum Foo{
    a,
//  ^ @constant
    aa,
//  ^ @constant
    C,
};

void foo(enum Foo f){
    switch ( f ) {
        case a:
         //  ^ @constant
            break;
        case aa:
         //  ^ @constant
            break;
        case C:
            break;
        default:
    }
}
