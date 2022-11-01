package kg.ash.javavi.searchers;

public class PackageNameMap extends JavaClassMap {

    public PackageNameMap(String name) {
        super(name);
    }

    @Override
    public int getType() {
        return JavaClassMap.TYPE_SUBPACKAGE;
    }
}
