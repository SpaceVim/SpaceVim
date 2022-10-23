import os

import parso


def get_python_files(path):
    for dir_path, dir_names, file_names in os.walk(path):
        for file_name in file_names:
            if file_name.endswith('.py'):
                yield os.path.join(dir_path, file_name)


def test_on_itself(each_version):
    """
    There are obviously no syntax erros in the Python code of parso. However
    parso should output the same for all versions.
    """
    grammar = parso.load_grammar(version=each_version)
    path = os.path.dirname(os.path.dirname(__file__)) + '/parso'
    for file in get_python_files(path):
        tree = grammar.parse(path=file)
        errors = list(grammar.iter_errors(tree))
        assert not errors
