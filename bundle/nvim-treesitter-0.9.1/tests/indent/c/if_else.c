int foo(int x){
    if (x > 10)
        return 10;

    if (x > 10)
        return 10;
    else
        return 10;

    if (x > 20)
        return 20;
    else if (x > 15)
        return 15;
    else
        return 10;
}

int bar(int x){
    if (x > 20)
        return 10;
    else {
        return 10;
    }

    if (x > 20)
        return 10;
    else if (x > 10) {
        return 10;
    }
}

int baz(int x){
    if (x > 20)
        return x;
    else if(x > 10) {
        if(x > 10) {
            if(x > 10)
                return 10;
            if(x > 5) {
                return 5;
            }
        }
    }

    if (x > 20)
        if (x > 19)
            if(x > 18)
                return x;

    if (x > 20)
        return x;
    else if (x > 19) {
        if (x > 18)
            return x;
        else
            x++;
    }
    return 0;
}
