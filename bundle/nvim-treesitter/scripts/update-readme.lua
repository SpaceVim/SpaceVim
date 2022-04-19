-- Execute as `nvim --headless -c "luafile ./scripts/update-readme.lua"`
local parsers = require("nvim-treesitter.parsers").get_parser_configs()
local sorted_parsers = {}

for k, v in pairs(parsers) do
  table.insert(sorted_parsers, { name = k, parser = v })
end

table.sort(sorted_parsers, function(a, b)
  return a.name < b.name
end)

local generated_text = ""

for _, v in ipairs(sorted_parsers) do
  local link = "[" .. (v.parser.readme_name or v.name) .. "](" .. v.parser.install_info.url .. ")"

  if v.parser.maintainers then
    generated_text = generated_text
      .. "- [x] "
      .. link
      .. " ("
      .. (v.parser.experimental and "experimental, " or "")
      .. "maintained by "
      .. table.concat(v.parser.maintainers, ", ")
      .. ")\n"
  else
    generated_text = generated_text .. "- [ ] " .. link .. "\n"
  end
end

print(generated_text)
print "\n"

local readme_text = table.concat(vim.fn.readfile "README.md", "\n")

local new_readme_text = string.gsub(
  readme_text,
  "<!%-%-parserinfo%-%->.*<!%-%-parserinfo%-%->",
  "<!--parserinfo-->\n" .. generated_text .. "<!--parserinfo-->"
)
vim.fn.writefile(vim.fn.split(new_readme_text, "\n"), "README.md")

if string.find(readme_text, generated_text, 1, "plain") then
  print "README.md is up-to-date!"
  vim.cmd "q"
else
  print "New README.md was written. Please commit that change! Old text was: "
  print(string.sub(readme_text, string.find(readme_text, "<!%-%-parserinfo%-%->.*<!%-%-parserinfo%-%->")))
  vim.cmd "cq"
end
