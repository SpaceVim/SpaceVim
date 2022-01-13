function! health#lspconfig#check()
  call health#report_start('Checking language server protocol configuration')
  lua require 'lspconfig/health'.check_health()
endfunction
