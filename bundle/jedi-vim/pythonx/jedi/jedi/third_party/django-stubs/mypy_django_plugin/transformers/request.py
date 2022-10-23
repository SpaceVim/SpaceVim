from mypy.plugin import AttributeContext
from mypy.types import Instance
from mypy.types import Type as MypyType
from mypy.types import UnionType

from mypy_django_plugin.django.context import DjangoContext
from mypy_django_plugin.lib import helpers


def set_auth_user_model_as_type_for_request_user(ctx: AttributeContext, django_context: DjangoContext) -> MypyType:
    auth_user_model = django_context.settings.AUTH_USER_MODEL
    user_cls = django_context.apps_registry.get_model(auth_user_model)
    user_info = helpers.lookup_class_typeinfo(helpers.get_typechecker_api(ctx), user_cls)

    if user_info is None:
        return ctx.default_attr_type

    # Imported here because django isn't properly loaded yet when module is loaded
    from django.contrib.auth.models import AnonymousUser

    anonymous_user_info = helpers.lookup_class_typeinfo(helpers.get_typechecker_api(ctx), AnonymousUser)
    if anonymous_user_info is None:
        # This shouldn't be able to happen, as we managed to import the model above...
        return Instance(user_info, [])

    return UnionType([Instance(user_info, []), Instance(anonymous_user_info, [])])
