local lspkind = {}
local fmt = string.format

local kind_presets = {
  default = {
-- if you change or add symbol here
-- replace corresponding line in readme
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
  },
  codicons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
}

local kind_order = {
  'Text', 'Method', 'Function', 'Constructor', 'Field', 'Variable', 'Class', 'Interface', 'Module',
  'Property', 'Unit', 'Value', 'Enum', 'Keyword', 'Snippet', 'Color', 'File', 'Reference', 'Folder',
  'EnumMember', 'Constant', 'Struct', 'Event', 'Operator', 'TypeParameter'
}
local kind_len = 25

-- default true
local function opt_with_text(opts)
  return opts == nil or opts['with_text'] == nil or opts['with_text']
end

-- default 'default'
local function opt_preset(opts)
  local preset
  if opts == nil or opts['preset'] == nil then
    preset = 'default'
  else
    preset = opts['preset']
  end
  return preset
end

function lspkind.init(opts)
  local preset = opt_preset(opts)

  local symbol_map = kind_presets[preset]
  lspkind.symbol_map = (opts and opts['symbol_map'] and
                       vim.tbl_extend('force', symbol_map, opts['symbol_map'])) or symbol_map

  local symbols = {}
  local len = kind_len
  for i = 1, len do
    local name = kind_order[i]
    symbols[i] = lspkind.symbolic(name, opts)
  end

  for k,v in pairs(symbols) do
    require('vim.lsp.protocol').CompletionItemKind[k] = v
  end
end

lspkind.presets = kind_presets
lspkind.symbol_map = kind_presets.default

function lspkind.symbolic(kind, opts)
  local with_text = opt_with_text(opts)

  local symbol = lspkind.symbol_map[kind]
  if with_text == true then
    symbol = symbol and (symbol .. ' ') or ''
    return fmt('%s%s', symbol, kind)
  else
    return symbol
  end
end

function lspkind.cmp_format(opts)
  if opts == nil then
    opts = {}
  end
  if opts.preset or opts.symbol_map then
    lspkind.init(opts)
  end

  return function(entry, vim_item)
    vim_item.kind = lspkind.symbolic(vim_item.kind, opts)

    if opts.menu ~= nil then
      vim_item.menu = opts.menu[entry.source.name]
    end

    if opts.maxwidth ~= nil then
        vim_item.abbr = string.sub(vim_item.abbr, 1, opts.maxwidth)
    end

    return vim_item
  end
end

return lspkind
