.PHONY: fmt
fmt:
	stylua --config-path stylua.toml --glob 'lua/**/*.lua' -- lua

.PHONY: lint
lint:
	luacheck ./lua

.PHONY: test
test:
	vusted --output=gtest ./lua

.PHONY: pre-commit
pre-commit:
	./utils/stylua --config-path stylua.toml --glob 'lua/**/*.lua' -- lua
	luacheck lua
	vusted lua

.PHONY: integration
integration:
	./utils/stylua --config-path stylua.toml --check --glob 'lua/**/*.lua' -- lua
	luacheck lua
	vusted lua

