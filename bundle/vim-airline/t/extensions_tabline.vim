let g:airline#extensions#tabline#enabled = 1

source plugin/airline.vim
doautocmd VimEnter

describe 'default'

  it 'should use a tabline'
    e! CHANGELOG.md
    sp CONTRIBUTING.md
    Expect airline#extensions#tabline#get() == "%#airline_tabhid#...| %(%{airline#extensions#tabline#get_buffer_name(3)}%) %#airline_tabhid_to_airline_tab# %#airline_tab#%(%{airline#extensions#tabline#get_buffer_name(4)}%) %#airline_tab_to_airline_tabsel# %#airline_tabsel#%(%{airline#extensions#tabline#get_buffer_name(5)}%) %#airline_tabsel_to_airline_tabfill# %#airline_tabfill#%=%#airline_tabfill_to_airline_tabfill#%#airline_tabfill#%#airline_tabfill_to_airline_tablabel_right#%#airline_tablabel_right# buffers "
  end

  it 'Trigger on BufDelete autocommands'
    e! CHANGELOG.md
    sp CONTRIBUTING.md
    sp README.md
    2bd
    Expect airline#extensions#tabline#get() == "%#airline_tabhid#...%#airline_tabhid_to_airline_tab# %#airline_tab#%(%{airline#extensions#tabline#get_buffer_name(4)}%) | %(%{airline#extensions#tabline#get_buffer_name(5)}%) %#airline_tab_to_airline_tabsel# %#airline_tabsel#%(%{airline#extensions#tabline#get_buffer_name(6)}%) %#airline_tabsel_to_airline_tabfill# %#airline_tabfill#%=%#airline_tabfill_to_airline_tabfill#%#airline_tabfill#%#airline_tabfill_to_airline_tablabel_right#%#airline_tablabel_right# buffers "
  end
end
