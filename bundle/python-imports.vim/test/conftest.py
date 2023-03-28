import os
import sys

import pytest


source_path = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'pythonx')
sys.path.append(source_path)


class VimStub(object):
    def __init__(self):
        self.executed_commands = []

    def command(self, cmd):
        self.executed_commands.append(cmd)


try:
    import vim
except ImportError:
    sys.modules['vim'] = VimStub()
else:  # pragma: nocover
    del vim


@pytest.fixture(autouse=True)
def vim(monkeypatch):
    import python_imports as mod
    stub = VimStub()
    monkeypatch.setitem(sys.modules, 'vim', stub)
    monkeypatch.setattr(mod, 'vim', stub)
    return stub
