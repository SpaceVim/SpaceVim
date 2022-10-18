if vim.b.did_ftp == true then
    return
end

vim.opt_local.cursorline = true
vim.opt_local.modifiable = true
vim.opt_local.buflisted = true
vim.opt_local.syntax = "zkbrowser"
vim.opt_local.buftype = "nofile"
vim.opt_local.swapfile = false
vim.opt_local.iskeyword:append(":")
vim.opt_local.iskeyword:append("-")
vim.opt_local.suffixesadd:append(".md")
vim.opt_local.errorformat = "%f:%l: %m"

if vim.opt_local.keywordprg:get() == "" then
    vim.opt_local.keywordprg = ":ZkHover -preview"
end

if vim.opt_local.tagfunc:get() == "" then
    vim.opt_local.tagfunc = "v:lua.zettelkasten.tagfunc"
end

require("zettelkasten").add_hover_command()

if vim.fn.mapcheck("[I", "n") == "" then
    vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "[I",
        '<CMD>lua require("zettelkasten").show_back_references(vim.fn.expand("<cword>"))<CR>',
        { noremap = true, silent = true, nowait = true }
    )
end

local config = require("zettelkasten.config").get()
if config.notes_path ~= "" then
    vim.cmd("lcd " .. config.notes_path)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = vim.api.nvim_create_augroup("zettelkasten_browser_events", { clear = true }),
    buffer = vim.api.nvim_get_current_buf(),
    callback = function(opts)
        vim.opt_local.syntax = ""
        vim.api.nvim_buf_set_lines(
            0,
            vim.fn.line("$") - 1,
            -1,
            true,
            require("zettelkasten").get_note_browser_content()
        )
        vim.opt_local.syntax = "zkbrowser"
    end,
})
