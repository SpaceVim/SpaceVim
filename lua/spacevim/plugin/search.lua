local M = {}

local search_tools = {}

search_tools.namespace = {
    rg = 'r',
    ag = 'a',
    hw = 'h',
    pt = 't',
    ack = 'k',
    grep = 'g',
    findstr = 'i',
}

search_tools.a = {}
search_tools.a.command = 'ag'
search_tools.a.default_opts =
{
    '-i', '--nocolor', '--filename', '--noheading', '--column', '--ignore',
    '.hg', '--ignore', '.svn', '--ignore', '.git', '--ignore', '.bzr',
}
search_tools.a.recursive_opt = {}
search_tools.a.expr_opt = {}
search_tools.a.fixed_string_opt = {'-F'}
search_tools.a.default_fopts = {'--nonumber'}
search_tools.a.smart_case = {'-S'}
search_tools.a.ignore_case = {'-i'}
search_tools.a.hidden_opt = {'--hidden'}

search_tools.t = {}
search_tools.t.command = 'pt'
search_tools.t.default_opts = {'--nogroup', '--nocolor'}
search_tools.t.recursive_opt = {}
search_tools.t.expr_opt = {'-e'}
search_tools.t.fixed_string_opt = {}
search_tools.t.default_fopts = {}
search_tools.t.smart_case = {'-S'}
search_tools.t.ignore_case = {'-i'}

search_tools.h = {}
search_tools.h.command = 'hw'
search_tools.h.default_opts = {'--no-group', '--no-color'}
search_tools.h.recursive_opt = {}
search_tools.h.expr_opt = {}
search_tools.h.fixed_string_opt = {}
search_tools.h.default_fopts = {}
search_tools.h.smart_case = {}
search_tools.h.ignore_case = {}

search_tools.r = {}
search_tools.r.command = 'rg'
search_tools.r.default_opts = {
    '--no-heading', '--color=never', '--with-filename', '--line-number', '--column',
    '-g', '!.git'
}
search_tools.r.recursive_opt = {}
search_tools.r.expr_opt = {'-e'}
search_tools.r.fixed_string_opt = {'-F'}
search_tools.r.default_fopts = {'-N'}
search_tools.r.smart_case = {'-S'}
search_tools.r.ignore_case = {'-i'}
search_tools.r.hidden_opt = {'--hidden'}

search_tools.k = {}
search_tools.k.command = 'ack'
search_tools.k.default_opts = {'-i', '--no-heading', '--no-color', '-k', '-H'}
search_tools.k.recursive_opt = {}
search_tools.k.expr_opt = {}
search_tools.k.fixed_string_opt = {}
search_tools.k.default_fopts = {}
search_tools.k.smart_case = {'--smart-case'}
search_tools.k.ignore_case = {'--ignore-case'}

search_tools.g = {}
search_tools.g.command = 'grep'
search_tools.g.default_opts = {'-inHr'}
search_tools.g.expr_opt = {'-e'}
search_tools.g.fixed_string_opt = {'-F'}
search_tools.g.recursive_opt = {'.'}
search_tools.g.default_fopts = {}
search_tools.g.smart_case = {}
search_tools.g.ignore_case = {'-i'}

search_tools.G = {}
search_tools.G.command = 'git'
search_tools.G.default_opts = {'grep', '-n', '--column'}
search_tools.G.expr_opt = {'-E'}
search_tools.G.fixed_string_opt = {'-F'}
search_tools.G.recursive_opt = {'.'}
search_tools.G.default_fopts = {}
search_tools.G.smart_case = {}
search_tools.G.ignore_case = {'-i'}

search_tools.i = {}
search_tools.i.command = 'findstr'
search_tools.i.default_opts = {'/RSN'}
search_tools.i.recursive_opt = {}
search_tools.i.expr_opt = {}
search_tools.i.fixed_string_opt = {}
search_tools.i.default_fopts = {}
search_tools.i.smart_case = {}
search_tools.i.ignore_case = {'/I'}

--- @return string default_exe the default executable of searching tool
--- @return table default_opt default searching option
--- @return table default_ropt default ropt of tool
--- @return table expr_opt expr_opt of searching tool
--- @return table fixed_string_opt fixed string option of searching tool
--- @return table ignore_case ignore case option
--- @return table smart_case smart case option
--- @return table hidden_opt opt to show hidden files
function M.default_tool()
    if search_tools.default_exe == nil then
        for _, t in ipairs(vim.g.spacevim_search_tools or {'rg', 'ag', 'pt', 'ack', 'grep'}) do
            if vim.fn.executable(t) == 1 then
                search_tools.default_exe = t
                local key = search_tools.namespace[t]
                search_tools.default_opt = search_tools[key]['default_opts']
                search_tools.default_ropt = search_tools[key]['recursive_opt']
                search_tools.expr_opt = search_tools[key]['expr_opt']
                search_tools.fixed_string_opt = search_tools[key]['fixed_string_opt']
                search_tools.ignore_case = search_tools[key]['ignore_case']
                search_tools.smart_case = search_tools[key]['smart_case']
                search_tools.hidden_opt = search_tools[key]['hidden_opt']
                break
            end
        end
        if search_tools.default_exe == nil then
            return '', {}, {}, {}, {}, {}, {}, {}
        end
    end
    return search_tools.default_exe,
    search_tools.default_opt,
    search_tools.default_ropt,
    search_tools.expr_opt,
    search_tools.fixed_string_opt,
    search_tools.ignore_case,
    search_tools.smart_case,
    search_tools.hidden_opt

end

function M.getFopt(exe)
    local key = search_tools.namespace[exe]
    return search_tools[key]['default_fopts']
end


return M
