package kg.ash.javavi.actions;

import com.github.javaparser.ast.ImportDeclaration;
import com.github.javaparser.ast.Node;
import com.github.javaparser.printer.PrettyPrinter;
import com.github.javaparser.printer.PrettyPrinterConfiguration;
import kg.ash.javavi.clazz.ClassImport;

import java.util.ArrayList;
import java.util.List;

public class GetMissingImportsAction extends ImportsAction {

    // TODO(joshleeb): Move this somewhere nice.
    private static String removeComments(Node n) {
        PrettyPrinterConfiguration config = new PrettyPrinterConfiguration();
        config.setPrintComments(false);
        return new PrettyPrinter(config).print(n);
    }

    @Override
    public String action() {
        List<String> importTails = new ArrayList<>();
        List<String> asteriskImports = new ArrayList<>();
        if (compilationUnit.getImports() != null) {
            for (ImportDeclaration importDeclaration : 
                    compilationUnit.getImports()) {
                ClassImport classImport = new ClassImport(
                    removeComments(
                        importDeclaration.getName()), 
                    importDeclaration.isStatic(),
                    importDeclaration.isAsterisk());
                if (classImport.isAsterisk()) {
                    asteriskImports.add(classImport.getName());
                } else {
                    importTails.add(classImport.getTail());
                }
            }
        }

        if (compilationUnit.getPackageDeclaration().isPresent()) {
            asteriskImports.add(
                removeComments(
                    compilationUnit.getPackageDeclaration().
                    get().getName()));
        }

        StringBuilder result = new StringBuilder("{'imports':[");
        for (String classname : classnames) {
            if (!importTails.contains(classname)) {
                GetClassPackagesAction getPackagesAction = 
                    new GetClassPackagesAction();
                String packages = getPackagesAction.perform(
                        new String[] { classname });

                if (packages.startsWith("message:")) {
                    return packages;
                } else if (packages.length() == 2) {
                    continue;
                }

                String[] splitted = packages.substring(
                        1, packages.length() - 1).split(",");
                boolean found = false;
                for (String foundPackage : splitted) {
                    if (foundPackage.trim().isEmpty()) {
                        continue;
                    }

                    for (String asteriskImport : asteriskImports) {
                        if (isolatePackage(foundPackage)
                                .equals(asteriskImport)) {
                            found = true;
                            break;
                        }
                    }
                }
                if (!found) {
                    if (declarations.contains(classname)) {
                        found = true;
                    }
                }
                if (!found) {
                    result.append(packages).append(",");
                }
            }
        }
        return result.append("]}").toString();
    }

    private static String isolatePackage(String pkg) {
        pkg = pkg.trim().substring(1, pkg.length() - 1);
        return pkg.substring(0, pkg.lastIndexOf("."));
    }
}
