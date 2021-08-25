local M = {}
local sp = require('spacevim')
M.vim_job = vim.api == nil
M.jobs = {}


function warp_vim(argv, opts)
    local obj = {}
    local origin_opts = opts
    obj.in_io = opts.in_io or 'pipe'
    function obj._out_cb(job_id, data)
        if origin_opts.on_stdout ~= nil then
            origin_opts.on_stdout(origin_opts.jobpid, {data}, 'stdout')
        end
    end

    function obj._err_cb(job_id, data)
        if origin_opts.on_stderr ~= nil then
            origin_opts.on_stderr(origin_opts.jobpid, {data}, 'stderr')
        end
    end

    function obj._exit_cb(job_id, data)
        if origin_opts.on_exit ~= nil then
            origin_opts.on_exit(origin_opts.jobpid, data, 'exit')
        end
    end

    obj = {
        ['argv'] = argv,
        ['opts'] = {
            ['mode'] = 'nl',
            ['in_io' ] = obj.in_io,
            ['out_cb'] = obj._out_cb,
            ['err_cb'] = obj._err_cb,
            ['exit_cb'] = obj._exit_cb,
        }
    }
    if opts.cwd ~= nil then
        obj.opts.cwd =opts.cwd
    end
    return obj
end

function M.start(argv, ...)
  if M.nvim_job then
  elseif M.vim_job then
    local argvs=...
    local opts = {}
    if argvs ~= nil then
        opts = argvs[1] or opts
    end
    local id = #M.jobs + 1
    opts.jobpid = id
    local wrapped = warp_vim(argv, opts)
    local old_wd = ''
    local cmd = ''
    if wrapped.opts.cwd ~= nil and sp.has('patch-8.0.0902') then
      old_wd = sp.fn.getcwd()
      cwd = sp.fn.expand(wrapped.opts.cwd, 1)
      wrapped.opts.cwd = nil
      sp.cmd('cd' .. sp.fn.fnameescape(cwd))
    end
    wrapped.opts.out_cb(1, 3)
    local job = sp.fn.job_start(wrapped.argv, wrapped.opts)
    if old_wd ~= '' then
      sp.cmd('cd' .. sp.fn.fnameescape(old_wd))
    end
    table.insert(M.jobs, {id = job})
    return id
  else
  end
end

return M
