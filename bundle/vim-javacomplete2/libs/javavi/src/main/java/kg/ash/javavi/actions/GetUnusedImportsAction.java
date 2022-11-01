package kg.ash.javavi.actions;

import com.github.javaparser.ast.ImportDeclaration;
import com.github.javaparser.ast.Node;
import com.github.javaparser.printer.PrettyPrinter;
import com.github.javaparser.printer.PrettyPrinterConfiguration;
import kg.ash.javavi.clazz.ClassImport;

public class GetUnusedImportsAction extends ImportsAction {

    @Override
    public String action() {
        StringBuilder result = new StringBuilder("{'imports':[");
        for (ImportDeclaration importDeclaration : 
                compilationUnit.getImports()) {
            if (importDeclaration.isAsterisk()) {
                continue;
            }

            ClassImport classImport = new ClassImport(
                    removeComments(importDeclaration.getName()),
                importDeclaration.isStatic(), 
                importDeclaration.isAsterisk());

            String classname = classImport.getTail();
            if (!classnames.contains(classname)) {
                result.append("'")
                    .append(classImport.getHead())
                    .append(classImport.isStatic() ? "$" : ".")
                    .append(classname)
                    .append("',");
            }
        }
        return result.append("]}").toString();
    }

    private static String removeComments(Node n) {
        PrettyPrinterConfiguration config = 
            new PrettyPrinterConfiguration();
        config.setPrintComments(false);
        return new PrettyPrinter(config).print(n);
    }
}
