package kg.ash.javavi.readers.source;

import com.github.javaparser.JavaParser;
import com.github.javaparser.ParseProblemException;
import com.github.javaparser.TokenMgrException;
import com.github.javaparser.ast.CompilationUnit;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.StringReader;

import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;

public class CompilationUnitCreator {

    public static final Logger logger = LogManager.getLogger();

    public static CompilationUnitResult createFromFile(String fileName) {
        try {
            return new CompilationUnitResult(
                    JavaParser.parse(new FileReader(fileName)));
        } catch (TokenMgrException | FileNotFoundException e) {
            logger.error(e, e);
            return null;
        } catch (ParseProblemException ex) {
            logger.debug("parse error", ex);
            return new CompilationUnitResult(
                    ex.getProblems());
        }
    }

    public static CompilationUnitResult createFromContent(String content) {
        try {
            return new CompilationUnitResult(
                    JavaParser.parse(new StringReader(content)));
        } catch (TokenMgrException ex) {
            logger.error(ex, ex);
            return null;
        } catch (ParseProblemException ex) {
            logger.debug("parse error", ex);
            return new CompilationUnitResult(
                    ex.getProblems());
        }
    }

}
