local M = {}

local logger = require('spacevim.logger').derive('flygrep')
local mpt = require('spacevim.api').import('prompt')
local hi = require('spacevim.api').import('vim.highlight')
local regex = require('spacevim.api').import('vim.regex')
local Key = require('spacevim.api').import('vim.keys')
local buffer = require('spacevim.api').import('vim.buffer')
local window = require('spacevim.api').import('vim.window')
local sl = require('spacevim.api').import('vim.statusline')

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
local grep_mode = 'expr'
local filename_pattern = [[[^:]*:\d\+:\d\+:]]
local preview_able = false
local grep_history = {}
local previewd_bufnrs = {}
local preview_win_id = -1




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
grep_history = read_histroy()


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

local function append(t1, t2)
    for _,v in pairs(t2) do
        table.insert(t1, v)
    end
end

local function get_search_cmd(expr)
    local cmd = {grep_exe}
    append(cmd, grep_opt)
    if vim.o.ignorecase then
        append(cmd, grep_ignore_case)
    end
    if vim.o.smartcase then
        append(cmd, grep_smart_case)
    end
    if grep_mode == 'string' then
        append(cmd, grep_default_fix_string_opt)
    end
    append(cmd, grep_expr_opt)
    if not empty(grep_files) and vim.fn.type(grep_files) == 3 then
        append(cmd, {expr})
        append(cmd, grep_files)
    elseif not empty(grep_files) and vim.fn.type(grep_files) == 1 then
        append(cmd, {expr})
        append(cmd, {grep_files})
    elseif not empty(grep_dir) then
        if grep_exe == 'findstr' then
            append(cmd, {grep_dir, expr, [[%CD%\*]]})
        else
            append(cmd, {expr, grep_dir})
        end
    else
        append(cmd, {expr})
        if grep_exe == 'rg' or grep_exe == 'ag' or grep_exe == 'pt' then
            append(cmd, {'.'})
        end
        append(cmd, grep_ropt)
    end
    return cmd
end

local complete_input_history_num = {0, 0}

local function grep_stdout(id, data, event)
    -- ignore previous result
    if id ~= grepid then return end
    local datas = vim.fn.filter(data, '!empty(v:val)')
    --  let datas = s:LIST.uniq_by_func(datas, function('s:file_line'))
    if vim.fn.getbufline(buffer_id, 1)[1] == '' then
        vim.api.nvim_buf_set_lines(buffer_id, 0, -1, false, datas)
    else
        vim.api.nvim_buf_set_lines(buffer_id, -1, -1, false, datas)
    end
end

local function grep_stderr(id, data, event)
    for _,d in pairs(data) do
        logger.info('grep stderr:' .. d)
    end
end

local function update_statusline()
    if sl.support_float() and vim.fn.win_id2tabwin(flygrep_win_id)[1] == vim.fn.tabpagenr() then
        sl.open_float({
            {'FlyGrep ', 'SpaceVim_statusline_a_bold'},
            {' ', 'SpaceVim_statusline_a_SpaceVim_statusline_b'},
            {M.mode() .. ' ', 'SpaceVim_statusline_b'},
            {' ', 'SpaceVim_statusline_b_SpaceVim_statusline_c'},
            {vim.fn.getcwd() .. ' ', 'SpaceVim_statusline_c'},
            {' ', 'SpaceVim_statusline_c_SpaceVim_statusline_b'},
            {M.lineNr() .. ' ', 'SpaceVim_statusline_b'},
            {' ', 'SpaceVim_statusline_b_SpaceVim_statusline_z'},
            {vim.fn['repeat'](' ', vim.o.columns - 11), 'SpaceVim_statusline_z'},
        })
    end
end

local function close_statusline()
    sl.close_float()
end

local function grep_exit(id, data, event)
    logger.info('grep exit:' .. data)
    update_statusline()
    vim.cmd('redraw')
    mpt._build_prompt()
    grepid = 0
end

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
    logger.info('grep cmd:' .. vim.inspect(cmd))
    grepid = jobstart(cmd, {
        on_stdout = grep_stdout,
        on_stderr = grep_stderr,
        on_exit = grep_exit,
    })
    logger.info('flygrep job id is:' .. grepid)
end


local function matchadd(group, pattern, p)

end

local function expr_to_pattern(expr)
    if grep_mode == 'expr' then
        local items = vim.fn.split(expr)
        local pattern = vim.fn.join(items, '.*')
        local ignorecase = ''
        if vim.o.ignorecase then
            ignorecase = [[\c]]
        else
            ignorecase = [[\C]]
        end
        pattern = filename_pattern .. [[.*\zs]] .. ignorecase .. regex.parser(pattern, false)
        logger.info('matchadd pattern: ' .. pattern)
        return pattern
    else
        return expr
    end
end

local function flygrep(t)
    mpt._build_prompt()
    if t == '' then
        vim.cmd('redrawstatus')
        return
    end
    pcall(vim.fn.matchdelete, hi_id)
    vim.cmd('hi def link FlyGrepPattern MoreMsg')
    hi_id = matchadd('FlyGrepPattern', expr_to_pattern(t), 2)
    grep_expr = t
    timer_stop(grep_timer_id)
    grep_timer_id = timer_start(200, grep_timer, {['repeat'] = 1})
end

local function close_flygrep_win()
    vim.cmd('noautocmd q')
    vim.fn.win_gotoid(previous_winid)
end

local function get_file_pos(line)
    local filename = vim.fn.fnameescape(vim.fn.split(line, [[:\d\+:]])[1])
    local linenr = vim.fn.str2nr(string.sub(vim.fn.matchstr(line, [[:\d\+:]]), 2, -2))
    local colum = vim.fn.str2nr(string.sub(vim.fn.matchstr(line, [[\(:\d\+\)\@<=:\d\+:]]), 2, -2))
    return filename, linenr, colum
end

local function preview_timer(t)
    local cursor = vim.api.nvim_win_get_cursor(flygrep_win_id)
    local line = vim.api.nvim_buf_get_lines(buffer_id, cursor[1] - 1, cursor[1], false)[1]
    if line == '' then return end
    for id in ipairs(vim.fn.filter(previewd_bufnrs, 'bufexists(v:val) && buflisted(v:val)')) do
        vim.cmd('silent bd ' .. id)
    end
    local br = vim.fn.bufnr('$')
    local filename, liner, colum = get_file_pos(line)
    local bufnr = vim.fn.bufadd(filename)
    vim.fn.bufload(bufnr)
    local flygrep_win_height = 16
    if window.is_float(preview_win_id) then
        vim.api.nvim_win_set_buf(preview_win_id, bufnr)
    else
        preview_win_id = vim.api.nvim_open_win(bufnr, false,{
            relative = 'editor',
            width = vim.o.columns,
            height = 5,
            row = vim.o.lines - flygrep_win_height - 2 - 5,
            col = 0
        })
    end
    vim.api.nvim_win_set_cursor(preview_win_id, {liner, 1})
    if bufnr > br then
        table.insert(previewd_bufnrs, bufnr)
    end
    mpt._build_prompt()
end

local function preview()
    timer_stop(preview_timer_id)
    preview_timer_id = timer_start(200, preview_timer, {['repeat'] = 1})
end

local function close_preview_win()
    pcall(vim.api.nvim_win_close, preview_win_id, true)
end


local function close_buffer()
    if grepid > 0 then
        jobstop(grepid)
    end
    timer_stop(grep_timer_id)
    timer_stop(preview_timer_id)
    if preview_able then
        for id in ipairs(vim.fn.filter(previewd_bufnrs, 'bufexists(v:val) && buflisted(v:val)')) do
            vim.cmd('silent bd ' .. id)
        end
        close_preview_win()
        preview_able = false
    end
    close_flygrep_win()
end

mpt._onclose = close_buffer

local function close_grep_job()
    if grepid > 0 then
        pcall(jobstop, grepid)
    end
    timer_stop(grep_timer_id)
    timer_stop(preview_timer_id)
    vim.api.nvim_buf_set_lines(buffer_id, 0, -1, false, {})
    update_statusline()
    complete_input_history_num = {0,0}
end

mpt._oninputpro = close_grep_job

local function next_item()
    local cursor = vim.api.nvim_win_get_cursor(flygrep_win_id)
    if cursor[1] >= vim.api.nvim_buf_line_count(buffer_id) then
        cursor[1] = 1
    else
        cursor[1] = cursor[1] + 1
    end
    vim.api.nvim_win_set_cursor(flygrep_win_id, cursor)
    if preview_able then
        preview()
    end
    update_statusline()
    vim.cmd('redraw')
    mpt._build_prompt()
end

local function previous_item()
    local cursor = vim.api.nvim_win_get_cursor(flygrep_win_id)
    if cursor[1] == 1 then
        cursor[1] = vim.api.nvim_buf_line_count(buffer_id)
    else
        cursor[1] = cursor[1] - 1
    end
    vim.api.nvim_win_set_cursor(flygrep_win_id, cursor)
    update_statusline()
    vim.cmd('redraw')
    mpt._build_prompt()
end

local function open_item(...)
    local argv = {...}
    local edit_command = argv[1] or 'edit'
    mpt._handle_fly = flygrep
    local cursor = vim.api.nvim_win_get_cursor(flygrep_win_id)
    local line = vim.api.nvim_buf_get_lines(buffer_id, cursor[1] - 1, cursor[1], false)[1]
    -- print(vim.inspect(line))
    if line ~= '' then
        if grepid ~= 0 then
            jobstop(grepid)
        end
        mpt._clear_prompt()
        mpt._quit = true
        local filename, liner, colum = get_file_pos(line)
        if preview_able then
            close_preview_win()
        end
        preview_able = false
        close_flygrep_win()
        update_history()
        buffer.open_pos(edit_command, filename, liner, colum)
        vim.cmd('noautocmd normal! :')
    end
end


local function open_item_in_tab()
    open_item('tabedit')
end

local function open_item_vertically()
    open_item('vsplit')
end

local function open_item_horizontally()
    open_item('split')
end


local function move_cursor()
    if vim.v.mouse_winid == flygrep_win_id then
        vim.api.nvim_win_set_cursor(flygrep_win_id, {vim.v.mouse_lnum, 0})
    end
    mpt._build_prompt()
end

local function double_click()
    if vim.v.mouse_winid == flygrep_win_id then
        vim.api.nvim_win_set_cursor(flygrep_win_id, {vim.v.mouse_lnum, 0})
    end
    open_item()
end

local function toggle_expr_mode()
    if grep_mode == 'expr' then
        grep_mode = 'string'
    else
        grep_mode = 'expr'
    end
    mpt._oninputpro()
    mpt._handle_fly(mpt._prompt.cursor_begin
    .. mpt._prompt.cursor_char
    .. mpt._prompt.cursor_end)
end

local function apply_to_quickfix()
    mpt._handle_fly = flygrep
    if vim.fn.getbufline(buffer_id, 1)[1] ~= '' then
        if grepid ~= 0 then
            jobstop(grepid)
        end
        mpt._quit = true
        if preview_able then
            close_preview_win()
        end
        preview_able = false
        local searching_result = vim.api.nvim_buf_get_lines(buffer_id, 0, -1, false)
        close_flygrep_win()
        update_history()
        if vim.fn.empty(searching_result) == 0 then
            -- vim.cmd('cgetexpr '  .. vim.fn.join(searching_result, "\n"))
            -- vim.cmd([[
            -- cgetexpr join(luaeval(searching_result), "\n")
            -- ]])
            -- vim.fn.setqflist({})
            vim.fn.setqflist({}, 'r', {
                title = 'FlyGrep partten:' .. mpt._prompt.cursor_begin .. mpt._prompt.cursor_char .. mpt._prompt.cursor_end,
                lines = searching_result
            })
            mpt._clear_prompt()
            vim.cmd('copen')
        end
        vim.cmd('noautocmd normal! :')


    end
end

local function toggle_preview()
    if not preview_able then
        preview_able = true
        preview()
    else
        close_preview_win()
        preview_able = false
    end
    vim.cmd('redraw')
    mpt._build_prompt()
end

mpt._function_key = {
    [Key.t('<Tab>')] = next_item,
    [Key.t('<C-j>')] = next_item,
    [Key.t('<ScrollWheelDown>')] = next_item,
    [Key.t('<S-tab>')] = previous_item,
    [Key.t('<C-k>')] = previous_item,
    [Key.t('<ScrollWheelUp>')] = previous_item,
    [Key.t('<Return>')] = open_item,
    [Key.t('<C-t>')] = open_item_in_tab,
    [Key.t('<LeftMouse>')] = move_cursor,
    [Key.t('<2-LeftMouse>')] = double_click,
    [Key.t('<C-f>')] = start_filter,
    [Key.t('<C-v>')] = open_item_vertically,
    [Key.t('<C-s>')] = open_item_horizontally,
    [Key.t('<C-q>')] = apply_to_quickfix,
    [Key.t('<M-r>')] = start_replace,
    [Key.t('<C-p>')] = toggle_preview,
    [Key.t('<C-e>')] = toggle_expr_mode,
    [Key.t('<Up>')] = previous_match_history,
    [Key.t('<Down>')] = next_match_history,
    [Key.t('<PageDown>')] = page_down,
    [Key.t('<PageUp>')] = page_up,
    [Key.t('<C-End>')] = page_end,
    [Key.t('<C-Home>')] = page_home,
    [Key.t('x80\xfdK')] = previous_item,
    [Key.t('x80\xfc \x80\xfdK')] = previous_item,
    [Key.t('x80\xfc@\x80\xfdK')] = previous_item,
    [Key.t('x80\xfc`\x80\xfdK')] = previous_item,
    [Key.t('x80\xfdL')] = next_item,
    [Key.t('x80\xfc \x80\xfdL')] = next_item,
    [Key.t('x80\xfc@\x80\xfdL')] = next_item,
    [Key.t('x80\xfc`\x80\xfdL')] = next_item,
}

function M.mode()
    if mode == '' then
        return grep_mode
    else
        return grep_mode .. '(' .. mode .. ')'
    end
end

function M.lineNr()
    if vim.fn.getbufline(buffer_id, 1)[1] == '' then
        return 'no result'
    else
        local current = vim.api.nvim_win_get_cursor(flygrep_win_id)[1]
        local total = vim.api.nvim_buf_line_count(buffer_id)
        return current .. '/' .. total
    end
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
    if sl.support_float() then
        close_statusline()
    end
    logger.info('FlyGrep ending  =====================')
    vim.o.t_ve = save_tve
    hi.hi(cursor_hi)
    hi.hi(lcursor_hi)
    vim.o.guicursor = guicursor

end

return M
