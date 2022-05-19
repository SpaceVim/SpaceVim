-------------------------------------------------------------------------------
-- This module implements a function that traverses all live objects.
-- You can implement your own function to pass as a parameter of traverse
-- and give you the information you want. As an example we have implemented
-- countreferences and findallpaths
--
-- Alexandra Barros - 2006.03.15
-------------------------------------------------------------------------------

module("gc", package.seeall)

local List = {}

function List.new ()
	return {first = 0, last = -1}
end

function List.push (list, value)
	local last = list.last + 1
    list.last = last
    list[last] = value
end

function List.pop (list)	
    local first = list.first
    if first > list.last then error("list is empty") end
    local value = list[first]
    list[first] = nil        
    list.first = first + 1
    return value
end

function List.isempty (list)
	return list.first > list.last
end

-- Counts all references for a given object
function countreferences(value)
	local count = -1 
	local f = function(from, to, how, v)
		if to == value then 
			count = count + 1
		end 
	end	
	traverse({edge=f}, {count, f})
	return count
end

-- Prints all paths to an object
function findallpaths(obj)
	
	local comefrom = {}
	local f = function(from, to, how, value)
		if not comefrom[to] then comefrom[to] = {} end
		table.insert(comefrom[to], 1, {f = from, h = how, v=value})		
	end
	
	traverse({edge=f}, {comefrom, f})
	
	
	local function printpath(to)
		if not to or comefrom[to].visited or to == _G then
			print("-----")
			return
		end
		comefrom[to].visited = true
		for i=1, #comefrom[to] do
			local tfrom = comefrom[to][i].f
			print("from: ", vim.inspect(tfrom, { newline = '|' }), "\nhow:", comefrom[to][i].h,
					"\nvalue:", comefrom[to][i].v)
			printpath(tfrom)
		end			
	end
	
	printpath(obj)
	
end

-- Main function
-- 'funcs' is a table that contains a funcation for every lua type and also the
-- function edge edge (traverseedge).
function traverse(funcs, ignoreobjs)

	-- The keys of the marked table are the objetcts (for example, table: 00442330).
	-- The value of each key is true if the object has been found and false
	-- otherwise.
	local env = {marked = {}, list=List.new(), funcs=funcs}
	
	if ignoreobjs then
		for i=1, #ignoreobjs do
			env.marked[ignoreobjs[i]] = true
		end
	end
	
	env.marked["gc"] = true
	env.marked[gc] = true
	
	-- marks and inserts on the list
	edge(env, nil, "_G", "isname", nil)
	edge(env, nil, _G, "key", "_G")

	-- traverses the active thread
	-- inserts the local variables
	-- interates over the function on the stack, starting from the one that
	-- called traverse
	for i=2, math.huge do
		local info = debug.getinfo(i, "f") 
		if not info then break end 
		for j=1, math.huge do
			local n, v = debug.getlocal(i, j)
			if not n then break end
		
			edge(env, nil, n, "isname", nil)
			edge(env, nil, v, "local", n)
		end
	end
	
 	while not List.isempty(env.list) do	 		
 	
		local obj = List.pop(env.list)
 		local t = type(obj)
        if not gc["traverse" .. t] then
          error("Could not find traverse " .. t)
        end

 		gc["traverse" .. t](env, obj)
			
	end			
	
end

function traversetable(env, obj)
	
	local f = env.funcs.table
	if f then f(obj) end
	
	for key, value in pairs(obj) do	
		edge(env, obj, key, "iskey", nil)
		edge(env, obj, value, "key", key)		
	end
	
	local mtable = debug.getmetatable(obj)
	if mtable then edge(env, obj, mtable, "ismetatable", nil) end

end
			
function traversestring(env, obj)
	local f = env.funcs.string
	if f then f(obj) end
	
end

function traverseuserdata(env, obj)
	local f = env.funcs.userdata
	if f then f(obj) end
	
	local mtable = debug.getmetatable(obj)
	if mtable then edge(env, obj, mtable, "ismetatable", nil) end
	
	local fenv = debug.getfenv(obj)
	if fenv then edge(env, obj, fenv, "environment", nil) end
	
end

function traversefunction(env, obj)
	local f = env.funcs.func
	if f then f(obj) end
	
	-- gets the upvalues
	local i = 1	
	while true do
		local n, v = debug.getupvalue(obj, i)
		if not n then break end -- when there is no upvalues
		edge(env, obj, n, "isname", nil)
		edge(env, obj, v, "upvalue", n)
		i = i + 1
	end
		
	local fenv = debug.getfenv(obj)
	edge(env, obj, fenv, "enviroment", nil)
	
end

function traversecdata(env, t)
  -- print(env, t)
end
			
function traversethread(env, t)
	local f = env.funcs.thread
	if f then f(t) end
	
	for i=1, math.huge do
		local info = debug.getinfo(t, i, "f") 
		if not info then break end 
		for j=1, math.huge do
			local n, v = debug.getlocal(t, i , j)
			if not n then break end
			print(n, v)
		
			edge(env, nil, n, "isname", nil)
			edge(env, nil, v, "local", n)
		end
	end
	
	local fenv = debug.getfenv(t)
	edge(env, t, fenv, "enviroment", nil)
	
end


-- 'how' is a string that identifies the content of 'to' and 'value':
-- 		if 'how' is "iskey", then 'to' é is a key and 'value' is nil.
-- 		if 'how' is "key", then 'to' is an object and 'value' is the name of the
--		key.
function edge(env, from, to, how, value)
	
	local t = type(to)	
	
	if to and (t~="boolean") and (t~="number") and (t~="new") then
		-- If the destination object has not been found yet
		if not env.marked[to] then 
			env.marked[to] = true
			List.push(env.list, to) -- puts on the list to be traversed
		end
		
		local f = env.funcs.edge
		if f then f(from, to, how, value) end
		
	end	
	
end
