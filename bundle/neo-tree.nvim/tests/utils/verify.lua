local verify = {}

verify.eventually = function(timeout, assertfunc, failmsg, ...)
  local success, args = false, { ... }
  vim.wait(timeout or 1000, function()
    success = assertfunc(unpack(args))
    return success
  end)
  assert(success, failmsg)
end

verify.after = function(timeout, assertfunc, failmsg)
  vim.wait(timeout, function()
    return false
  end)
  assert(assertfunc(), failmsg)
end

verify.bufnr_is = function(bufnr, timeout)
  verify.eventually(timeout or 500, function()
    return bufnr == vim.api.nvim_get_current_buf()
  end, string.format("Current buffer is expected to be '%s' but is not", bufnr))
end

verify.bufnr_is_not = function(bufnr, timeout)
  verify.eventually(timeout or 500, function()
    return bufnr ~= vim.api.nvim_get_current_buf()
  end, string.format("Current buffer is '%s' when expected to not be", bufnr))
end

verify.buf_name_endswith = function(buf_name, timeout)
  verify.eventually(
    timeout or 500,
    function()
      if buf_name == "" then
        return true
      end
      local n = vim.api.nvim_buf_get_name(0)
      if n:sub(-#buf_name) == buf_name then
        return true
      else
        return false
      end
    end,
    string.format("Current buffer name is expected to be end with '%s' but it does not", buf_name)
  )
end

verify.buf_name_is = function(buf_name, timeout)
  verify.eventually(timeout or 500, function()
    return buf_name == vim.api.nvim_buf_get_name(0)
  end, string.format("Current buffer name is expected to be '%s' but is not", buf_name))
end

verify.tree_focused = function(timeout)
  verify.eventually(timeout or 1000, function()
    return vim.api.nvim_buf_get_option(0, "filetype") == "neo-tree"
  end, "Current buffer is not a 'neo-tree' filetype")
end

verify.tree_node_is = function(source_name, expected_node_id, winid, timeout)
  verify.eventually(timeout or 500, function()
    local state = require("neo-tree.sources.manager").get_state(source_name, nil, winid)
    if not state.tree then
      return false
    end
    local success, node = pcall(state.tree.get_node, state.tree)
    if not success then
      return false
    end
    if not node then
      return false
    end
    local node_id = node:get_id()
    if node_id == expected_node_id then
      return true
    end
    return false
  end, string.format("Tree node '%s' not focused", expected_node_id))
end

verify.filesystem_tree_node_is = function(expected_node_id, winid, timeout)
  verify.tree_node_is("filesystem", expected_node_id, winid, timeout)
end

verify.buffers_tree_node_is = function(expected_node_id, winid, timeout)
  verify.tree_node_is("buffers", expected_node_id, winid, timeout)
end

verify.git_status_tree_node_is = function(expected_node_id, winid, timeout)
  verify.tree_node_is("git_status", expected_node_id, winid, timeout)
end

verify.window_handle_is = function(winid, timeout)
  verify.eventually(timeout or 500, function()
    return winid == vim.api.nvim_get_current_win()
  end, string.format("Current window handle is expected to be '%s' but is not", winid))
end

verify.window_handle_is_not = function(winid, timeout)
  verify.eventually(timeout or 500, function()
    return winid ~= vim.api.nvim_get_current_win()
  end, string.format("Current window handle is not expected to be '%s' but it is", winid))
end

return verify
