runtime! plugin/textobj/*.vim




describe 'The plugin'
  it 'is loaded'
    Expect exists('g:loaded_textobj_indent') to_be_true
  end
end




describe 'Named key mappings'
  it 'is available in proper modes'
    for lhs in ['<Plug>(textobj-indent-a)',
    \         '<Plug>(textobj-indent-i)',
    \         '<Plug>(textobj-indent-same-a)',
    \         '<Plug>(textobj-indent-same-i)']
      Expect maparg(lhs, 'c') == ''
      Expect maparg(lhs, 'i') == ''
      Expect maparg(lhs, 'n') == ''
      Expect maparg(lhs, 'o') != ''
      Expect maparg(lhs, 'v') != ''
    endfor
  end
end




describe 'Default key mappings'
  it 'is available in proper modes'
    Expect maparg('ai', 'c') ==# ''
    Expect maparg('ai', 'i') ==# ''
    Expect maparg('ai', 'n') ==# ''
    Expect maparg('ai', 'o') ==# '<Plug>(textobj-indent-a)'
    Expect maparg('ai', 'v') ==# '<Plug>(textobj-indent-a)'
    Expect maparg('ii', 'c') ==# ''
    Expect maparg('ii', 'i') ==# ''
    Expect maparg('ii', 'n') ==# ''
    Expect maparg('ii', 'o') ==# '<Plug>(textobj-indent-i)'
    Expect maparg('ii', 'v') ==# '<Plug>(textobj-indent-i)'
    Expect maparg('aI', 'c') ==# ''
    Expect maparg('aI', 'i') ==# ''
    Expect maparg('aI', 'n') ==# ''
    Expect maparg('aI', 'o') ==# '<Plug>(textobj-indent-same-a)'
    Expect maparg('aI', 'v') ==# '<Plug>(textobj-indent-same-a)'
    Expect maparg('iI', 'c') ==# ''
    Expect maparg('iI', 'i') ==# ''
    Expect maparg('iI', 'n') ==# ''
    Expect maparg('iI', 'o') ==# '<Plug>(textobj-indent-same-i)'
    Expect maparg('iI', 'v') ==# '<Plug>(textobj-indent-same-i)'
  end
end




describe '<Plug>(textobj-indent-a)'
  before
    tabnew
    tabonly!

    silent put =[
    \   'if some_condition_is_satisfied',
    \   '  if another_condition_is_satisfied',
    \   '    call s:special_stuff()',
    \   '  endif',
    \   '  call s:normal_stuff()',
    \   '',
    \   '  ...',
    \   '  endif',
    \   'else',
    \   '  ...',
    \   'endif',
    \ ]
    1 delete _
    normal! 4G
  end

  it 'selects proper range of text'
    execute "normal v\<Plug>(textobj-indent-a)\<Esc>"
    Expect [line("'<"), col("'<")] ==# [2, 1]
    Expect [line("'>"), col("'>")] ==# [8, 8]
  end

  it 'targets proper range of text'
    execute "silent normal y\<Plug>(textobj-indent-a)"
    Expect [line("'["), col("'[")] ==# [2, 1]
    Expect [line("']"), col("']")] ==# [8, 8]
  end
end




describe '<Plug>(textobj-indent-i)'
  before
    tabnew
    tabonly!

    silent put =[
    \   'if some_condition_is_satisfied',
    \   '  if another_condition_is_satisfied',
    \   '    call s:special_stuff()',
    \   '  endif',
    \   '  call s:normal_stuff()',
    \   '',
    \   '  ...',
    \   '  endif',
    \   'else',
    \   '  ...',
    \   'endif',
    \ ]
    1 delete _
    normal! 4G
  end

  it 'selects proper range of text'
    execute "normal v\<Plug>(textobj-indent-i)\<Esc>"
    Expect [line("'<"), col("'<")] ==# [2, 1]
    Expect [line("'>"), col("'>")] ==# [5, 24]
  end

  it 'targets proper range of text'
    execute "silent normal y\<Plug>(textobj-indent-i)"
    Expect [line("'["), col("'[")] ==# [2, 1]
    Expect [line("']"), col("']")] ==# [5, 24]
  end
end




describe '<Plug>(textobj-indent-same-a)'
  before
    tabnew
    tabonly!

    silent put =[
    \   'if some_condition_is_satisfied',
    \   '  if another_condition_is_satisfied',
    \   '    call s:special_stuff()',
    \   '  endif',
    \   '  call s:normal_stuff()',
    \   '',
    \   '  ...',
    \   '  endif',
    \   'else',
    \   '  ...',
    \   'endif',
    \ ]
    1 delete _
    normal! 4G
  end

  it 'selects proper range of text'
    execute "normal v\<Plug>(textobj-indent-same-a)\<Esc>"
    Expect [line("'<"), col("'<")] ==# [4, 1]
    Expect [line("'>"), col("'>")] ==# [8, 8]
  end

  it 'targets proper range of text'
    execute "silent normal y\<Plug>(textobj-indent-same-a)"
    Expect [line("'["), col("'[")] ==# [4, 1]
    Expect [line("']"), col("']")] ==# [8, 8]
  end
end




describe '<Plug>(textobj-indent-same-i)'
  before
    tabnew
    tabonly!

    silent put =[
    \   'if some_condition_is_satisfied',
    \   '  if another_condition_is_satisfied',
    \   '    call s:special_stuff()',
    \   '  endif',
    \   '  call s:normal_stuff()',
    \   '',
    \   '  ...',
    \   '  endif',
    \   'else',
    \   '  ...',
    \   'endif',
    \ ]
    1 delete _
    normal! 4G
  end

  it 'selects proper range of text'
    execute "normal v\<Plug>(textobj-indent-same-i)\<Esc>"
    Expect [line("'<"), col("'<")] ==# [4, 1]
    Expect [line("'>"), col("'>")] ==# [5, 24]
  end

  it 'targets proper range of text'
    execute "silent normal y\<Plug>(textobj-indent-same-i)"
    Expect [line("'["), col("'[")] ==# [4, 1]
    Expect [line("']"), col("']")] ==# [5, 24]
  end
end
