# Updating Lua API Docs

1. Clone the neovim repo somewhere on your system
2. Run `./scripts/gen_vimdoc.py`
3. Copy `neovim/runtime/doc/*.mpack` files to the **neodev.nvim** data directory
4. Open the file `neodev.nvim/lua/build/api.lua` in Neovim
5. Execute `:luafile %`
6. You'll see a lot of annotations that might be changed due to your local
   system setup, so you can ignore those
7. Check if the changes you intended are present
8. Create a PR with your code changes, and **without** the new EmmyLua annotations
