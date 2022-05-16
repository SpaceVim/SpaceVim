--luacheck: ignore

function CanWinBeHidden()
  -- The answer is yes
  -- Just keep track of the buffer ID

  local what = "test string"
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- TODO: Handle list of lines
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, {what})

  local win_id = vim.api.nvim_open_win(bufnr, true, {relative='win', row=3, col=3, width=40, height=3})
  vim.api.nvim_win_close(win_id, false)
end


function CanWinBeReordered()
  what = "test string"
  buf_text = vim.api.nvim_create_buf(false, true)

  buf_border = vim.api.nvim_create_buf(false, true)

  -- TODO: Handle list of lines
  vim.api.nvim_buf_set_lines(buf_text, 0, -1, true, {what})
  vim.api.nvim_buf_set_lines(buf_border, 0, -1, true, {"====", "", "====="})

  win_text = vim.api.nvim_open_win(buf_text, false, {relative='win', row=3, col=3, width=40, height=1})
  win_border = vim.api.nvim_open_win(buf_border, false, {relative='win', row=2, col=3, width=40, height=3})

  vim.api.nvim_win_close(win_text, false)
  vim.api.nvim_win_close(win_border, false)

  current_win_id = vim.fn.win_getid()
  _ = {vim.fn.win_gotoid(win_text), vim.cmd("sleep 100m"), vim.fn.win_gotoid(current_win_id)}
  _ = {vim.fn.win_gotoid(win_text), vim.cmd("redraw"), vim.fn.win_gotoid(current_win_id)}
end

function CanMakeBorders()
  package.loaded['plenary.window.border'] = nil
  package.loaded['plenary.popup'] = nil

  Popup = require('plenary.popup').popup_create("Hello world", {
    title = "Example",

    line = 3,
    col = 3,
    pos = "topleft"
  })
end

function CanDoTopWin()
  package.loaded['plenary.window.border'] = nil
  package.loaded['plenary.window.float'] = nil
  package.loaded['plenary.popup'] = nil
  package.loaded['plenary.run'] = nil

  -- require('plenary.window.float').centered_with_top_win({"hello world", "this is TJ"})
  require('plenary.run').with_displayed_output({"This is a comment", "At the top"}, "echo 'hello world'")
end
