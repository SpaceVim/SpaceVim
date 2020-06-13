" vim: fdm=indent
source t/config/options.vim

describe 'table'
  describe 'IsRow'
    before
      new
      normal! ggdG
      read t/fixtures/table/sample.txt
    end

    it 'should be true when on a table row'
      Expect tablemode#table#IsRow(2) to_be_true
      Expect tablemode#table#IsRow(3) to_be_true
    end

    it 'should be false when not on a table row'
      Expect tablemode#table#IsRow(1) to_be_false
      Expect tablemode#table#IsRow(4) to_be_false
    end
  end

  describe 'IsBorder'
    before
      new
      normal! ggdG
      read t/fixtures/table/sample_with_header.txt
    end

    it 'should be true on a table border'
      Expect tablemode#table#IsBorder(1) to_be_true
      Expect tablemode#table#IsBorder(3) to_be_true
      Expect tablemode#table#IsBorder(6) to_be_true
    end

    it 'should be false when not on a table border'
      Expect tablemode#table#IsBorder(2) to_be_false
      Expect tablemode#table#IsBorder(4) to_be_false
      Expect tablemode#table#IsBorder(5) to_be_false
    end
  end

  describe 'IsTable'
    before
      new normal! ggdG
      read t/fixtures/table/sample_with_header.txt
    end

    it 'should be true on a table row'
      Expect tablemode#table#IsTable(2) to_be_true
      Expect tablemode#table#IsTable(4) to_be_true
      Expect tablemode#table#IsTable(5) to_be_true
    end

    it 'should be true when on a table border'
      Expect tablemode#table#IsTable(1) to_be_true
      Expect tablemode#table#IsTable(3) to_be_true
      Expect tablemode#table#IsTable(6) to_be_true
    end

    it 'should not be true when not on a table'
      Expect tablemode#table#IsTable(7) to_be_false
    end
  end

  describe 'IsHeader'
    before
      new
      normal! ggdG
      read t/fixtures/table/sample_with_header.txt
    end

    it 'should be true on the table header'
      Expect tablemode#table#IsHeader(2) to_be_true
    end

    it 'should be false anywhere else'
      Expect tablemode#table#IsHeader(1) to_be_false
      Expect tablemode#table#IsHeader(4) to_be_false
      Expect tablemode#table#IsHeader(5) to_be_false
      Expect tablemode#table#IsHeader(6) to_be_false
      Expect tablemode#table#IsHeader(7) to_be_false
    end
  end

  describe 'AddBorder'
    before
      new
      normal! ggdG
      read t/fixtures/table/sample_for_header.txt
    end

    it 'should add border to line'
      call tablemode#table#AddBorder(2)
      Expect tablemode#table#IsHeader(1) to_be_true
      Expect tablemode#table#IsBorder(2) to_be_true
    end

    describe 'for unicode'
      before
        new
        normal! ggdG
        read t/fixtures/table/sample_for_header_unicode.txt
      end

      it 'should add border to line'
        call tablemode#table#AddBorder(1)
        call tablemode#table#AddBorder(3)
        call tablemode#table#AddBorder(5)
        call tablemode#table#AddBorder(7)
        call tablemode#table#AddBorder(9)

        Expect tablemode#table#IsBorder(1) to_be_true
        Expect tablemode#utils#StrDisplayWidth(getline(1)) == tablemode#utils#StrDisplayWidth(getline(2))
        Expect tablemode#table#IsBorder(3) to_be_true
        Expect tablemode#utils#StrDisplayWidth(getline(3)) == tablemode#utils#StrDisplayWidth(getline(4))
        Expect tablemode#table#IsBorder(5) to_be_true
        Expect tablemode#utils#StrDisplayWidth(getline(5)) == tablemode#utils#StrDisplayWidth(getline(6))
        Expect tablemode#table#IsBorder(7) to_be_true
        Expect tablemode#utils#StrDisplayWidth(getline(7)) == tablemode#utils#StrDisplayWidth(getline(8))
        Expect tablemode#table#IsBorder(9) to_be_true
        Expect tablemode#utils#StrDisplayWidth(getline(9)) == tablemode#utils#StrDisplayWidth(getline(8))
      end
    end
  end

  describe 'Realign'
    describe 'without header alignments'
      describe 'for simple'
        before
          new
          normal! ggdG
          read t/fixtures/table/sample_realign_before.txt
        end

        it 'should be aligned properly'
          call tablemode#table#Realign(1)
          Expect getline(1,'$') == readfile('t/fixtures/table/sample_realign_after.txt')
        end
      end

      describe 'for unicode'
        before
          new
          normal! ggdG
          read t/fixtures/table/sample_realign_unicode_before.txt
        end

        it 'should be aligned properly'
          call tablemode#table#Realign(1)
          Expect getline(1,'$') == readfile('t/fixtures/table/sample_realign_unicode_after.txt')
        end
      end
    end

    describe 'with header alignments'
      describe 'for simple'
        before
          new
          normal! ggdG
          read t/fixtures/table/sample_header_realign_before.txt
        end

        it 'should be aligned properly'
          call tablemode#table#Realign(1)
          Expect getline(1,'$') == readfile('t/fixtures/table/sample_header_realign_after.txt')
        end
      end

      describe 'for unicode'
        before
          new
          normal! ggdG
          read t/fixtures/table/sample_header_realign_unicode_before.txt
        end

        it 'should be aligned properly'
          call tablemode#table#Realign(1)
          Expect getline(1,'$') == readfile('t/fixtures/table/sample_header_realign_unicode_after.txt')
        end
      end
    end
  end
end
