source plugin/javacomplete.vim
source autoload/javacomplete.vim
source autoload/javacomplete/complete/complete.vim
source t/javacomplete.vim

call vspec#hint({'sid': 'g:SID("complete/complete")', 'scope': 'SScope()'})

describe 'javacomplete-test'
    it 'Regexps test'
        let reTypeArgument = g:RE_TYPE_ARGUMENT
        let reTypeArgumentExtends = g:RE_TYPE_ARGUMENT_EXTENDS
        Expect 'Integer[]' =~ reTypeArgument
        Expect 'Integer[]' !~ reTypeArgumentExtends
        Expect '? super Integer[]' =~ reTypeArgument
        Expect '? super Integer[]' =~ reTypeArgumentExtends

        let qualid = g:RE_QUALID
        Expect 'java.util.function.ToIntFunction' =~ '^\s*' . qualid . '\s*$'
    end

end
