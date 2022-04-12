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


-- *vim.lsp.diagnostic.set_loclist()*	Use |vim.diagnostic.setloclist()| instead.
-- *vim.lsp.diagnostic.set_qflist()*	Use |vim.diagnostic.setqflist()| instead.

function M.set_loclist()
    if vim.diagnostic ~= nil then
        vim.diagnostic.setloclist()
    else
        vim.lsp.diagnostic.set_loclist()
    end
end


function M.goto_next()
    if vim.diagnostic ~= nil then
        vim.diagnostic.goto_next()
    else
        vim.lsp.diagnostic.goto_next()
    end
    
end

function M.goto_prev()
    if vim.diagnostic ~= nil then
        vim.diagnostic.goto_prev()
    else
        vim.lsp.diagnostic.goto_prev()
    end
    
end

function M.hide()
    if vim.diagnostic ~= nil then
        vim.diagnostic.hide()
    else
        vim.lsp.diagnostic.clear()
    end
end

return M
