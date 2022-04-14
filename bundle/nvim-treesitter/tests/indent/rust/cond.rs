fn foo(mut x: i32) -> i32 {
    if x > 10 {
        return 10;
    } else if x == 10 {
        return 9;
    } else {
        x += 10;
    }

    if x < 0 {
        if x == -1 {
            return 0;
        }
    }

    0
}
