return {
  ["vim.wait"] = {
    params = {
      { name = "time", type = "number" },
      { name = "condition", type = "fun(): boolean", optional = true },
      { name = "interval", type = "number", optional = true },
      { name = "fast_only", type = "boolean", optional = true },
    },
    ["return"] = {
      { type = "boolean, nil|number" },
    },
  },
}
