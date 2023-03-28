# Filename: xmgen.py
# Author: luzhlon
# Description: Generate xmake.lua
import vim

try:
    _cfg = vim.eval('g:xcfg')
    _f = open('xmake.lua', 'w')
    _f.writelines([
'''if is_mode("release") then
    set_symbols("hidden")
    set_optimize("fastest")
    set_strip("all")
elseif is_mode("debug") then
    set_symbols("debug")
    set_optimize("none")
end''', '\n\n'])
# 写入工程名称
    _f.writelines(["set_project '%s'" % _cfg['project'], '\n\n'])
    Filelist = lambda l: ','.join(list(map(lambda v:"'%s'" % v, l)))
# 写入目标配置
    for (name, target) in _cfg['targets'].items():
        t = ["target '%s'" % name, '\n',
             "set_kind '%s'" % target['targetkind'], '\n']
        if 'headerfiles' in target:
            t.append("add_headers(%s)" % Filelist(target['headerfiles']))
            t.append('\n')
        if 'sourcefiles' in target:
            t.append("add_files(%s)" % Filelist(target['sourcefiles']))
            t.append('\n')
        t.append('\n')
        _f.writelines(t)
    _f.close()
except OSError:
    print('open xmake.lua failure')
except vim.error as e:
    print(e)
