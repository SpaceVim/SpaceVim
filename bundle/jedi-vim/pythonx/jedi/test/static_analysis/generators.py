def generator():
    yield 1

#! 11 type-error-not-subscriptable
generator()[0]

list(generator())[0]
