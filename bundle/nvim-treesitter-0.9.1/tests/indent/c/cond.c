void foo(int x)
{
    if (x > 10) {
        return;
    } else if (x < -10) {
        x = -10;
    } else {
        x = -x;
    }
}
