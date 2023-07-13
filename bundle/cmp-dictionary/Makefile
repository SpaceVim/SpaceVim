.PHONY: test vusted luacheck format

test: luacheck vusted

vusted:
	vusted lua/

luacheck:
	luacheck lua/

format:
	stylua ./lua -g '!**/kit/**'
