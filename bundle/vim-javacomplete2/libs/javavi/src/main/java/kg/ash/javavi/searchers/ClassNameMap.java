package kg.ash.javavi.searchers;

public class ClassNameMap extends JavaClassMap {

    public String javaFile = null;
    public String classFile = null;

    public ClassNameMap(String name) {
        super(name);
    }

    @Override
    public int getType() {
        return JavaClassMap.TYPE_CLASS;
    }

    public void setJavaFile(String javaFile) {
        this.javaFile = javaFile;
    }

    public String getJavaFile() {
        return javaFile;
    }

    public void setClassFile(String classFile) {
        this.classFile = classFile;
    }

    public String getClassFile() {
        return classFile;
    }

    @Override
    public String toString() {
        return String.format("name = %s, type = %d, javaFile = %s, classFile = %s", name, getType(),
            javaFile, classFile);
    }
}
