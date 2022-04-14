macro_rules! foo {
    ($a:ident, $b:ident, $c:ident) => {
        struct a { value: $a };
        struct b { value: $b };
    };
    ($a:ident) => {
        struct a { value: $a };
    };
}

foo! {
    A
}
