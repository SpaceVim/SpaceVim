"""
A script to find bugs in the diff parser.

This script is extremely useful if changes are made to the diff parser. By
running a few thousand iterations, we can assure that the diff parser is in
good shape.

Usage:
  fuzz_diff_parser.py [--pdb|--ipdb] [-l] [-n=<nr>] [-x=<nr>] random [<path>]
  fuzz_diff_parser.py [--pdb|--ipdb] [-l] redo [-o=<nr>] [-p]
  fuzz_diff_parser.py -h | --help

Options:
  -h --help              Show this screen
  -n, --maxtries=<nr>    Maximum of random tries [default: 1000]
  -x, --changes=<nr>     Amount of changes to be done to a file per try [default: 5]
  -l, --logging          Prints all the logs
  -o, --only-last=<nr>   Only runs the last n iterations; Defaults to running all
  -p, --print-code      Print all test diffs
  --pdb                  Launch pdb when error is raised
  --ipdb                 Launch ipdb when error is raised
"""

from __future__ import print_function
import logging
import sys
import os
import random
import pickle

import parso
from parso.utils import split_lines
from test.test_diff_parser import _check_error_leaves_nodes

_latest_grammar = parso.load_grammar(version='3.8')
_python_reserved_strings = tuple(
    # Keywords are ususally only interesting in combination with spaces after
    # them. We don't put a space before keywords, to avoid indentation errors.
    s + (' ' if s.isalpha() else '')
    for s in _latest_grammar._pgen_grammar.reserved_syntax_strings.keys()
)
_random_python_fragments = _python_reserved_strings + (
    ' ', '\t', '\n', '\r', '\f', 'f"', 'F"""', "fr'", "RF'''", '"', '"""', "'",
    "'''", ';', ' some_random_word ', '\\', '#',
)


def find_python_files_in_tree(file_path):
    if not os.path.isdir(file_path):
        yield file_path
        return
    for root, dirnames, filenames in os.walk(file_path):
        if 'chardet' in root:
            # Stuff like chardet/langcyrillicmodel.py is just very slow to
            # parse and machine generated, so ignore those.
            continue

        for name in filenames:
            if name.endswith('.py'):
                yield os.path.join(root, name)


def _print_copyable_lines(lines):
    for line in lines:
        line = repr(line)[1:-1]
        if line.endswith(r'\n'):
            line = line[:-2] + '\n'
        print(line, end='')


def _get_first_error_start_pos_or_none(module):
    error_leaf = _check_error_leaves_nodes(module)
    return None if error_leaf is None else error_leaf.start_pos


class LineReplacement:
    def __init__(self, line_nr, new_line):
        self._line_nr = line_nr
        self._new_line = new_line

    def apply(self, code_lines):
        # print(repr(self._new_line))
        code_lines[self._line_nr] = self._new_line


class LineDeletion:
    def __init__(self, line_nr):
        self.line_nr = line_nr

    def apply(self, code_lines):
        del code_lines[self.line_nr]


class LineCopy:
    def __init__(self, copy_line, insertion_line):
        self._copy_line = copy_line
        self._insertion_line = insertion_line

    def apply(self, code_lines):
        code_lines.insert(
            self._insertion_line,
            # Use some line from the file. This doesn't feel totally
            # random, but for the diff parser it will feel like it.
            code_lines[self._copy_line]
        )


class FileModification:
    @classmethod
    def generate(cls, code_lines, change_count, previous_file_modification=None):
        if previous_file_modification is not None and random.random() > 0.5:
            # We want to keep the previous modifications in some cases to make
            # more complex parser issues visible.
            code_lines = previous_file_modification.apply(code_lines)
            added_modifications = previous_file_modification.modification_list
        else:
            added_modifications = []
        return cls(
            added_modifications
            + list(cls._generate_line_modifications(code_lines, change_count)),
            # work with changed trees more than with normal ones.
            check_original=random.random() > 0.8,
        )

    @staticmethod
    def _generate_line_modifications(lines, change_count):
        def random_line(include_end=False):
            return random.randint(0, len(lines) - (not include_end))

        lines = list(lines)
        for _ in range(change_count):
            rand = random.randint(1, 4)
            if rand == 1:
                if len(lines) == 1:
                    # We cannot delete every line, that doesn't make sense to
                    # fuzz and it would be annoying to rewrite everything here.
                    continue
                ld = LineDeletion(random_line())
            elif rand == 2:
                # Copy / Insertion
                # Make it possible to insert into the first and the last line
                ld = LineCopy(random_line(), random_line(include_end=True))
            elif rand in (3, 4):
                # Modify a line in some weird random ways.
                line_nr = random_line()
                line = lines[line_nr]
                column = random.randint(0, len(line))
                random_string = ''
                for _ in range(random.randint(1, 3)):
                    if random.random() > 0.8:
                        # The lower characters cause way more issues.
                        unicode_range = 0x1f if random.randint(0, 1) else 0x3000
                        random_string += chr(random.randint(0, unicode_range))
                    else:
                        # These insertions let us understand how random
                        # keyword/operator insertions work. Theoretically this
                        # could also be done with unicode insertions, but the
                        # fuzzer is just way more effective here.
                        random_string += random.choice(_random_python_fragments)
                if random.random() > 0.5:
                    # In this case we insert at a very random place that
                    # probably breaks syntax.
                    line = line[:column] + random_string + line[column:]
                else:
                    # Here we have better chances to not break syntax, because
                    # we really replace the line with something that has
                    # indentation.
                    line = ' ' * random.randint(0, 12) + random_string + '\n'
                ld = LineReplacement(line_nr, line)
            ld.apply(lines)
            yield ld

    def __init__(self, modification_list, check_original):
        self.modification_list = modification_list
        self._check_original = check_original

    def apply(self, code_lines):
        changed_lines = list(code_lines)
        for modification in self.modification_list:
            modification.apply(changed_lines)
        return changed_lines

    def run(self, grammar, code_lines, print_code):
        code = ''.join(code_lines)
        modified_lines = self.apply(code_lines)
        modified_code = ''.join(modified_lines)

        if print_code:
            if self._check_original:
                print('Original:')
                _print_copyable_lines(code_lines)

            print('\nModified:')
            _print_copyable_lines(modified_lines)
            print()

        if self._check_original:
            m = grammar.parse(code, diff_cache=True)
            start1 = _get_first_error_start_pos_or_none(m)

        grammar.parse(modified_code, diff_cache=True)

        if self._check_original:
            # Also check if it's possible to "revert" the changes.
            m = grammar.parse(code, diff_cache=True)
            start2 = _get_first_error_start_pos_or_none(m)
            assert start1 == start2, (start1, start2)


class FileTests:
    def __init__(self, file_path, test_count, change_count):
        self._path = file_path
        with open(file_path, errors='replace') as f:
            code = f.read()
        self._code_lines = split_lines(code, keepends=True)
        self._test_count = test_count
        self._code_lines = self._code_lines
        self._change_count = change_count
        self._file_modifications = []

    def _run(self, grammar, file_modifications, debugger, print_code=False):
        try:
            for i, fm in enumerate(file_modifications, 1):
                fm.run(grammar, self._code_lines, print_code=print_code)
                print('.', end='')
                sys.stdout.flush()
            print()
        except Exception:
            print("Issue in file: %s" % self._path)
            if debugger:
                einfo = sys.exc_info()
                pdb = __import__(debugger)
                pdb.post_mortem(einfo[2])
            raise

    def redo(self, grammar, debugger, only_last, print_code):
        mods = self._file_modifications
        if only_last is not None:
            mods = mods[-only_last:]
        self._run(grammar, mods, debugger, print_code=print_code)

    def run(self, grammar, debugger):
        def iterate():
            fm = None
            for _ in range(self._test_count):
                fm = FileModification.generate(
                    self._code_lines, self._change_count,
                    previous_file_modification=fm
                )
                self._file_modifications.append(fm)
                yield fm

        self._run(grammar, iterate(), debugger)


def main(arguments):
    debugger = 'pdb' if arguments['--pdb'] else \
               'ipdb' if arguments['--ipdb'] else None
    redo_file = os.path.join(os.path.dirname(__file__), 'fuzz-redo.pickle')

    if arguments['--logging']:
        root = logging.getLogger()
        root.setLevel(logging.DEBUG)

        ch = logging.StreamHandler(sys.stdout)
        ch.setLevel(logging.DEBUG)
        root.addHandler(ch)

    grammar = parso.load_grammar()
    parso.python.diff.DEBUG_DIFF_PARSER = True
    if arguments['redo']:
        with open(redo_file, 'rb') as f:
            file_tests_obj = pickle.load(f)
        only_last = arguments['--only-last'] and int(arguments['--only-last'])
        file_tests_obj.redo(
            grammar,
            debugger,
            only_last=only_last,
            print_code=arguments['--print-code']
        )
    elif arguments['random']:
        # A random file is used to do diff parser checks if no file is given.
        # This helps us to find errors in a lot of different files.
        file_paths = list(find_python_files_in_tree(arguments['<path>'] or '.'))
        max_tries = int(arguments['--maxtries'])
        tries = 0
        try:
            while tries < max_tries:
                path = random.choice(file_paths)
                print("Checking %s: %s tries" % (path, tries))
                now_tries = min(1000, max_tries - tries)
                file_tests_obj = FileTests(path, now_tries, int(arguments['--changes']))
                file_tests_obj.run(grammar, debugger)
                tries += now_tries
        except Exception:
            with open(redo_file, 'wb') as f:
                pickle.dump(file_tests_obj, f)
            raise
    else:
        raise NotImplementedError('Command is not implemented')


if __name__ == '__main__':
    from docopt import docopt

    arguments = docopt(__doc__)
    main(arguments)
