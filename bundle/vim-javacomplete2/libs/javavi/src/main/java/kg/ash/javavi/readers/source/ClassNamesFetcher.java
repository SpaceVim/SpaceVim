package kg.ash.javavi.readers.source;

import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.ImportDeclaration;
import com.github.javaparser.ast.Node;
import com.github.javaparser.ast.body.ClassOrInterfaceDeclaration;
import com.github.javaparser.ast.body.ConstructorDeclaration;
import com.github.javaparser.ast.body.FieldDeclaration;
import com.github.javaparser.ast.body.MethodDeclaration;
import com.github.javaparser.ast.body.Parameter;
import com.github.javaparser.ast.expr.AnnotationExpr;
import com.github.javaparser.ast.expr.Expression;
import com.github.javaparser.ast.expr.FieldAccessExpr;
import com.github.javaparser.ast.expr.MethodCallExpr;
import com.github.javaparser.ast.expr.Name;
import com.github.javaparser.ast.expr.NameExpr;
import com.github.javaparser.ast.stmt.BlockStmt;
import com.github.javaparser.ast.type.ClassOrInterfaceType;
import com.github.javaparser.ast.type.Type;
import com.github.javaparser.ast.type.UnionType;
import com.github.javaparser.ast.visitor.TreeVisitor;
import com.github.javaparser.ast.visitor.VoidVisitorAdapter;
import com.github.javaparser.printer.PrettyPrinterConfiguration;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ClassNamesFetcher {

    private final CompilationUnit compilationUnit;
    private final Set<String> resultList = new HashSet<>();
    private final Set<String> declarationList = new HashSet<>();
    private List<String> staticImportsList = new ArrayList<>();

    public static PrettyPrinterConfiguration withoutComments() {
        PrettyPrinterConfiguration pp = new PrettyPrinterConfiguration();
        pp.setPrintComments(false);
        return pp;
    }

    public ClassNamesFetcher(CompilationUnit compilationUnit) {
        this.compilationUnit = compilationUnit;
        for (ImportDeclaration id : compilationUnit.getImports()) {
            if (id.isStatic()) {
                String name = id.getName().toString();
                staticImportsList.add(
                        name.substring(
                            name.lastIndexOf(".") + 1, name.length()));
            }
        }
    }

    @SuppressWarnings("unchecked")
    public Set<String> getNames() {
        List<VoidVisitorAdapter> adapters = new ArrayList<>();
        adapters.add(new ClassTypeVisitor());
        adapters.add(new TypesVisitor());
        adapters.add(new AnnotationsVisitor());
        adapters.forEach(a -> a.visit(compilationUnit, null));

        return resultList;
    }

    public Set<String> getDeclarationList() {
        if (resultList.isEmpty()) {
            getNames();
        }
        return declarationList;
    }

    private class ClassTypeVisitor extends VoidVisitorAdapter<Object> {

        @Override
        public void visit(ClassOrInterfaceDeclaration type, Object arg) {
            new DeepVisitor(this, arg).visitBreadthFirst(type);
            if (type.getAnnotations() != null) {
                for (AnnotationExpr expr : type.getAnnotations()) {
                    resultList.add(expr.getNameAsString());
                    List<Node> children = expr.getChildNodes();
                    for (Node node : children.subList(1, children.size())) {
                        new DeepVisitor(this, arg).visitBreadthFirst(node);
                    }
                }
            }
        }
    }

    private class AnnotationsVisitor extends VoidVisitorAdapter<Object> {

        private void addAnnotations(
                List<AnnotationExpr> annotations, Object arg) {
            if (annotations != null) {
                for (AnnotationExpr expr : annotations) {
                    resultList.add(expr.getNameAsString());
                    List<Node> children = expr.getChildNodes();
                    for (Node node : children.subList(1, children.size())) {
                        new DeepVisitor(this, arg).visitBreadthFirst(node);
                    }
                }
            }
        }

        @Override
        public void visit(ConstructorDeclaration type, Object arg) {
            addAnnotations(type.getAnnotations(), arg);
        }

        @Override
        public void visit(FieldDeclaration type, Object arg) {
            addAnnotations(type.getAnnotations(), arg);
        }

        @Override
        public void visit(MethodDeclaration type, Object arg) {
            addAnnotations(type.getAnnotations(), arg);
            if (type.getParameters() != null) {
                for (Parameter param : type.getParameters()) {
                    addAnnotations(param.getAnnotations(), arg);
                }
            }

            if (type.getThrownExceptions() != null) {
                for (Type expr : type.getThrownExceptions()) {
                    resultList.add(expr.toString(withoutComments()));
                }
            }
        }
    }

    private class TypesVisitor extends VoidVisitorAdapter<Object> {

        @Override
        public void visit(BlockStmt type, Object arg) {
            new DeepVisitor(this, arg).visitBreadthFirst(type);
        }

        @Override
        public void visit(FieldAccessExpr type, Object arg) {
            addStatic(type);
        }

        @Override
        public void visit(MethodCallExpr type, Object arg) {
            addStatic(type);
        }

        private void addStatic(Expression type) {
            if (type.getChildNodes() != null && 
                    type.getChildNodes().size() > 0) {
                String name = type.getChildNodes().
                    get(0).toString(withoutComments());
                if (!name.contains(".")) {
                    resultList.add(name);
                }
            }
        }

        @Override
        public void visit(ClassOrInterfaceType type, Object arg) {
            String name = type.getNameAsString();
            String fullName = type.toString(withoutComments());
            if (!fullName.startsWith(name)) {
                if (!type.getChildNodes().isEmpty()) {
                    name = type.getChildNodes().
                        get(0).toString(withoutComments());
                }
            }
            if (name.contains(".")) {
                name = name.split("\\.")[0];
            }
            resultList.add(name);
            if (type.getTypeArguments().isPresent()) {
                for (Type t : type.getTypeArguments().get()) {
                    String typeName = t.toString(withoutComments());
                    if (typeName.contains(".")) {
                        typeName = typeName.split("\\.")[0];
                    }
                    resultList.add(typeName);
                }
            }
        }
    }

    private class DeepVisitor extends TreeVisitor {

        private VoidVisitorAdapter<Object> adapter;
        private Object arg;

        public DeepVisitor(VoidVisitorAdapter<Object> adapter, Object arg) {
            this.adapter = adapter;
            this.arg = arg;
        }

        public void process(Node node) {
            if (node instanceof ClassOrInterfaceType) {
                adapter.visit((ClassOrInterfaceType) node, arg);
            } else if (node instanceof UnionType) {
                ((UnionType) node).getElements()
                    .forEach(
                            t -> resultList.add(
                                t.toString(withoutComments())));
            } else if (node instanceof MethodCallExpr) {
                MethodCallExpr methodCall = ((MethodCallExpr) node);
                String name = methodCall.getNameAsString();
                if (staticImportsList.contains(name)) {
                    resultList.add(name);
                }
            } else if (node instanceof NameExpr) {
                // javaparser has no difference on 'method call' expression,
                // so class name with static method call look the same as
                // object method call. that's why we check here for usual
                // class name type with upper case letter at the beginning.
                // it can miss some unusual class names with lower case at
                // the beginning.
                NameExpr nameExpr = (NameExpr) node;
                String parent = "";
                if (nameExpr.getParentNode().isPresent()) {
                    parent = nameExpr.getParentNode().
                        get().toString(withoutComments());
                }
                String name = nameExpr.getNameAsString();
                if (name != null) {
                    if (!parent.startsWith("@") && 
                            !parent.equals(name) && 
                            parent.endsWith(name)) {
                        return;
                    }

                    if (name.matches("^[A-Z][A-Za-z0-9_]*")) {
                        resultList.add(name);
                    }
                }
            } else if (node instanceof Name) {
                String name = node.toString(withoutComments());

                if (name.matches("^[A-Z][A-Za-z0-9_]*")) {
                    resultList.add(name);
                }
            } else if (node instanceof ClassOrInterfaceDeclaration) {
                ClassOrInterfaceDeclaration declaration = 
                    (ClassOrInterfaceDeclaration) node;
                declarationList.add(
                        declaration.getName().toString(
                            withoutComments()));
            }
        }
    }
}
