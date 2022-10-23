from jedi import api


def test_add_bracket_after_function(monkeypatch, Script):
    settings = api.settings
    monkeypatch.setattr(settings, 'add_bracket_after_function', True)
    script = Script('''\
def foo():
    pass
foo''')
    completions = script.complete()
    assert completions[0].complete == '('
