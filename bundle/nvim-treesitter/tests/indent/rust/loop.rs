fn foo(mut x: i32) {
    while x > 0 {
        x -= 1;
    }

    for i in 0..3 {
        x += 1;
    }

    loop {
        x += 1;

        if x < 100 {
            continue;
        }

        break;
    }
}
