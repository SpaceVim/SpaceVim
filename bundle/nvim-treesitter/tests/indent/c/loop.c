void foo(int x)
{
    while (x > 0) {
        x--;
        continue;
    }

    for (int i = 0; i < 5; ++i) {
        x++;
        break;
    }

    do {
        x++;
    } while (x < 0);
}
