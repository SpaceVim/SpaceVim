local _extensions = require "telescope._extensions"

local telescope = {}

-- TODO(conni2461): also table of contents for tree-sitter-lua
-- TODO: Add pre to the works
-- ---@pre [[
-- ---@pre ]]

---@brief [[
--- Telescope.nvim is a plugin for fuzzy finding and neovim. It helps you search,
--- filter, find and pick things in Lua.
---
--- Getting started with telescope:
---   1. Run `:checkhealth telescope` to make sure everything is installed.
---   2. Evaluate it is working with
---      `:Telescope find_files` or
---      `:lua require("telescope.builtin").find_files()`
---   3. Put a `require("telescope").setup()` call somewhere in your neovim config.
---   4. Read |telescope.setup| to check what config keys are available and what you can put inside the setup call
---   5. Read |telescope.builtin| to check which builtin pickers are offered and what options these implement
---   6. Profit
---
---  The below flow chart illustrates a simplified telescope architecture:
--- <pre>
--- ┌───────────────────────────────────────────────────────────┐
--- │      ┌────────┐                                           │
--- │      │ Multi  │                                ┌───────+  │
--- │      │ Select │    ┌───────┐                   │ Entry │  │
--- │      └─────┬──*    │ Entry │    ┌────────+     │ Maker │  │
--- │            │   ┌───│Manager│────│ Sorter │┐    └───┬───*  │
--- │            ▼   ▼   └───────*    └────────┘│        │      │
--- │            1────────┐                 2───┴──┐     │      │
--- │      ┌─────│ Picker │                 │Finder│◀────┘      │
--- │      ▼     └───┬────┘                 └──────*            │
--- │ ┌────────┐     │       3────────+         ▲               │
--- │ │Selected│     └───────│ Prompt │─────────┘               │
--- │ │ Entry  │             └───┬────┘                         │
--- │ └────────*             ┌───┴────┐  ┌────────┐  ┌────────┐ │
--- │     │  ▲    4─────────┐│ Prompt │  │(Attach)│  │Actions │ │
--- │     ▼  └──▶ │ Results ││ Buffer │◀─┤Mappings│◀─┤User Fn │ │
--- │5─────────┐  └─────────┘└────────┘  └────────┘  └────────┘ │
--- ││Previewer│                                                │
--- │└─────────┘                   telescope.nvim architecture  │
--- └───────────────────────────────────────────────────────────┘
---
---   + The `Entry Maker` at least defines
---     - value: "raw" result of the finder
---     - ordinal: string to be sorted derived from value
---     - display: line representation of entry in results buffer
---
---   * The finder, entry manager, selected entry, and multi selections
---     comprises `entries` constructed by the `Entry Maker` from
---     raw results of the finder (`value`s)
---
---  Primary components:
---   1 Picker: central UI dedicated to varying use cases
---             (finding files, grepping, diagnostics, etc.)
---             see :h telescope.builtin
---   2 Finder: pipe or interactively generates results to pick over
---   3 Prompt: user input that triggers the finder which sorts results
---             in order into the entry manager
---   4 Results: listed entries scored by sorter from finder results
---   5 Previewer: preview of context of selected entry
---                see :h telescope.previewers
--- </pre>
---
---  A practical introduction into telescope customization is our
---  `developers.md` (top-level of repo) and `:h telescope.actions` that
---  showcase how to access information about the state of the picker (current
---  selection, etc.).
--- <pre>
--- To find out more:
--- https://github.com/nvim-telescope/telescope.nvim
---
---   :h telescope.setup
---   :h telescope.command
---   :h telescope.builtin
---   :h telescope.themes
---   :h telescope.layout
---   :h telescope.resolve
---   :h telescope.actions
---   :h telescope.actions.state
---   :h telescope.actions.set
---   :h telescope.actions.utils
---   :h telescope.actions.generate
---   :h telescope.actions.history
---   :h telescope.previewers
--- </pre>
---@brief ]]

---@tag telescope.nvim
---@config { ["name"] = "INTRODUCTION" }

--- Setup function to be run by user. Configures the defaults, pickers and
--- extensions of telescope.
---
--- Usage:
--- <code>
--- require('telescope').setup{
---   defaults = {
---     -- Default configuration for telescope goes here:
---     -- config_key = value,
---     -- ..
---   },
---   pickers = {
---     -- Default configuration for builtin pickers goes here:
---     -- picker_name = {
---     --   picker_config_key = value,
---     --   ...
---     -- }
---     -- Now the picker_config_key will be applied every time you call this
---     -- builtin picker
---   },
---   extensions = {
---     -- Your extension configuration goes here:
---     -- extension_name = {
---     --   extension_config_key = value,
---     -- }
---     -- please take a look at the readme of the extension you want to configure
---   }
--- }
--- </code>
---@param opts table: Configuration opts. Keys: defaults, pickers, extensions
---@eval { ["description"] = require('telescope').__format_setup_keys() }
function telescope.setup(opts)
  opts = opts or {}

  if opts.default then
    error "'default' is not a valid value for setup. See 'defaults'"
  end

  require("telescope.config").set_defaults(opts.defaults)
  require("telescope.config").set_pickers(opts.pickers)
  _extensions.set_config(opts.extensions)
end

--- Load an extension.
--- - Notes:
---   - Loading triggers ext setup via the config passed in |telescope.setup|
---@param name string: Name of the extension
function telescope.load_extension(name)
  return _extensions.load(name)
end

--- Register an extension. To be used by plugin authors.
---@param mod table: Module
function telescope.register_extension(mod)
  return _extensions.register(mod)
end

--- Use telescope.extensions to reference any extensions within your configuration. <br>
--- While the docs currently generate this as a function, it's actually a table. Sorry.
telescope.extensions = require("telescope._extensions").manager

telescope.__format_setup_keys = function()
  local names = require("telescope.config").descriptions_order
  local descriptions = require("telescope.config").descriptions

  local result = { "<pre>", "", "Valid keys for {opts.defaults}" }
  for _, name in ipairs(names) do
    local desc = descriptions[name]

    table.insert(result, "")
    table.insert(result, string.format("%s*telescope.defaults.%s*", string.rep(" ", 70 - 20 - #name), name))
    table.insert(result, string.format("%s: ~", name))
    for _, line in ipairs(vim.split(desc, "\n")) do
      table.insert(result, string.format("    %s", line))
    end
  end

  table.insert(result, "</pre>")
  return result
end

return telescope
