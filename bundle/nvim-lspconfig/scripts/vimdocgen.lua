local docgen = require 'babelfish'

local docs = {}

docs.generate = function()
  local metadata = {
    input_file = './README.md',
    output_file = './doc/lspconfig.txt',
    project_name = 'lspconfig',
    header_aliases = {
      ['Example: using the defaults'] = { 'Defaults', 'defaults' },
      ['Example: override some defaults'] = { 'Overriding server defaults', 'override-server-defaults' },
      ['Example: custom config'] = { 'Custom config', 'custom-config' },
      ['Example: override default config for all servers'] = { 'Overriding all defaults', 'override-all-defaults' },
      ['Individual server settings and initialization options'] = {
        'Per-server documentation',
        'server-documentation',
      },
      ['Keybindings and completion'] = { 'Keybindings', 'keybindings' },
      ['Manually starting (or restarting) language servers'] = { 'Manual control', 'manual-control' },
    },
  }
  docgen.generate_readme(metadata)
end

docs.generate()

return docs
