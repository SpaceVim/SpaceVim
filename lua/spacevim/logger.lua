local M = {}

local logger = require('spacevim.api').import('logger')

logger.set_name('SpaceVim')
logger.set_level(1)
logger.set_silent(1)
logger.set_verbose(1)



function M.info(msg)
    logger.info(msg)
end

function M.warn(msg, ...)
    logger.warn(msg, ...)
end

function M.error(msg)
    logger.error(msg)
end

function M.setLevel(level)
    logger.set_level(level)
end

function M.setOutput(file)
    logger.set_file(file)
end

function M.derive(name)
    local derive = {}
    derive['origin_name'] = logger.get_name()

    function derive.info()
        logger.set_name(self.derive_name)
        logger.info(msg)
        logger.set_name(self.origin_name)
    end
    function derive.warn()
        logger.set_name(self.derive_name)
        logger.warn(msg)
        logger.set_name(self.origin_name)
    end
    function derive.error()
        logger.set_name(self.derive_name)
        logger.error(msg)
        logger.set_name(self.origin_name)
    end

    derive['derive_name'] = fn.printf('%' .. fn.strdisplaywidth(logger.get_name()) .. 'S', name)
    return derive
end

return M
