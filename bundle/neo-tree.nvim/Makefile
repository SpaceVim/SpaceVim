.PHONY: test
test:
	nvim --headless --noplugin -u tests/mininit.lua -c "lua require('plenary.test_harness').test_directory('tests/neo-tree/', {minimal_init='tests/mininit.lua',sequential=true})"

.PHONY: test-docker
test-docker:
	docker build -t neo-tree .
	docker run --rm neo-tree make test

.PHONY: format
format:
	stylua --glob '*.lua' --glob '!defaults.lua' .
