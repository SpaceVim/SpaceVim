struct foo {
    int x, y;
};

struct foo bar(int x, int y) {
    return (struct foo) {
        .x = x,
        .y = y
    };
}
