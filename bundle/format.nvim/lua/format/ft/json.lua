local M = {}

function M.enabled()
  return {'prettier'}
end

function M.prettier(opt)
    return {
        exe = 'prettier',
        args = {'--stdin-filepath', opt.filepath},
        stdin = true,
        }
end

return M
