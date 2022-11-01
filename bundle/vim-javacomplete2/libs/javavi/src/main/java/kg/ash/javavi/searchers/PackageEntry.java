package kg.ash.javavi.searchers;

public class PackageEntry {

    public final static int FILETYPE_JAVA = 0;
    public final static int FILETYPE_CLASS = 1;

    private String entry;
    private int source;
    private String javaFile = null;
    private String classFile = null;
    private String archiveName = null;

    public PackageEntry(String entry, int source) {
        this.entry = entry;
        this.source = source;
    }

    public PackageEntry(String entry, int source, String archiveName) {
        this.entry = entry;
        this.source = source;
        this.archiveName = archiveName;
    }

    public PackageEntry(String entry, int source, String filePath, int fileType) {
        this.entry = entry;
        this.source = source;
        if (fileType == FILETYPE_JAVA) {
            this.javaFile = filePath;
        } else {
            this.classFile = filePath;
        }
    }

    public String getEntry() {
        return entry;
    }

    public int getSource() {
        return source;
    }

    public String getJavaFile() {
        return javaFile;
    }

    public String getClassFile() {
        return classFile;
    }

    public String getArchiveName() {
        return archiveName;
    }

    @Override
    public String toString() {
        return String.format("{%s, %d, %s, %s}", entry, source, javaFile, classFile);
    }

}
