local M = {}

local logger = require('spacevim.api').import('logger')
local cmd = require('spacevim').cmd
local fn = nil
if vim.fn == nil then
    fn = require('spacevim').fn
else
    fn = vim.fn
end

logger.set_name('SpaceVim')
logger.set_level(1)
logger.set_silent(1)
logger.set_verbose(1)



function M.info(msg)
    logger.info(msg)
end

function M.warn(msg, ...)
    logger.warn(msg, ...)
end

function M.error(msg)
    logger.error(msg)
end

function M.setLevel(level)
    logger.set_level(level)
end

function M.setOutput(file)
    logger.set_file(file)
end

function M.viewRuntimeLog()
  local info = "### SpaceVim runtime log :\n\n"
  ..  "```log\n"
  .. logger.view(logger.level)
  .. "\n```\n"
  cmd('tabnew')
  cmd('setl nobuflisted')
  cmd('nnoremap <buffer><silent> q :tabclose!<CR>')
  -- put info into buffer
  fn.append(0, fn.split(info, "\n"))
  cmd('setl nomodifiable')
  cmd('setl buftype=nofile')
  cmd('setl filetype=markdown')
  M.syntax_extra()
end

function M.syntax_extra()
  fn.matchadd('ErrorMsg','.*[\\sError\\s\\].*')
  fn.matchadd('WarningMsg','.*[\\sWarn\\s\\].*')
end

function M.derive(name)
    local derive = {}
    derive['origin_name'] = logger.get_name()

    function derive.info()
        logger.set_name(self.derive_name)
        logger.info(msg)
        logger.set_name(self.origin_name)
    end
    function derive.warn()
        logger.set_name(self.derive_name)
        logger.warn(msg)
        logger.set_name(self.origin_name)
    end
    function derive.error()
        logger.set_name(self.derive_name)
        logger.error(msg)
        logger.set_name(self.origin_name)
    end

    derive['derive_name'] = fn.printf('%' .. fn.strdisplaywidth(logger.get_name()) .. 'S', name)
    return derive
end

return M
