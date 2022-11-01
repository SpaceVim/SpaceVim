package kg.ash.javavi.readers;

import com.github.javaparser.Position;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.ImportDeclaration;
import com.github.javaparser.ast.Modifier;
import com.github.javaparser.ast.Node;
import com.github.javaparser.ast.NodeList;
import com.github.javaparser.ast.PackageDeclaration;
import com.github.javaparser.ast.body.ClassOrInterfaceDeclaration;
import com.github.javaparser.ast.body.ConstructorDeclaration;
import com.github.javaparser.ast.body.FieldDeclaration;
import com.github.javaparser.ast.body.MethodDeclaration;
import com.github.javaparser.ast.body.Parameter;
import com.github.javaparser.ast.body.VariableDeclarator;
import com.github.javaparser.ast.type.ClassOrInterfaceType;
import com.github.javaparser.ast.type.TypeParameter;
import com.github.javaparser.ast.visitor.VoidVisitorAdapter;

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;

import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;

import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.clazz.ClassConstructor;
import kg.ash.javavi.clazz.ClassField;
import kg.ash.javavi.clazz.ClassImport;
import kg.ash.javavi.clazz.ClassMethod;
import kg.ash.javavi.clazz.ClassTypeParameter;
import kg.ash.javavi.clazz.SourceClass;
import kg.ash.javavi.readers.source.ClassNamesFetcher;
import kg.ash.javavi.readers.source.CompilationUnitCreator;
import kg.ash.javavi.readers.source.CompilationUnitResult;
import kg.ash.javavi.searchers.ClassSearcher;
import kg.ash.javavi.searchers.FqnSearcher;

public class Parser implements ClassReader {

    public static final Logger logger = LogManager.getLogger();

    private String sources;
    private String sourceFile = null;
    private String sourceContent = null;
    private ClassOrInterfaceDeclaration parentClass = null;

    public Parser(String sources) {
        this.sources = sources.replace('\\', '/');
    }

    public Parser(String sources, String sourceFile) {
        this.sources = sources.replace('\\', '/');
        this.sourceFile = sourceFile.replace('\\', '/');
    }

    public void setSourceContent(String sourceContent) {
        this.sourceContent = sourceContent;
    }

    @Override
    public ClassReader setTypeArguments(List<String> typeArguments) {
        // Not supported yet.
        return this;
    }

    @Override
    public ClassReader addKnown(List list) {
        return this;
    }

    @Override
    public SourceClass read(String targetClass) {
        if ((sourceFile == null || sourceFile.isEmpty())
                && (sourceContent == null || sourceContent.isEmpty())) {
            return null;
        }

        logger.debug("read class from sources: {}", targetClass);

        if (targetClass.contains("$")) {
            targetClass = targetClass.split("\\$")[0];
        }

        if (Cache.getInstance().getClasses().containsKey(targetClass)) {
            return Cache.getInstance().getClasses().get(targetClass);
        }

        CompilationUnitResult cur = sourceFile != null
            ? CompilationUnitCreator.createFromFile(sourceFile)
            : CompilationUnitCreator.createFromContent(sourceContent);

        CompilationUnit cu;
        if (cur == null) {
            return null;
        } else if (cur.getProblems() != null) {
            return null;
        } else {
            cu = cur.getCompilationUnit();
        }

        SourceClass clazz = new SourceClass();
        Cache.getInstance().getClasses().put(targetClass, clazz);

        Optional<PackageDeclaration> packageDeclaration =
            cu.getPackageDeclaration();
        if (packageDeclaration.isPresent()) {
            clazz.setPackage(packageDeclaration.get().getNameAsString());
        }

        Optional<Position> beginning = cu.getBegin();
        Optional<Position> ending = cu.getEnd();
        if (beginning.isPresent() && ending.isPresent()) {
            clazz.setRegion(
                    beginning.get().line,
                    beginning.get().column,
                    ending.get().line,
                    ending.get().column);
        }

        if (cu.getImports() != null) {
            for (ImportDeclaration id : cu.getImports()) {
                clazz.addImport(
                    new ClassImport(
                        id.getName().toString(),
                        id.isStatic(),
                        id.isAsterisk()));
            }
        }

        ClassOrInterfaceVisitor coiVisitor =
            new ClassOrInterfaceVisitor(clazz);
        coiVisitor.visit(cu, null);
        clazz = coiVisitor.getClazz();

        ClassVisitor visitor = new ClassVisitor(clazz);
        visitChildren(parentClass.getChildNodes(), visitor);
        clazz = visitor.getClazz();

        List<String> impls = new ArrayList<>();
        if (clazz.getSuperclass() != null) {
            impls.add(clazz.getSuperclass());
        }

        impls.addAll(clazz.getInterfaces());
        for (String impl : impls) {
            ClassSearcher seacher = new ClassSearcher();
            if (seacher.find(impl, sources)) {
                SourceClass implClass = seacher.getReader().read(impl);
                if (implClass != null) {
                    clazz.addLinkedClass(implClass);
                    for (ClassConstructor c : implClass.getConstructors()) {

                        if (implClass.getName().equals("java.lang.Object")) {
                            continue;
                        }
                        c.setDeclaration(
                            c.getDeclaration().replace(
                                implClass.getName(), clazz.getName()));
                        c.setDeclaration(c.getDeclaration()
                            .replace(
                                implClass.getSimpleName(),
                                clazz.getSimpleName()));
                        clazz.addConstructor(c);
                    }
                    for (ClassMethod method : implClass.getMethods()) {
                        clazz.addMethod(method);
                    }
                    for (ClassField field : implClass.getFields()) {
                        clazz.addField(field);
                    }
                }
            }
        }

        return clazz;
    }

    private void visitChildren(List<Node> nodes, ClassVisitor visitor) {
        for (Node n : nodes) {
            if (n instanceof FieldDeclaration) {
                visitor.visit((FieldDeclaration) n, null);
            } else if (n instanceof MethodDeclaration) {
                visitor.visit((MethodDeclaration) n, null);
            } else if (n instanceof ConstructorDeclaration) {
                visitor.visit((ConstructorDeclaration) n, null);
            } else if (n instanceof ClassOrInterfaceDeclaration) {
                visitor.visit((ClassOrInterfaceDeclaration) n, null);
            }
        }
    }

    public void setExtendedAndInterfaceTypes(
            SourceClass clazz, ClassOrInterfaceDeclaration n) {
        NodeList<ClassOrInterfaceType> extendedTypes = n.getExtendedTypes();
        if (extendedTypes != null && extendedTypes.size() > 0) {
            String className = extendedTypes.get(0).getNameAsString();
            clazz.setSuperclass(
                    new FqnSearcher(sources).getFqn(clazz, className));
        } else {
            clazz.setSuperclass("java.lang.Object");
            addConstructorIfNotEmpty(clazz);
        }

        NodeList<ClassOrInterfaceType> implementedTypes =
            n.getImplementedTypes();
        if (implementedTypes != null) {
            for (ClassOrInterfaceType iface : implementedTypes) {
                clazz.addInterface(
                        new FqnSearcher(sources).getFqn(
                            clazz, iface.getNameAsString()));
            }
        }
    }

    private class ClassOrInterfaceVisitor extends VoidVisitorAdapter<Object> {

        private SourceClass clazz;

        public ClassOrInterfaceVisitor(SourceClass clazz) {
            this.clazz = clazz;
        }

        public SourceClass getClazz() {
            return clazz;
        }

        @Override
        public void visit(ClassOrInterfaceDeclaration n, Object arg) {
            parentClass = n;
            clazz.setName(n.getNameAsString());
            clazz.setModifiers(n.getModifiers());
            clazz.setIsInterface(n.isInterface());

            Optional<Position> beginning = n.getBegin();
            Optional<Position> ending = n.getEnd();
            if (beginning.isPresent() && ending.isPresent()) {
                clazz.setRegion(
                        beginning.get().line,
                        beginning.get().column,
                        ending.get().line,
                        ending.get().column);
            }

            setExtendedAndInterfaceTypes(clazz, n);
        }
    }

    private void addConstructorIfNotEmpty(SourceClass clazz) {
        if (clazz.getConstructors().isEmpty()) {
            ClassConstructor ctor = new ClassConstructor();
            ctor.setDeclaration(
                    String.format("public %s()", clazz.getName()));
            ctor.setModifiers(EnumSet.of(Modifier.PUBLIC));
            clazz.addConstructor(ctor);
        }
    }

    private class ClassVisitor extends VoidVisitorAdapter<Object> {

        private SourceClass clazz;

        public ClassVisitor(SourceClass clazz) {
            this.clazz = clazz;
        }

        public SourceClass getClazz() {
            return clazz;
        }

        @Override
        public void visit(ConstructorDeclaration n, Object arg) {
            ClassConstructor constructor = new ClassConstructor();
            constructor.setDeclaration(n.getDeclarationAsString());
            constructor.setModifiers(n.getModifiers());
            if (n.getTypeParameters() != null) {
                for (TypeParameter parameter : n.getTypeParameters()) {
                    constructor.addTypeParameter(
                        new ClassTypeParameter(parameter.getNameAsString()));
                }
            }
            clazz.addConstructor(constructor);
        }

        @Override
        public void visit(MethodDeclaration n, Object arg) {
            ClassMethod method = new ClassMethod();
            method.setName(n.getNameAsString());
            method.setModifiers(n.getModifiers());
            method.setDeclaration(n.getDeclarationAsString());

            n.getAnnotationByClass(Deprecated.class)
                .ifPresent(c -> method.setDeprecated(true));

            String className = n.getType().toString();
            method.setTypeName(
                    new FqnSearcher(sources).getFqn(clazz, className));

            if (n.getTypeParameters() != null) {
                for (TypeParameter parameter : n.getTypeParameters()) {
                    method.addTypeParameter(
                            new ClassTypeParameter(
                                parameter.getNameAsString()));
                }
            }

            if (n.getParameters() != null) {
                for (Parameter parameter : n.getParameters()) {
                    method.addTypeParameter(
                            new ClassTypeParameter(
                                parameter.getType().toString(
                                    ClassNamesFetcher.withoutComments())));
                }
            }
            clazz.addMethod(method);
        }

        @Override
        public void visit(FieldDeclaration n, Object arg) {
            for (VariableDeclarator v : n.getVariables()) {
                ClassField field = new ClassField();
                field.setName(v.getNameAsString());
                field.setModifiers(n.getModifiers());

                String className = n.getElementType().asString();
                field.setTypeName(
                        new FqnSearcher(sources).getFqn(clazz, className));

                clazz.addField(field);
            }
        }

        @Override
        public void visit(ClassOrInterfaceDeclaration n, Object arg) {
            SourceClass clazz = new SourceClass();
            clazz.setName(this.clazz.getSimpleName() + "$" + n.getName());
            clazz.setModifiers(n.getModifiers());
            clazz.setIsInterface(n.isInterface());

            Optional<Position> beginning = n.getBegin();
            Optional<Position> ending = n.getEnd();
            if (beginning.isPresent() && ending.isPresent()) {
                clazz.setRegion(
                        beginning.get().line,
                        beginning.get().column,
                        ending.get().line,
                        ending.get().column);
            }

            setExtendedAndInterfaceTypes(clazz, n);

            clazz.setPackage(this.clazz.getPackage());

            ClassVisitor visitor = new ClassVisitor(clazz);
            visitChildren(n.getChildNodes(), visitor);
            this.clazz.addNestedClass(clazz.getName());
            this.clazz.addLinkedClass(clazz);

            Cache.getInstance().getClasses().put(clazz.getName(), clazz);
        }

    }
}
