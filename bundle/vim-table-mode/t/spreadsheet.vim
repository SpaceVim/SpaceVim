" vim: fdm=indent
source t/config/options.vim

describe 'spreadsheet'
  describe 'API'
    before
      new
      read t/fixtures/sample.txt
    end

    it 'should return the row count'
      Expect tablemode#spreadsheet#RowCount(2) == 2
      Expect tablemode#spreadsheet#RowCount(3) == 2
    end

    it 'should return the row number'
      Expect tablemode#spreadsheet#RowNr(2) == 1
      Expect tablemode#spreadsheet#RowNr(3) == 2
    end

    it 'should return the column count'
      Expect tablemode#spreadsheet#ColumnCount(2) == 2
      Expect tablemode#spreadsheet#ColumnCount(3) == 2
    end

    it 'should return the column number'
      call cursor(2,3)
      Expect tablemode#spreadsheet#ColumnNr('.') == 1
      call cursor(2,12)
      Expect tablemode#spreadsheet#ColumnNr('.') == 2
    end

    it 'should return true when in the first cell'
      call cursor(2,3)
      Expect tablemode#spreadsheet#IsFirstCell() to_be_true
      call cursor(2,12)
      Expect tablemode#spreadsheet#IsFirstCell() to_be_false
    end

    it 'should return true when in the last cell'
      call cursor(2,3)
      Expect tablemode#spreadsheet#IsLastCell() to_be_false
      call cursor(2,12)
      Expect tablemode#spreadsheet#IsLastCell() to_be_true
    end

    it 'should return the line number of the first row'
      Expect tablemode#spreadsheet#GetFirstRow(2) == 2
      Expect tablemode#spreadsheet#GetFirstRow(3) == 2
    end

    it 'should return the line nuber of the last row'
      Expect tablemode#spreadsheet#GetLastRow(2) == 3
      Expect tablemode#spreadsheet#GetLastRow(3) == 3
    end

    describe 'Math'
      before
        new
        read t/fixtures/cell/sample.txt
      end

      it 'should return the sum of cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#Sum('1:2') == 4.0
        Expect tablemode#spreadsheet#Sum('1,1:1,2') == 3.0
        Expect tablemode#spreadsheet#Sum('1,1:2,2') == 10.0
        call cursor(2,7)
        Expect tablemode#spreadsheet#Sum('1:2') == 6.0
        Expect tablemode#spreadsheet#Sum('2,1:2,2') == 7.0
      end

      it 'should return the average of cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#Average('1:2') == 2.0
        Expect tablemode#spreadsheet#Average('1,1:1,2') == 1.5
        Expect tablemode#spreadsheet#Average('1,1:2,2') == 2.5
        call cursor(2,7)
        Expect tablemode#spreadsheet#Average('1:2') == 3.0
        Expect tablemode#spreadsheet#Average('2,1:2,2') == 3.5
      end

      it 'should return the min of cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#Min('1:2') == 1.0
        Expect tablemode#spreadsheet#Min('1,1:1,2') == 1.0
        Expect tablemode#spreadsheet#Min('1,1:2,2') == 1.0
        call cursor(2,7)
        Expect tablemode#spreadsheet#Min('1:2') == 2.0
        Expect tablemode#spreadsheet#Min('2,1:2,2') == 3.0
      end

      it 'should return the max of cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#Max('1:2') == 3.0
        Expect tablemode#spreadsheet#Max('1,1:1,2') == 2.0
        Expect tablemode#spreadsheet#Max('1,1:2,2') == 4.0
        call cursor(2,7)
        Expect tablemode#spreadsheet#Max('1:2') == 4.0
        Expect tablemode#spreadsheet#Max('2,1:2,2') == 4.0
      end
    end

    describe 'Count'
      before
        new
        read t/fixtures/cell/counts.txt
      end

      it 'should return the count of empty cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#CountE('1:3') == 1
        Expect tablemode#spreadsheet#CountE('1,1:1,3') == 0
        Expect tablemode#spreadsheet#CountE('2,1:2,3') == 2
        Expect tablemode#spreadsheet#CountE('1,1:3,3') == 2
        call cursor(3,11)
        Expect tablemode#spreadsheet#CountE('1:3') == 1
        Expect tablemode#spreadsheet#CountE('3,1:3,3') == 0
      end

      it 'should return the count of not-empty cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#CountNE('1:3') == 2
        Expect tablemode#spreadsheet#CountNE('1,1:1,3') == 3
        Expect tablemode#spreadsheet#CountNE('2,1:2,3') == 1
        Expect tablemode#spreadsheet#CountNE('1,1:3,3') == 7
        call cursor(3,11)
        Expect tablemode#spreadsheet#CountNE('1:3') == 2
        Expect tablemode#spreadsheet#CountNE('3,1:3,3') == 3
      end

      it 'should return the percent count of empty cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#PercentE('1:3') == 33
        Expect tablemode#spreadsheet#PercentE('1,1:1,3') == 0
        Expect tablemode#spreadsheet#PercentE('2,1:2,3') == 66
        Expect tablemode#spreadsheet#PercentE('1,1:3,3') == 22
        call cursor(3,11)
        Expect tablemode#spreadsheet#PercentE('1:3') == 33
        Expect tablemode#spreadsheet#PercentE('3,1:3,3') == 0
      end

      it 'should return the percent count of not-empty cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#PercentNE('1:3') == 66
        Expect tablemode#spreadsheet#PercentNE('1,1:1,3') == 100
        Expect tablemode#spreadsheet#PercentNE('2,1:2,3') == 33
        Expect tablemode#spreadsheet#PercentNE('1,1:3,3') == 77
        call cursor(3,11)
        Expect tablemode#spreadsheet#PercentNE('1:3') == 66
        Expect tablemode#spreadsheet#PercentNE('3,1:3,3') == 100
      end

      it 'should return the average of not-empty cell range'
        call cursor(1,3)
        Expect tablemode#spreadsheet#AverageNE('1:3') == 2.5
        Expect tablemode#spreadsheet#AverageNE('1,1:1,3') == 2.0
        Expect tablemode#spreadsheet#AverageNE('2,1:2,3') == 0.0
        Expect tablemode#spreadsheet#AverageNE('1,1:3,3') == 3.0
        call cursor(3,11)
        Expect tablemode#spreadsheet#AverageNE('1:3') == 4.5
        Expect tablemode#spreadsheet#AverageNE('3,1:3,3') == 5.0
      end
    end
  end

  describe 'Manipulations'
    before
      new
      normal! ggdG
      read t/fixtures/sample.txt
      call cursor(2, 3)
    end

    it 'should delete a row successfully'
      Expect tablemode#spreadsheet#RowCount('.') == 2
      call tablemode#spreadsheet#DeleteRow()
      Expect tablemode#spreadsheet#RowCount('.') == 1
    end

    it 'should successfully delete column'
      Expect tablemode#spreadsheet#ColumnCount('.') == 2
      call tablemode#spreadsheet#DeleteColumn()
      Expect tablemode#spreadsheet#ColumnCount('.') == 1
    end

    it 'should successfully insert a column before the cursor'
      Expect tablemode#spreadsheet#ColumnCount('.') == 2
      call tablemode#spreadsheet#InsertColumn(0)
      Expect tablemode#spreadsheet#ColumnCount('.') == 3
      Expect getline('.') == '|  | test11 | test12 |'
    end

    it 'should successfully insert a column after the cursor'
      normal! $
      Expect tablemode#spreadsheet#ColumnCount('.') == 2
      call tablemode#spreadsheet#InsertColumn(1)
      Expect tablemode#spreadsheet#ColumnCount('.') == 3
      Expect getline('.') == '| test11 | test12 |  |'
    end
  end

  describe 'Manipulation of tables with headers'
    before
      new
      normal! ggdG
      let g:table_mode_header_fillchar = '='
      read t/fixtures/complex_header.txt
      call cursor(4, 7)
    end

    it 'should successfully delete a row '
      Expect tablemode#spreadsheet#RowCount('.') == 5
      call tablemode#spreadsheet#DeleteRow()
      Expect tablemode#spreadsheet#RowCount('.') == 4
      Expect getline(4) == '|     2    | 8        |        b | y        |'
    end

    it 'should successfully delete a column'
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
      call tablemode#spreadsheet#DeleteColumn()
      Expect tablemode#spreadsheet#ColumnCount('.') == 3
      Expect getline(4) == '| 9        |        a | z        |'
    end

    it 'should successfully insert a column before the cursor'
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
      call tablemode#spreadsheet#InsertColumn(0)
      Expect tablemode#spreadsheet#ColumnCount('.') == 5
      Expect getline(4) == '|  |     1    | 9        |        a | z        |'
    end

    it 'should successfully insert a column after the cursor'
      normal! $
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
      call tablemode#spreadsheet#InsertColumn(1)
      Expect tablemode#spreadsheet#ColumnCount('.') == 5
      Expect getline(4) == '|     1    | 9        |        a | z        |  |'
    end
  end

  describe 'Repeated Manipulations'
    before
      new
      normal! ggdG
      read t/fixtures/big_sample.txt
      call cursor(2, 3)
    end

    it 'should delete multiple rows correctly'
      Expect tablemode#spreadsheet#RowCount('.') == 5
      .,.+1 call tablemode#spreadsheet#DeleteRow()
      Expect tablemode#spreadsheet#RowCount('.') == 3
    end

    it 'should delete multiple columns correctly'
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
      .,.+1 call tablemode#spreadsheet#DeleteColumn()
      Expect tablemode#spreadsheet#ColumnCount('.') == 2
    end

    it 'should insert multiple columns before the cursor correctly'
      call cursor(2, 7)
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
      execute "normal! 2:\<C-u>call tablemode#spreadsheet#InsertColumn(0)\<CR>"
      Expect tablemode#spreadsheet#ColumnCount('.') == 6
      Expect getline('.') == '| 1 |  |  | 9 | a | z |'
    end

    it 'should insert multiple columns after the cursor correctly'
      call cursor(2, 7)
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
      execute "normal! 2:\<C-u>call tablemode#spreadsheet#InsertColumn(1)\<CR>"
      Expect tablemode#spreadsheet#ColumnCount('.') == 6
      Expect getline('.') == '| 1 | 9 |  |  | a | z |'
    end
  end

  describe 'Unicode table separators'
    before
      new
      normal! ggdG
      read t/fixtures/table/sample_realign_unicode_after.txt
      call cursor(2, 19)
    end

    it 'should not prevent the deletion of rows'
      Expect tablemode#spreadsheet#RowCount('.') == 4
      call tablemode#spreadsheet#DeleteRow()
      Expect tablemode#spreadsheet#RowCount('.') == 3
    end

    it 'should not prevent the deletion of columns'
      Expect tablemode#spreadsheet#ColumnCount('.') == 3
      call tablemode#spreadsheet#DeleteColumn()
      Expect tablemode#spreadsheet#ColumnCount('.') == 2
    end

    it 'should not prevent the insertion of columns before the cursor'
      Expect tablemode#spreadsheet#ColumnCount('.') == 3
      call tablemode#spreadsheet#InsertColumn(1)
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
    end

    it 'should not prevent the insertion of columns after the cursor'
      Expect tablemode#spreadsheet#ColumnCount('.') == 3
      call tablemode#spreadsheet#InsertColumn(1)
      Expect tablemode#spreadsheet#ColumnCount('.') == 4
    end
  end

  describe 'Escaped table separators'
    before
      new
      normal! ggdG
      read t/fixtures/escaped_seperator.txt
      call cursor(2, 3)
    end

    it 'should not prevent the deletion of rows'
      Expect tablemode#spreadsheet#RowCount('.') == 7
      call tablemode#spreadsheet#DeleteRow()
      Expect tablemode#spreadsheet#RowCount('.') == 6
      Expect getline('.') == '| a separator.      |                         |'
    end

    it 'should not prevent the deletion of columns'
      Expect tablemode#spreadsheet#ColumnCount('.') == 2
      call tablemode#spreadsheet#DeleteColumn()
      Expect tablemode#spreadsheet#ColumnCount('.') == 1
      Expect getline('.') == '| It can be escaped by a \. |'
    end

    it 'should not prevent the insertion of columns'
      Expect tablemode#spreadsheet#ColumnCount('.') == 2
      call tablemode#spreadsheet#InsertColumn(1)
      Expect tablemode#spreadsheet#ColumnCount('.') == 3
      Expect getline('.') == '| The \| works as   |  | It can be escaped by a \. |'
    end
  end
end
