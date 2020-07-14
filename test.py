import vim
import string
bufnr = int(vim.eval("a:buffer"))
start_line = int(vim.eval("a:start"))
if start_line < -1:
    start_line += 1
end_line = int(vim.eval("a:end"))
if end_line < -1:
    end_line += 1
lines = vim.eval("a:replacement")
vim.buffers[bufnr][start_line:end_line] = lines
