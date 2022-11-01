source autoload/javacomplete/scanner.vim
source t/javacomplete.vim

call vspec#hint({'sid': 'g:SID("scanner")', 'scope': 'SScope()'})

describe 'javacomplete scanner test'
    it 'ParseExpr test'
        Expect Call('javacomplete#scanner#ParseExpr', 'var') == ['var']
        Expect Call('javacomplete#scanner#ParseExpr', 'var.') == ['var']
        Expect Call('javacomplete#scanner#ParseExpr', 'var.method().') == ['var', 'method()']
        Expect Call('javacomplete#scanner#ParseExpr', 'var.vari') == ['var', 'vari']
        Expect Call('javacomplete#scanner#ParseExpr', 'var.vari.') == ['var', 'vari']
        Expect Call('javacomplete#scanner#ParseExpr', 'var[].') == ['var[]']
        Expect Call('javacomplete#scanner#ParseExpr', '(Boolean) var.') == [' var']
        Expect Call('javacomplete#scanner#ParseExpr', '((Boolean) var).') == ['(Boolean)obj.']
        Expect Call('javacomplete#scanner#ParseExpr', '((Boolean) var).method()') == ['(Boolean)obj.', 'method()']
        Expect Call('javacomplete#scanner#ParseExpr', 'System.out::') == ['System', 'out']
        Expect Call('javacomplete#scanner#ParseExpr', 'System.out:') == ['System', 'out']
    end
    
    it 'ExtractCleanExpr test'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', 'var') == 'var'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', ' var.') == 'var.'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', 'var [ 0 ].') == 'var[0].'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', 'Boolean b = ((Boolean) var).method()') == '((Boolean)var).method()'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', 'List<String>::') == 'List<String>::'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', 'import ="java.util') == 'java.util'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', 'import = "java.util') == 'java.util'
        Expect Call('javacomplete#scanner#ExtractCleanExpr', '? super java.lang.String') == 'java.lang.String'
    end

end
