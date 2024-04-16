local M = {}

function M.enabled()
  return { 'prettier' }
end

function M.prettier(opt)
  return {
    exe = vim.fn.exepath('prettier'),
    name = 'prettier',
    args = {'--stdin-filepath', opt.filepath},
    stdin = true
  }
end

return M
