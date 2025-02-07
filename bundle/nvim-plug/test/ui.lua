local ui = require('plug.ui')
ui.open()
ui.on_update('test.vim', {
  clone_done = true,
})
ui.on_update('test2.vim', {
  clone_process = '16% (160/1000)',
})
ui.on_update('test3.vim', {
  clone_done = true,
})
ui.on_update('test4.vim', {
  clone_done = false,
})
