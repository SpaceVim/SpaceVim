void foo(int x, int y)
{
    if ((x*x - y*y > 0) ||
        (x == 1 || y == 1) &&
        (x != 2 && y != 2)
    ) {
        return;
    }

    int z = (x + y) *
        (x - y);
}
