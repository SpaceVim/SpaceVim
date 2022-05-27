local a = require "plenary.async.async"

local M = {}

---This will be deprecated because the callback can be called multiple times.
---This will give a coroutine error because the coroutine will be resumed multiple times.
---Please use buf_request_all instead.
M.buf_request = a.wrap(vim.lsp.buf_request, 4)

M.buf_request_all = a.wrap(vim.lsp.buf_request_all, 4)

return M
