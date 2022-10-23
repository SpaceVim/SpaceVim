import typing
from typing import (
    Callable,
    Dict,
    Generic,
    List,
    Sequence,
    Tuple,
    Type,
    TypeVar,
)

T = TypeVar('T')


def foo(x: T) -> T:
    return x


class CustomGeneric(Generic[T]):
    def __init__(self, val: T) -> None:
        self.val = val


class PlainClass(object):
    pass


tpl = ("1", 2)
tpl_typed = ("2", 3)  # type: Tuple[str, int]

collection = {"a": 1}
collection_typed = {"a": 1}  # type: Dict[str, int]

list_of_ints = [42]  # type: List[int]
list_of_funcs = [foo]  # type: List[Callable[[T], T]]

custom_generic = CustomGeneric(123.45)

plain_instance = PlainClass()


# Test that simple parameters are handled
def list_t_to_list_t(the_list: List[T]) -> List[T]:
    return the_list

x0 = list_t_to_list_t("abc")[0]
#?
x0

x1 = list_t_to_list_t(foo)[0]
#?
x1

x1 = list_t_to_list_t(typing)[0]
#?
x1

x2 = list_t_to_list_t(tpl)[0]
#?
x2

x3 = list_t_to_list_t(tpl_typed)[0]
#?
x3

x4 = list_t_to_list_t(collection)[0]
#?
x4

x5 = list_t_to_list_t(collection_typed)[0]
#?
x5

x6 = list_t_to_list_t(custom_generic)[0]
#?
x6

x7 = list_t_to_list_t(plain_instance)[0]
#?
x7

for a in list_t_to_list_t(12):
    #?
    a


# Test that simple parameters are handled
def list_type_t_to_list_t(the_list: List[Type[T]]) -> List[T]:
    return [x() for x in the_list]

x0 = list_type_t_to_list_t("abc")[0]
#?
x0

x1 = list_type_t_to_list_t(foo)[0]
#?
x1

x2 = list_type_t_to_list_t(tpl)[0]
#?
x2

x3 = list_type_t_to_list_t(tpl_typed)[0]
#?
x3

x4 = list_type_t_to_list_t(collection)[0]
#?
x4

x5 = list_type_t_to_list_t(collection_typed)[0]
#?
x5

x6 = list_type_t_to_list_t(custom_generic)[0]
#?
x6

x7 = list_type_t_to_list_t(plain_instance)[0]
#?
x7

for a in list_type_t_to_list_t(12):
    #?
    a


x0 = list_type_t_to_list_t(["abc"])[0]
#?
x0

x1 = list_type_t_to_list_t([foo])[0]
#?
x1

x2 = list_type_t_to_list_t([tpl])[0]
#?
x2

x3 = list_type_t_to_list_t([tpl_typed])[0]
#?
x3

x4 = list_type_t_to_list_t([collection])[0]
#?
x4

x5 = list_type_t_to_list_t([collection_typed])[0]
#?
x5

x6 = list_type_t_to_list_t([custom_generic])[0]
#?
x6

x7 = list_type_t_to_list_t([plain_instance])[0]
#?
x7

for a in list_type_t_to_list_t([12]):
    #?
    a


def list_func_t_to_list_t(the_list: List[Callable[[T], T]]) -> List[T]:
    # Not actually a viable signature, but should be enough to test our handling
    # of the generic parameters.
    pass


x0 = list_func_t_to_list_t("abc")[0]
#?
x0

x1 = list_func_t_to_list_t(foo)[0]
#?
x1

x2 = list_func_t_to_list_t(tpl)[0]
#?
x2

x3 = list_func_t_to_list_t(tpl_typed)[0]
#?
x3

x4 = list_func_t_to_list_t(collection)[0]
#?
x4

x5 = list_func_t_to_list_t(collection_typed)[0]
#?
x5

x6 = list_func_t_to_list_t(custom_generic)[0]
#?
x6

x7 = list_func_t_to_list_t(plain_instance)[0]
#?
x7

for a in list_func_t_to_list_t(12):
    #?
    a


x0 = list_func_t_to_list_t(["abc"])[0]
#?
x0

x2 = list_func_t_to_list_t([tpl])[0]
#?
x2

x3 = list_func_t_to_list_t([tpl_typed])[0]
#?
x3

x4 = list_func_t_to_list_t([collection])[0]
#?
x4

x5 = list_func_t_to_list_t([collection_typed])[0]
#?
x5

x6 = list_func_t_to_list_t([custom_generic])[0]
#?
x6

x7 = list_func_t_to_list_t([plain_instance])[0]
#?
x7

for a in list_func_t_to_list_t([12]):
    #?
    a


def tuple_t(tuple_in: Tuple[T]]) -> Sequence[T]:
    return tuple_in


x0 = list_t_to_list_t("abc")[0]
#?
x0

x1 = list_t_to_list_t(foo)[0]
#?
x1

x2 = list_t_to_list_t(tpl)[0]
#?
x2

x3 = list_t_to_list_t(tpl_typed)[0]
#?
x3

x4 = list_t_to_list_t(collection)[0]
#?
x4

x5 = list_t_to_list_t(collection_typed)[0]
#?
x5

x6 = list_t_to_list_t(custom_generic)[0]
#?
x6

x7 = list_t_to_list_t(plain_instance)[0]
#?
x7

for a in list_t_to_list_t(12):
    #?
    a


def tuple_t_elipsis(tuple_in: Tuple[T, ...]]) -> Sequence[T]:
    return tuple_in


x0 = list_t_to_list_t("abc")[0]
#?
x0

x1 = list_t_to_list_t(foo)[0]
#?
x1

x2 = list_t_to_list_t(tpl)[0]
#?
x2

x3 = list_t_to_list_t(tpl_typed)[0]
#?
x3

x4 = list_t_to_list_t(collection)[0]
#?
x4

x5 = list_t_to_list_t(collection_typed)[0]
#?
x5

x6 = list_t_to_list_t(custom_generic)[0]
#?
x6

x7 = list_t_to_list_t(plain_instance)[0]
#?
x7

for a in list_t_to_list_t(12):
    #?
    a


def list_tuple_t_to_tuple_list_t(the_list: List[Tuple[T]]) -> Tuple[List[T], ...]:
    return tuple(list(x) for x in the_list)


for b in list_tuple_t_to_tuple_list_t(list_of_ints):
    #?
    b[0]


def list_tuple_t_elipsis_to_tuple_list_t(the_list: List[Tuple[T, ...]]) -> Tuple[List[T], ...]:
    return tuple(list(x) for x in the_list)


for b in list_tuple_t_to_tuple_list_t(list_of_ints):
    #?
    b[0]
