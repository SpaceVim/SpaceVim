package kg.ash.javavi.readers;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;

public class FileClassLoader extends ClassLoader {

    private String classFile;

    public FileClassLoader(ClassLoader parent, String classFile) {
        super(parent);
        this.classFile = classFile;
    }

    // TODO: Handle throwables.
    public Class loadClass(String name) {
        try {
            if (name.startsWith("java.")) {
                return Class.forName(name);
            }

            File file = new File(classFile);
            if (file.exists()) {
                FileInputStream fileInputStream = new FileInputStream(file);
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                int data = fileInputStream.read();

                while (data != -1) {
                    buffer.write(data);
                    data = fileInputStream.read();
                }

                fileInputStream.close();

                byte[] classData = buffer.toByteArray();
                return defineClass(name, classData, 0, classData.length);
            }
        } catch (Throwable t) {
            try {
                return Class.forName(name);
            } catch (Throwable t2) {
            }
        }

        return null;
    }
}
