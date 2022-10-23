""" Pep-0484 type hinting """


class A():
    pass


def function_parameters(a: A, b, c: str, d: int, e: str, f: str, g: int=4):
    """
    :param e: if docstring and annotation agree, only one should be returned
    :type e: str
    :param f: if docstring and annotation disagree, both should be returned
    :type f: int
    """
    #? A()
    a
    #?
    b
    #? str()
    c
    #? int()
    d
    #? str()
    e
    #? str()
    f
    # int()
    g


def return_unspecified():
    pass

#?
return_unspecified()


def return_none() -> None:
    """
    Return type None means the same as no return type as far as jedi
    is concerned
    """
    pass

#? None
return_none()


def return_str() -> str:
    pass

#? str()
return_str()


def return_custom_class() -> A:
    pass

#? A()
return_custom_class()


def return_annotation_and_docstring() -> str:
    """
    :rtype: int
    """
    pass

#? str()
return_annotation_and_docstring()


def return_annotation_and_docstring_different() -> str:
    """
    :rtype: str
    """
    pass

#? str()
return_annotation_and_docstring_different()


def annotation_forward_reference(b: "B") -> "B":
    #? B()
    b

#? ["test_element"]
annotation_forward_reference(1).t

class B:
    test_element = 1
    pass

#? B()
annotation_forward_reference(1)


class SelfReference:
    test_element = 1
    def test_method(self, x: "SelfReference") -> "SelfReference":
        #? SelfReference()
        x
        #? ["test_element", "test_method"]
        self.t
        #? ["test_element", "test_method"]
        x.t
        #? ["test_element", "test_method"]
        self.test_method(1).t

#? SelfReference()
SelfReference().test_method()

def function_with_non_pep_0484_annotation(
        x: "I can put anything here",
        xx: "",
        yy: "\r\n\0;+*&^564835(---^&*34",
        y: 3 + 3,
        zz: float) -> int("42"):
    # infers int from function call
    #? int()
    x
    # infers int from function call
    #? int()
    xx
    # infers int from function call
    #? int()
    yy
    # infers str from function call
    #? str()
    y
    #? float()
    zz
#?
function_with_non_pep_0484_annotation(1, 2, 3, "force string")

def function_forward_reference_dynamic(
        x: return_str_type(),
        y: "return_str_type()") -> None:
    #? str()
    x
    #? str()
    y

def return_str_type():
    return str


X = str
def function_with_assined_class_in_reference(x: X, y: "Y"):
    #? str()
    x
    #? int()
    y
Y = int

def just_because_we_can(x: "flo" + "at"):
    #? float()
    x


def keyword_only(a: str, *, b: str):
    #? ['startswith']
    a.startswi
    #? ['startswith']
    b.startswi


def argskwargs(*args: int, **kwargs: float):
    """
    This might be a bit confusing, but is part of the standard.
    args is changed to Tuple[int] in this case and kwargs to Dict[str, float],
    which makes sense if you think about it a bit.
    """
    #? tuple()
    args
    #? int()
    args[0]
    #? str()
    next(iter(kwargs.keys()))
    #? float()
    kwargs['']


class NotCalledClass:
    def __init__(self, x):
        self.x: int = x
        self.y: int = ''
        #? int()
        self.x
        #? int()
        self.y
        #? int()
        self.y
        self.z: int
        self.z = ''
        #? str() int()
        self.z
        self.w: float
        #? float()
        self.w
