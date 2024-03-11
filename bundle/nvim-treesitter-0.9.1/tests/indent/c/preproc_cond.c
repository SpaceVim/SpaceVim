void foo(int x)
{
    x = x + 1;
#if 1
    x = x + 2;
#else
    x = x + 3;
#endif
    x = x + 4;
}
