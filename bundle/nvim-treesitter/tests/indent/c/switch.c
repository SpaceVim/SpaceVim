void foo(int x) {
    switch (x) {
        case 1:
            x += 1;
            break;
        case 2: x += 2;
            break;
        case 3: x += 3; break;
        case 4: {
            x += 4;
            break;
        }
        default:
            x = -x;
    }
}
