call textobj#user#plugin('number', {
\   'real': {
\     'pattern': '\v\d+(\.\d+)?',
\     'select': ['an', 'in'],
\   }
\ })

describe 'textobj-user'
  before
    new
    put ='2abc'
    put ='         2.    abc2232'
    1 delete _
  end

  after
    close!
  end

  it 'selects a number object with a single digit'
    normal 1Gvany
    Expect [line("'<"), col("'<"), line("'>"), col("'>")] == [1, 1, 1, 1]
    normal 2Gvany
    Expect [line("'<"), col("'<"), line("'>"), col("'>")] == [2, 10, 2, 10]
  end

  it 'selects a number object with multiple digit'
    normal 2Gf2vany
    Expect [line("'<"), col("'<"), line("'>"), col("'>")] == [2, 19, 2, 22]
  end
end
