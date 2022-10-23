try:
    import readline
except ImportError:
    readline = False
import unittest

from jedi import utils


@unittest.skipIf(not readline, "readline not found")
class TestSetupReadline(unittest.TestCase):
    class NameSpace(object):
        pass

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.namespace = self.NameSpace()
        utils.setup_readline(self.namespace)

    def complete(self, text):
        completer = readline.get_completer()
        i = 0
        completions = []
        while True:
            completion = completer(text, i)
            if completion is None:
                break
            completions.append(completion)
            i += 1
        return completions

    def test_simple(self):
        assert self.complete('list') == ['list']
        assert self.complete('importerror') == ['ImportError']
        s = "print(BaseE"
        assert self.complete(s) == [s + 'xception']

    def test_nested(self):
        assert self.complete('list.Insert') == ['list.insert']
        assert self.complete('list().Insert') == ['list().insert']

    def test_magic_methods(self):
        assert self.complete('list.__getitem__') == ['list.__getitem__']
        assert self.complete('list().__getitem__') == ['list().__getitem__']

    def test_modules(self):
        import sys
        import os
        self.namespace.sys = sys
        self.namespace.os = os

        try:
            assert self.complete('os.path.join') == ['os.path.join']
            string = 'os.path.join("a").upper'
            assert self.complete(string) == [string]

            c = {'os.' + d for d in dir(os) if d.startswith('ch')}
            assert set(self.complete('os.ch')) == set(c)
        finally:
            del self.namespace.sys
            del self.namespace.os

    def test_calls(self):
        s = 'str(bytes'
        assert self.complete(s) == [s, 'str(BytesWarning']

    def test_import(self):
        s = 'from os.path import a'
        assert set(self.complete(s)) == {s + 'ltsep', s + 'bspath'}
        assert self.complete('import keyword') == ['import keyword']

        import os
        s = 'from os import '
        goal = {s + el for el in dir(os)}
        # There are minor differences, e.g. the dir doesn't include deleted
        # items as well as items that are not only available on linux.
        difference = set(self.complete(s)).symmetric_difference(goal)
        difference = {
            x for x in difference
            if all(not x.startswith('from os import ' + s)
                   for s in ['_', 'O_', 'EX_', 'MFD_', 'SF_', 'ST_',
                             'CLD_', 'POSIX_SPAWN_', 'P_', 'RWF_',
                             'SCHED_'])
        }
        # There are quite a few differences, because both Windows and Linux
        # (posix and nt) librariesare included.
        assert len(difference) < 30

    def test_local_import(self):
        s = 'import test.test_utils'
        assert self.complete(s) == [s]

    def test_preexisting_values(self):
        self.namespace.a = range(10)
        assert set(self.complete('a.')) == {'a.' + n for n in dir(range(1))}
        del self.namespace.a

    def test_colorama(self):
        """
        Only test it if colorama library is available.

        This module is being tested because it uses ``setattr`` at some point,
        which Jedi doesn't understand, but it should still work in the REPL.
        """
        try:
            # if colorama is installed
            import colorama
        except ImportError:
            pass
        else:
            self.namespace.colorama = colorama
            assert self.complete('colorama')
            assert self.complete('colorama.Fore.BLACK') == ['colorama.Fore.BLACK']
            del self.namespace.colorama


def test_version_info():
    assert utils.version_info()[:2] > (0, 7)
