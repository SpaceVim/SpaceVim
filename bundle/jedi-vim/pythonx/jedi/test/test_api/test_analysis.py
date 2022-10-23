def test_issue436(Script):
    code = "bar = 0\nbar += 'foo' + 4"
    errors = set(repr(e) for e in Script(code)._analysis())
    assert len(errors) == 2
    assert '<Error type-error-operation: None@2,4>' in errors
    assert '<Error type-error-operation: None@2,13>' in errors
