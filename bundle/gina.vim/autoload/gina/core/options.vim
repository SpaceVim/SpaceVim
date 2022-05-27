let s:Options = vital#gina#import('Options')

function! gina#core#options#new() abort
  return s:Options.new()
endfunction

function! gina#core#options#help_if_necessary(args, options) abort
  if a:args.get('-h|--help')
    call a:options.help()
    throw gina#core#revelator#cancel()
  endif
endfunction
