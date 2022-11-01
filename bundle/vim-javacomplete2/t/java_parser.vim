source autoload/java_parser.vim
source t/javacomplete.vim

function! SID() abort
  redir => l:scriptnames
  silent scriptnames
  redir END
  for line in split(l:scriptnames, '\n')
    let [l:sid, l:path] = matchlist(line, '^\s*\(\d\+\):\s*\(.*\)$')[1:2]
    if l:path =~# '\<autoload[/\\]java_parser\.vim$'
      return '<SNR>' . l:sid . '_'
    endif
  endfor
endfunction
call vspec#hint({'sid': 'SID()', 'scope': 'java_parser#SScope()'})


describe 'javaparser test'
    it 'test'
        call Call('java_parser#InitParser', [])
        call Call('java_parser#compilationUnit')
        Expect Call('java_parser#expression') == {"tag": "ERRONEOUS", "errs": [], "pos": 0}

        let source = ['package foo.bar.baz;',
            \ 'public class DemoClass {',
            \ ' String str = new String();',
            \ ' public DemoClass() {',
            \ '     Integer in = new Integer();',
            \ ' }',
            \ '}']

        call Call('java_parser#InitParser', source)
        Expect Call('java_parser#compilationUnit') != 0
        call Call('java_parser#GotoPosition', '96')
        Expect Call('java_parser#statement') != 0
        Expect Call('java_parser#nextToken') == 0
    end

    it 'GetInnerText test'
        let tree = Call('javacomplete#parseradapter#Parse', 't/data/LambdaNamedClass.java')

        call Call('java_parser#GotoPosition', 380)
        Expect Call('s:GetInnerText', '(') == '(String t, BigDecimal d)'

        call Call('java_parser#GotoPosition', 400)
        Expect Call('s:GetInnerText', '{') == '{            Integer i = new Integer();            t.            d.        }'
    end
end
