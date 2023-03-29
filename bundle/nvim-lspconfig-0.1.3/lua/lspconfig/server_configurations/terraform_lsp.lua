local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'terraform-lsp' },
    filetypes = { 'terraform', 'hcl' },
    root_dir = util.root_pattern('.terraform', '.git'),
  },
  docs = {
    description = [[
https://github.com/juliosueiras/terraform-lsp

Terraform language server
Download a released binary from
https://github.com/juliosueiras/terraform-lsp/releases.

From https://github.com/hashicorp/terraform-ls#terraform-ls-vs-terraform-lsp:

Both HashiCorp and the maintainer of terraform-lsp expressed interest in
collaborating on a language server and are working towards a _long-term_
goal of a single stable and feature-complete implementation.

For the time being both projects continue to exist, giving users the
choice:

- `terraform-ls` providing
  - overall stability (by relying only on public APIs)
  - compatibility with any provider and any Terraform >=0.12.0 currently
    less features
  - due to project being younger and relying on public APIs which may
    not offer the same functionality yet

- `terraform-lsp` providing
  - currently more features
  - compatibility with a single particular Terraform (0.12.20 at time of writing)
    - configs designed for other 0.12 versions may work, but interpretation may be inaccurate
  - less stability (due to reliance on Terraform's own internal packages)
]],
    default_config = {
      root_dir = [[root_pattern(".terraform", ".git")]],
    },
  },
}
