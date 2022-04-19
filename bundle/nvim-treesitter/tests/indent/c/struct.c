struct foo {
    int a;
    struct bar {
        int x;
    } b;
};

union baz {
    struct foo;
    int x;
};
