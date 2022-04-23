--
--------------------------------------------------------------------------------
--         File:  candidates.lua
--------------------------------------------------------------------------------
--

local api = vim.api

local get_candidates = function(_, arg1, arg2)
  -- For neovim 0.5.1/0.6 breaking changes
  -- https://github.com/neovim/neovim/pull/15504
  local result = ((vim.fn.has('nvim-0.6') == 1 or vim.fn.has('nvim-0.5.1'))
                  and type(arg1) == 'table' and arg1 or arg2)
  if not result or result == 0 then
    return
  end

  local success = (type(result) == 'table' and not vim.tbl_isempty(result)
    ) and true or false
  result = result['items'] ~= nil and result['items'] or result

  if #result > 0 then
    api.nvim_set_var('deoplete#source#lsp#_results', result)
    api.nvim_set_var('deoplete#source#lsp#_success', success)
    api.nvim_set_var('deoplete#source#lsp#_requested', true)
    api.nvim_call_function('deoplete#auto_complete', {})
  end
end

local request_candidates = function(arguments)
  vim.lsp.buf_request(0, 'textDocument/completion', arguments, get_candidates)
end

return {
  request_candidates = request_candidates
}
