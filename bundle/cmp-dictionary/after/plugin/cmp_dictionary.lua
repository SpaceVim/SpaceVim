if vim.g.loaded_cmp_dictionary then
  return
end
vim.g.loaded_cmp_dictionary = true

require("cmp").register_source("dictionary", require("cmp_dictionary.source").new())

local update = require("cmp_dictionary").update

vim.api.nvim_create_user_command("CmpDictionaryUpdate", update, {})

vim.api.nvim_create_autocmd("OptionSet", {
  group = vim.api.nvim_create_augroup("cmp_dictionary_auto_update", {}),
  pattern = "dictionary",
  callback = update,
})

update()
