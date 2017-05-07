function! SpaceVim#issue#report() abort
    call s:open()
endfunction

function! s:open() abort
    exe 'tabnew ' . tempname() . '/issue_report.md'
    call setline(1, s:template())
    w
endfunction

function! s:template() abort
    let info = [
                \ '<!-- please remove the issue template when request for a feature -->',
                \ '## Expected behavior, english is recommend',
                \ '',
                \ '## Environment Information',
                \ '',
                \ '- OS:' . SpaceVim#api#import('system').name(),
                \ '- vim version:' . (has('nvim') ? '' : v:version),
                \ '- neovim version:' . (has('nvim') ? v:version : ''),
                \ '',
                \ '## The reproduce ways from Vim starting (Required!)',
                \ '',
                \ '## Output of the `:SPDebugInfo!`',
                \ '']
                \ + split(execute(':SPDebugInfo'), "\n") +
                \ [
                \ '## Screenshots',
                \ '',
                \ 'If you have any screenshots for this issue please upload here. BTW you can use https://asciinema.org/ for recording video  in terminal.'
                \ ]
    return info
endfunction
