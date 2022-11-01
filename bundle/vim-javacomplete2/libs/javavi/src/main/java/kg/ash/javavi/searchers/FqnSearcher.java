package kg.ash.javavi.searchers;

import kg.ash.javavi.TargetParser;
import kg.ash.javavi.clazz.ClassImport;
import kg.ash.javavi.clazz.SourceClass;

import java.util.ArrayList;
import java.util.List;

public class FqnSearcher {

    private String sources;

    public FqnSearcher(String sources) {
        this.sources = sources;
        if (this.sources != null) {
            this.sources = this.sources.replace('\\', '/');
        }
    }

    public String getFqn(SourceClass clazz, String name) {
        TargetParser targetParser = new TargetParser(sources);
        name = targetParser.parse(name);

        List<String> fqns = new ArrayList<>();
        for (ClassImport ci : clazz.getImports()) {
            if (!ci.isAsterisk()) {
                if (ci.getTail().equals(name)) {
                    fqns.add(ci.getName());
                    break;
                }
            } else {
                fqns.add(replaceAsterisk(ci.getName()) + name);
            }
        }

        if (clazz.getPackage() != null) {
            fqns.add(clazz.getPackage().concat(".").concat(name));
        }

        String result = searchForRealClass(fqns);
        if (result == null) {
            result = name;
        }

        return result.concat(searchForTypeArguments(clazz, targetParser.getTypeArguments()));
    }

    private String searchForRealClass(List<String> fqns) {
        ClassSearcher seacher = new ClassSearcher();
        for (String fqn : fqns) {
            if (seacher.find(fqn, sources)) {
                return fqn;
            }
        }

        return null;
    }

    private String searchForTypeArguments(SourceClass clazz, List<String> typeArguments) {
        if (typeArguments.isEmpty()) {
            return "";
        }

        StringBuilder arguments = new StringBuilder("<");
        for (String arg : typeArguments) {
            String fqn = getFqn(clazz, arg);
            arguments.append(fqn).append(",");
        }
        arguments.setCharAt(arguments.length() - 1, '>');

        return arguments.toString();
    }

    private String replaceAsterisk(String asteriskImport) {
        String[] splitted = asteriskImport.split("\\.");
        String importName = "";
        for (String s : splitted) {
            if (!s.equals("*")) {
                importName += s.concat(".");
            }
        }

        return importName;
    }
}
