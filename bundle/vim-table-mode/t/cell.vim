" vim: fdm=indent
source t/config/options.vim

describe 'cell'
  describe 'API'
    before
      new
      read t/fixtures/sample.txt
    end

    it 'should return the cells with GetCells'
      Expect tablemode#spreadsheet#cell#GetCells(2, 1, 1) ==# 'test11'
      " Get Rows
      Expect tablemode#spreadsheet#cell#GetCells(2, 1) == ['test11', 'test12']
      Expect tablemode#spreadsheet#cell#GetCells(2, 2) == ['test21', 'test22']
      " Get Columns
      Expect tablemode#spreadsheet#cell#GetCells(2, 0, 1) == ['test11', 'test21']
      Expect tablemode#spreadsheet#cell#GetCells(2, 0, 2) == ['test12', 'test22']
    end

    it 'should return the row with GetRow'
      Expect tablemode#spreadsheet#cell#GetRow(1, 2) == ['test11', 'test12']
      Expect tablemode#spreadsheet#cell#GetRow(2, 2) == ['test21', 'test22']
    end

    it 'should return the column with GetColumn'
      Expect tablemode#spreadsheet#cell#GetColumn(1, 2) == ['test11', 'test21']
      Expect tablemode#spreadsheet#cell#GetColumn(2, 2) == ['test12', 'test22']
    end

    it 'should return the cells in a range with GetCellRange'
      " Entire table as range
      Expect tablemode#spreadsheet#cell#GetCellRange('1,1:2,2', 2, 1) == [['test11', 'test21'], ['test12', 'test22']]

      " Get Rows given different seed lines and columns
      Expect tablemode#spreadsheet#cell#GetCellRange('1,1:1,2', 2, 1) == ['test11', 'test12']
      Expect tablemode#spreadsheet#cell#GetCellRange('1,1:1,2', 2, 2) == ['test11', 'test12']
      Expect tablemode#spreadsheet#cell#GetCellRange('1,1:1,2', 3, 1) == ['test11', 'test12']
      Expect tablemode#spreadsheet#cell#GetCellRange('1,1:1,2', 3, 2) == ['test11', 'test12']
      Expect tablemode#spreadsheet#cell#GetCellRange('2,1:2,2', 2, 1) == ['test21', 'test22']
      Expect tablemode#spreadsheet#cell#GetCellRange('2,1:2,2', 2, 2) == ['test21', 'test22']
      Expect tablemode#spreadsheet#cell#GetCellRange('2,1:2,2', 3, 1) == ['test21', 'test22']
      Expect tablemode#spreadsheet#cell#GetCellRange('2,1:2,2', 3, 2) == ['test21', 'test22']

      " Get Columns given different seed lines and column
      Expect tablemode#spreadsheet#cell#GetCellRange('1:2', 2, 1) == ['test11', 'test21']
      Expect tablemode#spreadsheet#cell#GetCellRange('1:2', 2, 2) == ['test12', 'test22']
      Expect tablemode#spreadsheet#cell#GetCellRange('1:2', 3, 1) == ['test11', 'test21']
      Expect tablemode#spreadsheet#cell#GetCellRange('1:2', 3, 2) == ['test12', 'test22']

      " Get Column given negative values in range for representing rows from
      " the end, -1 being the second last row.
      Expect tablemode#spreadsheet#cell#GetCellRange('1:-1', 2, 1) == ['test11']
      Expect tablemode#spreadsheet#cell#GetCellRange('1:-1', 3, 1) == ['test11']
      Expect tablemode#spreadsheet#cell#GetCellRange('1:-1', 2, 2) == ['test12']
      Expect tablemode#spreadsheet#cell#GetCellRange('1:-1', 3, 2) == ['test12']
    end
  end

  describe 'Motions'
    describe 'left or right'
      before
        new
        normal! ggdG
        read t/fixtures/sample.txt
        call cursor(2, 3)
      end

      it 'should move left when not on first column'
        call cursor(2, 12)
        Expect tablemode#spreadsheet#ColumnNr('.') == 2
        call tablemode#spreadsheet#cell#Motion('h')
        Expect tablemode#spreadsheet#ColumnNr('.') == 1
      end

      it 'should move to the previous row last column if it exists when on first column'
        call cursor(3, 3)
        Expect tablemode#spreadsheet#RowNr('.') == 2
        Expect tablemode#spreadsheet#ColumnNr('.') == 1
        call tablemode#spreadsheet#cell#Motion('h')
        Expect tablemode#spreadsheet#RowNr('.') == 1
        Expect tablemode#spreadsheet#ColumnNr('.') == 2
      end

      it 'should move right when not on last column'
        Expect tablemode#spreadsheet#ColumnNr('.') == 1
        call tablemode#spreadsheet#cell#Motion('l')
        Expect tablemode#spreadsheet#ColumnNr('.') == 2
      end

      it 'should move to the next row first column if it exists when on last column'
        call cursor(2, 12)
        Expect tablemode#spreadsheet#RowNr('.') == 1
        Expect tablemode#spreadsheet#ColumnNr('.') == 2
        call tablemode#spreadsheet#cell#Motion('l')
        Expect tablemode#spreadsheet#RowNr('.') == 2
        Expect tablemode#spreadsheet#ColumnNr('.') == 1
      end
    end

    describe 'up or down'
      before
        new
        normal! ggdG
        read t/fixtures/sample.txt
        call cursor(2, 3)
      end

      it 'should move a row up unless on first row'
        call cursor(3, 3)
        Expect tablemode#spreadsheet#RowNr('.') == 2
        call tablemode#spreadsheet#cell#Motion('k')
        Expect tablemode#spreadsheet#RowNr('.') == 1
      end

      it 'should remain on first row when trying to move up'
        Expect tablemode#spreadsheet#RowNr('.') == 1
        call tablemode#spreadsheet#cell#Motion('k')
        Expect tablemode#spreadsheet#RowNr('.') == 1
      end

      it 'should move a row down unless on last row'
        Expect tablemode#spreadsheet#RowNr('.') == 1
        call tablemode#spreadsheet#cell#Motion('j')
        Expect tablemode#spreadsheet#RowNr('.') == 2
      end

      it 'should remain on last row when trying to move down'
        Expect tablemode#spreadsheet#RowNr('.') == 1
        call tablemode#spreadsheet#cell#Motion('k')
        Expect tablemode#spreadsheet#RowNr('.') == 1
      end
    end
  end
end
