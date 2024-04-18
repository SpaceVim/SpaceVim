local M = {}

function M.enabled()
  return { 'rustfmt' }
end

function M.rustfmt(opt)
  return {
    exe = 'rustfmt',
    args = {},
    stdin = true,
  }
end

return M
