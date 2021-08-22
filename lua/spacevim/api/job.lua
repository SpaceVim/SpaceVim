local M = {}


function warp_vim(argv, opts)
    local obj = {}
    obj._argv = argv
    obj._opts = opts
    obj.in_io = opts.in_io or 'pipe'
    function obj._out_cb(job_id, data)
        if obj._opts.on_stdout ~= nil then
            obj._opts.on_stdout(obj._opts.jobpid, {data}, 'stdout')
        end
    end

    function obj._err_cb(job_id, data)
        if obj._opts.on_stderr ~= nil then
            obj._opts.on_stderr(obj._opts.jobpid, {data}, 'stderr')
        end
    end

    function obj._exit_cb(job_id, data)
        if obj._opts.on_exit ~= nil then
            obj._opts.on_exit(obj._opts.jobpid, data, 'exit')
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

function M.start(cmd, opt)

end

return M
