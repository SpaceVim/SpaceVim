source autoload/javacomplete/util.vim
source t/javacomplete.vim

call vspec#hint({'sid': 'g:SID("util")'})


describe 'javacomplete utils test'
    it 'CountDims test'
        Expect Call('javacomplete#util#CountDims', '') == 0
        Expect Call('javacomplete#util#CountDims', 'String[]') == 1
        Expect Call('javacomplete#util#CountDims', 'String[][]') == 2
        Expect Call('javacomplete#util#CountDims', 'String[][][][][]') == 5
        Expect Call('javacomplete#util#CountDims', 'String]') == 1
        Expect Call('javacomplete#util#CountDims', 'String[') == 0
        Expect Call('javacomplete#util#CountDims', 'String[[') == 0
        Expect Call('javacomplete#util#CountDims', 'String]]') == 1
    end

    it 'GetClassNameWithScope test'
        new 
        put ='ArrayLi'
        Expect Call('javacomplete#util#GetClassNameWithScope') == 'ArrayLi'

        new 
        put ='ArrayList '
        Expect Call('javacomplete#util#GetClassNameWithScope') == 'ArrayList'

        new 
        put ='ArrayList l'
        call cursor(0, 10)
        Expect Call('javacomplete#util#GetClassNameWithScope') == 'ArrayList'

        new
        call cursor(1, 1)
        put! ='ArrayList<String> l'
        call cursor(1, 11)
        Expect Call('javacomplete#util#GetClassNameWithScope') == 'String'

        new 
        call cursor(1, 1)
        put! ='List l = new ArrayList<String>()'
        call cursor(1, 1)
        Expect Call('javacomplete#util#GetClassNameWithScope') == 'List'
        call cursor(1, 14)
        Expect Call('javacomplete#util#GetClassNameWithScope') == 'ArrayList'
        call cursor(1, 31)
        Expect Call('javacomplete#util#GetClassNameWithScope') == ''

        new 
        call cursor(1, 1)
        put! ='@Annotation'
        call cursor(1, 2)
        Expect Call('javacomplete#util#GetClassNameWithScope') == '@Annotation'

        new 
        call cursor(1, 1)
        put! ='ArrayList. '
        call cursor(1, 12)
        Expect Call('javacomplete#util#GetClassNameWithScope') == 'ArrayList'

    end

    it 'CleanFQN test'
        Expect Call('javacomplete#util#CleanFQN', '') == ''
        Expect Call('javacomplete#util#CleanFQN', 'java.lang.Object') == 'Object'
        Expect Call('javacomplete#util#CleanFQN', 'java.lang.Object java.util.HashMap.get()') == 'Object get()'
        Expect Call('javacomplete#util#CleanFQN', 'public java.math.BigDecimal java.util.HashMap.computeIfAbsent(java.lang.String,java.util.function.Function<? super java.lang.String, ? extends java.math.BigDecimal>)') == 'public BigDecimal computeIfAbsent(String,Function<? super String, ? extends BigDecimal>)'

        Expect Call('javacomplete#util#CleanFQN', 'public boolean scala.Tuple2.specInstance$()') == 'public boolean specInstance$()'
    end

    it 'Prune test'
        Expect Call('javacomplete#util#Prune', ' 	sb. /* block comment*/ append( "stringliteral" ) // comment ') == 'sb.   append( "" ) '
        Expect Call('javacomplete#util#Prune', ' 	list.stream(\n\t\ts -> {System.out.println(s)}).') == 'list.stream(\n\t\ts -> {System.out.println(s)}). '
    end

    it 'HasKeyword test'
        Expect Call('javacomplete#util#HasKeyword', 'java.util.function.ToIntFunction') == 0
    end

    it 'GenMethodParamsDeclaration test'
        let m = {'p': ['int', 'int'], 'r': 'java.util.List<java.lang.Object>', 'c': 'java.util.List<java.lang.Object>', 'd': 'public abstract java.util.List<java.lang.Object> java.util.List.subList(int,int)', 'm': '10000000001', 'n': 'subList'}
        Expect Call('javacomplete#util#GenMethodParamsDeclaration', m) == 'public abstract java.util.List<java.lang.Object> java.util.List.subList(int i1, int i2)'

        let m = {'p': ['java.lang.Object'], 'r': 'int', 'c': 'int', 'd': 'public abstract int java.util.List.indexOf(java.lang.Object)', 'm': '10000000001', 'n': 'indexOf'}
        Expect Call('javacomplete#util#GenMethodParamsDeclaration', m) == 'public abstract int java.util.List.indexOf(Object object)'

        let m = {'p': ['java.util.Collection<? extends java.lang.Object>'], 'r': 'boolean', 'c': 'boolean', 'd': 'public abstract boolean java.util.List.addAll(java.util.Collection<? extends java.lang.Object>)', 'm': '10000000001', 'n': 'addAll'}
        Expect Call('javacomplete#util#GenMethodParamsDeclaration', m) == 'public abstract boolean java.util.List.addAll(Collection<? extends Object> collection)'

        let m = {'p': ['T[]'], 'r': 'T[]', 'c': 'T[]', 'd': 'public abstract <T> T[] java.util.List.toArray(T[])', 'm': '10000000001', 'n': 'toArray'}
        Expect Call('javacomplete#util#GenMethodParamsDeclaration', m) == 'public abstract <T> T[] java.util.List.toArray(T[] t)'

        let m = {'p': ['java.math.BigDecimal', 'java.math.BigDecimal'], 'r': 'int', 'c': 'int', 'd': 'public abstract int indexOf(java.math.BigDecimal,java.math.BigDecimal)', 'm': '10000000001', 'n': 'indexOf'}
        Expect Call('javacomplete#util#GenMethodParamsDeclaration', m) == 'public abstract int indexOf(BigDecimal bigDecimal1, BigDecimal bigDecimal2)'

        let m = {'p': ['java.math.BigDecimal', 'java.math.BigDecimal'], 'r': 'int', 'c': 'int', 'd': 'public abstract int indexOf(java.math.BigDecimal,java.math.BigDecimal) throws java.lang.Exception', 'm': '10000000001', 'n': 'indexOf'}
        Expect Call('javacomplete#util#GenMethodParamsDeclaration', m) == 'public abstract int indexOf(BigDecimal bigDecimal1, BigDecimal bigDecimal2) throws java.lang.Exception'
    end
end
