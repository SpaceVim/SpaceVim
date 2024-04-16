local M = {}

function M.enabled()
  return { 'stylua' }
end

function M.stylua(opt)
  return {
    exe = 'stylua',
    args = { '-' },
    stdin = true,
  }
end

return M
