int foo(int x)
{
    goto error;
    return 0;
error:
    return 1;
}
