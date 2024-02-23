local resolve = require "telescope.config.resolve"

local p_window = {}

function p_window.get_window_options(picker, max_columns, max_lines)
  local layout_strategy = picker.layout_strategy
  local getter = require("telescope.pickers.layout_strategies")[layout_strategy]

  if not getter then
    error(string.format("'%s' is not a valid layout strategy", layout_strategy))
  end

  return getter(picker, max_columns, max_lines)
end

function p_window.get_initial_window_options(picker)
  local popup_border = resolve.win_option(picker.window.border)
  local popup_borderchars = resolve.win_option(picker.window.borderchars)

  local preview = {
    title = picker.preview_title,
    border = popup_border.preview,
    borderchars = popup_borderchars.preview,
    enter = false,
    highlight = false,
  }

  local results = {
    title = picker.results_title,
    border = popup_border.results,
    borderchars = popup_borderchars.results,
    enter = false,
  }

  local prompt = {
    title = picker.prompt_title,
    border = popup_border.prompt,
    borderchars = popup_borderchars.prompt,
    enter = true,
  }

  return {
    preview = preview,
    results = results,
    prompt = prompt,
  }
end

return p_window
