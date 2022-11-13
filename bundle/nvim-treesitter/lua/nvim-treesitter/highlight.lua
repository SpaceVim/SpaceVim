local api = vim.api
local ts = vim.treesitter

local parsers = require "nvim-treesitter.parsers"
local configs = require "nvim-treesitter.configs"

local M = {}

local hlmap = vim.treesitter.highlighter.hl_map

-- nvim-treesitter Highlight Group Mappings
-- Note: Some highlight groups may not be applied upstream, some may be experimental

hlmap["annotation"] = "TSAnnotation"

hlmap["attribute"] = "TSAttribute"

hlmap["boolean"] = "TSBoolean"

hlmap["character"] = "TSCharacter"
hlmap["character.special"] = "TSCharacterSpecial"

hlmap["comment"] = "TSComment"

hlmap["conditional"] = "TSConditional"

hlmap["constant"] = "TSConstant"
hlmap["constant.builtin"] = "TSConstBuiltin"
hlmap["constant.macro"] = "TSConstMacro"

hlmap["constructor"] = "TSConstructor"

hlmap["debug"] = "TSDebug"
hlmap["define"] = "TSDefine"

hlmap["error"] = "TSError"
hlmap["exception"] = "TSException"

hlmap["field"] = "TSField"

hlmap["float"] = "TSFloat"

hlmap["function"] = "TSFunction"
hlmap["function.builtin"] = "TSFuncBuiltin"
hlmap["function.macro"] = "TSFuncMacro"

hlmap["include"] = "TSInclude"

hlmap["keyword"] = "TSKeyword"
hlmap["keyword.function"] = "TSKeywordFunction"
hlmap["keyword.operator"] = "TSKeywordOperator"
hlmap["keyword.return"] = "TSKeywordReturn"

hlmap["label"] = "TSLabel"

hlmap["method"] = "TSMethod"

hlmap["namespace"] = "TSNamespace"

hlmap["none"] = "TSNone"
hlmap["number"] = "TSNumber"

hlmap["operator"] = "TSOperator"

hlmap["parameter"] = "TSParameter"
hlmap["parameter.reference"] = "TSParameterReference"

hlmap["preproc"] = "TSPreProc"

hlmap["property"] = "TSProperty"

hlmap["punctuation.delimiter"] = "TSPunctDelimiter"
hlmap["punctuation.bracket"] = "TSPunctBracket"
hlmap["punctuation.special"] = "TSPunctSpecial"

hlmap["repeat"] = "TSRepeat"

hlmap["storageclass"] = "TSStorageClass"

hlmap["string"] = "TSString"
hlmap["string.regex"] = "TSStringRegex"
hlmap["string.escape"] = "TSStringEscape"
hlmap["string.special"] = "TSStringSpecial"

hlmap["symbol"] = "TSSymbol"

hlmap["tag"] = "TSTag"
hlmap["tag.attribute"] = "TSTagAttribute"
hlmap["tag.delimiter"] = "TSTagDelimiter"

hlmap["text"] = "TSText"
hlmap["text.strong"] = "TSStrong"
hlmap["text.emphasis"] = "TSEmphasis"
hlmap["text.underline"] = "TSUnderline"
hlmap["text.strike"] = "TSStrike"
hlmap["text.title"] = "TSTitle"
hlmap["text.literal"] = "TSLiteral"
hlmap["text.uri"] = "TSURI"
hlmap["text.math"] = "TSMath"
hlmap["text.reference"] = "TSTextReference"
hlmap["text.environment"] = "TSEnvironment"
hlmap["text.environment.name"] = "TSEnvironmentName"

hlmap["text.note"] = "TSNote"
hlmap["text.warning"] = "TSWarning"
hlmap["text.danger"] = "TSDanger"

hlmap["todo"] = "TSTodo"

hlmap["type"] = "TSType"
hlmap["type.builtin"] = "TSTypeBuiltin"
hlmap["type.qualifier"] = "TSTypeQualifier"
hlmap["type.definition"] = "TSTypeDefinition"

hlmap["variable"] = "TSVariable"
hlmap["variable.builtin"] = "TSVariableBuiltin"

local function should_enable_vim_regex(config, lang)
  local additional_hl = config.additional_vim_regex_highlighting
  local is_table = type(additional_hl) == "table"

  return additional_hl and (not is_table or vim.tbl_contains(additional_hl, lang))
end

local function enable_syntax(bufnr)
  api.nvim_buf_set_option(bufnr, "syntax", "ON")
end

function M.stop(bufnr)
  if ts.highlighter.active[bufnr] then
    ts.highlighter.active[bufnr]:destroy()
  end
end

function M.start(bufnr, lang)
  local parser = parsers.get_parser(bufnr, lang)
  ts.highlighter.new(parser, {})
end

function M.attach(bufnr, lang)
  local config = configs.get_module "highlight"
  M.start(bufnr, lang)
  if should_enable_vim_regex(config, lang) then
    enable_syntax(bufnr)
  end
end

function M.detach(bufnr)
  M.stop(bufnr)
  enable_syntax(bufnr)
end

function M.set_custom_captures(captures)
  for k, v in pairs(captures) do
    hlmap[k] = v
  end
end

return M
