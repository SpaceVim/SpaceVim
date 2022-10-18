local zk = require("zettelkasten")

if vim.opt_local.tagfunc:get() == "" then
    vim.opt_local.tagfunc = "v:lua.zettelkasten.tagfunc"
end

if vim.opt_local.completefunc:get() == "" then
    vim.opt_local.completefunc = "v:lua.zettelkasten.completefunc"
end

vim.opt.isfname:append(":")
vim.opt.isfname:append("-")
vim.opt_local.iskeyword:append(":")
vim.opt_local.iskeyword:append("-")
vim.opt_local.suffixesadd:append(".md")
vim.opt_local.errorformat = "%f:%l: %m"
vim.opt_local.include = "[[\\s]]"
vim.opt_local.define = "^# \\s*"

if vim.opt_local.keywordprg:get() == "" then
    vim.opt_local.keywordprg = ":ZkHover"
end

if vim.fn.mapcheck("[I", "n") == "" then
    vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "[I",
        '<CMD>lua require("zettelkasten").show_back_references(vim.fn.expand("<cword>"))<CR>',
        { noremap = true, silent = true, nowait = true }
    )
end

require("zettelkasten").add_hover_command()
