local logger = require('spacevim.logger').derive('git')


return {
  info = logger.info,
  warn = logger.warn,
  debug = logger.debug

}

