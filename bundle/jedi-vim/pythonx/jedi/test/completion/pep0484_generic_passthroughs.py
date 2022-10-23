from typing import (
    Any,
    Callable,
    Iterable,
    List,
    Sequence,
    Tuple,
    Type,
    TypeVar,
    Union,
    Generic,
)

T = TypeVar('T')
U = TypeVar('U')
TList = TypeVar('TList', bound=List[Any])
TType = TypeVar('TType', bound=Type)
TTypeAny = TypeVar('TTypeAny', bound=Type[Any])
TCallable = TypeVar('TCallable', bound=Callable[..., Any])

untyped_list_str = ['abc', 'def']
typed_list_str = ['abc', 'def']  # type: List[str]

untyped_tuple_str = ('abc',)
typed_tuple_str = ('abc',)  # type: Tuple[str]

untyped_tuple_str_int = ('abc', 4)
typed_tuple_str_int = ('abc', 4)  # type: Tuple[str, int]

variadic_tuple_str = ('abc',)  # type: Tuple[str, ...]
variadic_tuple_str_int = ('abc', 4)  # type: Tuple[Union[str, int], ...]


def untyped_passthrough(x):
    return x

def typed_list_generic_passthrough(x: List[T]) -> List[T]:
    return x

def typed_tuple_generic_passthrough(x: Tuple[T]) -> Tuple[T]:
    return x

def typed_multi_typed_tuple_generic_passthrough(x: Tuple[T, U]) -> Tuple[U, T]:
    return x[1], x[0]

def typed_variadic_tuple_generic_passthrough(x: Tuple[T, ...]) -> Sequence[T]:
    return x

def typed_iterable_generic_passthrough(x: Iterable[T]) -> Iterable[T]:
    return x

def typed_fully_generic_passthrough(x: T) -> T:
    return x

def typed_bound_generic_passthrough(x: TList) -> TList:
    #? list()
    x

    return x

# Forward references are more likely with custom types, however this aims to
# test just the handling of the quoted type rather than any other part of the
# machinery.
def typed_quoted_return_generic_passthrough(x: T) -> 'List[T]':
    return [x]

def typed_quoted_input_generic_passthrough(x: 'Tuple[T]') -> T:
    x
    return x[0]


for a in untyped_passthrough(untyped_list_str):
    #? str()
    a

for b in untyped_passthrough(typed_list_str):
    #? str()
    b


for c in typed_list_generic_passthrough(untyped_list_str):
    #? str()
    c

for d in typed_list_generic_passthrough(typed_list_str):
    #? str()
    d


for e in typed_iterable_generic_passthrough(untyped_list_str):
    #? str()
    e

for f in typed_iterable_generic_passthrough(typed_list_str):
    #? str()
    f


for g in typed_tuple_generic_passthrough(untyped_tuple_str):
    #? str()
    g

for h in typed_tuple_generic_passthrough(typed_tuple_str):
    #? str()
    h


out_untyped = typed_multi_typed_tuple_generic_passthrough(untyped_tuple_str_int)
#? int()
out_untyped[0]
#? str()
out_untyped[1]


out_typed = typed_multi_typed_tuple_generic_passthrough(typed_tuple_str_int)
#? int()
out_typed[0]
#? str()
out_typed[1]


for j in typed_variadic_tuple_generic_passthrough(untyped_tuple_str_int):
    #? str() int()
    j

for k in typed_variadic_tuple_generic_passthrough(typed_tuple_str_int):
    #? str() int()
    k

for l in typed_variadic_tuple_generic_passthrough(variadic_tuple_str):
    #? str()
    l

for m in typed_variadic_tuple_generic_passthrough(variadic_tuple_str_int):
    #? str() int()
    m

#? float
typed_fully_generic_passthrough(float)

for n in typed_fully_generic_passthrough(untyped_list_str):
    #? str()
    n

for o in typed_fully_generic_passthrough(typed_list_str):
    #? str()
    o


for p in typed_bound_generic_passthrough(untyped_list_str):
    #? str()
    p

for q in typed_bound_generic_passthrough(typed_list_str):
    #? str()
    q


for r in typed_quoted_return_generic_passthrough("something"):
    #? str()
    r

for s in typed_quoted_return_generic_passthrough(42):
    #? int()
    s


#? str()
typed_quoted_input_generic_passthrough(("something",))

#? int()
typed_quoted_input_generic_passthrough((42,))



class CustomList(List):
    def get_first(self):
        return self[0]


#? str()
CustomList[str]()[0]
#? str()
CustomList[str]().get_first()

#? str()
typed_fully_generic_passthrough(CustomList[str]())[0]
#?
typed_list_generic_passthrough(CustomList[str])[0]


def typed_bound_type_implicit_any_generic_passthrough(x: TType) -> TType:
    #? Type()
    x
    return x

def typed_bound_type_any_generic_passthrough(x: TTypeAny) -> TTypeAny:
    # Should be Type(), though we don't get the handling of the nested argument
    # to `Type[...]` quite right here.
    x
    return x


class MyClass:
    pass

def my_func(a: str, b: int) -> float:
    pass

#? MyClass
typed_fully_generic_passthrough(MyClass)

#? MyClass()
typed_fully_generic_passthrough(MyClass())

#? my_func
typed_fully_generic_passthrough(my_func)

#? CustomList()
typed_bound_generic_passthrough(CustomList[str]())

# should be list(), but we don't validate generic typevar upper bounds
#? int()
typed_bound_generic_passthrough(42)

#? MyClass
typed_bound_type_implicit_any_generic_passthrough(MyClass)

#? MyClass
typed_bound_type_any_generic_passthrough(MyClass)

# should be Type(), but we don't validate generic typevar upper bounds
#? int()
typed_bound_type_implicit_any_generic_passthrough(42)

# should be Type(), but we don't validate generic typevar upper bounds
#? int()
typed_bound_type_any_generic_passthrough(42)


def decorator(fn: TCallable) -> TCallable:
    pass


def will_be_decorated(the_param: complex) -> float:
    pass


is_decorated = decorator(will_be_decorated)

#? will_be_decorated
is_decorated

#? ['the_param=']
is_decorated(the_para
)


class class_decorator_factory_plain:
    def __call__(self, func: T) -> T:
        ...

#? class_decorator_factory_plain()
class_decorator_factory_plain()

#?
class_decorator_factory_plain()()

is_decorated_by_class_decorator_factory = class_decorator_factory_plain()(will_be_decorated)

#? will_be_decorated
is_decorated_by_class_decorator_factory

#? ['the_param=']
is_decorated_by_class_decorator_factory(the_par
)


def decorator_factory_plain() -> Callable[[T], T]:
    pass

#? Callable()
decorator_factory_plain()

#?
decorator_factory_plain()()

#? int()
decorator_factory_plain()(42)

is_decorated_by_plain_factory = decorator_factory_plain()(will_be_decorated)

#? will_be_decorated
is_decorated_by_plain_factory

#? ['the_param=']
is_decorated_by_plain_factory(the_par
)


class class_decorator_factory_bound_callable:
    def __call__(self, func: TCallable) -> TCallable:
        ...

#? class_decorator_factory_bound_callable()
class_decorator_factory_bound_callable()

#? Callable()
class_decorator_factory_bound_callable()()

is_decorated_by_class_bound_factory = class_decorator_factory_bound_callable()(will_be_decorated)

#? will_be_decorated
is_decorated_by_class_bound_factory

#? ['the_param=']
is_decorated_by_class_bound_factory(the_par
)


def decorator_factory_bound_callable() -> Callable[[TCallable], TCallable]:
    pass

#? Callable()
decorator_factory_bound_callable()

#? Callable()
decorator_factory_bound_callable()()

is_decorated_by_bound_factory = decorator_factory_bound_callable()(will_be_decorated)

#? will_be_decorated
is_decorated_by_bound_factory

#? ['the_param=']
is_decorated_by_bound_factory(the_par
)


class That(Generic[T]):
    def __init__(self, items: List[Tuple[str, T]]) -> None:
        pass

    def get(self) -> T:
        pass

inst = That([("abc", 2)])

# No completions here, but should have completions for `int`
#? int()
inst.get()
