--=============================================================================
-- pastebin.lua
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local job = require('spacevim.api.job')

local log = require('spacevim.logger').derive('pastebin')

local M = {}

local job_id = -1

local url = ''

local function eval(f)
  return f()
end

local function get_visual_selection()
  local pos_start = vim.fn.getpos("'<")
  local pos_end = vim.fn.getpos("'>")
  local line_start = pos_start[2]
  local column_start = pos_start[3]
  local line_end = pos_end[2]
  local column_end = pos_end[3]
  local lines = vim.fn.getline(line_start, line_end)
  if #lines == 0 then
    return ''
  end

  local v_mode = vim.fn.visualmode()

  if v_mode == 'v' or v_mode == 'V' then
    lines[#lines] = string.sub(
      lines[#lines],
      1,
      column_end - eval(function()
        if vim.o.selection == 'inclusive' then
          return 0
        else
          return 1
        end
      end)
    )
    lines[1] = string.sub(lines[1], column_start, #lines[1])
  else
    for i = 1, #lines, 1 do
      lines[i] = string.sub(
        lines[i],
        1,
        column_end - eval(function()
          if vim.o.selection == 'inclusive' then
            return 0
          else
            return 1
          end
        end)
      )
      lines[i] = string.sub(lines[i], column_start - 1, #lines[i])
    end
  end
  return table.concat(lines, '\n')
end

local function on_stdout(_, data)
  for _, v in ipairs(data) do
    log.info(v)
    if #v > 0 then
      url = v
    end
  end
end

local function on_stderr(_, data)
  for _, v in ipairs(data) do
    log.warn(v)
  end
end

local function on_exit(_, code, single)
  job_id = -1
  if code == 0 and single == 0 and url ~= '' then
    vim.fn.setreg('+', url .. '.txt')
    vim.api.nvim_echo({ { 'Pastebin:' .. url .. '.txt', 'Normal' } }, false, {})
  else
    log.warn('url:' .. url)
    log.warn('exit code:' .. code)
    log.warn('single code:' .. single)
  end
end

function M.paste()
  url = ''
  local context = get_visual_selection()
  log.debug('context is:\n' .. context)
  if context == '' then
    log.info('no selection text, skipped.')
    return
  end
  if job_id ~= -1 then
    log.info('previous job has not been finished, killed!')
    job.stop(job_id)
  end
  local cmd = { 'curl', '-s', '-F', 'content=<-', 'http://dpaste.com/api/v2/' }
  job_id = job.start(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = on_exit,
  })
  log.info('job id:' .. job_id)
  job.send(job_id, vim.split(context, '\n'))
  job.chanclose(job_id, 'stdin')
  job.stop(job_id)
end

return M
