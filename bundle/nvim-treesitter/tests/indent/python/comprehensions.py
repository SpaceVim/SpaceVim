# list
a = [
    x + 1 for x in range(3)
]

# dict
b = {
    x: x + 1 for x in range(3)
}

# generator
c = (
    x * x for x in range(3)
)

# set
d = {
    x + x for x in range(3)
}

# other styles
e = [
    x + 1 for x
    in range(3)
]
