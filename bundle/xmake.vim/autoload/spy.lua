import 'core.project.project'
import 'core.project.config'
import 'core.base.global'

local help_content = [==[
xmake lua spy.lua [OPTION] ACTION

OPTION:
    -o FILE        output the content to FILE

ACTION:
    config         get a config
    global         get a global config
    getenv ...     get some ENVIRONMENTs
    project        get all project's configuration
]==]

-- table of action's procedures(functions)
local actions = {}
local outfile = nil

-- main
function main(...)
    local args = {...}
    local action = args[1]
    if action == '-o' then
        outfile = args[2]
        action = args[3]
        args = table.slice(args, 3)
    end
    if action then
        local func = actions[action]
        if func then func(args) end
    else
        print(help_content)
    end
end
-- convert the value 't' to JSON string, in a line
local function tojson(t)
    if type(t) == 'table' then
        local list = {}
        if t[1] then
            for i = 1, #t do
                list[i] = tojson(t[i])
            end
            return table.concat({'[', table.concat(list, ','), ']'})
        else
            for k, v in pairs(t) do
                table.insert(list, tojson(k) .. ':' .. tojson(v))
            end
            return table.concat({'{', table.concat(list, ','), '}'})
        end
    end
    local tt = type(t)
    if tt == 'string' then
        -- t = t:gsub('[\\\n\r\t"]', {
        --     ['\\'] = '\\\\', ['\n'] = '\\n',
        --     ['\t'] = '\\t', ['"'] = '\\"', ['\r'] = '\\r'
        -- })
        -- return '"' .. t .. '"'
        return string.format('%q', t)
    elseif tt == 'nil' then
        return 'null'
    else            -- number or boolean
        return tostring(t)
    end
end

function output(t)
    local t = tojson(t)
    if outfile then
        local file = io.open(outfile, 'w')
        if not file then
            print('can not open file to write:', outfile)
            return
        end
        file:write(t)
        file:close()
    else
        print(t)
    end
end
-- Action: config ----- get the current configuration
actions.config = function(args)
    config.load()
    local list = {}
    for i = 2,#args do
        list[i-1] = config.get(args[i]) or ''
    end
    output(list)
end
-- Action: global ----- get the global configuration
actions.global = function(args)
    global.load()
    local list = {}
    for i = 2,#args do
        list[i-1] = global.get(args[i]) or ''
    end
    output(list)
end
-- Action: getenv ------ get environment variables inside xmake
actions.getenv = function(args)
    local list = {}
    for i = 2,#args do
        list[i-1] = os.getenv(args[i]) or ''
    end
    output(list)
end
actions.incdirs = function(args)
    config.load()
    for name, target in pairs(project.targets()) do
        print(target:get('includedirs'))
    end
    print(os.getenv('INCLUDE'))
end
-- Action: project ----- get the project's configuration
actions.project = function(args)
    config.load()
    -- os.cd(project.directory())
    -- project's configuration
    local xconfig = {
        config = {
            arch = config:arch(),
            plat = config:plat(),
            mode = config:mode(),
            cc = config.get('cc'),
            cxx = config.get('cxx')
        },
        -- project's name
        name = project.name() or '<unamed>',
        -- project's version
        version = project.version(),
        -- project's targets
        targets = {}
    }
    -- read the configuration of all targets
    for tname, target in pairs(project.targets()) do
        local tcfg = {}
        try { function ()
            tcfg.name        = target:name()
            tcfg.targetkind  = target:targetkind() or ''
            tcfg.sourcefiles = target:sourcefiles() or {}
            tcfg.headerfiles = target:headerfiles() or {}
            tcfg.targetfile  = target:targetfile() or '' end,
        catch { function(err)
            print(err)
        end}}
        xconfig.targets[tname] = tcfg
    end
    -- output
    output(xconfig)
end
