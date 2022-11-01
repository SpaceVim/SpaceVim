package kg.ash.javavi.clazz;

public class CodeRegion {

    private int beginLine = -1;
    private int beginColumn = -1;
    private int endLine = -1;
    private int endColumn = -1;

    public CodeRegion() {
    }

    public CodeRegion(int beginLine, int beginColumn, int endLine, int endColumn) {
        this.beginLine = beginLine;
        this.beginColumn = beginColumn;
        this.endLine = endLine;
        this.endColumn = endColumn;
    }

    public int getBeginLine() {
        return beginLine;
    }

    public int getBeginColumn() {
        return beginColumn;
    }

    public int getEndLine() {
        return endLine;
    }

    public int getEndColumn() {
        return endColumn;
    }

}
