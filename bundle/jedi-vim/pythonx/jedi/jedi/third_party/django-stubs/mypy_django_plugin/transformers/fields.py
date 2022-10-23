from typing import Optional, Tuple, cast

from django.db.models.fields import Field
from django.db.models.fields.related import RelatedField
from mypy.nodes import AssignmentStmt, NameExpr, TypeInfo
from mypy.plugin import FunctionContext
from mypy.types import AnyType, Instance
from mypy.types import Type as MypyType
from mypy.types import TypeOfAny

from mypy_django_plugin.django.context import DjangoContext
from mypy_django_plugin.lib import fullnames, helpers


def _get_current_field_from_assignment(ctx: FunctionContext, django_context: DjangoContext) -> Optional[Field]:
    outer_model_info = helpers.get_typechecker_api(ctx).scope.active_class()
    if (outer_model_info is None
            or not helpers.is_model_subclass_info(outer_model_info, django_context)):
        return None

    field_name = None
    for stmt in outer_model_info.defn.defs.body:
        if isinstance(stmt, AssignmentStmt):
            if stmt.rvalue == ctx.context:
                if not isinstance(stmt.lvalues[0], NameExpr):
                    return None
                field_name = stmt.lvalues[0].name
                break
    if field_name is None:
        return None

    model_cls = django_context.get_model_class_by_fullname(outer_model_info.fullname)
    if model_cls is None:
        return None

    current_field = model_cls._meta.get_field(field_name)
    return current_field


def reparametrize_related_field_type(related_field_type: Instance, set_type, get_type) -> Instance:
    args = [
        helpers.convert_any_to_type(related_field_type.args[0], set_type),
        helpers.convert_any_to_type(related_field_type.args[1], get_type),
    ]
    return helpers.reparametrize_instance(related_field_type, new_args=args)


def fill_descriptor_types_for_related_field(ctx: FunctionContext, django_context: DjangoContext) -> MypyType:
    current_field = _get_current_field_from_assignment(ctx, django_context)
    if current_field is None:
        return AnyType(TypeOfAny.from_error)

    assert isinstance(current_field, RelatedField)

    related_model_cls = django_context.get_field_related_model_cls(current_field)
    if related_model_cls is None:
        return AnyType(TypeOfAny.from_error)

    default_related_field_type = set_descriptor_types_for_field(ctx)

    # self reference with abstract=True on the model where ForeignKey is defined
    current_model_cls = current_field.model
    if (current_model_cls._meta.abstract
            and current_model_cls == related_model_cls):
        # for all derived non-abstract classes, set variable with this name to
        # __get__/__set__ of ForeignKey of derived model
        for model_cls in django_context.all_registered_model_classes:
            if issubclass(model_cls, current_model_cls) and not model_cls._meta.abstract:
                derived_model_info = helpers.lookup_class_typeinfo(helpers.get_typechecker_api(ctx), model_cls)
                if derived_model_info is not None:
                    fk_ref_type = Instance(derived_model_info, [])
                    derived_fk_type = reparametrize_related_field_type(default_related_field_type,
                                                                       set_type=fk_ref_type, get_type=fk_ref_type)
                    helpers.add_new_sym_for_info(derived_model_info,
                                                 name=current_field.name,
                                                 sym_type=derived_fk_type)

    related_model = related_model_cls
    related_model_to_set = related_model_cls
    if related_model_to_set._meta.proxy_for_model is not None:
        related_model_to_set = related_model_to_set._meta.proxy_for_model

    typechecker_api = helpers.get_typechecker_api(ctx)

    related_model_info = helpers.lookup_class_typeinfo(typechecker_api, related_model)
    if related_model_info is None:
        # maybe no type stub
        related_model_type = AnyType(TypeOfAny.unannotated)
    else:
        related_model_type = Instance(related_model_info, [])  # type: ignore

    related_model_to_set_info = helpers.lookup_class_typeinfo(typechecker_api, related_model_to_set)
    if related_model_to_set_info is None:
        # maybe no type stub
        related_model_to_set_type = AnyType(TypeOfAny.unannotated)
    else:
        related_model_to_set_type = Instance(related_model_to_set_info, [])  # type: ignore

    # replace Any with referred_to_type
    return reparametrize_related_field_type(default_related_field_type,
                                            set_type=related_model_to_set_type,
                                            get_type=related_model_type)


def get_field_descriptor_types(field_info: TypeInfo, is_nullable: bool) -> Tuple[MypyType, MypyType]:
    set_type = helpers.get_private_descriptor_type(field_info, '_pyi_private_set_type',
                                                   is_nullable=is_nullable)
    get_type = helpers.get_private_descriptor_type(field_info, '_pyi_private_get_type',
                                                   is_nullable=is_nullable)
    return set_type, get_type


def set_descriptor_types_for_field(ctx: FunctionContext) -> Instance:
    default_return_type = cast(Instance, ctx.default_return_type)

    is_nullable = False
    null_expr = helpers.get_call_argument_by_name(ctx, 'null')
    if null_expr is not None:
        is_nullable = helpers.parse_bool(null_expr) or False

    set_type, get_type = get_field_descriptor_types(default_return_type.type, is_nullable)
    return helpers.reparametrize_instance(default_return_type, [set_type, get_type])


def determine_type_of_array_field(ctx: FunctionContext, django_context: DjangoContext) -> MypyType:
    default_return_type = set_descriptor_types_for_field(ctx)

    base_field_arg_type = helpers.get_call_argument_type_by_name(ctx, 'base_field')
    if not base_field_arg_type or not isinstance(base_field_arg_type, Instance):
        return default_return_type

    base_type = base_field_arg_type.args[1]  # extract __get__ type
    args = []
    for default_arg in default_return_type.args:
        args.append(helpers.convert_any_to_type(default_arg, base_type))

    return helpers.reparametrize_instance(default_return_type, args)


def transform_into_proper_return_type(ctx: FunctionContext, django_context: DjangoContext) -> MypyType:
    default_return_type = ctx.default_return_type
    assert isinstance(default_return_type, Instance)

    outer_model_info = helpers.get_typechecker_api(ctx).scope.active_class()
    if (outer_model_info is None
            or not helpers.is_model_subclass_info(outer_model_info, django_context)):
        return ctx.default_return_type

    assert isinstance(outer_model_info, TypeInfo)

    if helpers.has_any_of_bases(default_return_type.type, fullnames.RELATED_FIELDS_CLASSES):
        return fill_descriptor_types_for_related_field(ctx, django_context)

    if default_return_type.type.has_base(fullnames.ARRAY_FIELD_FULLNAME):
        return determine_type_of_array_field(ctx, django_context)

    return set_descriptor_types_for_field(ctx)
