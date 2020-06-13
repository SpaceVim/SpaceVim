" vim: fdm=indent
source t/config/options.vim

describe 'utils'
  describe 'line'
    it 'should return the current line number'
      Expect tablemode#utils#line('.') == line('.')
    end

    it 'should return the line number itself if it is a number'
      Expect tablemode#utils#line(1) == 1
    end
  end

  describe 'strip'
    it 'should strip all initial or trailing whitespace from a string'
      let string = ' This is awesome  '
      Expect tablemode#utils#strip(string) == 'This is awesome'
    end
  end

  describe 'strlen'
    it 'should return the length of a string correctly'
      let string = 'this is a test'
      Expect tablemode#utils#strlen(string) == 14
    end

    it 'should return the length of a unicode string correctly'
      let string = '測試 is good.'
      Expect tablemode#utils#strlen(string) == 11
    end
  end

  describe 'strdisplaywidth'
    it 'should return the display width of a string correctly'
      let string = 'this is a test'
      Expect tablemode#utils#StrDisplayWidth(string) == 14
    end

    it 'should return the display width of a unicode string correctly'
      let string = '測試 is good.'
      Expect tablemode#utils#StrDisplayWidth(string) == 13
    end
  end
end
