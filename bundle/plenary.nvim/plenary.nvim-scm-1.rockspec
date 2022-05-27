local _MODREV, _SPECREV = 'scm', '-1'
rockspec_format = "3.0"
package = 'plenary.nvim'
version = _MODREV .. _SPECREV

description = {
   summary = 'lua functions you don\'t want to write ',
   labels = { "neovim" },
   detailed = [[
	  plenary: full; complete; entire; absolute; unqualified. All the lua functions I don't want to write twice.
   ]],
   homepage = 'http://github.com/nvim-lua/plenary.nvim',
   license = 'MIT/X11',
}

dependencies = {
   'lua >= 5.1, < 5.4',
   'luassert'
}

source = {
   url = 'http://github.com/nvim-lua/plenary.nvim/archive/v' .. _MODREV .. '.zip',
   dir = 'plenary.nvim-' .. _MODREV,
}

if _MODREV == 'scm' then
   source = {
      url = 'git://github.com/nvim-lua/plenary.nvim',
   }
end

build = {
   type = 'builtin',
   modules = {
	   -- paths are relative to source.dir
	   ["plenary.busted"] = "lua/plenary/busted.lua",
	   ["plenary.class"] = "lua/plenary/class.lua",
	   ["plenary.context_manager"] = "lua/plenary/context_manager.lua",
	   ["plenary.debug_utils"] = "lua/plenary/debug_utils.lua",
	   ["plenary.enum"] = "lua/plenary/enum.lua",
	   ["plenary.errors"] = "lua/plenary/errors.lua",
	   ["plenary.filetype"] = "lua/plenary/filetype.lua",
	   ["plenary.fun"] = "lua/plenary/fun.lua",
	   ["plenary.functional"] = "lua/plenary/functional.lua",
	   ["plenary.init"] = "lua/plenary/init.lua",
	   ["plenary.iterators"] = "lua/plenary/iterators.lua",
	   ["plenary.job"] = "lua/plenary/job.lua",
	   ["plenary.log"] = "lua/plenary/log.lua",
	   ["plenary.nvim_meta"] = "lua/plenary/nvim_meta.lua",
	   ["plenary.operators"] = "lua/plenary/operators.lua",
	   ["plenary.path"] = "lua/plenary/path.lua",
	   ["plenary.profile"] = "lua/plenary/profile.lua",
	   ["plenary.reload"] = "lua/plenary/reload.lua",
	   ["plenary.run"] = "lua/plenary/run.lua",
	   ["plenary.scandir"] = "lua/plenary/scandir.lua",
	   ["plenary.strings"] = "lua/plenary/strings.lua",
	   ["plenary.tbl"] = "lua/plenary/tbl.lua",
	   ["plenary.test_harness"] = "lua/plenary/test_harness.lua",

	   ["plenary.async.api"] = "lua/plenary/async/api.lua",
	   ["plenary.async.async"] = "lua/plenary/async/async.lua",
	   ["plenary.async.control"] = "lua/plenary/async/control.lua",
	   ["plenary.async.init"] = "lua/plenary/async/init.lua",
	   ["plenary.async.lsp"] = "lua/plenary/async/lsp.lua",
	   ["plenary.async.structs"] = "lua/plenary/async/structs.lua",
	   ["plenary.async.tests"] = "lua/plenary/async/tests.lua",
	   ["plenary.async.util"] = "lua/plenary/async/util.lua",
	   ["plenary.async.uv_async"] = "lua/plenary/async/uv_async.lua",

	   ["plenary.async_lib.api"] = "lua/plenary/async_lib/api.lua",
	   ["plenary.async_lib.async"] = "lua/plenary/async_lib/async.lua",
	   ["plenary.async_lib.init"] = "lua/plenary/async_lib/init.lua",
	   ["plenary.async_lib.lsp"] = "lua/plenary/async_lib/lsp.lua",
	   ["plenary.async_lib.structs"] = "lua/plenary/async_lib/structs.lua",
	   ["plenary.async_lib.tests"] = "lua/plenary/async_lib/tests.lua",
	   ["plenary.async_lib.util"] = "lua/plenary/async_lib/util.lua",
	   ["plenary.async_lib.uv_async"] = "lua/plenary/async_lib/uv_async.lua",

	   ["plenary.collections.py_list"] = "lua/plenary/collections/py_list.lua",

	   ["plenary.lsp.override"] = "lua/plenary/lsp/override.lua",

	   ["plenary.neorocks.init"] = "lua/plenary/neorocks/init.lua",

	   ["plenary.popup.init"] = "lua/plenary/popup/init.lua",
	   ["plenary.popup.utils"] = "lua/plenary/popup/utils.lua",

	   ["plenary.profile.lua_profiler"] = "lua/plenary/profile/lua_profiler.lua",
	   ["plenary.profile.memory_profiler"] = "lua/plenary/profile/memory_profiler.lua",
	   ["plenary.profile.p"] = "lua/plenary/profile/p.lua",

	   ["plenary.vararg.init"] = "lua/plenary/vararg/init.lua",
	   ["plenary.vararg.rotate"] = "lua/plenary/vararg/rotate.lua",

	   ["plenary.window.border"] = "lua/plenary/window/border.lua",
	   ["plenary.window.float"] = "lua/plenary/window/float.lua",
	   ["plenary.window.init"] = "lua/plenary/window/init.lua",
   },
   copy_directories = {
	   'plugin'
   }
}

