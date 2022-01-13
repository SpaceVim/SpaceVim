local misc = require('cmp.utils.misc')
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/
---@class lsp
local lsp = {}

lsp.Position = {}

---Convert lsp.Position to vim.Position
---@param buf number|string
---@param position lsp.Position
---@return vim.Position
lsp.Position.to_vim = function(buf, position)
  if not vim.api.nvim_buf_is_loaded(buf) then
    vim.fn.bufload(buf)
  end
  local lines = vim.api.nvim_buf_get_lines(buf, position.line, position.line + 1, false)
  if #lines > 0 then
    return {
      row = position.line + 1,
      col = misc.to_vimindex(lines[1], position.character),
    }
  end
  return {
    row = position.line + 1,
    col = position.character + 1,
  }
end

---Convert lsp.Position to vim.Position
---@param buf number|string
---@param position vim.Position
---@return lsp.Position
lsp.Position.to_lsp = function(buf, position)
  if not vim.api.nvim_buf_is_loaded(buf) then
    vim.fn.bufload(buf)
  end
  local lines = vim.api.nvim_buf_get_lines(buf, position.row - 1, position.row, false)
  if #lines > 0 then
    return {
      line = position.row - 1,
      character = misc.to_utfindex(lines[1], position.col),
    }
  end
  return {
    line = position.row - 1,
    character = position.col - 1,
  }
end

lsp.Range = {}

---Convert lsp.Position to vim.Position
---@param buf number|string
---@param range lsp.Range
---@return vim.Range
lsp.Range.to_vim = function(buf, range)
  return {
    start = lsp.Position.to_vim(buf, range.start),
    ['end'] = lsp.Position.to_vim(buf, range['end']),
  }
end

---Convert lsp.Position to vim.Position
---@param buf number|string
---@param range vim.Range
---@return lsp.Range
lsp.Range.to_lsp = function(buf, range)
  return {
    start = lsp.Position.to_lsp(buf, range.start),
    ['end'] = lsp.Position.to_lsp(buf, range['end']),
  }
end

---@alias lsp.CompletionTriggerKind "1" | "2" | "3"
lsp.CompletionTriggerKind = {}
lsp.CompletionTriggerKind.Invoked = 1
lsp.CompletionTriggerKind.TriggerCharacter = 2
lsp.CompletionTriggerKind.TriggerForIncompleteCompletions = 3

---@class lsp.CompletionContext
---@field public triggerKind lsp.CompletionTriggerKind
---@field public triggerCharacter string|nil

---@alias lsp.InsertTextFormat "1" | "2"
lsp.InsertTextFormat = {}
lsp.InsertTextFormat.PlainText = 1
lsp.InsertTextFormat.Snippet = 2
lsp.InsertTextFormat = vim.tbl_add_reverse_lookup(lsp.InsertTextFormat)

---@alias lsp.InsertTextMode "1" | "2"
lsp.InsertTextMode = {}
lsp.InsertTextMode.AsIs = 0
lsp.InsertTextMode.AdjustIndentation = 1
lsp.InsertTextMode = vim.tbl_add_reverse_lookup(lsp.InsertTextMode)

---@alias lsp.MarkupKind "'plaintext'" | "'markdown'"
lsp.MarkupKind = {}
lsp.MarkupKind.PlainText = 'plaintext'
lsp.MarkupKind.Markdown = 'markdown'
lsp.MarkupKind.Markdown = 'markdown'
lsp.MarkupKind = vim.tbl_add_reverse_lookup(lsp.MarkupKind)

---@alias lsp.CompletionItemTag "1"
lsp.CompletionItemTag = {}
lsp.CompletionItemTag.Deprecated = 1
lsp.CompletionItemTag = vim.tbl_add_reverse_lookup(lsp.CompletionItemTag)

---@alias lsp.CompletionItemKind "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "10" | "11" | "12" | "13" | "14" | "15" | "16" | "17" | "18" | "19" | "20" | "21" | "22" | "23" | "24" | "25"
lsp.CompletionItemKind = {}
lsp.CompletionItemKind.Text = 1
lsp.CompletionItemKind.Method = 2
lsp.CompletionItemKind.Function = 3
lsp.CompletionItemKind.Constructor = 4
lsp.CompletionItemKind.Field = 5
lsp.CompletionItemKind.Variable = 6
lsp.CompletionItemKind.Class = 7
lsp.CompletionItemKind.Interface = 8
lsp.CompletionItemKind.Module = 9
lsp.CompletionItemKind.Property = 10
lsp.CompletionItemKind.Unit = 11
lsp.CompletionItemKind.Value = 12
lsp.CompletionItemKind.Enum = 13
lsp.CompletionItemKind.Keyword = 14
lsp.CompletionItemKind.Snippet = 15
lsp.CompletionItemKind.Color = 16
lsp.CompletionItemKind.File = 17
lsp.CompletionItemKind.Reference = 18
lsp.CompletionItemKind.Folder = 19
lsp.CompletionItemKind.EnumMember = 20
lsp.CompletionItemKind.Constant = 21
lsp.CompletionItemKind.Struct = 22
lsp.CompletionItemKind.Event = 23
lsp.CompletionItemKind.Operator = 24
lsp.CompletionItemKind.TypeParameter = 25
lsp.CompletionItemKind = vim.tbl_add_reverse_lookup(lsp.CompletionItemKind)

---@class lsp.CompletionList
---@field public isIncomplete boolean
---@field public items lsp.CompletionItem[]

---@alias lsp.CompletionResponse lsp.CompletionList|lsp.CompletionItem[]|nil

---@class lsp.MarkupContent
---@field public kind lsp.MarkupKind
---@field public value string

---@class lsp.Position
---@field public line number
---@field public character number

---@class lsp.Range
---@field public start lsp.Position
---@field public end lsp.Position

---@class lsp.Command
---@field public title string
---@field public command string
---@field public arguments any[]|nil

---@class lsp.TextEdit
---@field public range lsp.Range|nil
---@field public newText string

---@class lsp.InsertReplaceTextEdit
---@field public insert lsp.Range|nil
---@field public replace lsp.Range|nil
---@field public newText string

---@class lsp.CompletionItemLabelDetails
---@field public detail string|nil
---@field public description string|nil

---@class lsp.CompletionItem
---@field public label string
---@field public labelDetails lsp.CompletionItemLabelDetails|nil
---@field public kind lsp.CompletionItemKind|nil
---@field public tags lsp.CompletionItemTag[]|nil
---@field public detail string|nil
---@field public documentation lsp.MarkupContent|string|nil
---@field public deprecated boolean|nil
---@field public preselect boolean|nil
---@field public sortText string|nil
---@field public filterText string|nil
---@field public insertText string|nil
---@field public insertTextFormat lsp.InsertTextFormat
---@field public insertTextMode lsp.InsertTextMode
---@field public textEdit lsp.TextEdit|lsp.InsertReplaceTextEdit|nil
---@field public additionalTextEdits lsp.TextEdit[]
---@field public commitCharacters string[]|nil
---@field public command lsp.Command|nil
---@field public data any|nil
---
---TODO: Should send the issue for upstream?
---@field public word string|nil
---@field public dup boolean|nil

return lsp
