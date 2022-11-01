package kg.ash.javavi.clazz;

import com.github.javaparser.ast.Modifier;

import java.util.EnumSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;

public class ClassMethod {

    private String name;
    private EnumSet<Modifier> modifiers;
    private String declaration;
    private String typeName;
    private List<ClassTypeParameter> typeParameters = new LinkedList<>();
    private boolean deprecated = false;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setModifiers(EnumSet<Modifier> modifiers) {
        this.modifiers = modifiers;
    }

    public EnumSet<Modifier> getModifiers() {
        return modifiers;
    }

    public void setDeclaration(String declaration) {
        this.declaration = declaration;
    }

    public String getDeclaration() {
        return declaration;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getTypeName() {
        return typeName;
    }

    public void addTypeParameter(ClassTypeParameter typeParameter) {
        typeParameters.add(typeParameter);
    }

    public List<ClassTypeParameter> getTypeParameters() {
        return typeParameters;
    }

    public void setDeprecated(boolean deprecated) {
        this.deprecated = deprecated;
    }

    public boolean getDeprecated() {
        return deprecated;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }

        final ClassMethod other = (ClassMethod) obj;
        if (!Objects.equals(this.name, other.name) && (this.name == null || !this.name.equals(
            other.name))) {
            return false;
        }
        if (!Objects.equals(this.typeName, other.typeName) && (this.typeName == null
            || !this.typeName.equals(other.typeName))) {
            return false;
        }
        return this.declaration == other.declaration || (this.declaration != null
            && this.declaration.equals(other.declaration));
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 17 * hash + (this.name != null ? this.name.hashCode() : 0);
        hash = 17 * hash + (this.typeName != null ? this.typeName.hashCode() : 0);
        hash = 17 * hash + (this.declaration != null ? this.declaration.hashCode() : 0);
        return hash;
    }

    @Override
    public String toString() {
        return name;
    }
}
