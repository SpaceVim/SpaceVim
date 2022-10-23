import pytest
from textwrap import dedent


@pytest.fixture(autouse=True)
def skip_not_supported(environment):
    if environment.version_info < (3, 6):
        pytest.skip()


def test_fstring_multiline(Script):
    code = dedent("""\
        '' f'''s{
           str.uppe
        '''
        """)
    c, = Script(code).complete(line=2, column=9)
    assert c.name == 'upper'
