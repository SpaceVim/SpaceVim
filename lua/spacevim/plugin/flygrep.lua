local M = {}

local logger = require('spacevim.logger').derive('flygrep')
local mpt = require('spacevim.api').import('prompt')
local hi = require('spacevim.api').import('vim.highlight')

-- compatibility functions
local jobstart = vim.fn.jobstart
local jobsend = vim.fn.jobsend
local jobstop = vim.fn.jobstop
local function empty(expr)
    return vim.fn.empty(expr) == 1
end
local function isdirectory(dir)
    return vim.fn.isdirectory(dir) == 1
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
local mode = ''
local buffer_id = -1
local flygrep_win_id = -1
local grep_files = {}
local grep_dir = ''
local grep_exe = ''
local grep_opt = {}
local grep_ropt = {}
local grep_ignore_case = {}
local grep_smart_case = {}
local grep_expr_opt = {}
local hi_id = -1




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

local function update_statusline()
    
end

local function matchadd(group, pattern, p)
    
end

local function flygrep_stdout(id, data, event)

end

local function flygrep(t)
    mpt._build_prompt()
    if t == '' then
        vim.cmd('redrawstatus')
        return
    end
    pcall(vim.fn.matchdelete, hi_id)
    vim.cmd('hi def link FlyGrepPattern MoreMsg')
    hi_id = matchadd('FlyGrepPattern', expr_to_pattern(expr), 2)
    grep_expr = expr
    timer_stop(grep_timer_id)
    grep_timer_id = timer_start(200, grep_timer, {['repeat'] = 1})
end

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
    vim.cmd('setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber')
    local save_tve = vim.o.t_ve
    vim.cmd('setlocal t_ve=')
    local cursor_hi = {}
    cursor_hi = hi.group2dict('Cursor')
    local lcursor_hi = {}
    lcursor_hi = hi.group2dict('lCursor')
    local guicursor = vim.o.guicursor
    hi.hide_in_normal('Cursor')
    hi.hide_in_normal('lCursor')
    if vim.fn.has('nvim') == 1 then
        vim.cmd('set guicursor+=a:Cursor/lCursor')
    end
    vim.cmd('setf SpaceVimFlyGrep')
    update_statusline()
    matchadd('FileName', filename_pattern, 3)
    mpt._prompt.cursor_begin = argv.input or ''
    local fs = argv.files or ''
    if fs == '@buffers' then
        grep_files = vim.fn.map(buffer.listed_buffers(), 'bufname(v:val)')
    elseif not empty(fs) then
        grep_files = fs
    else
        grep_files = ''
    end

    local dir = vim.fn.expand(argv.dir or '')

    if not empty(dir) and isdirectory(dir) then
        grep_dir = dir
    else
        grep_dir = ''
    end
    grep_exe = argv.cmd or grep_default_exe
    if empty(grep_dir) and empty(grep_files) and grep_exe == 'findstr' then
        grep_files = '*.*'
    elseif grep_exe == 'findstr' and not empty(grep_dir) then
        grep_dir = '/D:' .. grep_dir
    end
    grep_opt = argv.opt or grep_default_opt
    grep_ropt = argv.ropt or grep_default_ropt
    grep_ignore_case = argv.ignore_case or grep_default_ignore_case
    grep_smart_case = argv.smart_case or grep_default_smart_case
    grep_expr_opt = argv.expr_opt or grep_default_expr_opt
    logger.info('FlyGrep startting ===========================')
    logger.info('   executable    : ' .. grep_exe)
    logger.info('   option        : ' .. vim.fn.string(grep_opt))
    logger.info('   r_option      : ' .. vim.fn.string(grep_ropt))
    logger.info('   files         : ' .. vim.fn.string(grep_files))
    logger.info('   dir           : ' .. vim.fn.string(grep_dir))
    logger.info('   ignore_case   : ' .. vim.fn.string(grep_ignore_case))
    logger.info('   smart_case    : ' .. vim.fn.string(grep_smart_case))
    logger.info('   expr opt      : ' .. vim.fn.string(grep_expr_opt))
    mpt.open()
    logger.info('FlyGrep ending  =====================')
    vim.o.t_ve = save_tve
    hi.hi(cursor_hi)
    hi.hi(lcursor_hi)
    vim.o.guicursor = guicursor

end


return M
