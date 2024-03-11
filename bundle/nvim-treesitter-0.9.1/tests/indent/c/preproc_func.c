#define FOO(x) do { \
        x = x + 1;  \
        x = x / 2;  \
    } while (x > 0);

void foo(int x)
{
    FOO(x);
}
