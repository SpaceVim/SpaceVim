import os

import pytest

from . import helpers
from jedi.common import indent_block
from jedi import RefactoringError


def assert_case_equal(case, actual, desired):
    """
    Assert ``actual == desired`` with formatted message.

    This is not needed for typical pytest use case, but as we need
    ``--assert=plain`` (see ../pytest.ini) to workaround some issue
    due to pytest magic, let's format the message by hand.
    """
    assert actual == desired, """
Test %r failed.
actual  =
%s
desired =
%s
""" % (case, indent_block(str(actual)), indent_block(str(desired)))


def assert_static_analysis(case, actual, desired):
    """A nicer formatting for static analysis tests."""
    a = set(actual)
    d = set(desired)
    assert actual == desired, """
Test %r failed.
not raised  = %s
unspecified = %s
""" % (case, sorted(d - a), sorted(a - d))


def test_completion(case, monkeypatch, environment, has_django):
    skip_reason = case.get_skip_reason(environment)
    if skip_reason is not None:
        pytest.skip(skip_reason)

    if (not has_django) and case.path.endswith('django.py'):
        pytest.skip('Needs django to be installed to run this test.')
    repo_root = helpers.root_dir
    monkeypatch.chdir(os.path.join(repo_root, 'jedi'))
    case.run(assert_case_equal, environment)


def test_static_analysis(static_analysis_case, environment):
    skip_reason = static_analysis_case.get_skip_reason(environment)
    if skip_reason is not None:
        pytest.skip(skip_reason)
    else:
        static_analysis_case.run(assert_static_analysis, environment)


def test_refactor(refactor_case, environment):
    """
    Run refactoring test case.

    :type refactor_case: :class:`.refactor.RefactoringCase`
    """
    desired_result = refactor_case.get_desired_result()
    if refactor_case.type == 'error':
        with pytest.raises(RefactoringError) as e:
            refactor_case.refactor(environment)
        assert e.value.args[0] == desired_result.strip()
    elif refactor_case.type == 'text':
        refactoring = refactor_case.refactor(environment)
        assert not refactoring.get_renames()
        text = ''.join(f.get_new_code() for f in refactoring.get_changed_files().values())
        assert_case_equal(refactor_case, text, desired_result)
    else:
        diff = refactor_case.refactor(environment).get_diff()
        assert_case_equal(refactor_case, diff, desired_result)
