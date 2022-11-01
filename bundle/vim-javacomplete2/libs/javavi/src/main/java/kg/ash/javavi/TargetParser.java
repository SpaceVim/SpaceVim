package kg.ash.javavi;

import kg.ash.javavi.searchers.ClassSearcher;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TargetParser {

    private final Pattern pattern = Pattern.compile("^(.*?)<(.*)>$");
    private final Pattern extendsPattern = Pattern.compile("^?[\\s]+(super|extends)\\s+(.*)$");
    private final ClassSearcher seacher = new ClassSearcher();

    private final List<String> typeArguments = new ArrayList<>();
    private String sources;

    public TargetParser(String sources) {
        this.sources = sources;
    }

    public String parse(String target) {
        typeArguments.clear();

        Matcher matcher = pattern.matcher(target);
        if (matcher.find()) {
            target = matcher.group(1);
            String ta = markSplits(matcher.group(2));
            for (String arguments : ta.split("<_split_>")) {
                parseArguments(arguments);
            }
        }

        return target;
    }

    private void parseArguments(String arguments) {
        arguments = arguments.replaceAll("(\\(|\\))", "");
        String[] argumentVariants = arguments.split("\\|");
        boolean added = false;
        for (String arg : argumentVariants) {
            Matcher argMatcher = pattern.matcher(arg);
            boolean matchResult = argMatcher.find();
            if (matchResult) {
                arg = argMatcher.group(1);
            }
            String name = getExactName(arg);
            if (seacher.find(name.replaceAll("(\\[|\\])", ""), sources)) {
                if (matchResult && !argMatcher.group(2).equals("?")) {
                    typeArguments.add(String.format("%s<%s>", name, argMatcher.group(2)));
                } else {
                    typeArguments.add(name);
                }
                added = true;
                break;
            }
        }

        if (!added) {
            typeArguments.add("java.lang.Object");
        }
    }

    private String getExactName(String name) {
        Matcher matcher = extendsPattern.matcher(name);
        if (matcher.find()) {
            name = matcher.group(2);
        }

        return name;
    }

    private String markSplits(String ta) {
        int i = 0;
        int lbr = 0;
        while (i < ta.length()) {
            char c = ta.charAt(i);
            if (c == '<') {
                lbr++;
            } else if (c == '>') {
                lbr--;
            } else if (c == ',' && lbr == 0) {
                ta = ta.substring(0, i) + "<_split_>" + ta.substring(i + 1, ta.length());
                i += 9;
            }

            i++;
        }

        return ta;
    }

    public List<String> getTypeArguments() {
        return typeArguments;
    }

    public String getTypeArgumentsString() {
        return getTypeArgumentsString(this.typeArguments);
    }

    public static String getTypeArgumentsString(List<String> typeArguments) {
        if (typeArguments.isEmpty()) {
            return "";
        }

        StringBuilder builder = new StringBuilder("<");
        for (String arg : typeArguments) {
            builder.append(arg).append(",");
        }
        builder.setCharAt(builder.length() - 1, '>');
        return builder.toString();
    }
}
