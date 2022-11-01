source plugin/javacomplete.vim
source autoload/javacomplete.vim
source autoload/javacomplete/parseradapter.vim
source t/javacomplete.vim

call vspec#hint({'sid': 'g:SID("parseradapter")', 'scope': 'SScope()'})

describe 'javacomplete parseradapter test'
    it 'Lambdas anonym argument search test'
        let tree = Call('javacomplete#parseradapter#Parse', 't/data/LambdaAnonClass.java')

        let result = Call('javacomplete#parseradapter#SearchNameInAST', tree, 't', 388, 1)
        Expect result[0].tag == 'LAMBDA'
        Expect result[0].args.tag == 'IDENT'
        Expect result[0].args.name == 't'

        let result = Call('javacomplete#parseradapter#SearchNameInAST', tree, 'd', 463, 1)
        Expect result[1].tag == 'LAMBDA'
        Expect result[1].args[0].tag == 'IDENT'
        Expect result[1].args[0].name == 't'
    end

    it 'Lambdas in method return'
        let tree = Call('javacomplete#parseradapter#Parse', 't/data/LambdaReturnClass.java')

        let result = Call('javacomplete#parseradapter#SearchNameInAST', tree, 'p', 171, 1)
        Expect result[0].tag == 'LAMBDA'
        Expect result[0].args.tag == 'IDENT'
        Expect result[0].args.name == 'p'
    end

end
