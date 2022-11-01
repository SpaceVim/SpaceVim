package kg.ash.javavi.output;

import kg.ash.javavi.Javavi;
import kg.ash.javavi.clazz.ClassConstructor;
import kg.ash.javavi.clazz.ClassField;
import kg.ash.javavi.clazz.ClassMethod;
import kg.ash.javavi.clazz.ClassTypeParameter;
import kg.ash.javavi.clazz.SourceClass;
import kg.ash.javavi.readers.Reflection;

import java.util.HashMap;
import java.util.List;

public class OutputClassInfo {

    public static final String KEY_NAME = "'n':";
    public static final String KEY_TYPE = "'t':";
    public static final String KEY_MODIFIER = "'m':";
    public static final String KEY_PARAMETERTYPES = "'p':";
    public static final String KEY_RETURNTYPE = "'r':";
    public static final String KEY_DESCRIPTION = "'d':";
    public static final String KEY_DECLARING_CLASS = "'c':";

    public String get(SourceClass clazz) {
        HashMap<String, String> classMap = new HashMap<>();
        putClassInfo(classMap, clazz);

        StringBuilder sb = new StringBuilder();
        if (classMap.size() > 0) {
            sb.append("{");
            for (String s : classMap.keySet()) {
                sb.append("'").append(s).append("':")
                    .append(classMap.get(s)).append(",");
            }
            sb.append("}");
        }

        return sb.toString();
    }

    private void putClassInfo(
            HashMap<String, String> map, SourceClass clazz) {
        if (clazz == null || map.containsKey(clazz.getName())) {
            return;
        }

        StringBuilder sb = init(clazz);
        isIntefaceOrClass(sb, clazz);
        hasNested(sb, clazz);
        hasConstructors(sb, clazz);
        hasFields(sb, clazz);
        hasMethods(sb, clazz);
        finish(sb, clazz, map);
    }

    private StringBuilder init(SourceClass clazz) {
        StringBuilder sb = new StringBuilder();
        sb.append("{")
            .append("'tag':'CLASSDEF',")
            .append(Javavi.NEWLINE)
            .append("'flags':'")
            .append(Integer.toString(
                        Reflection.EnumSetModifierToInt(
                            clazz.getModifiers()), 2))
            .append("',")
            .append(Javavi.NEWLINE)
            .append("'name':'")
            .append(clazz.getName())
            .append("',")
            .append(Javavi.NEWLINE)
            .append("'classpath':'1',")
            .append(Javavi.NEWLINE)
            .append("'pos':[")
            .append(clazz.getRegion().getBeginLine())
            .append(",")
            .append(clazz.getRegion().getBeginColumn())
            .append("],")
            .append("'endpos':[")
            .append(clazz.getRegion().getEndLine())
            .append(",")
            .append(clazz.getRegion().getEndColumn())
            .append("],")
            .append("'fqn':'")
            .append(clazz.getName())
            .append("',")
            .append(Javavi.NEWLINE);

        return sb;
    }

    private void isIntefaceOrClass(StringBuilder sb, SourceClass clazz) {
        if (clazz.isInterface()) {
            sb.append("'interface':'1','extends':[");
        } else {
            String superclass = clazz.getSuperclass();
            if (superclass != null 
                    && !"java.lang.Object".equals(superclass)) {
                sb.append("'extends':['").append(superclass)
                    .append("'],").append(Javavi.NEWLINE);
            }
            sb.append("'implements':[");
        }

        clazz.getInterfaces().forEach(
                iface -> sb.append("'").append(iface).append("',"));
        sb.append("],").append(Javavi.NEWLINE);
    }

    private void hasNested(StringBuilder sb, SourceClass clazz) {
        sb.append("'nested':[");
        clazz.getNestedClasses().forEach(
                nested -> sb.append("'").append(nested).append("',"));
        sb.append("],").append(Javavi.NEWLINE);
    }

    private void hasConstructors(StringBuilder sb, SourceClass clazz) {
        sb.append("'ctors':[");
        for (ClassConstructor ctor : clazz.getConstructors()) {
            sb.append("{");

            appendModifier(sb, 
                    Reflection.EnumSetModifierToInt(
                        ctor.getModifiers()));
            appendParameterTypes(sb, ctor.getTypeParameters());

            sb.append(KEY_DESCRIPTION).append("'")
                .append(ctor.getDeclaration()).append("'");

            sb.append("},").append(Javavi.NEWLINE);
        }

        sb.append("],").append(Javavi.NEWLINE);
    }


    private void hasFields(StringBuilder sb, SourceClass clazz) {
        sb.append("'fields':[");
        for (ClassField field : clazz.getFields()) {
            sb.append("{");
            sb.append(KEY_NAME).append("'")
                .append(field.getName()).append("',");

            if (!field.getTypeName().equals(clazz.getName())) {
                sb.append(KEY_DECLARING_CLASS).append("'")
                    .append(field.getTypeName()).append("',");
            }

            appendModifier(sb, Reflection.EnumSetModifierToInt(
                        field.getModifiers()));
            sb.append(KEY_TYPE)
                .append("'")
                .append(field.getTypeName())
                .append("'")
                .append("},")
                .append(Javavi.NEWLINE);
        }

        sb.append("],").append(Javavi.NEWLINE);
    }

    private void hasMethods(StringBuilder sb, SourceClass clazz) {
        sb.append("'methods':[");
        for (ClassMethod method : clazz.getMethods()) {
            sb.append("{");

            sb.append(KEY_NAME).append("'")
                .append(method.getName()).append("',");

            if (!method.getTypeName().equals(clazz.getName())) {
                sb.append(KEY_DECLARING_CLASS)
                    .append("'")
                    .append(method.getTypeName())
                    .append("',");
            }

            appendModifier(sb, Reflection.EnumSetModifierToInt(
                        method.getModifiers()));

            sb.append(KEY_RETURNTYPE).append("'")
                .append(method.getTypeName()).append("',");

            appendParameterTypes(sb, method.getTypeParameters());

            sb.append(KEY_DESCRIPTION)
                .append("'");
            if (method.getDeprecated()) {
                sb.append("@Deprecated ");
            }
            sb.append(method.getDeclaration())
                .append("'")
                .append("},")
                .append(Javavi.NEWLINE);
        }
        sb.append("],").append(Javavi.NEWLINE);
    }

    private void finish(
            StringBuilder sb, SourceClass clazz,
            HashMap<String, String> map) {

        sb.append("}");

        map.put(clazz.getName(), sb.toString());

        for (SourceClass sourceClass : clazz.getLinkedClasses()) {
            putClassInfo(map, sourceClass);
        }
    }

    private void appendModifier(StringBuilder sb, int modifier) {
        sb.append(KEY_MODIFIER).append("'")
            .append(Integer.toString(modifier, 2)).append("',");
    }

    private void appendParameterTypes(
            StringBuilder sb, List<ClassTypeParameter> paramTypes) {
        if (paramTypes == null || paramTypes.isEmpty()) {
            return;
        }

        sb.append(KEY_PARAMETERTYPES).append("[");

        paramTypes.forEach(
                parameter -> sb.append("'").append(
                    parameter.getName()).append("',"));

        sb.append("],");
    }
}
