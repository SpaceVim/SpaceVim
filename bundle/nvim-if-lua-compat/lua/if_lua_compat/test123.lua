require('if_lua_compat')
local b = vim.buffer()
-- b()
-- print(#b)
-- print(b[154])
-- print(b.name)
-- print(b.fname)
-- print(b.number)
-- b:insert('hello', 127)
-- print(b:isvalid())
-- print(b:next())
-- print(b:previous())
-- print(vim.type(b))
-- print(b:next().name)
-- print(b:previous().name)

local w = vim.window()
-- w()
-- print(w.buffer.name)
-- print(w.line)
-- w.line = 20
-- print(w.col)
-- w.col = 3
-- print(w.width)
-- w.width = 60
-- print(w.height)
-- w.height = 20
-- w:next()
-- w:previous()
-- print(w:isvalid())
-- print(vim.type(w))
-- print(w:next().height)
-- print(w:previous().line)


-- print(vim.type(3))
-- print(vim.type({}))
-- print(vim.type('str'))


local l = vim.list({1, test = 2, 3})
-- print(l[2])
-- print(l.test)
-- print(vim.type(l))
-- print(#l)
-- for v in l() do
--     print(v)
-- end
-- table.insert(l, 4)
-- table.insert(l, 2, 2)
-- table.insert(l, 2, 2)
-- print(l[2])
-- print(l[4])
-- print(vim.inspect(l))
-- table.remove(l, 4)
-- print(vim.inspect(l))
-- l.test = 'hello'
-- print(l.test)
-- l:add(4)
-- l:insert('test', 1)
-- l:insert('test2')
-- for k, v in l() do
--     print(k, v)
-- end

local d = vim.dict({1, test = 2, 3})
-- print(d.test)
-- print(d['test'])
-- print(d[1])
-- print(d[2])
-- for k, v in d() do
--     print(k, v)
-- end
-- print(#d)
-- print(vim.type(d))
-- d[4] = 4
-- print(d['4'], d[4])
-- d[true] = 1

vim.beep()

-- vim.open('init.lua')
-- vim.open('not_a_file')
-- vim.open(1)
-- vim.open()
-- vim.open(true)
-- vim.open({})

local f = vim.funcref('printf')
-- local invalid_f = vim.funcref('ffffff')
-- local invalid_type = vim.funcref({})

-- f()

local bl = vim.blob('test')
local bl2 = vim.blob('😀')
local bl3 = vim.blob()
-- print(vim.inspect(bl))
-- print(vim.inspect(bl2))
-- local tbl = {}
-- bl2:add(1.1)
--
-- print(vim.inspect(bl2))
--
-- for i = 0, #bl2 do
--     table.insert(tbl, string.char(bl2[i]))
-- end
--
-- print(table.concat(tbl))
-- bl3:add('test')
