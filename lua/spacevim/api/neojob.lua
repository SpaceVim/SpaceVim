local job = require('spacevim.api.job')
local nt = require('spacevim.api.notify')

local text = {}
local function on_stdout(id, data)
  nt.notify('stdout:' .. #data)
  for _, v in ipairs(data) do
    table.insert(text, v)
  end
end

local function on_stderr(id, data)
  nt.notify('stdout')
end

local function on_exit(id, code, single)
  nt.notify('done')
  -- vim.api.nvim_buf_set_lines(0, 0, -1, false, text)
end

-- local id = job.start({ vim.fn.exepath('prettier'), '--stdin-filepath', 't.md' }, {
local id = job.start({ 'cat' }, {
  on_stdout = on_stdout,
  on_stderr = on_stderr,
  on_exit = on_exit,
})

job.send(id, vim.api.nvim_buf_get_lines(0, 0, -1, false))
job.send(id, nil)
-- job.chanclose(id, 'stdin')
-- job.stop(id)

-- local id2 = vim.fn.jobstart('cat', {
-- on_stdout = on_stdout,
-- on_stderr = on_stderr,
-- on_exit = on_exit,
-- })
--
-- vim.fn.chansend(id2, vim.api.nvim_buf_get_lines(0, 0, -1, false))
-- vim.fn.jobstop(id2)
