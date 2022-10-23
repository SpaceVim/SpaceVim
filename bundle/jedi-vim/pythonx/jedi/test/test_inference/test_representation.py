from textwrap import dedent


def get_definition_and_inference_state(Script, source):
    first, = Script(dedent(source)).infer()
    return first._name._value, first._inference_state


def test_function_execution(Script):
    """
    We've been having an issue of a mutable list that was changed inside the
    function execution. Test if an execution always returns the same result.
    """

    s = """
    def x():
        return str()
    x"""
    func, inference_state = get_definition_and_inference_state(Script, s)
    # Now just use the internals of the result (easiest way to get a fully
    # usable function).
    # Should return the same result both times.
    assert len(func.execute_with_values()) == 1
    assert len(func.execute_with_values()) == 1


def test_class_mro(Script):
    s = """
    class X(object):
        pass
    X"""
    cls, inference_state = get_definition_and_inference_state(Script, s)
    mro = cls.py__mro__()
    assert [c.name.string_name for c in mro] == ['X', 'object']
