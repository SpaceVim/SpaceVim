# Exists only for completion/pytest.py

import pytest


@pytest.fixture()
def my_other_conftest_fixture():
    return 1.0


@pytest.fixture()
def my_conftest_fixture(my_other_conftest_fixture):
    return my_other_conftest_fixture


def my_not_existing_fixture():
    return 3  # Just a normal function


@pytest.fixture()
def inheritance_fixture():
    return ''


@pytest.fixture
def testdir(testdir):
    #? ['chdir']
    testdir.chdir
    return testdir
