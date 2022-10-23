import os
from typing import Optional

import libcst
from libcst import Annotation, BaseExpression, FunctionDef, Name, Subscript
from libcst.metadata import SyntacticPositionProvider

BASE_DIR = 'django-stubs'

fpath = os.path.join(BASE_DIR, 'core', 'checks', 'model_checks.pyi')
with open(fpath, 'r') as f:
    contents = f.read()


tree = libcst.parse_module(contents)


class TypeAnnotationsAnalyzer(libcst.CSTVisitor):
    METADATA_DEPENDENCIES = (SyntacticPositionProvider,)

    def __init__(self, fpath: str):
        super().__init__()
        self.fpath = fpath

    def get_node_location(self, node: FunctionDef) -> str:
        start_line = self.get_metadata(SyntacticPositionProvider, node).start.line
        return f'{self.fpath}:{start_line}'

    def show_error_for_node(self, node: FunctionDef, error_message: str):
        print(self.get_node_location(node), error_message)

    def check_subscripted_annotation(self, annotation: BaseExpression) -> Optional[str]:
        if isinstance(annotation, Subscript):
            if isinstance(annotation.value, Name):
                error_message = self.check_concrete_class_usage(annotation.value)
                if error_message:
                    return error_message

            if annotation.value.value == 'Union':
                for slice_param in annotation.slice:
                    if isinstance(slice_param.slice.value, Name):
                        error_message = self.check_concrete_class_usage(annotation.value)
                        if error_message:
                            return error_message

    def check_concrete_class_usage(self, name_node: Name) -> Optional[str]:
        if name_node.value == 'List':
            return (f'Concrete class {name_node.value!r} used for an iterable annotation. '
                    f'Use abstract collection (Iterable, Collection, Sequence) instead')

    def visit_FunctionDef(self, node: FunctionDef) -> Optional[bool]:
        params_node = node.params
        for param_node in [*params_node.params, *params_node.default_params]:
            param_name = param_node.name.value
            annotation_node = param_node.annotation  # type: Annotation
            if annotation_node is not None:
                annotation = annotation_node.annotation
                if annotation.value == 'None':
                    self.show_error_for_node(node, f'"None" type annotation used for parameter {param_name!r}')
                    continue

                error_message = self.check_subscripted_annotation(annotation)
                if error_message is not None:
                    self.show_error_for_node(node, error_message)
                    continue

        if node.returns is not None:
            return_annotation = node.returns.annotation
            if isinstance(return_annotation, Subscript) and return_annotation.value.value == 'Union':
                self.show_error_for_node(node, 'Union is return type annotation')

        return False


for dirpath, dirnames, filenames in os.walk(BASE_DIR):
    for filename in filenames:
        fpath = os.path.join(dirpath, filename)
        # skip all other checks for now, low priority
        if not fpath.startswith(('django-stubs/db', 'django-stubs/views', 'django-stubs/apps',
                                 'django-stubs/http', 'django-stubs/contrib/postgres')):
            continue

        with open(fpath, 'r') as f:
            contents = f.read()

        tree = libcst.MetadataWrapper(libcst.parse_module(contents))
        analyzer = TypeAnnotationsAnalyzer(fpath)
        tree.visit(analyzer)
