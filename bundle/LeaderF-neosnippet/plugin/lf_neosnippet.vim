scriptencoding utf-8

let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
let g:Lf_Extensions.neosnippet = {
\   'source': string(function('lf_neosnippet#source'))[10:-3],
\   'accept': string(function('lf_neosnippet#accept'))[10:-3],
\   'preview': string(function('lf_neosnippet#preview'))[10:-3],
\   'before_enter': string(function('lf_neosnippet#before_enter'))[10:-3],
\}
