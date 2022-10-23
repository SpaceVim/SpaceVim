from typing import overload


@overload
def with_overload(x: int, y: int) -> float: ...

@overload
def with_overload(x: str, y: list) -> float: ...
