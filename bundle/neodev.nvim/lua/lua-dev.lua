vim.notify(
  "'lua-dev' was renamed to 'neodev'. Please update your config.",
  vim.log.levels.WARN,
  { title = "neodev.nvim" }
)
return require("neodev")
