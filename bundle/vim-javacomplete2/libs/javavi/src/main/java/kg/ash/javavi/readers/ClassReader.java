package kg.ash.javavi.readers;

import kg.ash.javavi.clazz.SourceClass;

import java.util.List;

public interface ClassReader {
    SourceClass read(String fqn);

    ClassReader setTypeArguments(List<String> typeArguments);

    ClassReader addKnown(List knownClasses);
}
