from mypy.nodes import (
    GDEF, FuncDef, MemberExpr, NameExpr, RefExpr, StrExpr, SymbolTableNode, TypeInfo,
)
from mypy.plugin import ClassDefContext, DynamicClassDefContext
from mypy.types import AnyType, Instance, TypeOfAny

from mypy_django_plugin.lib import fullnames, helpers


def create_new_manager_class_from_from_queryset_method(ctx: DynamicClassDefContext) -> None:
    semanal_api = helpers.get_semanal_api(ctx)

    callee = ctx.call.callee
    assert isinstance(callee, MemberExpr)
    assert isinstance(callee.expr, RefExpr)

    base_manager_info = callee.expr.node
    if base_manager_info is None:
        if not semanal_api.final_iteration:
            semanal_api.defer()
        return

    assert isinstance(base_manager_info, TypeInfo)
    new_manager_info = semanal_api.basic_new_typeinfo(ctx.name,
                                                      basetype_or_fallback=Instance(base_manager_info,
                                                                                    [AnyType(TypeOfAny.unannotated)]))
    new_manager_info.line = ctx.call.line
    new_manager_info.defn.line = ctx.call.line
    new_manager_info.metaclass_type = new_manager_info.calculate_metaclass_type()

    current_module = semanal_api.cur_mod_node
    current_module.names[ctx.name] = SymbolTableNode(GDEF, new_manager_info,
                                                     plugin_generated=True)
    passed_queryset = ctx.call.args[0]
    assert isinstance(passed_queryset, NameExpr)

    derived_queryset_fullname = passed_queryset.fullname
    assert derived_queryset_fullname is not None

    sym = semanal_api.lookup_fully_qualified_or_none(derived_queryset_fullname)
    assert sym is not None
    if sym.node is None:
        if not semanal_api.final_iteration:
            semanal_api.defer()
        else:
            # inherit from Any to prevent false-positives, if queryset class cannot be resolved
            new_manager_info.fallback_to_any = True
        return

    derived_queryset_info = sym.node
    assert isinstance(derived_queryset_info, TypeInfo)

    if len(ctx.call.args) > 1:
        expr = ctx.call.args[1]
        assert isinstance(expr, StrExpr)
        custom_manager_generated_name = expr.value
    else:
        custom_manager_generated_name = base_manager_info.name + 'From' + derived_queryset_info.name

    custom_manager_generated_fullname = '.'.join(['django.db.models.manager', custom_manager_generated_name])
    if 'from_queryset_managers' not in base_manager_info.metadata:
        base_manager_info.metadata['from_queryset_managers'] = {}
    base_manager_info.metadata['from_queryset_managers'][custom_manager_generated_fullname] = new_manager_info.fullname

    class_def_context = ClassDefContext(cls=new_manager_info.defn,
                                        reason=ctx.call, api=semanal_api)
    self_type = Instance(new_manager_info, [])
    # we need to copy all methods in MRO before django.db.models.query.QuerySet
    for class_mro_info in derived_queryset_info.mro:
        if class_mro_info.fullname == fullnames.QUERYSET_CLASS_FULLNAME:
            break
        for name, sym in class_mro_info.names.items():
            if isinstance(sym.node, FuncDef):
                helpers.copy_method_to_another_class(class_def_context,
                                                     self_type,
                                                     new_method_name=name,
                                                     method_node=sym.node)
