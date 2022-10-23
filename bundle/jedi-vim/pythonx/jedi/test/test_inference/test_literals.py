import pytest
from jedi.inference.value import TreeInstance


def _infer_literal(Script, code, is_fstring=False):
    def_, = Script(code).infer()
    if is_fstring:
        assert def_.name == 'str'
        assert isinstance(def_._name._value, TreeInstance)
        return ''
    else:
        return def_._name._value.get_safe_value()


def test_f_strings(Script, environment):
    """
    f literals are not really supported in Jedi. They just get ignored and an
    empty string is returned.
    """
    if environment.version_info < (3, 6):
        pytest.skip()

    assert _infer_literal(Script, 'f"asdf"', is_fstring=True) == ''
    assert _infer_literal(Script, 'f"{asdf} "', is_fstring=True) == ''
    assert _infer_literal(Script, 'F"{asdf} "', is_fstring=True) == ''
    assert _infer_literal(Script, 'rF"{asdf} "', is_fstring=True) == ''


def test_rb_strings(Script, environment):
    assert _infer_literal(Script, 'x = br"asdf"; x') == b'asdf'
    assert _infer_literal(Script, 'x = rb"asdf"; x') == b'asdf'


def test_thousand_separators(Script, environment):
    if environment.version_info < (3, 6):
        pytest.skip()

    assert _infer_literal(Script, '1_2_3') == 123
    assert _infer_literal(Script, '123_456_789') == 123456789
    assert _infer_literal(Script, '0x3_4') == 52
    assert _infer_literal(Script, '0b1_0') == 2
    assert _infer_literal(Script, '0o1_0') == 8
