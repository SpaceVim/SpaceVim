local M = {}

-- The following have been replaced by |vim.diagnostic.open_float()|.
--
-- *vim.lsp.diagnostic.show_line_diagnostics()*
-- *vim.lsp.diagnostic.show_position_diagnostics()*

function M.open_float()
    if vim.diagnostic ~= nil then
        vim.diagnostic.open_float()
    else
        vim.lsp.diagnostic.show_line_diagnostics()
    end

end


return M
