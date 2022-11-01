package kg.ash.javavi.actions;

import kg.ash.javavi.output.OutputClassInfo;
import kg.ash.javavi.readers.Parser;

public class GetClassInfoFromSourceAction extends ActionWithTarget {

    @Override
    public String perform(String[] args) {
        Parser parser = new Parser(sources, parseTarget(args));
        return new OutputClassInfo().get(parser.read(null));
    }
}
