if !has('nvim-0.5.0')
  echohl Error
  echom 'This plugin only works with Neovim >= v0.5.0'
  echohl clear
  finish
endif

" The jump-to-word command.
command! HopWord              lua require'hop'.hint_words()
command! HopWordBC            lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopWordAC            lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopWordCurrentLine   lua require'hop'.hint_words({ current_line_only = true })
command! HopWordCurrentLineBC lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })
command! HopWordCurrentLineAC lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })
command! HopWordMW            lua require'hop'.hint_words({ multi_windows = true })

" The jump-to-pattern command.
command! HopPattern              lua require'hop'.hint_patterns()
command! HopPatternBC            lua require'hop'.hint_patterns({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopPatternAC            lua require'hop'.hint_patterns({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopPatternCurrentLine   lua require'hop'.hint_patterns({ current_line_only = true })
command! HopPatternCurrentLineBC lua require'hop'.hint_patterns({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })
command! HopPatternCurrentLineAC lua require'hop'.hint_patterns({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })
command! HopPatternMW            lua require'hop'.hint_patterns({ multi_windows = true })

" The jump-to-char-1 command.
command! HopChar1              lua require'hop'.hint_char1()
command! HopChar1BC            lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopChar1AC            lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopChar1CurrentLine   lua require'hop'.hint_char1({ current_line_only = true })
command! HopChar1CurrentLineBC lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })
command! HopChar1CurrentLineAC lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })
command! HopChar1MW            lua require'hop'.hint_char1({ multi_windows = true })

" The jump-to-char-2 command.
command! HopChar2              lua require'hop'.hint_char2()
command! HopChar2BC            lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopChar2AC            lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopChar2CurrentLine   lua require'hop'.hint_char2({ current_line_only = true })
command! HopChar2CurrentLineBC lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })
command! HopChar2CurrentLineAC lua require'hop'.hint_char2({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })
command! HopChar2MW            lua require'hop'.hint_char2({ multi_windows = true })

" The jump-to-line command.
command! HopLine   lua require'hop'.hint_lines()
command! HopLineBC lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopLineAC lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopLineMW lua require'hop'.hint_lines({ multi_windows = true })

" The jump-to-line command (non-whitespace).
command! HopLineStart   lua require'hop'.hint_lines_skip_whitespace()
command! HopLineStartBC lua require'hop'.hint_lines_skip_whitespace({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopLineStartAC lua require'hop'.hint_lines_skip_whitespace({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopLineStartMW lua require'hop'.hint_lines_skip_whitespace({ multi_windows = true })

" The vertical command (line jump preserving the column cursor position).
command! HopVertical   lua require'hop'.hint_vertical()
command! HopVerticalBC lua require'hop'.hint_vertical({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopVerticalAC lua require'hop'.hint_vertical({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopVerticalMW lua require'hop'.hint_vertical({ multi_windows = true })

" The jump-to-anywhere command.
command! HopAnywhere              lua require'hop'.hint_anywhere()
command! HopAnywhereBC            lua require'hop'.hint_anywhere({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
command! HopAnywhereAC            lua require'hop'.hint_anywhere({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })
command! HopAnywhereCurrentLine   lua require'hop'.hint_anywhere({ current_line_only = true })
command! HopAnywhereCurrentLineBC lua require'hop'.hint_anywhere({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })
command! HopAnywhereCurrentLineAC lua require'hop'.hint_anywhere({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })
command! HopAnywhereMW            lua require'hop'.hint_anywhere({ multi_windows = true })
