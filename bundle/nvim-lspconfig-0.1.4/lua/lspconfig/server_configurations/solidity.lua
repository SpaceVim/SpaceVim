local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'solidity-ls', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern('.git', 'package.json'),
    settings = { solidity = { includePath = '', remapping = {} } },
  },
  docs = {
    description = [[
https://github.com/qiuxiang/solidity-ls

npm i solidity-ls -g

Make sure that solc is installed and it's the same version of the file.  solc-select is recommended.

Solidity language server is a LSP with autocomplete, go to definition and diagnostics.

If you use brownie, use this root_dir:
root_dir = util.root_pattern('brownie-config.yaml', '.git')

on includePath, you can add an extra path to search for external libs, on remapping you can remap lib <> path, like:

```lua
{ solidity = { includePath = '/Users/your_user/.brownie/packages/', remapping = { ["@OpenZeppelin/"] = 'OpenZeppelin/openzeppelin-contracts@4.6.0/' } } }
```

**For brownie users**
Change the root_dir to:

```lua
root_pattern("brownie-config.yaml", ".git")
```

The best way of using it is to have a package.json in your project folder with the packages that you will use.
After installing with package.json, just create a `remappings.txt` with:

```
@OpenZeppelin/=node_modules/OpenZeppelin/openzeppelin-contracts@4.6.0/
```

You can omit the node_modules as well.
]],
    default_config = {
      root_dir = [[root_pattern("package.json", ".git")]],
    },
  },
}
