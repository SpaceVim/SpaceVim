if exists('g:lspconfig')
  finish
endif
let g:lspconfig = 1

lua << EOF
lsp_complete_configured_servers = function()
  return table.concat(require'lspconfig'.available_servers(), '\n')
end
lsp_get_active_client_ids = function()
  return vim.tbl_map(function(client)
    return ("%d (%s)"):format(client.id, client.name)
  end, vim.lsp.get_active_clients())
end
require'lspconfig'._root._setup()
EOF
