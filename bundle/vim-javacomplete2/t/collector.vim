source plugin/javacomplete.vim
source autoload/javacomplete.vim
source autoload/javacomplete/collector.vim
source t/javacomplete.vim

call vspec#hint({'sid': 'g:SID("collector")', 'scope': 'SScope()'})

describe 'javacomplete-test'
    it 'CollectFQNs test'
        Expect Call('s:CollectFQNs', 'List', 'kg.ash.foo', '', '') == ['kg.ash.foo.List','java.lang.List', 'java.lang.Object']
        Expect Call('s:CollectFQNs', 'java.util.List', 'kg.ash.foo', '', '') == ['java.util.List']
        Expect Call('s:CollectFQNs', 'Object', 'kg.ash.foo', '', '') == ['kg.ash.foo.Object','java.lang.Object']

        new
        source autoload/javacomplete.vim
        put ='import java.util.List;'
        Expect Call('s:CollectFQNs', 'List', '', '', '') == ['java.util.List']
      
        new
        source autoload/javacomplete.vim
        put ='import java.util.*;'
        put ='import java.foo.*;'
        Expect Call('s:CollectFQNs', 'List', '', '', '') == ['List', 'java.lang.List', 'java.util.List', 'java.foo.List', 'java.lang.Object']
        Expect Call('s:CollectFQNs', 'List', 'kg.ash.foo', '', '') == ['kg.ash.foo.List', 'java.lang.List', 'java.util.List', 'java.foo.List', 'java.lang.Object']
    end

    it 'GetPackageName test'

        Expect Call('javacomplete#collector#GetPackageName') == ''

        new 
        put ='package foo.bar.baz'
        Expect Call('javacomplete#collector#GetPackageName') == ''

        new 
        put ='package foo.bar.baz;'
        Expect Call('javacomplete#collector#GetPackageName') == 'foo.bar.baz'
    end

    it 'CollectTypeArguments test'
        source autoload/javacomplete.vim
        Expect Call('s:CollectTypeArguments', '', '', '') == ''

        Expect Call('s:CollectTypeArguments', 'Integer', '', '') == '<(Integer|java.lang.Integer|java.lang.Object)>'
        Expect Call('s:CollectTypeArguments', 'Integer[]', '', '') == '<(Integer[]|java.lang.Integer[]|java.lang.Object)>'
        Expect Call('s:CollectTypeArguments', '? super Integer[]', '', '') == '<(Integer[]|java.lang.Integer[]|java.lang.Object)>'

        new
        source autoload/javacomplete.vim
        put ='import java.util.List;'
        put ='import java.util.HashMap;'
        Expect Call('s:CollectTypeArguments', 'List<HashMap<String,BigDecimal>>', '', '') == '<java.util.List<HashMap<String,BigDecimal>>>'
        Expect Call('s:CollectTypeArguments', 'HashMap<String,BigDecimal>', '', '') == '<java.util.HashMap<String,BigDecimal>>'
        Expect Call('s:CollectTypeArguments', 'String,BigDecimal', '', '') == '<(String|java.lang.String|java.lang.Object),(BigDecimal|java.lang.BigDecimal|java.lang.Object)>'
        put ='import java.math.BigDecimal;'
        Expect Call('s:CollectTypeArguments', 'String,BigDecimal', '', '') == '<(String|java.lang.String|java.lang.Object),java.math.BigDecimal>'

        Expect Call('s:CollectTypeArguments', 'MyClass', '', '') == '<(MyClass|java.lang.MyClass|java.lang.Object)>'
        Expect Call('s:CollectTypeArguments', 'MyClass', 'foo.bar.baz', '') == '<(foo.bar.baz.MyClass|java.lang.MyClass|java.lang.Object)>'

        Expect Call('s:CollectTypeArguments', 'Object,Object,String', 'kg.test', '') == '<(kg.test.Object|java.lang.Object),(kg.test.Object|java.lang.Object),(kg.test.String|java.lang.String|java.lang.Object)>'
    end

    it 'SplitTypeArguments test'
        Expect Call('s:SplitTypeArguments', 'java.util.List<Integer>') == ['java.util.List', 'Integer']
        Expect Call('s:SplitTypeArguments', 'java.util.List<java.lang.Integer>') == ['java.util.List', 'java.lang.Integer']
        Expect Call('s:SplitTypeArguments', 'java.util.HashMap<Integer,String>') == ['java.util.HashMap', 'Integer,String']
        Expect Call('s:SplitTypeArguments', 'java.util.List<? extends java.lang.Integer[]>') == ['java.util.List', '? extends java.lang.Integer[]']
        Expect Call('s:SplitTypeArguments', 'List<? extends java.lang.Integer[]>') == ['List', '? extends java.lang.Integer[]']
        Expect Call('s:SplitTypeArguments', 'java.util.HashMap<? super Integer,? extends String>') == ['java.util.HashMap', '? super Integer,? extends String']
        Expect Call('s:SplitTypeArguments', 'java.util.function.ToIntFunction<? super java.lang.Integer[]>') == ['java.util.function.ToIntFunction', '? super java.lang.Integer[]']
        Expect Call('s:SplitTypeArguments', 'java.lang.Class<?>') == ['java.lang.Class', 0]
    end

end
