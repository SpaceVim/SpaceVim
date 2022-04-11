command! -bar -nargs=0 LeaderfNeosnippet call execute("Leaderf neosnippet")

" In order to be listed by :LeaderfSelf
call g:LfRegisterSelf('LeaderfNeosnippet', 'neosnippet')
