from typing import List, Tuple, Type, Union

from django.db.models.base import Model
from mypy.plugin import FunctionContext, MethodContext
from mypy.types import Instance
from mypy.types import Type as MypyType

from mypy_django_plugin.django.context import DjangoContext
from mypy_django_plugin.lib import helpers


def get_actual_types(ctx: Union[MethodContext, FunctionContext],
                     expected_keys: List[str]) -> List[Tuple[str, MypyType]]:
    actual_types = []
    # positionals
    for pos, (actual_name, actual_type) in enumerate(zip(ctx.arg_names[0], ctx.arg_types[0])):
        if actual_name is None:
            if ctx.callee_arg_names[0] == 'kwargs':
                # unpacked dict as kwargs is not supported
                continue
            actual_name = expected_keys[pos]
        actual_types.append((actual_name, actual_type))
    # kwargs
    if len(ctx.callee_arg_names) > 1:
        for actual_name, actual_type in zip(ctx.arg_names[1], ctx.arg_types[1]):
            if actual_name is None:
                # unpacked dict as kwargs is not supported
                continue
            actual_types.append((actual_name, actual_type))
    return actual_types


def typecheck_model_method(ctx: Union[FunctionContext, MethodContext], django_context: DjangoContext,
                           model_cls: Type[Model], method: str) -> MypyType:
    typechecker_api = helpers.get_typechecker_api(ctx)
    expected_types = django_context.get_expected_types(typechecker_api, model_cls, method=method)
    expected_keys = [key for key in expected_types.keys() if key != 'pk']

    for actual_name, actual_type in get_actual_types(ctx, expected_keys):
        if actual_name not in expected_types:
            ctx.api.fail('Unexpected attribute "{}" for model "{}"'.format(actual_name,
                                                                           model_cls.__name__),
                         ctx.context)
            continue
        helpers.check_types_compatible(ctx,
                                       expected_type=expected_types[actual_name],
                                       actual_type=actual_type,
                                       error_message='Incompatible type for "{}" of "{}"'.format(actual_name,
                                                                                                 model_cls.__name__))

    return ctx.default_return_type


def redefine_and_typecheck_model_init(ctx: FunctionContext, django_context: DjangoContext) -> MypyType:
    assert isinstance(ctx.default_return_type, Instance)

    model_fullname = ctx.default_return_type.type.fullname
    model_cls = django_context.get_model_class_by_fullname(model_fullname)
    if model_cls is None:
        return ctx.default_return_type

    return typecheck_model_method(ctx, django_context, model_cls, '__init__')


def redefine_and_typecheck_model_create(ctx: MethodContext, django_context: DjangoContext) -> MypyType:
    if not isinstance(ctx.default_return_type, Instance):
        # only work with ctx.default_return_type = model Instance
        return ctx.default_return_type

    model_fullname = ctx.default_return_type.type.fullname
    model_cls = django_context.get_model_class_by_fullname(model_fullname)
    if model_cls is None:
        return ctx.default_return_type

    return typecheck_model_method(ctx, django_context, model_cls, 'create')
