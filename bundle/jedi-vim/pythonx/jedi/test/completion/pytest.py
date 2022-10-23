from typing import Generator

import pytest
from pytest import fixture


@pytest.fixture(scope='module')
def my_fixture() -> str:
    pass


@fixture
def my_simple_fixture():
    return 1


@fixture
def my_yield_fixture():
    yield 1


@fixture
class MyClassFixture():
    pass

# -----------------
# goto/infer
# -----------------

#! 18 ['def my_conftest_fixture']
def test_x(my_conftest_fixture, my_fixture, my_not_existing_fixture, my_yield_fixture):
    #? str()
    my_fixture
    #? int()
    my_yield_fixture
    #?
    my_not_existing_fixture
    #? float()
    return my_conftest_fixture

#? 18 float()
def test_x(my_conftest_fixture, my_fixture):
    pass


#! 18 ['param MyClassFixture']
def test_x(MyClassFixture):
    #?
    MyClassFixture

#? 15
def lala(my_fixture):
    pass

@pytest.fixture
#? 15 str()
def lala(my_fixture):
    pass

#! 15 ['param my_fixture']
def lala(my_fixture):
    pass

@pytest.fixture
#! 15 ['def my_fixture']
def lala(my_fixture):
    pass

# overriding types of a fixture should be possible
def test_x(my_yield_fixture: str):
    #? str()
    my_yield_fixture

# -----------------
# completion
# -----------------

#? 34 ['my_fixture']
def test_x(my_simple_fixture, my_fixture):
    return
#? 34 ['my_fixture']
def test_x(my_simple_fixture, my_fixture):
    return
#? ['my_fixture']
def test_x(my_simple_fixture, my_f
    return
#? 18 ['my_simple_fixture']
def test_x(my_simple_fixture):
    return
#? ['my_simple_fixture']
def test_x(my_simp
    return
#? ['my_conftest_fixture']
def test_x(my_con
    return
#? 18 ['my_conftest_fixture']
def test_x(my_conftest_fixture):
    return

#? []
def lala(my_con
    return

@pytest.fixture
#? ['my_conftest_fixture']
def lala(my_con
    return

@pytest.fixture
#? 15 ['my_conftest_fixture']
def lala(my_con):
    return

@pytest.fixture
@some_decorator
#? ['my_conftest_fixture']
def lala(my_con
    return

@pytest.fixture
@some_decorator
#? 15 ['my_conftest_fixture']
def lala(my_con):
    return

# -----------------
# pytest owned fixtures
# -----------------

#? ['monkeypatch']
def test_p(monkeyp


#! 15 ['def monkeypatch']
def test_p(monkeypatch):
    #? ['setattr']
    monkeypatch.setatt

#? ['capsysbinary']
def test_p(capsysbin

#? ['tmpdir', 'tmpdir_factory']
def test_p(tmpdi


def close_parens():
    pass
# -----------------
# inheritance
# -----------------

@fixture
#? 40 ['inheritance_fixture']
def inheritance_fixture(inheritance_fixture):
    #? str()
    inheritance_fixture
    #? ['upper']
    inheritance_fixture.upper
    return 1


#! 48 ['def inheritance_fixture']
def test_inheritance_fixture(inheritance_fixture, caplog):
    #? int()
    inheritance_fixture

    #? ['set_level']
    caplog.set_le


@pytest.fixture
def caplog(caplog):
    yield caplog

# -----------------
# Generator with annotation
# -----------------

@pytest.fixture
def with_annot() -> Generator[float, None, None]:
    pass

def test_with_annot(inheritance_fixture, with_annot):
    #? float()
    with_annot
