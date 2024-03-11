fn foo<T>(t: T) -> i32
where
    T: Debug,
{
    1
}

fn foo<T>(t: T) -> i32 where
    T: Debug,
{
    1
}

struct Foo<T>(T);

impl<T> Write for Foo<T>
where
    T: Debug,
{

}
