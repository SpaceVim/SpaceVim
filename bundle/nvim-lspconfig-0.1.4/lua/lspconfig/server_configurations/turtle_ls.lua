local util = require 'lspconfig.util'

local bin_name = 'turtle-language-server'
local bin_path = os.getenv 'NVM_BIN'
local full_path
if bin_path == nil then
  local paths = {}
  local sep = ':'
  if vim.fn.has 'win32' == 1 then
    sep = ';'
  end
  local path = os.getenv 'PATH'
  if path ~= nil then
    for str in string.gmatch(path, '([^' .. sep .. ']+)') do
      table.insert(paths, str)
    end
  end
  for _, p in ipairs(paths) do
    local candidate = util.path.join(p, bin_name)
    if util.path.is_file(candidate) then
      full_path = candidate
      break
    end
  end
else
  full_path = util.path.join(bin_path, bin_name)
end

local cmd = { 'node', full_path, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', 'node', full_path, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'turtle', 'ttl' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/stardog-union/stardog-language-servers/tree/master/packages/turtle-language-server
`turtle-language-server`, An editor-agnostic server providing language intelligence (diagnostics, hover tooltips, etc.) for the W3C standard Turtle RDF syntax via the Language Server Protocol.
installable via npm install -g turtle-language-server or yarn global add turtle-language-server.
requires node.
]],
  },
}
