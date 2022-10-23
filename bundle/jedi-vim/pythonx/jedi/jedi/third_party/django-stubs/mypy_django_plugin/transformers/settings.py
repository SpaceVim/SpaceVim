from mypy.nodes import MemberExpr
from mypy.plugin import AttributeContext, FunctionContext
from mypy.types import AnyType, Instance
from mypy.types import Type as MypyType
from mypy.types import TypeOfAny, TypeType

from mypy_django_plugin.django.context import DjangoContext
from mypy_django_plugin.lib import helpers


def get_user_model_hook(ctx: FunctionContext, django_context: DjangoContext) -> MypyType:
    auth_user_model = django_context.settings.AUTH_USER_MODEL
    model_cls = django_context.apps_registry.get_model(auth_user_model)
    model_cls_fullname = helpers.get_class_fullname(model_cls)

    model_info = helpers.lookup_fully_qualified_typeinfo(helpers.get_typechecker_api(ctx),
                                                         model_cls_fullname)
    if model_info is None:
        return AnyType(TypeOfAny.unannotated)

    return TypeType(Instance(model_info, []))


def get_type_of_settings_attribute(ctx: AttributeContext, django_context: DjangoContext) -> MypyType:
    assert isinstance(ctx.context, MemberExpr)
    setting_name = ctx.context.name
    if not hasattr(django_context.settings, setting_name):
        ctx.api.fail(f"'Settings' object has no attribute {setting_name!r}", ctx.context)
        return ctx.default_attr_type

    typechecker_api = helpers.get_typechecker_api(ctx)

    # first look for the setting in the project settings file, then global settings
    settings_module = typechecker_api.modules.get(django_context.django_settings_module)
    global_settings_module = typechecker_api.modules.get('django.conf.global_settings')
    for module in [settings_module, global_settings_module]:
        if module is not None:
            sym = module.names.get(setting_name)
            if sym is not None and sym.type is not None:
                return sym.type

    # if by any reason it isn't present there, get type from django settings
    value = getattr(django_context.settings, setting_name)
    value_fullname = helpers.get_class_fullname(value.__class__)

    value_info = helpers.lookup_fully_qualified_typeinfo(typechecker_api, value_fullname)
    if value_info is None:
        return ctx.default_attr_type

    return Instance(value_info, [])
