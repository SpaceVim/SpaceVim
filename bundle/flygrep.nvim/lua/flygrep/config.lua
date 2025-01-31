local M = {}

M.color_templete = {
  a = {
    fg = '#2c323c',
    bg = '#98c379',
    ctermfg = 16,
    ctermbg = 114,
    bold = true,
  },
  b = {
    fg = '#abb2bf',
    bg = '#3b4048',
    ctermfg = 145,
    ctermbg = 16,
    bold = false,
  },
}

M.command = {
  execute = 'rg',
  default_opts = {
    '--no-heading',
    '--color=never',
    '--with-filename',
    '--line-number',
    '--column',
    '-g',
    '!.git',
  },
  expr_opt = '-e',
  fixed_string_opt = '-F',
  default_fopts = { '-N' },
  smart_case = '-S',
  ignore_case = '-i',
  hidden_opt = '--hidden',
}

M.timeout = 200

M.matched_higroup = 'IncSearch'

M.enable_preview = false

M.setup = function(conf)
  if type(conf) ~= 'table' then
    return
  end

  M.color_templete = conf.color_templete or M.color_templete

  M.timeout = conf.timeout or M.timeout
end

return M
