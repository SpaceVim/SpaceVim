local x = 123

local Point = record
	x: number
	y: number
end

local function myfunc(a: any, b: number, c: Point): number
	print(a)

	if x then
		prnit("Hello, I am an error")
	end

	return 42 
end
