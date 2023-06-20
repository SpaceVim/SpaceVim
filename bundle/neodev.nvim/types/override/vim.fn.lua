return {
  ["vim.fn.getline"] = {
    params = {
      { name = "lnum", type = "number|string" },
    },
    overload = {
      "fun(lnum:number|string, end:number|string):string[]|nil[]",
    },
    ["return"] = {
      { type = "string" },
    },
  },
  ["vim.fn.expand"] = {
    params = {
      { name = "string", type = "string" },
      { name = "nosuf", type = "boolean", optional = true },
    },
    overload = {
      "fun(string:string, nosuf?:boolean, list:true):string[]",
    },
    ["return"] = {
      { type = "string" },
    },
  },
  ["vim.fn.glob"] = {
    params = {
      { name = "expr", type = "string" },
      { name = "nosuf", type = "boolean", optional = true },
    },
    overload = {
      "fun(expr:string, nosuf?:boolean, list:true):string[]",
      "fun(expr:string, nosuf?:boolean, list:true, alllinks:true):string[]",
    },
    ["return"] = {
      { type = "string" },
    },
  },
  ["vim.fn.sign_define"] = {
    overload = {
      "fun(name:string, dict?:table)",
    },
  },
  ["vim.fn.input"] = {
    params = {
      { name = "opts", type = "string|table<string, any>" },
    },
    ["return"] = {
      { type = "string" },
    },
  },
  ["vim.fn.searchpair"] = {
    params = {
      { name = "start", type = "string" },
      { name = "middle", type = "string", optional = true },
      { name = "end", type = "string" },
      { name = "flags", type = "string", optional = true },
      { name = "skip", type = "string", optional = true },
      { name = "stopline", type = "number", optional = true },
      { name = "timeout", type = "number", optional = true },
    },
  },
  ["vim.fn.searchpairpos"] = {
    params = {
      { name = "start", type = "string" },
      { name = "middle", type = "string", optional = true },
      { name = "end", type = "string" },
      { name = "flags", type = "string", optional = true },
      { name = "skip", type = "string", optional = true },
      { name = "stopline", type = "number", optional = true },
      { name = "timeout", type = "number", optional = true },
    },
  },
}
