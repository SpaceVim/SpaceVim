let s:save_cpo = &cpo
set cpo&vim

" Options {{{
" -------
let s:stations = get(g:, 'unite_source_radio_stations', [
    \ ['Digitally Imported: Chillout Dreams' , 'http://listen.di.fm/public3/chilloutdreams.pls' ],
    \ ['Digitally Imported: Chillout' , 'http://listen.di.fm/public3/chillout.pls' ],
    \ ['Digitally Imported: Funky House', 'http://listen.di.fm/public3/funkyhouse.pls' ],
    \ ['Digitally Imported: Lounge' , 'http://listen.di.fm/public3/lounge.pls' ],
    \ ['Digitally Imported: Progressive', 'http://listen.di.fm/public3/progressive.pls' ],
    \ ['Digitally Imported: PsyChill' , 'http://listen.di.fm/public3/psychill.pls' ],
    \ ['Digitally Imported: Soulful House' , 'http://listen.di.fm/public3/soulfulhouse.pls' ],
    \ ['Ragga Kings', 'http://www.raggakings.net/listen.m3u'],
    \ ['SKY.FM: Best of the 80s', 'http://www.sky.fm/mp3/the80s.pls'],
    \ ['SKY.FM: Classic Rap', 'http://www.sky.fm/mp3/classicrap.pls'],
    \ ['SKY.FM: Jazz', 'http://www.sky.fm/mp3/jazz.pls'],
    \ ['SKY.FM: Mostly Classical', 'http://www.sky.fm/mp3/classical.pls'],
    \ ['SKY.FM: Salsa', 'http://www.sky.fm/mp3/salsa.pls'],
    \ ['SKY.FM: Simply Soundtracks', 'http://www.sky.fm/mp3/soundtracks.pls'],
    \ ['SKY.FM: Smooth Jazz', 'http://www.sky.fm/mp3/smoothjazz.pls'],
    \ ['SKY.FM: Uptempo Smooth Jazz', 'http://www.sky.fm/mp3/uptemposmoothjazz.pls'],
    \ ['Slay Radio (C64 Remix)', 'http://www.slayradio.org/tune_in.php/128kbps/listen.m3u'],
    \ ['SomaFM: Beat Blender (House)', 'http://somafm.com/startstream=beatblender.pls'],
    \ ['SomaFM: Cliq Hop', 'http://somafm.com/startstream=cliqhop.pls'],
    \ ['SomaFM: Covers', 'http://somafm.com/covers.pls'],
    \ ['SomaFM: Digitalis (Rock)', 'http://somafm.com/digitalis.pls'],
    \ ['SomaFM: DEF CON Radio', 'http://somafm.com/defcon.pls'],
    \ ['SomaFM: Groove Salad (Chillout)', 'http://somafm.com/startstream=groovesalad.pls'],
    \ ['SomaFM: Illinois Street Lounge (Lounge)', 'http://somafm.com/illstreet.pls'],
    \ ['SomaFM: PopTron! (Pop)', 'http://somafm.com/poptron.pls'],
    \ ['SomaFM: Secret Agent (Downtempo)', 'http://somafm.com/secretagent.pls'],
    \ ['SomaFM: Sonic Universe (Jazz)', 'http://somafm.com/startstream=sonicuniverse.pls'],
    \ ['SomaFM: Tags Trance Trip (Progressive)', 'http://somafm.com/tagstrance.pls']
\ ])
let s:play_cmd = get(g:, 'unite_source_radio_play_cmd', '')
let s:process = {}
let s:source = {
\   'action_table': {},
\   'default_action' : 'execute',
\   'hooks': {},
\   'name': 'radio',
\   'syntax': 'uniteSource__Radio'
\}
" }}}

" Unite integration {{{
" -----------------

    function! unite#sources#radio#define()
        return s:source
    endfunction

    fun! s:source.gather_candidates(args, context) "{{{
        return map(copy(s:stations), "{
            \ 'word' : len(s:process) && s:process.url == v:val[1] ? '|P>'.v:val[0].'<P|' : v:val[0],
            \ 'url': v:val[1],
            \ 'cmd': len(v:val) > 2 ? v:val[2] : ''
        \ }")
    endfun "}}}

    let s:source.action_table.execute = {'description' : 'play station'}
    fun! s:source.action_table.execute.func(candidate) "{{{
        call unite#sources#radio#play(a:candidate.url, a:candidate.cmd)
    endfunction "}}}

    fun! s:source.hooks.on_syntax(args, context) "{{{
        call s:hl_current()
    endfunction "}}}

    fun! s:source.hooks.on_post_filter(args, context) "{{{
        if len(s:process)
            call s:widemessage("Now Playing: " . s:process.url)
        endif
    endfunction "}}}

    fun! s:hl_current()
        syntax match uniteSource__Radio_Play  /|P>.*<P|/
            \  contained containedin=uniteSource__Radio
            \  contains
            \  	= uniteSource__Radio_PlayHiddenBegin
            \  	, uniteSource__Radio_PlayHiddenEnd

        syntax match uniteSource__Radio_PlayHiddenBegin '|P>' contained conceal
        syntax match uniteSource__Radio_PlayHiddenEnd   '<P|' contained conceal

        highlight uniteSource__Radio_Play guifg=#888888 ctermfg=Green

    endfun

" }}}

command! -nargs=? UniteMPlay call unite#sources#radio#play(<q-args>)
command! UniteMStop call unite#sources#radio#stop()

if empty(s:play_cmd)
    if executable('/Applications/VLC.app/Contents/MacOS/VLC')
        let s:play_cmd = '/Applications/VLC.app/Contents/MacOS/VLC -Irc --quiet'
    elseif executable('mvp')
        let s:play_cmd = 'mvp'
    elseif executable('mplayer')
        let s:play_cmd = 'mplayer -quiet -playlist'
    elseif executable('cvlc')
        let s:play_cmd = 'cvlc -Irc --quiet'
    else
        echoerr "Unite-radio player hasnt found. See :help unite-radio"
    endif
endif

fun! unite#sources#radio#play(url, cmd) "{{{
    if a:url !~ '\(pls\|m3u\|asx\)$'
        let s:play_cmd = "mplayer -quiet"
    endif

    if a:cmd != ''
        let s:play_cmd = a:cmd
    endif

    call unite#sources#radio#stop()
    let s:process = vimproc#popen2(s:play_cmd.' '.a:url)
    let s:process.url = a:url
    call s:widemessage("Now Playing: " . s:process.url)
endfunction "}}}

fun! unite#sources#radio#stop() "{{{
    if len(s:process)
        call s:process.kill(9)
    endif
    let s:process = {}
endfunction "}}}

au VimLeavePre * UniteMStop

fun! s:widemessage(msg) "{{{
    let x=&ruler | let y=&showcmd
    set noruler noshowcmd
    redraw
    echohl Debug | echo strpart(a:msg, 0, &columns-1) | echohl none
    let &ruler=x | let &showcmd=y
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
