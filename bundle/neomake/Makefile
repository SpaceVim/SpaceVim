# Do not let mess "cd" with user-defined paths.
CDPATH:=

TEST_SHELL:=$(shell command -v bash 2>/dev/null)
ifeq ($(TEST_SHELL),)
  $(error Could not determine TEST_SHELL (defaults to bash))
endif
# This is expected in tests.
TEST_VIM_PREFIX:=SHELL=$(TEST_SHELL)
SHELL:=$(TEST_SHELL) -o pipefail

# Use nvim if it is installed, otherwise vim.
ifeq ($(TEST_VIM),)
ifeq ($(shell command -v nvim 2>/dev/null),)
  TEST_VIM:=vim
else
  TEST_VIM:=nvim
endif
endif

IS_NEOVIM=$(findstring nvim,$(TEST_VIM))$(findstring neovim,$(TEST_VIM))
test: $(if $(IS_NEOVIM),testnvim,testvim)
test_interactive: $(if $(TEST_VIM),$(if $(IS_NEOVIM),testnvim_interactive,testvim_interactive),testnvim_interactive testvim_interactive)

VADER:=Vader!
VADER_OPTIONS:=-q
VADER_ARGS=tests/all.vader
VIM_ARGS='+$(VADER) $(VADER_OPTIONS) $(VADER_ARGS)'

NEOMAKE_TESTS_DEP_PLUGINS_DIR?=build/vim/plugins
TESTS_VADER_DIR:=$(NEOMAKE_TESTS_DEP_PLUGINS_DIR)/vader
$(TESTS_VADER_DIR):
	mkdir -p $(dir $@)
	git clone -q --depth=1 -b display-source-with-exceptions https://github.com/blueyed/vader.vim $@
TESTS_FUGITIVE_DIR:=$(NEOMAKE_TESTS_DEP_PLUGINS_DIR)/vim-fugitive
$(TESTS_FUGITIVE_DIR):
	mkdir -p $(dir $@)
	git clone -q --depth=1 https://github.com/tpope/vim-fugitive $@

DEP_PLUGINS=$(TESTS_VADER_DIR) $(TESTS_FUGITIVE_DIR)

TEST_VIMRC:=tests/vim/vimrc

testwatch: override export VADER_OPTIONS+=-q
testwatch:
	contrib/run-tests-watch

testwatchx: override export VADER_OPTIONS+=-x
testwatchx: testwatch

testx: override VADER_OPTIONS+=-x
testx: test
testnvimx: override VADER_OPTIONS+=-x
testnvimx: testnvim
testvimx: override VADER_OPTIONS+=-x
testvimx: testvim

# Set Neovim logfile destination to prevent `.nvimlog` being created.
testnvim: export NVIM_LOG_FILE:=/dev/stderr
testnvim: TEST_VIM:=nvim
testnvim: TEST_VIM_PREFIX+=VADER_OUTPUT_FILE=/dev/stderr
testnvim: | build/vim-test-home $(DEP_PLUGINS)
	$(call func-run-vim)

testvim: TEST_VIM:=vim
testvim: | build/vim-test-home $(DEP_PLUGINS)
	$(call func-run-vim)

# Add coloring to Vader's output:
# 1. failures (includes pending) in red "(X)"
# 2. test case header in bold "(2/2)"
# 3. Neomake's debug log messages in less intense grey
# 4. non-Neomake log lines (e.g. from :Log) in bold/bright yellow.
_SED_HIGHLIGHT_ERRORS:=| contrib/highlight-log --compact vader
# Need to close stdin to fix spurious 'sed: couldn't write X items to stdout: Resource temporarily unavailable'.
# NOTE: uses </dev/null instead of <&-, because Vim behaves different then:
#  - test "Automake restarts if popup menu is visible" hangs (https://github.com/vim/vim/issues/1320)
#  - running the command from "make testvim" directly (i.e. without "make")
#    triggers half the screen to be cleared in the end
# Vim requires stdin to be closed for feedkeys to stay in insert mode, at
# least in Docker on CircleCI.
_REDIR_STDOUT:=2>&1 >/dev/null </dev/null

# Neovim needs a valid HOME (https://github.com/neovim/neovim/issues/5277).
# Vim hangs with /dev/null on Windows (native Vim via MSYS2).
TEST_VIM_PREFIX+=HOME=$(CURDIR)/build/vim-test-home

# Neovim might quit after ~5s with stdin being closed.  Use --headless mode to
# work around this.
# > Vim: Error reading input, exiting...
# > Vim: Finished.
# For Vim `-s /dev/null` is used to skip the 2s delay with warning
# "Vim: Warning: Output is not to a terminal".
COVERAGE_FILE:=.coverage_covimerage
_COVIMERAGE=$(if $(filter-out 0,$(NEOMAKE_DO_COVERAGE)),covimerage run --data-file $(COVERAGE_FILE) --append --no-report ,)
define func-run-vim
	$(info Using: $(shell $(TEST_VIM_PREFIX) "$(TEST_VIM)" --version | head -n2))
	($(_COVIMERAGE)$(if $(TEST_VIM_PREFIX),env $(TEST_VIM_PREFIX) ,)"$(TEST_VIM)" \
	  $(if $(IS_NEOVIM),$(if $(_REDIR_STDOUT),--headless,),-X $(if $(_REDIR_STDOUT),-s /dev/null,)) \
	  --noplugin -Nu $(TEST_VIMRC) -i NONE $(VIM_ARGS) $(_REDIR_STDOUT)) $(_SED_HIGHLIGHT_ERRORS)
endef

# Interactive tests, keep Vader open.
_run_interactive: VADER:=Vader
_run_interactive: _REDIR_STDOUT:=
_run_interactive:
	$(call func-run-vim)

testvim_interactive: TEST_VIM:=vim -X
testvim_interactive: _run_interactive

testnvim_interactive: TEST_VIM:=nvim
testnvim_interactive: _run_interactive


# Manually invoke Vim, using the test setup.  This helps with building tests.
runvim: VIM_ARGS:=
runvim: testvim_interactive

runnvim: VIM_ARGS:=
runnvim: testnvim_interactive

# Add targets for .vader files, absolute and relative.
# This can be used with `b:dispatch = ':Make %'` in Vim.
TESTS:=$(wildcard tests/*.vader tests/*/*.vader)
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
_TESTS_REL_AND_ABS:=$(call uniq,$(abspath $(TESTS)) $(TESTS))
FILE_TEST_TARGET=$(if $(IS_NEOVIM),testnvim,testvim)
$(_TESTS_REL_AND_ABS):
	$(MAKE) --no-print-directory $(FILE_TEST_TARGET) VADER_ARGS='$@'
.PHONY: $(_TESTS_REL_AND_ABS)

testcoverage: COVERAGE_VADER_ARGS:=tests/main.vader $(wildcard tests/isolated/*.vader)
testcoverage:
	$(RM) $(COVERAGE_FILE)
	@ret=0; \
	for testfile in $(COVERAGE_VADER_ARGS); do \
	  $(MAKE) --no-print-directory test VADER_ARGS=$$testfile NEOMAKE_DO_COVERAGE=1 || (( ++ret )); \
	done; \
	exit $$ret

tags:
	ctags -R --langmap=vim:+.vader
.PHONY: tags

# Linters, called from .travis.yml.
LINT_ARGS:=./plugin ./autoload

# Vint.
VINT_BIN=$(shell command -v vint 2>/dev/null || echo build/vint/bin/vint)
build/vint: | build
	$(shell command -v virtualenv 2>/dev/null || echo python3 -m venv) $@
build/vint/bin/vint: | build/vint
	build/vint/bin/pip install --quiet vim-vint
vint: | $(VINT_BIN)
	$| --color $(LINT_ARGS)
vint-errors: | $(VINT_BIN)
	$| --color --error $(LINT_ARGS)

# vimlint
VIMLINT_BIN=$(shell command -v vimlint 2>/dev/null || echo build/vimlint/bin/vimlint.sh -l build/vimlint -p build/vimlparser)
build/vimlint/bin/vimlint.sh: build/vimlint build/vimlparser
build/vimlint: | build
	git clone -q --depth=1 https://github.com/syngan/vim-vimlint $@
build/vimlparser: | build
	git clone -q --depth=1 https://github.com/ynkdir/vim-vimlparser $@
VIMLINT_OPTIONS=-u -e EVL102.l:_=1 -e 'EVL103.a:_.*=1'
vimlint: | $(firstword $(VIMLINT_BIN))
	$(VIMLINT_BIN) $(VIMLINT_OPTIONS) $(LINT_ARGS)
vimlint-errors: | $(firstword VIMLINT_BIN)
	$(VIMLINT_BIN) $(VIMLINT_OPTIONS) -E $(LINT_ARGS)

build build/vim-test-home:
	mkdir $@
build/vim-test-home: | build
build/vimhelplint: | build
	cd build \
	&& wget -O- https://github.com/machakann/vim-vimhelplint/archive/master.tar.gz \
	  | tar xz \
	&& mv vim-vimhelplint-master vimhelplint
vimhelplint: | $(if $(VIMHELPLINT_DIR),,build/vimhelplint)
	contrib/vimhelplint doc/neomake.txt

# Run tests in dockerized Vims.
DOCKER_REPO:=neomake/vims-for-tests
DOCKER_TAG:=50
NEOMAKE_DOCKER_IMAGE?=
DOCKER_IMAGE:=$(if $(NEOMAKE_DOCKER_IMAGE),$(NEOMAKE_DOCKER_IMAGE),$(DOCKER_REPO):$(DOCKER_TAG))
DOCKER_STREAMS:=-ti
DOCKER_ARGS:=
DOCKER=docker run $(DOCKER_STREAMS) --rm \
    -v $(PWD):/testplugin \
    -w /testplugin \
    -e NEOMAKE_TEST_NO_COLORSCHEME \
    $(DOCKER_ARGS) $(DOCKER_IMAGE)
docker_image:
	docker build -f Dockerfile.tests -t $(DOCKER_REPO):$(DOCKER_TAG) .
docker_push:
	docker push $(DOCKER_REPO):$(DOCKER_TAG)
docker_update_latest:
	docker tag $(DOCKER_REPO):$(DOCKER_TAG) $(DOCKER_REPO):latest
	docker push $(DOCKER_REPO):latest
docker_update_image:
	@git diff --cached --exit-code >/dev/null || { echo "WARN: git index is not clean."; }
	@if git diff --exit-code -- Makefile >/dev/null; then \
	  sed -i '/^DOCKER_TAG:=/s/:=.*/:=$(shell echo $$(($(DOCKER_TAG)+1)))/' Makefile; \
	else \
	  echo "WARN: Makefile is not clean. Not updating."; \
	fi
	@if git diff --exit-code -- Dockerfile.tests >/dev/null; then \
	  sed -i '/^ENV NEOMAKE_DOCKERFILE_UPDATE=/s/=.*/=$(shell date +%Y-%m-%d)/' Dockerfile.tests; \
	else \
	  echo "WARN: Dockerfile.tests is not clean. Not updating."; \
	fi
	make docker_image
	make docker_test DOCKER_VIM=vim81
	@echo "Done.  Use 'make docker_push' to push it, and then update .circleci/config.yml."

DOCKER_VIMS:=vim73 vim74-trusty vim74-xenial vim80 vim81 \
  neovim-v0.1.7 neovim-v0.3.8 neovim-master vim-master
_DOCKER_VIM_TARGETS:=$(addprefix docker_test-,$(DOCKER_VIMS))

docker_test_all: $(_DOCKER_VIM_TARGETS)

$(_DOCKER_VIM_TARGETS):
	$(MAKE) docker_test DOCKER_VIM=$(patsubst docker_test-%,%,$@)

_docker_test: DOCKER_VIM:=vim81
_docker_test: DOCKER_MAKE_TARGET=$(DOCKER_MAKE_TEST_TARGET) \
  TEST_VIM='/vim-build/bin/$(DOCKER_VIM)' \
  VADER_OPTIONS="$(VADER_OPTIONS)" VADER_ARGS="$(VADER_ARGS)" \
	_REDIR_STDOUT="$(_REDIR_STDOUT)" \
	$(DOCKER_MAKE_TEST_ARGS)
_docker_test: docker_make
docker_test: DOCKER_MAKE_TEST_TARGET:=test
docker_test: DOCKER_STREAMS:=-t
docker_test: _docker_test

docker_test_interactive: DOCKER_MAKE_TEST_TARGET:=test_interactive
docker_test_interactive: DOCKER_STREAMS:=-ti
docker_test_interactive: _docker_test

docker_testcoverage: DOCKER_MAKE_TEST_TARGET:=testcoverage
# Pick up VADER_ARGS from command line for COVERAGE_VADER_ARGS.
docker_testcoverage: DOCKER_MAKE_TEST_ARGS:=$(if $(filter command line,$(origin COVERAGE_VADER_ARGS)),COVERAGE_VADER_ARGS="$(COVERAGE_VADER_ARGS)",$(if $(filter command line,$(origin VADER_ARGS)),COVERAGE_VADER_ARGS="$(VADER_ARGS)",))
docker_testcoverage: DOCKER_STREAMS:=-t
docker_testcoverage: _docker_test
	sed -i 's~/testplugin/~$(CURDIR)/~g' $(COVERAGE_FILE)
	coverage report -m

docker_run: DOCKER_ARGS:=-e PATH=/vim-build/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
docker_run: $(DEP_PLUGINS)
docker_run:
	$(DOCKER) $(if $(DOCKER_RUN),$(DOCKER_RUN),bash)

# Pass down/through MAKEFLAGS explicitly (not available in Docker env).
docker_make: DOCKER_RUN=$(MAKE) -$(MAKEFLAGS) $(DOCKER_MAKE_TARGET)
docker_make: docker_run

docker_check: DOCKER_MAKE_TARGET=check_docker
docker_check: docker_make

docker_vimhelplint:
	$(MAKE) docker_make DOCKER_MAKE_TARGET=vimhelplint

_ECHO_DOCKER_VIMS:=ls /vim-build/bin | grep vim | sort
docker_list_vims:
	docker run --rm $(DOCKER_IMAGE) $(_ECHO_DOCKER_VIMS)

check_lint_diff:
	@# NOTE: does not see changed files for builds on master.
	@set -e; \
	echo "Looking for changed files (to origin/master)."; \
	CHANGED_VIM_FILES=($$(git diff-tree --no-commit-id --name-only --diff-filter=AM -r origin/master.. \
	  | grep '\.vim$$' | grep -v '^tests/fixtures')) || true; \
	ret=0; \
	if [ "$${#CHANGED_VIM_FILES[@]}" -eq 0 ]; then \
	  echo 'No .vim files changed.'; \
	else \
	  MAKE_ARGS="LINT_ARGS=$${CHANGED_VIM_FILES[*]}"; \
	  echo "== Running \"make vimlint $$MAKE_ARGS\" =="; \
	  $(MAKE) --no-print-directory vimlint "$$MAKE_ARGS" || (( ret+=1 )); \
	  echo "== Running \"make vint $$MAKE_ARGS\" =="; \
	  $(MAKE) --no-print-directory vint "$$MAKE_ARGS"    || (( ret+=2 )); \
	fi; \
	if ! git diff-tree --quiet --exit-code --diff-filter=AM -r origin/master.. -- doc/neomake.txt; then \
	  echo "== Running \"make vimhelplint\" for changed doc/neomake.txt =="; \
	  $(MAKE) --no-print-directory vimhelplint       || (( ret+=4 )); \
	fi; \
	exit $$ret

check_lint: vimlint vint vimhelplint

# Checks to be run within the Docker image.
check_docker:
	@:; set -e; ret=0; \
	echo '== Checking for DOCKER_VIMS to be in sync'; \
	vims=$$($(_ECHO_DOCKER_VIMS)); \
	docker_vims="$$(printf '%s\n' $(DOCKER_VIMS) | sort)"; \
	if ! [ "$$vims" = "$$docker_vims" ]; then \
	  echo "DOCKER_VIMS is out of sync with Vims in image."; \
	  diff <(echo "$$vims") <(echo "$$docker_vims"); \
	  (( ret+=8 )); \
	fi; \
	exit $$ret

# Like CircleCI runs them.
check_in_docker: DOCKER_MAKE_TARGET=checkqa
check_in_docker: docker_make

# Run in CircleCI.
checkqa:
	$(MAKE) -k check check_docker check_lint_diff

check:
	@:; set -e; ret=0; \
	[ $$TERM = dumb ] && export TERM=xterm; \
	echo_bold() { tput bold; echo "$$@"; tput sgr0; }; \
	echo '== Checking that all tests are included'; \
	for f in $(filter-out all.vader main.vader isolated.vader,$(notdir $(shell git ls-files tests/*.vader))); do \
	  if ! grep -q "^Include.*: $$f" tests/main.vader; then \
	    echo_bold "Test not included in main.vader: $$f" >&2; ret=1; \
	  fi; \
	done; \
	for f in $(notdir $(shell git ls-files tests/isolated/*.vader)); do \
	  if ! grep -q "^Include.*: isolated/$$f" tests/isolated.vader; then \
	    echo_bold "Test not included in isolated.vader: $$f" >&2; ret=1; \
	  fi; \
	done; \
	echo '== Checking for absent Before sections in tests'; \
	if grep '^Before:' tests/*.vader; then \
	  echo_bold "Before: should not be used in tests itself, because it overrides the global one."; \
	  (( ret+=2 )); \
	fi; \
	echo '== Checking for absent :Log calls'; \
	if git --no-pager grep --line-number --color --perl-regexp '^(\s*au.*\b)?\s*Log\b' \
	    -- :^tests/include/init.vim :^tests/include/setup.vader; then \
	  echo_bold "Found Log commands."; \
	  (( ret+=4 )); \
	fi; \
	echo '== Checking tests'; \
	output="$$(grep --line-number --color AssertThrows -A1 tests/*.vader)"; \
	output="$(echo "$$output" \
		| grep -E '^[^[:space:]]+- ' \
		| grep -v g:vader_exception | sed -e s/-/:/ -e s/-// || true)"; \
	if [[ -n "$$output" ]]; then \
		echo_bold 'AssertThrows used without checking g:vader_exception:' >&2; \
		echo "$$output" >&2; \
	  (( ret+=16 )); \
	fi; \
	echo '== Running custom checks'; \
	tput bold; \
	contrib/vim-checks $(LINT_ARGS) || (( ret+= 16 )); \
	tput sgr0; \
	exit $$ret

NEOMAKE_LOG:=/tmp/neomake.log
tail_log:
	fifo=$(shell mktemp -u); \
	  mkfifo $$fifo; \
	  tail -f $(NEOMAKE_LOG) \
	  | $(CURDIR)/contrib/highlight-log >> $$fifo & \
		less --force --chop-long-lines +F $$fifo

clean:
	$(RM) -r build
.PHONY: clean

# Fixtures {{{

# A function to define targets/rules for fixture generation.
# Args:
# 1: the tool (bin) and input/output dir.
# 2: arguments for the tool
# NOTE: uses "sed -i.bak" for MacOS's default sed.
define func-generate-fixture
tests/fixtures/output/$1:
	mkdir -p $$@
tests/fixtures/output/$1/%.stderr tests/fixtures/output/$1/%.stdout tests/fixtures/output/$1/%.exitcode: tests/fixtures/input/$1/% | tests/fixtures/output/$1
	@baseout=tests/fixtures/output/$1/$$*; \
	echo "Generating $$$$baseout"; \
	$1 $2 $$< >$$$$baseout.stdout 2>$$$$baseout.stderr; \
	ret=$$$$?; \
	printf $$$$ret > $$$$baseout.exitcode; \
	if ! [ -f $$$$baseout.stdout ]; then \
	  echo "Missing output: $$$$baseout.stdout." >&2; exit 1; \
	fi; \
	sed -i.bak -e "s~$(CURDIR)/~/tmp/neomake-tests/~g" \
	  $$$$baseout.stdout $$$$baseout.stderr; \
	$(RM) $$$$baseout.stdout.bak $$$$baseout.stderr.bak
endef

# Call and eval the above function to generate rules for different tools.
$(eval $(call func-generate-fixture,puppet,parser validate --color=false))
$(eval $(call func-generate-fixture,puppet-lint,--log-format "%{path}:%{line}:%{column}:%{kind}:[%{check}] %{message}"))
$(eval $(call func-generate-fixture,xmllint,--xinclude --postvalid --noout))
$(eval $(call func-generate-fixture,zsh,-n))

_FIXTURES_INPUT:=$(wildcard tests/fixtures/input/*/*)
_FIXTURES_OUTPUT:=$(patsubst tests/fixtures/input/%,tests/fixtures/output/%,$(addsuffix .stdout,$(_FIXTURES_INPUT)) $(addsuffix .stderr,$(_FIXTURES_INPUT)))

fixtures: $(_FIXTURES_OUTPUT)
.PHONY: fixtures

fixtures-rebuild:
	$(RM) tests/fixtures/output/*/*.stdout tests/fixtures/output/*/*.stderr
	$(MAKE) --keep-going fixtures
.PHONY: fixtures-rebuild
# }}}

.PHONY: vint vint-errors vimlint vimlint-errors
.PHONY: test testnvim testvim testnvim_interactive testvim_interactive
.PHONY: runvim runnvim tags _run_tests
