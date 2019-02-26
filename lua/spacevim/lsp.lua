function spacevim_lsp_doc_callback(success, data)
    if not success then
        return
    end
    vim.api.nvim_command('leftabove split __spacevim_lspdoc__')
    vim.api.nvim_command('set filetype=markdown')
    vim.api.nvim_command("call setline(1, luaeval('data'))")
end
