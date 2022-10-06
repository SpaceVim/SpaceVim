local M = {}

local logger = require('spacevim.logger').derive('flygrep')
local mpt = require('spacevim.api').import('prompt')

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

local current_grep_pattern = ''
local function grep_timer(...)
    if grep_mode == 'expr' then
        current_grep_pattern = vim.fn.join(vim.fn.split(grep_expr), '.*')
    else
        current_grep_pattern = grep_expr
    end
    local cmd = get_search_cmd(current_grep_pattern)
    grepid = jobstart(cmd, {
        on_stdout = grep_stdout,
        on_stderr = grep_stderr,
        on_exit = grep_exit,
    })
end

local function get_search_cmd(expr)
   local cmd = {grep_exe} + grep_opt 
   if vim.o.ignorecase then
       cmd = cmd + grep_ignore_case
   end
   if vim.o.smartcase then
       cmd = cmd + grep_smart_case
   end
   if grep_mode == 'string' then
       cmd = cmd + grep_default_fix_string_opt
   end
   cmd = cmd + grep_expr_opt
   if not empty(grep_files) and vim.fn.type(grep_files) == 3 then
       cmd = cmd + {expr} + grep_files
   elseif not empty(grep_files) and vim.fn.type(grep_files) == 1 then
       cmd = cmd + {expr} + {grep_files}
   elseif not empty(grep_dir) then
       if grep_exe == 'findstr' then
           cmd = cmd + {grep_dir} + {expr} + {[[%CD%\*]]}
       else
           cmd = cmd + {expr} + {grep_dir}
       end
   else
       cmd = cmd + {expr}
       if grep_exe == 'rg' or grep_exe == 'ag' or grep_exe == 'pt' then
           cmd = cmd + {'.'}
       end
       cmd = cmd + grep_ropt
   end
   return cmd
end

local mode = ''
local buffer_id = -1
local flygrep_win_id = -1

function M.open(argv)

    previous_winid = vim.fn.win_getid()
    if empty(grep_default_exe) then
        logger.warn(' [flygrep] make sure you have one search tool in your PATH')
        return
    end
    mpt._handle_fly = flygrep
    buffer_id = vim.api.nvim_create_buf(false, true)
    local flygrep_win_height = 16
    flygrep_win_id = vim.api.nvim_open_win(buffer_id, true,{
        relative = 'editor',
        width = vim.o.columns,
        height = flygrep_win_height,
        row = vim.o.lines - flygrep_win_height - 2,
        col = 0
    })

    if vim.fn.exists('&winhighlight') == 1 then
        vim.cmd('set winhighlight=Normal:Pmenu,EndOfBuffer:Pmenu,CursorLine:PmenuSel')
    end



end

local function flygrep(t)

    jobid = jobstart(grep_cmd, {
        on_stdout = flygrep_stdout,
    })

end


function flygrep_stdout(id, data, event)

end


return M
