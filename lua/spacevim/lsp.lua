-- lsp wrapper for neovim lsp api
--


local lsp = {}

function lsp.spacevim_lsp_doc_callback(success, data)
    if not success then
        return
    end
    vim.api.nvim_command('leftabove split __lspdoc__')
    vim.api.nvim_command('set filetype=markdown')
end

return lsp
