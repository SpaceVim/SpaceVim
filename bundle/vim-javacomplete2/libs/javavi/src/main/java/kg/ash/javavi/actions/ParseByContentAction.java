package kg.ash.javavi.actions;

import static kg.ash.javavi.actions.ActionFactory.getArgWithName;
import static kg.ash.javavi.actions.ActionFactory.getJavaViSources;

import kg.ash.javavi.Javavi;
import kg.ash.javavi.output.OutputClassInfo;
import kg.ash.javavi.readers.Parser;

import java.io.UnsupportedEncodingException;
import java.util.Base64;

public class ParseByContentAction implements Action {

    @Override
    public String perform(String[] args) {
        try {
            String targetClass = getArgWithName(args, "-target");
            String base64Content = getArgWithName(args, "-content");

            String content = new String(Base64.getDecoder().decode(base64Content), "UTF-8");
            Parser parser = new Parser(getJavaViSources(Javavi.system));
            parser.setSourceContent(content);

            return new OutputClassInfo().get(parser.read(targetClass));
        } catch (UnsupportedEncodingException ex) {
            return ex.getMessage();
        }
    }
}
