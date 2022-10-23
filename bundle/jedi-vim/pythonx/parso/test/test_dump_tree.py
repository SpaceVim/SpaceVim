from textwrap import dedent

import pytest

from parso import parse
# Using star import for easier eval testing below.
from parso.python.tree import *  # noqa: F403
from parso.tree import *  # noqa: F403
from parso.tree import ErrorLeaf, TypedLeaf


@pytest.mark.parametrize(
    'indent,expected_dump', [
        (None, "Module(["
               "Lambda(["
               "Keyword('lambda', (1, 0)), "
               "Param(["
               "Name('x', (1, 7), prefix=' '), "
               "Operator(',', (1, 8)), "
               "]), "
               "Param(["
               "Name('y', (1, 10), prefix=' '), "
               "]), "
               "Operator(':', (1, 11)), "
               "PythonNode('arith_expr', ["
               "Name('x', (1, 13), prefix=' '), "
               "Operator('+', (1, 15), prefix=' '), "
               "Name('y', (1, 17), prefix=' '), "
               "]), "
               "]), "
               "EndMarker('', (1, 18)), "
               "])"),
        (0, dedent('''\
            Module([
            Lambda([
            Keyword('lambda', (1, 0)),
            Param([
            Name('x', (1, 7), prefix=' '),
            Operator(',', (1, 8)),
            ]),
            Param([
            Name('y', (1, 10), prefix=' '),
            ]),
            Operator(':', (1, 11)),
            PythonNode('arith_expr', [
            Name('x', (1, 13), prefix=' '),
            Operator('+', (1, 15), prefix=' '),
            Name('y', (1, 17), prefix=' '),
            ]),
            ]),
            EndMarker('', (1, 18)),
            ])''')),
        (4, dedent('''\
            Module([
                Lambda([
                    Keyword('lambda', (1, 0)),
                    Param([
                        Name('x', (1, 7), prefix=' '),
                        Operator(',', (1, 8)),
                    ]),
                    Param([
                        Name('y', (1, 10), prefix=' '),
                    ]),
                    Operator(':', (1, 11)),
                    PythonNode('arith_expr', [
                        Name('x', (1, 13), prefix=' '),
                        Operator('+', (1, 15), prefix=' '),
                        Name('y', (1, 17), prefix=' '),
                    ]),
                ]),
                EndMarker('', (1, 18)),
            ])''')),
        ('\t', dedent('''\
            Module([
            \tLambda([
            \t\tKeyword('lambda', (1, 0)),
            \t\tParam([
            \t\t\tName('x', (1, 7), prefix=' '),
            \t\t\tOperator(',', (1, 8)),
            \t\t]),
            \t\tParam([
            \t\t\tName('y', (1, 10), prefix=' '),
            \t\t]),
            \t\tOperator(':', (1, 11)),
            \t\tPythonNode('arith_expr', [
            \t\t\tName('x', (1, 13), prefix=' '),
            \t\t\tOperator('+', (1, 15), prefix=' '),
            \t\t\tName('y', (1, 17), prefix=' '),
            \t\t]),
            \t]),
            \tEndMarker('', (1, 18)),
            ])''')),
    ]
)
def test_dump_parser_tree(indent, expected_dump):
    code = "lambda x, y: x + y"
    module = parse(code)
    assert module.dump(indent=indent) == expected_dump

    # Check that dumped tree can be eval'd to recover the parser tree and original code.
    recovered_code = eval(expected_dump).get_code()
    assert recovered_code == code


@pytest.mark.parametrize(
    'node,expected_dump,expected_code', [
        (  # Dump intermediate node (not top level module)
            parse("def foo(x, y): return x + y").children[0], dedent('''\
                Function([
                    Keyword('def', (1, 0)),
                    Name('foo', (1, 4), prefix=' '),
                    PythonNode('parameters', [
                        Operator('(', (1, 7)),
                        Param([
                            Name('x', (1, 8)),
                            Operator(',', (1, 9)),
                        ]),
                        Param([
                            Name('y', (1, 11), prefix=' '),
                        ]),
                        Operator(')', (1, 12)),
                    ]),
                    Operator(':', (1, 13)),
                    ReturnStmt([
                        Keyword('return', (1, 15), prefix=' '),
                        PythonNode('arith_expr', [
                            Name('x', (1, 22), prefix=' '),
                            Operator('+', (1, 24), prefix=' '),
                            Name('y', (1, 26), prefix=' '),
                        ]),
                    ]),
                ])'''),
            "def foo(x, y): return x + y",
        ),
        (  # Dump leaf
            parse("def foo(x, y): return x + y").children[0].children[0],
            "Keyword('def', (1, 0))",
            'def',
        ),
        (  # Dump ErrorLeaf
            ErrorLeaf('error_type', 'error_code', (1, 1), prefix=' '),
            "ErrorLeaf('error_type', 'error_code', (1, 1), prefix=' ')",
            ' error_code',
        ),
        (  # Dump TypedLeaf
            TypedLeaf('type', 'value', (1, 1)),
            "TypedLeaf('type', 'value', (1, 1))",
            'value',
        ),
    ]
)
def test_dump_parser_tree_not_top_level_module(node, expected_dump, expected_code):
    dump_result = node.dump()
    assert dump_result == expected_dump

    # Check that dumped tree can be eval'd to recover the parser tree and original code.
    recovered_code = eval(dump_result).get_code()
    assert recovered_code == expected_code


def test_dump_parser_tree_invalid_args():
    module = parse("lambda x, y: x + y")

    with pytest.raises(TypeError):
        module.dump(indent=1.1)


def test_eval_dump_recovers_parent():
    module = parse("lambda x, y: x + y")
    module2 = eval(module.dump())
    assert module2.parent is None
    lambda_node = module2.children[0]
    assert lambda_node.parent is module2
    assert module2.children[1].parent is module2
    assert lambda_node.children[0].parent is lambda_node
    param_node = lambda_node.children[1]
    assert param_node.parent is lambda_node
    assert param_node.children[0].parent is param_node
    assert param_node.children[1].parent is param_node
    arith_expr_node = lambda_node.children[-1]
    assert arith_expr_node.parent is lambda_node
    assert arith_expr_node.children[0].parent is arith_expr_node
