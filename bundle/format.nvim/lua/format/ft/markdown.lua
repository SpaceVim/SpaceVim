if vim.fn.executable('prettier') == 1 then
  return {
    exe = vim.fn.exepath('prettier'),
    name = 'prettier',
    args = {'--stdin-filepath', 't.md'},
    stdin = true
  }
end
