local level = 2
local info = debug.getinfo(1, 'Sf')
local source = info.source

local b = require('busted.core')()

b.register('file', 'file', {})

local testFileLoader = require 'busted.modules.standalone_loader'(b)
testFileLoader(info, { verbose = nil })

local execute = require('busted.execute')(b)

print(vim.inspect(execute))
print(vim.inspect(b))
print("===")
print(execute(1, {}))
print("===")
-- execute(1, {})

-- print(vim.inspect(b.execute))
-- print(vim.inspect(b.execute('file', './tests/plenary/bu/simple_busted_spec.lua')))
-- require('busted.init')(b)
-- print(vim.inspect(b))
