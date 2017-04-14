let log = SpaceVim#api#import('logger')
call log.set_name('TestLog')
" log.name == 'TestLog'
call log.info('info test')
call log.warn('info test')
call log.error('info test')
" len(log.temp) == 3
call log.set_level(2)
call log.info('info test')
call log.warn('info test')
call log.error('info test')
" len(log.temp) == 5
call log.set_level(3)
call log.info('info test')
call log.warn('info test')
call log.error('info test')
" len(log.temp) == 6
" len(log.view(1)) == 6
" len(log.view(2)) == 5
" len(log.view(3)) == 3

