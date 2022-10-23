# python >= 3.6
from typing import List, Dict, overload, Tuple, TypeVar

lst: list
list_alias: List
list_str: List[str]
list_str: List[int]

# -------------------------
# With base classes
# -------------------------

@overload
def overload_f2(value: List) -> str: ...
@overload
def overload_f2(value: Dict) -> int: ...

#? str()
overload_f2([''])
#? int()
overload_f2({1.0: 1.0})
#? str()
overload_f2(lst)
#? str()
overload_f2(list_alias)
#? str()
overload_f2(list_str)


@overload
def overload_f3(value: list) -> str: ...
@overload
def overload_f3(value: dict) -> float: ...

#? str()
overload_f3([''])
#? float()
overload_f3({1.0: 1.0})
#? str()
overload_f3(lst)
#? str()
overload_f3(list_alias)
#? str()
overload_f3(list_str)

# -------------------------
# Generics Matching
# -------------------------

@overload
def overload_f1(value: List[str]) -> str: ...


@overload
def overload_f1(value: Dict[str, str]) -> Dict[str, str]: ...

def overload_f1():
    pass

#? str()
overload_f1([''])
#? str() dict()
overload_f1(1)
#? dict()
overload_f1({'': ''})

#? str() dict()
overload_f1(lst)
#? str() dict()
overload_f1(list_alias)
#? str()
overload_f1(list_str)
#? str() dict()
overload_f1(list_int)

# -------------------------
# Broken Matching
# -------------------------
T = TypeVar('T')

@overload
def broken_f1(value: 1) -> str: ...

@overload
def broken_f1(value: Tuple[T]) -> Tuple[T]: ...

tup: Tuple[float]
#? float()
broken_f1(broken_f1(tup))[0]
