local M = {}

local system = require('spacevim.api').import('system')
local fn = nil

if vim.fn == nil then
    fn = require('spacevim').fn
else
    fn = vim.fn
end

if system.isWindows then
    M.separator = '\\'
    M.pathSeparator = ';'
else
    M.separator = '/'
    M.pathSeparator = ':'
end

local file_node_extensions = {
    ['styl'] = '',
    ['scss'] = '',
    ['htm'] = '',
    ['html'] = '',
    ['erb'] = '',
    ['slim'] = '',
    ['ejs'] = '',
    ['wxml'] = '',
    ['css'] = '',
    ['less'] = '',
    ['wxss'] = '',
    ['md'] = '',
    ['markdown'] = '',
    ['json'] = '',
    ['js'] = '',
    ['jsx'] = '',
    ['rb'] = '',
    ['php'] = '',
    ['py'] = '',
    ['pyc'] = '',
    ['pyo'] = '',
    ['pyd'] = '',
    ['coffee'] = '',
    ['mustache'] = '',
    ['hbs'] = '',
    ['conf'] = '',
    ['ini'] = '',
    ['yml'] = '',
    ['bat'] = '',
    ['jpg'] = '',
    ['jpeg'] = '',
    ['bmp'] = '',
    ['png'] = '',
    ['gif'] = '',
    ['ico'] = '',
    ['twig'] = '',
    ['cpp'] = '',
    ['c++'] = '',
    ['cxx'] = '',
    ['cc'] = '',
    ['cp'] = '',
    ['c'] = '',
    ['hs'] = '',
    ['lhs'] = '',
    ['lua'] = '',
    ['java'] = '',
    ['sh'] = '',
    ['fish'] = '',
    ['ml'] = 'λ',
    ['mli'] = 'λ',
    ['diff'] = '',
    ['db'] = '',
    ['sql'] = '',
    ['dump'] = '',
    ['clj'] = '',
    ['cljc'] = '',
    ['cljs'] = '',
    ['edn'] = '',
    ['scala'] = '',
    ['go'] = '',
    ['dart'] = '',
    ['xul'] = '',
    ['sln'] = '',
    ['suo'] = '',
    ['pl'] = '',
    ['pm'] = '',
    ['t'] = '',
    ['rss'] = '',
    ['f#'] = '',
    ['fsscript'] = '',
    ['fsx'] = '',
    ['fs'] = '',
    ['fsi'] = '',
    ['rs'] = '',
    ['rlib'] = '',
    ['d'] = '',
    ['erl'] = '',
    ['hrl'] = '',
    ['vim'] = '',
    ['ai'] = '',
    ['psd'] = '',
    ['psb'] = '',
    ['ts'] = '',
    ['tsx'] = '',
    ['jl'] = '',
    ['ex'] = '',
    ['exs'] = '',
    ['eex'] = '',
    ['leex'] = ''
}

local file_node_exact_matches = {
    ['exact-match-case-sensitive-1.txt']  = 'X1',
    ['exact-match-case-sensitive-2']      = 'X2',
    ['gruntfile.coffee']                  = '',
    ['gruntfile.js']                      = '',
    ['gruntfile.ls']                      = '',
    ['gulpfile.coffee']                   = '',
    ['gulpfile.js']                       = '',
    ['gulpfile.ls']                       = '',
    ['dropbox']                           = '',
    ['.ds_store']                         = '',
    ['.gitconfig']                        = '',
    ['.gitignore']                        = '',
    ['.bashrc']                           = '',
    ['.bashprofile']                      = '',
    ['favicon.ico']                       = '',
    ['license']                           = '',
    ['node_modules']                      = '',
    ['react.jsx']                         = '',
    ['Procfile']                          = '',
    ['.vimrc']                            = '',
    ['mix.lock']                          = '',
}

local file_node_pattern_matches = {
    ['.*jquery.*\\.js$']       = '',
    ['.*angular.*\\.js$']      = '',
    ['.*backbone.*\\.js$']     = '',
    ['.*require.*\\.js$']      = '',
    ['.*materialize.*\\.js$']  = '',
    ['.*materialize.*\\.css$'] = '',
    ['.*mootools.*\\.js$']     = ''
}

function M.fticon(path)
    local file = fn.fnamemodify(path, ':t')
    if file_node_exact_matches[file] ~= nil then
        return file_node_exact_matches[file]
    end
    for k,v in ipairs(file_node_pattern_matches) do
        if fn.match(file, k) ~= -1 then
            return v
        end
    end
    local ext = fn.fnamemodify(file, ':e')
    return file_node_extensions[ext] or ''
end




return M
