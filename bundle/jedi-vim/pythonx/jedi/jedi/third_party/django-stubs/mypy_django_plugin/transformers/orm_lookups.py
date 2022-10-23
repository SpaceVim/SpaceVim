from mypy.plugin import MethodContext
from mypy.types import AnyType, Instance
from mypy.types import Type as MypyType
from mypy.types import TypeOfAny

from mypy_django_plugin.django.context import DjangoContext
from mypy_django_plugin.lib import fullnames, helpers


def typecheck_queryset_filter(ctx: MethodContext, django_context: DjangoContext) -> MypyType:
    lookup_kwargs = ctx.arg_names[1]
    provided_lookup_types = ctx.arg_types[1]

    assert isinstance(ctx.type, Instance)

    if not ctx.type.args or not isinstance(ctx.type.args[0], Instance):
        return ctx.default_return_type

    model_cls_fullname = ctx.type.args[0].type.fullname
    model_cls = django_context.get_model_class_by_fullname(model_cls_fullname)
    if model_cls is None:
        return ctx.default_return_type

    for lookup_kwarg, provided_type in zip(lookup_kwargs, provided_lookup_types):
        if lookup_kwarg is None:
            continue
        if (isinstance(provided_type, Instance)
                and provided_type.type.has_base('django.db.models.expressions.Combinable')):
            provided_type = resolve_combinable_type(provided_type, django_context)

        lookup_type = django_context.resolve_lookup_expected_type(ctx, model_cls, lookup_kwarg)
        # Managers as provided_type is not supported yet
        if (isinstance(provided_type, Instance)
                and helpers.has_any_of_bases(provided_type.type, (fullnames.MANAGER_CLASS_FULLNAME,
                                                                  fullnames.QUERYSET_CLASS_FULLNAME))):
            return ctx.default_return_type

        helpers.check_types_compatible(ctx,
                                       expected_type=lookup_type,
                                       actual_type=provided_type,
                                       error_message=f'Incompatible type for lookup {lookup_kwarg!r}:')

    return ctx.default_return_type


def resolve_combinable_type(combinable_type: Instance, django_context: DjangoContext) -> MypyType:
    if combinable_type.type.fullname != fullnames.F_EXPRESSION_FULLNAME:
        # Combinables aside from F expressions are unsupported
        return AnyType(TypeOfAny.explicit)

    return django_context.resolve_f_expression_type(combinable_type)
