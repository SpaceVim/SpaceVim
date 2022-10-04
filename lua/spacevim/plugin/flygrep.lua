local flygrep = {}

local logger = require('spacevim.logger').derive('flygrep')

-- the job functions
local jobstart = vim.fn.jobstart
local jobsend = vim.fn.jobsend
local jobstop = vim.fn.jobstop


local timer_start = vim.fn.timer_start
local timer_stop = vim.fn.timer_stop


local jobid = -1
local grep_cmd = {}

-- The available options are:
-- - input: string, the default input pattern
-- - files: a list of string or `@buffers`
-- - cmd: list
-- - opt: list
-- - ropt: list
-- - ignore_case: boolean
-- - smart_case: boolean
-- - expr_opt: 

function flygrep.open(opt)

end

local function flygrep(t)

    jobid = jobstart(grep_cmd, {
        on_stdout = flygrep_stdout,
    })
    
end


function flygrep_stdout(id, data, event)
    
end


return flygrep
