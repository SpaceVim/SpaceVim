local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'arduino' },
    root_dir = util.root_pattern '*.ino',
  },
  docs = {
    description = [[
https://github.com/arduino/arduino-language-server

Language server for Arduino

The `arduino-language-server` can be installed by running:

```
go install github.com/arduino/arduino-language-server@latest
```

The `arduino-cli` tool must also be installed. Follow [these
installation instructions](https://arduino.github.io/arduino-cli/latest/installation/) for
your platform.

After installing `arduino-cli`, follow [these
instructions](https://arduino.github.io/arduino-cli/latest/getting-started/#create-a-configuration-file)
for generating a configuration file if you haven't done so already, and make
sure you [install any relevant platforms
libraries](https://arduino.github.io/arduino-cli/latest/getting-started/#install-the-core-for-your-board).
Make sure to save the full path to the created `arduino-cli.yaml` file for later.

The language server also requires `clangd` to be installed. Follow [these
installation instructions](https://clangd.llvm.org/installation) for your
platform.

Next, you will need to decide which FQBN to use.
To identify the available FQBNs for boards you currently have connected, you may use the `arduino-cli` command, like so:

```sh
$ arduino-cli board list
Port         Protocol Type              Board Name  FQBN            Core
/dev/ttyACM0 serial   Serial Port (USB) Arduino Uno arduino:avr:uno arduino:avr
                                                    ^^^^^^^^^^^^^^^
```

After all dependencies are installed you'll need to set the command for the
language server in your setup:

```lua
require'lspconfig'.arduino_language_server.setup {
  cmd = {
    "arduino-language-server",
    "-cli-config", "/path/to/arduino-cli.yaml",
    "-fqbn", "arduino:avr:uno",
    "-cli", "arduino-cli",
    "-clangd", "clangd"
  }
}
```

For further instruction about configuration options, run `arduino-language-server --help`.
]],
  },
}
