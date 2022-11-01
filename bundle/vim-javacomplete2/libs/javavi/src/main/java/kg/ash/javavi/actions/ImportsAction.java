package kg.ash.javavi.actions;

import com.github.javaparser.Range;
import com.github.javaparser.ast.CompilationUnit;

import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

import kg.ash.javavi.readers.source.ClassNamesFetcher;
import kg.ash.javavi.readers.source.CompilationUnitCreator;
import kg.ash.javavi.readers.source.CompilationUnitResult;

public abstract class ImportsAction implements Action {

    protected Set<String> classnames;
    protected Set<String> declarations;
    protected CompilationUnit compilationUnit;

    @Override
    public String perform(String[] args) {
        try {
            String base64Content = getContent(args);
            String content = new String(
                    Base64.getDecoder().decode(base64Content), "UTF-8");

            CompilationUnitResult compilationUnitResult = 
                CompilationUnitCreator.createFromContent(content);
            if (compilationUnitResult == null) {
                return "Couldn't parse file";
            } else if (compilationUnitResult.getProblems() != null) {
                StringBuilder result = 
                    new StringBuilder("{'parse-problems':[");
                Set<Range> ranges = new HashSet<>();
                compilationUnitResult.getProblems().stream().forEach(p -> {
                    p.getLocation().get().getBegin().getRange()
                        .filter(range -> !ranges.contains(range))
                        .ifPresent(range -> {
                            result.append("{'message':'").append(p.getMessage()).append("'");
                            result.append(",'lnum':'")
                                .append(range.begin.line).append("'");
                            result.append(",'col':'")
                                .append(range.begin.column).append("'},");
                            ranges.add(range);
                        });
                });
                return result.append("]}").toString();
            } else {
                compilationUnit = compilationUnitResult.getCompilationUnit();
            }

            ClassNamesFetcher classnamesFetcher = 
                new ClassNamesFetcher(compilationUnit);
            classnames = classnamesFetcher.getNames();
            declarations = classnamesFetcher.getDeclarationList();

            return action();
        } catch (UnsupportedEncodingException ex) {
            return ex.getMessage();
        }
    }

    private String getContent(String[] args) {
        for (int i = 0; i < args.length; i++) {
            if (args[i].equals("-content")) {
                return args[i + 1];
            }
        }
        return "";
    }

    public abstract String action();
}
