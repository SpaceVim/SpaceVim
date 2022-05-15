--
-- Show case of MemoryReferenceInfo.lua.
--
-- @filename  Example.lua
-- @author    WangYaoqi
-- @date      2017-05-04

local mri = require("plenary.profile.memory_profiler")

-- Set config.
mri.m_cConfig.m_bAllMemoryRefFileAddTime = false
--mri.m_cConfig.m_bSingleMemoryRefFileAddTime = false
--mri.m_cConfig.m_bComparedMemoryRefFileAddTime = false

-- 打印当前 Lua 虚拟机的所有内存引用快照到文件(或者某个对象的所有引用信息快照)到本地文件。
-- strSavePath - 快照保存路径，不包括文件名。
-- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
-- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
-- strRootObjectName - 遍历的根节点对象名称，"" 或者 nil 时使用 tostring(cRootObject)
-- cRootObject - 遍历的根节点对象，默认为 nil 时使用 debug.getregistry()。
-- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, strRootObjectName, cRootObject)
collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshot("./", "1-Before", -1)

-- Add a global variable.
local author = 
{
    Name = "yaukeywang",
    Job = "Game Developer",
    Hobby = "Game, Travel, Gym",
    City = "Beijing",
    Country = "China",
    Ask = function (question)
        return "My answer is for your question: " .. question .. "."
    end
}

_G.Author = author

-- Dump memory snapshot again.
collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshot("./", "2-After", -1)

-- 打印当前 Lua 虚拟机中某一个对象的所有相关引用。
-- strSavePath - 快照保存路径，不包括文件名。
-- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
-- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
-- strObjectName - 对象显示名称。
-- cObject - 对象实例。
-- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, strObjectName, cObject)
collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-Object", -1, "Author", _G.Author)

-- We can also find string references.
collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-String", -1, "Author Name", "yaukeywang")

-- 比较两份内存快照结果文件，打印文件 strResultFilePathAfter 相对于 strResultFilePathBefore 中新增的内容。
-- strSavePath - 快照保存路径，不包括文件名。
-- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
-- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
-- strResultFilePathBefore - 第一个内存快照文件。
-- strResultFilePathAfter - 第二个用于比较的内存快照文件。
-- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotComparedFile(strSavePath, strExtraFileName, nMaxRescords, strResultFilePathBefore, strResultFilePathAfter)
mri.m_cMethods.DumpMemorySnapshotComparedFile("./", "Compared", -1, "./LuaMemRefInfo-All-[1-Before].txt", "./LuaMemRefInfo-All-[2-After].txt")

-- 按照关键字过滤一个内存快照文件然后输出到另一个文件.
-- strFilePath - 需要被过滤输出的内存快照文件。
-- strFilter - 过滤关键字
-- bIncludeFilter - 包含关键字(true)还是排除关键字(false)来输出内容。
-- bOutputFile - 输出到文件(true)还是 console 控制台(false)。
-- MemoryReferenceInfo.m_cBases.OutputFilteredResult(strFilePath, strFilter, bIncludeFilter, bOutputFile)
-- Filter all result include keywords: "Author".
mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", true, true)

-- Filter all result exclude keywords: "Author".
mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", false, true)

-- All dump finished!
print("Dump memory snapshot information finished!")
