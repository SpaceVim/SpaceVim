class Base(object):
    class Nested():
        def foo():
            pass


class X(Base.Nested):
    pass


X().foo()
#! 4 attribute-error
X().bar()
