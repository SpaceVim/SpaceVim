from foo import bar
# ^ @include
#           ^ @include
def generator():
    yield from bar(42)
    # ^ @keyword.return
    #       ^ @keyword.return
