if exists('g:lspconfig')
  finish
endif
let g:lspconfig = 1

lua << EOF
lsp_complete_configured_servers = function()
  return table.concat(require'lspconfig'.available_servers(), '\n')
end
lsp_get_active_client_ids = function()
  client_ids = {}
  for idx, client in ipairs(vim.lsp.get_active_clients()) do
    table.insert(client_ids, tostring(client.id))
  end
  return client_ids
end
require'lspconfig'._root._setup()
EOF
