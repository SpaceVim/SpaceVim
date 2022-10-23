from typing import (
    Callable,
    Dict,
    Generic,
    Iterable,
    List,
    Mapping,
    Optional,
    Tuple,
    Type,
    TypeVar,
    Union,
    Sequence,
)

K = TypeVar('K')
T = TypeVar('T')
T_co = TypeVar('T_co', covariant=True)
V = TypeVar('V')


just_float = 42.  # type: float
optional_float = 42.  # type: Optional[float]
list_of_ints = [42]  # type: List[int]
list_of_floats = [42.]  # type: List[float]
list_of_optional_floats = [x or None for x in list_of_floats]  # type: List[Optional[float]]
list_of_ints_and_strs = [42, 'abc']  # type: List[Union[int, str]]

# Test that simple parameters are handled
def list_t_to_list_t(the_list: List[T]) -> List[T]:
    return the_list

x0 = list_t_to_list_t(list_of_ints)[0]
#? int()
x0

for a in list_t_to_list_t(list_of_ints):
    #? int()
    a

# Test that unions are handled
x2 = list_t_to_list_t(list_of_ints_and_strs)[0]
#? int() str()
x2

for z in list_t_to_list_t(list_of_ints_and_strs):
    #? int() str()
    z


list_of_int_type = [int]  # type: List[Type[int]]

# Test that nested parameters are handled
def list_optional_t_to_list_t(the_list: List[Optional[T]]) -> List[T]:
    return [x for x in the_list if x is not None]


for xa in list_optional_t_to_list_t(list_of_optional_floats):
    #? float()
    xa

# Under covariance rules this is strictly incorrect (because List is mutable,
# the function would be allowed to put `None`s into our List[float], which would
# be bad), however we don't expect jedi to enforce that.
for xa1 in list_optional_t_to_list_t(list_of_floats):
    #? float()
    xa1


def optional_t_to_list_t(x: Optional[T]) -> List[T]:
    return [x] if x is not None else []


for xb in optional_t_to_list_t(optional_float):
    #? float()
    xb


for xb2 in optional_t_to_list_t(just_float):
    #? float()
    xb2


def optional_list_t_to_list_t(x: Optional[List[T]]) -> List[T]:
    return x if x is not None else []


optional_list_float = None  # type: Optional[List[float]]
for xc in optional_list_t_to_list_t(optional_list_float):
    #? float()
    xc

for xc2 in optional_list_t_to_list_t(list_of_floats):
    #? float()
    xc2


def list_type_t_to_list_t(the_list: List[Type[T]]) -> List[T]:
    return [x() for x in the_list]


x1 = list_type_t_to_list_t(list_of_int_type)[0]
#? int()
x1


for b in list_type_t_to_list_t(list_of_int_type):
    #? int()
    b


# Test construction of nested generic tuple return parameters
def list_t_to_list_tuple_t(the_list: List[T]) -> List[Tuple[T]]:
    return [(x,) for x in the_list]


x1t = list_t_to_list_tuple_t(list_of_ints)[0][0]
#? int()
x1t


for c1 in list_t_to_list_tuple_t(list_of_ints):
    #? int()
    c1[0]


for c2, in list_t_to_list_tuple_t(list_of_ints):
    #? int()
    c2


# Test handling of nested tuple input parameters
def list_tuple_t_to_tuple_list_t(the_list: List[Tuple[T]]) -> Tuple[List[T], ...]:
    return tuple(list(x) for x in the_list)


list_of_int_tuples = [(x,) for x in list_of_ints]  # type: List[Tuple[int]]

for b in list_tuple_t_to_tuple_list_t(list_of_int_tuples):
    #? int()
    b[0]


def list_tuple_t_elipsis_to_tuple_list_t(the_list: List[Tuple[T, ...]]) -> Tuple[List[T], ...]:
    return tuple(list(x) for x in the_list)


list_of_int_tuple_elipsis = [tuple(list_of_ints)]  # type: List[Tuple[int, ...]]

for b in list_tuple_t_elipsis_to_tuple_list_t(list_of_int_tuple_elipsis):
    #? int()
    b[0]


# Test handling of nested callables
def foo(x: int) -> int:
    return x


list_of_funcs = [foo]  # type: List[Callable[[int], int]]

def list_func_t_to_list_func_type_t(the_list: List[Callable[[T], T]]) -> List[Callable[[Type[T]], T]]:
    def adapt(func: Callable[[T], T]) -> Callable[[Type[T]], T]:
        def wrapper(typ: Type[T]) -> T:
            return func(typ())
        return wrapper
    return [adapt(x) for x in the_list]


for b in list_func_t_to_list_func_type_t(list_of_funcs):
    #? int()
    b(int)


def bar(*a, **k) -> int:
    return len(a) + len(k)


list_of_funcs_2 = [bar]  # type: List[Callable[..., int]]

def list_func_t_passthrough(the_list: List[Callable[..., T]]) -> List[Callable[..., T]]:
    return the_list


for b in list_func_t_passthrough(list_of_funcs_2):
    #? int()
    b(None, x="x")


mapping_int_str = {42: 'a'}  # type: Dict[int, str]

# Test that mappings (that have more than one parameter) are handled
def invert_mapping(mapping: Mapping[K, V]) -> Mapping[V, K]:
    return {v: k for k, v in mapping.items()}

#? int()
invert_mapping(mapping_int_str)['a']


# Test that the right type is chosen when a mapping is passed to something with
# only a single parameter. This checks that our inheritance checking picks the
# right thing.
def first(iterable: Iterable[T]) -> T:
    return next(iter(iterable))

#? int()
first(mapping_int_str)

# Test inference of str as an iterable of str.
#? str()
first("abc")

some_str = NotImplemented  # type: str
#? str()
first(some_str)

annotated = [len]  # type: List[ Callable[[Sequence[float]], int] ]
#? int()
first(annotated)()

# Test that the right type is chosen when a partially realised mapping is expected
def values(mapping: Mapping[int, T]) -> List[T]:
    return list(mapping.values())

#? str()
values(mapping_int_str)[0]

x2 = values(mapping_int_str)[0]
#? str()
x2

for b in values(mapping_int_str):
    #? str()
    b


#
# Tests that user-defined generic types are handled
#
list_ints = [42]  # type: List[int]

class CustomGeneric(Generic[T_co]):
    def __init__(self, val: T_co) -> None:
        self.val = val


# Test extraction of type from a custom generic type
def custom(x: CustomGeneric[T]) -> T:
    return x.val

custom_instance = CustomGeneric(42)  # type: CustomGeneric[int]

#? int()
custom(custom_instance)

x3 = custom(custom_instance)
#? int()
x3


# Test construction of a custom generic type
def wrap_custom(iterable: Iterable[T]) -> List[CustomGeneric[T]]:
    return [CustomGeneric(x) for x in iterable]

#? int()
wrap_custom(list_ints)[0].val

x4 = wrap_custom(list_ints)[0]
#? int()
x4.val

for x5 in wrap_custom(list_ints):
    #? int()
    x5.val


# Test extraction of type from a nested custom generic type
list_custom_instances = [CustomGeneric(42)]  # type: List[CustomGeneric[int]]

def unwrap_custom(iterable: Iterable[CustomGeneric[T]]) -> List[T]:
    return [x.val for x in iterable]

#? int()
unwrap_custom(list_custom_instances)[0]

x6 = unwrap_custom(list_custom_instances)[0]
#? int()
x6

for x7 in unwrap_custom(list_custom_instances):
    #? int()
    x7


for xc in unwrap_custom([CustomGeneric(s) for s in 'abc']):
    #? str()
    xc


for xg in unwrap_custom(CustomGeneric(s) for s in 'abc'):
    #? str()
    xg


# Test extraction of type from type parameer nested within a custom generic type
custom_instance_list_int = CustomGeneric([42])  # type: CustomGeneric[List[int]]

def unwrap_custom2(instance: CustomGeneric[Iterable[T]]) -> List[T]:
    return list(instance.val)

#? int()
unwrap_custom2(custom_instance_list_int)[0]

x8 = unwrap_custom2(custom_instance_list_int)[0]
#? int()
x8

for x9 in unwrap_custom2(custom_instance_list_int):
    #? int()
    x9


# Test that classes which have generic parents but are not generic themselves
# are still inferred correctly.
class Specialised(Mapping[int, str]):
    pass


specialised_instance = NotImplemented  # type: Specialised

#? int()
first(specialised_instance)

#? str()
values(specialised_instance)[0]


# Test that classes which have generic ancestry but neither they nor their
# parents are not generic are still inferred correctly.
class ChildOfSpecialised(Specialised):
    pass


child_of_specialised_instance = NotImplemented  # type: ChildOfSpecialised

#? int()
first(child_of_specialised_instance)

#? str()
values(child_of_specialised_instance)[0]


# Test that unbound generics are inferred as much as possible
class CustomPartialGeneric1(Mapping[str, T]):
    pass


custom_partial1_instance = NotImplemented  # type: CustomPartialGeneric1[int]

#? str()
first(custom_partial1_instance)


custom_partial1_unbound_instance = NotImplemented  # type: CustomPartialGeneric1

#? str()
first(custom_partial1_unbound_instance)


class CustomPartialGeneric2(Mapping[T, str]):
    pass


custom_partial2_instance = NotImplemented  # type: CustomPartialGeneric2[int]

#? int()
first(custom_partial2_instance)

#? str()
values(custom_partial2_instance)[0]


custom_partial2_unbound_instance = NotImplemented  # type: CustomPartialGeneric2

#? []
first(custom_partial2_unbound_instance)

#? str()
values(custom_partial2_unbound_instance)[0]
