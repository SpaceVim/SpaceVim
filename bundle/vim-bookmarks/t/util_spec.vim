describe 'util'

  it 'should return command output'
    Expect util#redir_execute(":echo 'foo'") ==# 'foo'
  end

end
