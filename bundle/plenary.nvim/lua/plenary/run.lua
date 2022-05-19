local floatwin = require "plenary.window.float"

local run = {}

run.with_displayed_output = function(title_text, cmd, opts)
  local views = floatwin.centered_with_top_win(title_text)

  local job_id = vim.fn.termopen(cmd)

  local count = 0
  while not vim.wait(1000, function()
    return vim.fn.jobwait({ job_id }, 0)[1] == -1
  end) do
    vim.cmd [[normal! G]]
    count = count + 1

    if count == 10 then
      break
    end
  end

  vim.fn.win_gotoid(views.win_id)
  vim.cmd [[startinsert]]

  return views.bufnr, views.win_id
end

return run
