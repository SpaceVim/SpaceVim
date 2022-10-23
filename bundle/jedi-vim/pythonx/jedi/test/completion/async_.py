"""
Tests for all async use cases.

Currently we're not supporting completion of them, but they should at least not
raise errors or return extremely strange results.
"""

async def x():
    return 1

#? []
x.cr_awai

#? ['cr_await']
x().cr_awai

a = await x()
#? int()
a

async def y():
    argh = await x()
    #? int()
    argh
    #? ['__next__']
    x().__await__().__next
    return 2

class A():
    @staticmethod
    async def b(c=1, d=2):
        return 1

#! 9 ['def b']
await A.b()

#! 11 ['param d=2']
await A.b(d=3)

class Awaitable:
    def __await__(self):
        yield None
        return ''

async def awaitable_test():
    foo = await Awaitable()
    #? str()
    foo

# python >= 3.6

async def asgen():
    yield 1
    await asyncio.sleep(0)
    yield 2

async def wrapper():
    #? int()
    [x async for x in asgen()][0]

    async for y in asgen():
        #? int()
        y

#? ['__anext__']
asgen().__ane
#? []
asgen().mro


# Normal completion (#1092)
normal_var1 = 42

async def foo():
    normal_var2 = False
    #? ['normal_var1', 'normal_var2']
    normal_var


class C:
    @classmethod
    async def async_for_classmethod(cls) -> "C":
        return

    async def async_for_method(cls) -> int:
        return


async def f():
    c = await C.async_for_method()
    #? int()
    c
    d = await C().async_for_method()
    #? int()
    d

    e = await C.async_for_classmethod()
    #? C()
    e
    f = await C().async_for_classmethod()
    #? C()
    f


class AsyncCtxMgr:
    def some_method():
        pass

    async def __aenter__(self):
        return self

    async def __aexit__(self, *args):
        pass


async def asyncctxmgr():
    async with AsyncCtxMgr() as acm:
        #? AsyncCtxMgr()
        acm
        #? ['some_method']
        acm.som
