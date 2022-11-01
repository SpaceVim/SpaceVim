package kg.ash.javavi.searchers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;
import java.util.zip.ZipFile;

import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;

public class ClasspathPackageSearcher implements PackageSeacherIFace {

    public static final Logger logger = LogManager.getLogger();

    public List<PackageEntry> loadEntries() {
        List<PackageEntry> result = new ArrayList<>();

        List<String> knownPaths = new ArrayList<>();
        new ClasspathCollector().collectClassPath()
            .stream()
            .forEach(filePath -> {
                if (filePath.toLowerCase().endsWith(".class")) {
                    String path = filePath.substring(
                            0, filePath.length() - 6)
                        .replaceAll("/", ".");
                    String newPath = path.substring(
                            0, path.lastIndexOf("."));
                    String fileName = path.substring(
                            path.lastIndexOf(".") + 1, path.length());
                    Optional<PackageEntry> kp = knownPaths.parallelStream()
                        .filter(s -> newPath.endsWith(s))
                        .findFirst()
                        .map(p -> p + File.separator + fileName + ".class")
                        .map(p -> new PackageEntry(
                                    p, 
                                    JavaClassMap.SOURCETYPE_CLASSPATH,
                                    filePath,
                                    PackageEntry.FILETYPE_CLASS));
                    if (kp.isPresent()) {
                        result.add(kp.get());
                        return;
                    }

                    String[] split = path.split("\\.");
                    int j = split.length - 2;
                    while (j > 0) {
                        path = "";
                        for (int i = j; i <= split.length - 2; i++) {
                            path += split[i] + ".";
                        }
                        String pkg = getPackageByFile(path + fileName);
                        if (pkg != null) {
                            result.add(
                                    new PackageEntry(
                                        pkg + File.separator + 
                                        fileName + ".class",
                                        JavaClassMap.SOURCETYPE_CLASSPATH,
                                        filePath,
                                        PackageEntry.FILETYPE_CLASS));
                            knownPaths.add(pkg);
                            break;
                        } else {
                            j--;
                        }
                    }
                } else if (filePath.endsWith("classlist")) {
                    try (Stream<String> stream = 
                            Files.lines(Paths.get(filePath))) {
                        stream.forEach(l -> {
                            result.add(
                                    new PackageEntry(l + ".class", 
                                        JavaClassMap.SOURCETYPE_CLASSPATH,
                                        filePath));
                        });
                    } catch (IOException ex) {
                        logger.warn("error read classlist file", ex);
                    }
                } else {
                    try {
                        for (Enumeration entries = 
                                new ZipFile(filePath).entries();
                                entries.hasMoreElements(); ) {
                            String entry = entries.nextElement().toString();
                            if (filePath.endsWith(".jmod") 
                                    && entry.startsWith("classes/")) {
                                entry = entry.substring(8);
                            }
                            result.add(
                                    new PackageEntry(entry, 
                                        JavaClassMap.SOURCETYPE_CLASSPATH,
                                        filePath));
                        }
                    } catch (Exception e) {
                        logger.error(e, e);
                    }
                }
            });

        return result;
    }

    private String getPackageByFile(String path) {
        try {
            Class clazz = Class.forName(path);
            return clazz.getPackage().getName();
        } catch (ExceptionInInitializerError | 
                ClassNotFoundException | 
                NoClassDefFoundError ex) {
            return null;
        }
    }
}
