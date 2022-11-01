source autoload/javacomplete/version.vim
source t/javacomplete.vim

call vspec#hint({'sid': 'g:SID("util")'})


describe 'javacomplete utils test'
    it 'ServerAccordance test'
        Expect Call('javacomplete#version#CompareVersions', '2.5.6', '2.5.6') == 0
        Expect Call('javacomplete#version#CompareVersions', '2.5.6', '2.5.5') == 1
        Expect Call('javacomplete#version#CompareVersions', '2.5.6', '2.5.7') == -1
        Expect Call('javacomplete#version#CompareVersions', '2.5.6', '2.5.6.1') == -1
        Expect Call('javacomplete#version#CompareVersions', '2.5.6', '2.4.7') == 1
    end
end
