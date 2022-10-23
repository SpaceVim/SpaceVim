import pytest
from parso.grammar import load_grammar
from parso import utils


def test_load_inexisting_grammar():
    # This version shouldn't be out for a while, but if we ever do, wow!
    with pytest.raises(NotImplementedError):
        load_grammar(version='15.8')
    # The same is true for very old grammars (even though this is probably not
    # going to be an issue.
    with pytest.raises(NotImplementedError):
        load_grammar(version='1.5')


@pytest.mark.parametrize(('string', 'result'), [
    ('2', (2, 7)), ('3', (3, 6)), ('1.1', (1, 1)), ('1.1.1', (1, 1)), ('300.1.31', (300, 1))
])
def test_parse_version(string, result):
    assert utils._parse_version(string) == result


@pytest.mark.parametrize('string', ['1.', 'a', '#', '1.3.4.5'])
def test_invalid_grammar_version(string):
    with pytest.raises(ValueError):
        load_grammar(version=string)


def test_grammar_int_version():
    with pytest.raises(TypeError):
        load_grammar(version=3.8)
