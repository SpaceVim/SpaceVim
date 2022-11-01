package kg.ash.javavi.readers.source;

import com.github.javaparser.Problem;
import com.github.javaparser.ast.CompilationUnit;

import java.util.List;

public class CompilationUnitResult {

    private CompilationUnit compilationUnit;
    private List<Problem> problems;

    public CompilationUnitResult(CompilationUnit compilationUnit) {
        this.compilationUnit = compilationUnit;
    }

    public CompilationUnitResult(List<Problem> problems) {
        this.problems = problems;
    }

    public CompilationUnit getCompilationUnit() {
        return compilationUnit;
    }

    public void setCompilationUnit(CompilationUnit compilationUnit) {
        this.compilationUnit = compilationUnit;
    }

    public List<Problem> getProblems() {
        return problems;
    }

    public void setProblems(List<Problem> problems) {
        this.problems = problems;
    }
}
