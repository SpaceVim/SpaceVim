local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.arduino_language_server = {
  default_config = {
    cmd = { 'arduino-language-server' },
    filetypes = { 'arduino' },
    root_dir = function(fname)
      return util.root_pattern '*.ino'(fname)
    end,
    docs = {
      description = [[
https://github.com/arduino/arduino-language-server

Language server for Arduino

The `arduino-language-server` can be installed by running:
	go get -u github.com/arduino/arduino-language-server

The `arduino-cli` tools must also be installed. Follow these instructions for your distro:
	https://arduino.github.io/arduino-cli/latest/installation/

After installing the `arduino-cli` tools, follow these instructions for generating
a configuration file:
	https://arduino.github.io/arduino-cli/latest/getting-started/#create-a-configuration-file
and make sure you install any relevant platforms libraries:
	https://arduino.github.io/arduino-cli/latest/getting-started/#install-the-core-for-your-board

The language server also requires `clangd` be installed. It will look for `clangd` by default but
the binary path can be overridden if need be.

After all dependencies are installed you'll need to override the lspconfig command for the
language server in your setup function with the necessary configurations:

```lua
lspconfig.arduino_language_server.setup({
	cmd =  {
		-- Required
		"arduino-language-server",
		"-cli-config", "/path/to/arduino-cli.yaml",
		-- Optional
		"-cli", "/path/to/arduino-cli",
		"-clangd", "/path/to/clangd"
	}
})
```

For further instruction about configuration options, run `arduino-language-server --help`.

]],
    },
  },
}

-- vim:et ts=2 sw=2
