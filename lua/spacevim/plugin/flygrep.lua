local flygrep = {}

local logger = require('spacevim.logger').derive('flygrep')

-- the job functions
local jobstart = vim.fn.jobstart
local jobsend = vim.fn.jobsend
local jobstop = vim.fn.jobstop


-- compatibility functions

local function empty(expr)
    return vim.fn.empty(expr) == 1
end

local timer_start = vim.fn.timer_start
local timer_stop = vim.fn.timer_stop


-- the script local values, same as s: in vim script
local previous_winid = -1
local grep_expr = ''
local grep_default_exe,
grep_default_opt,
grep_default_ropt,
grep_default_expr_opt,
grep_default_fix_string_opt,
grep_default_ignore_case,
grep_default_smart_case = require('spacevim.plugin.search').default_tool()

local grep_timer_id = -1
local preview_timer_id = -1
local grepid = 0

local function read_histroy()
    if vim.fn.filereadable(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/flygrep_history')) == 1 then
        local _his = vim.fn.json_decode(vim.fn.join(vim.fn.readfile(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/flygrep_history'), ''), ''))
        if vim.fn.type(_his) == 3 then
            return _his
        else
            return {}
        end
    else
        return {}
    end
end

local function update_history()
    if vim.fn.index(grep_history, grep_expr) >= 0 then
        vim.fn.remove(grep_history, vim.fn.index(grep_history, grep_expr))
    end
    vim.fn.add(grep_history, grep_expr)
    if vim.fn.isdirectory(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim')) == 0 then
        vim.fn.mkdir(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim'))
    end
    if vim.fn.filereadable(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/flygrep_history')) == 1 then
        vim.fn.writefile({vim.fn.json_encode(grep_history)}, vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/flygrep_history'))
    end
    
end

local grep_history = read_histroy()
local complete_input_history_num = {0, 0}

-- The available options are:
-- - input: string, the default input pattern
-- - files: a list of string or `@buffers`
-- - cmd: list
-- - opt: list
-- - ropt: list
-- - ignore_case: boolean
-- - smart_case: boolean
-- - expr_opt: 

function flygrep.open(argv)

    previous_winid = vim.fn.win_getid()

end

local function flygrep(t)

    jobid = jobstart(grep_cmd, {
        on_stdout = flygrep_stdout,
    })

end


function flygrep_stdout(id, data, event)

end


return flygrep
