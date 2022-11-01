source autoload/javacomplete/imports.vim
source plugin/javacomplete.vim
source t/javacomplete.vim

call vspec#hint({'sid': 'g:SID("imports")', 'scope': 'SScope()'})

describe 'javacomplete imports test'
    it 'AddImport test'
        new
        source autoload/javacomplete.vim
        put! ='package kg.ash.foo;'

        call Call('s:AddImport', 'java.util.List')
        Expect getline(3) == 'import java.util.List;'

        call Call('s:AddImport', 'java.util.ArrayList')
        Expect getline(3) == 'import java.util.List;'

        call Call('s:AddImport', 'foo.bar.Baz')
        Expect getline(5) == 'import foo.bar.Baz;'

        call Call('s:AddImport', 'zoo.bar.Baz')
        Expect getline(5) == 'import zoo.bar.Baz;'

        call Call('s:AddImport', 'zoo.bar.Baz')
        Expect getline(5) == 'import zoo.bar.Baz;'

        new

        source autoload/javacomplete.vim
        call Call('s:AddImport', 'java.util.List')
        Expect getline(1) == 'import java.util.List;'

        call Call('s:AddImport', 'java.util.ArrayList')
        Expect getline(2) == 'import java.util.ArrayList;'

        call Call('s:AddImport', 'foo.bar.Baz')
        Expect getline(3) == 'import foo.bar.Baz;'

        call Call('s:AddImport', 'zoo.bar.Baz')
        Expect getline(3) == 'import zoo.bar.Baz;'

    end
end
