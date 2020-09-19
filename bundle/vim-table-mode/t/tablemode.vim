" vim: fdm=indent
source t/config/options.vim

describe 'tablemode'
  describe 'Activation'
    describe 'tablemode#Enable()'
      before
        call tablemode#Enable()
      end

      it 'should enable table mode'
        Expect b:table_mode_active to_be_true
      end
    end

    describe 'tablemode#Disable()'
      before
        call tablemode#Disable()
      end

      it 'should disable table mode'
        Expect b:table_mode_active to_be_false
      end
    end

    describe 'tablemode#Toggle()'
      it 'should toggle table mode'
        call tablemode#Toggle()
        Expect b:table_mode_active to_be_true
        call tablemode#Toggle()
        Expect b:table_mode_active to_be_false
      end
    end
  end

  describe 'Tableize'
    before
      new
      read t/fixtures/tableize.txt
    end

    it 'should tableize with default delimiter'
      :2,3call tablemode#TableizeRange('')
      Expect tablemode#table#IsRow(2) to_be_true
      Expect tablemode#spreadsheet#RowCount(2) == 2
      Expect tablemode#spreadsheet#ColumnCount(2) == 3
    end

    it 'should tableize with given delimiter'
      :2,3call tablemode#TableizeRange('/;')
      Expect tablemode#table#IsRow(2) to_be_true
      Expect tablemode#spreadsheet#RowCount(2) == 2
      Expect tablemode#spreadsheet#ColumnCount(2) == 2
    end
  end
end
