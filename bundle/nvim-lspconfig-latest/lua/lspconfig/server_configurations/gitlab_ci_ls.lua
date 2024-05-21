local util = require 'lspconfig.util'

local cache_dir = util.path.join(vim.loop.os_homedir(), '.cache/gitlab-ci-ls/')
return {
  default_config = {
    cmd = { 'gitlab-ci-ls' },
    filetypes = { 'yaml.gitlab' },
    root_dir = util.root_pattern('.gitlab*', '.git'),
    init_options = {
      cache_path = cache_dir,
      log_path = util.path.join(cache_dir, 'log/gitlab-ci-ls.log'),
    },
  },
  docs = {
    description = [[
https://github.com/alesbrelih/gitlab-ci-ls

Language Server for Gitlab CI

`gitlab-ci-ls` can be installed via cargo:
cargo install gitlab-ci-ls
]],
    default_config = {
      cmd = { 'gitlab-ci-ls' },
      filetypes = { 'yaml.gitlab' },
      root_dir = [[util.root_pattern('.gitlab*', '.git')]],
      init_options = {
        cache_path = [[util.path.join(vim.loop.os_homedir(), '.cache/gitlab-ci-ls/')]],
        log_path = [[util.path.join(util.path.join(vim.loop.os_homedir(), '.cache/gitlab-ci-ls/'), 'log/gitlab-ci-ls.log')]],
      },
    },
  },
}
