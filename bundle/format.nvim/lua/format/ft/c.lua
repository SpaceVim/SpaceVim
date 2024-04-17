local M = {}

function M.enabled()
  return { 'uncrustify', 'clangformat', 'astyle' }
end

function M.clangformat(opt)
  return {
    exe = 'clang-format',
    args = { '-assume-filename=' .. opt.filepath },
    stdin = true,
  }
end

function M.uncrustify(opt)
  return {
    exe = 'uncrustify',
    args = { '-q', '-l', 'C' },
    stdin = true,
  }
end

function M.astyle(opt)
  return {
    exe = 'astyle',
    args = {'--mode=c'},
    stdin = true
  }
end

return M
