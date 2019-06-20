function! cutthroat#command#prepare(command) abort
    let g:opsave = &operatorfunc
    let &operatorfunc = a:command
endfunction

"""Deleting {{{1
"
"""
function! cutthroat#command#delete(type, ...) abort

    if !a:0
        call setpos('.', getpos("'["))

        if a:type ==# 'char'
            normal! v
        elseif a:type ==# 'line'
            normal! V
        else " a:type ==# 'block'
            execute "normal! \<c-v>"
        endif

        call setpos('.', getpos("']"))
    endif

    normal! ygvd

    if !a:0
        let &operatorfunc = g:opsave
    endif

endfunction

function! cutthroat#command#deleteToEOL() abort
    normal! y$D
endfunction

function! cutthroat#command#deleteLine() abort
    normal! yydd
endfunction

"""Changing {{{1
"
"""
function! cutthroat#command#change(type, ...) abort

    if !a:0
        call setpos('.', getpos("'["))

        if a:type ==# 'char'
            normal! v
        elseif a:type ==# 'line'
            normal! V
        else " a:type ==# 'block'
            execute "normal! \<c-v>"
        endif

        call setpos('.', getpos("']"))
    endif

    execute 'normal! ygvc'

    if !a:0
        let &operatorfunc = g:opsave
    endif
endfunction

function! cutthroat#command#changeToEOL() abort
    normal! y$C
endfunction

function! cutthroat#command#changeLine() abort
    normal! yycc
endfunction

"""Changing {{{1
"
"""
function! cutthroat#command#replace(type, ...) abort

    if !a:0
        call setpos('.', getpos("'["))

        if a:type ==# 'char'
            normal! v
        elseif a:type ==# 'line'
            normal! V
        else " a:type ==# 'block'
            execute "normal! \<c-v>"
        endif

        call setpos('.', getpos("']"))
    endif

    execute 'normal! p'

    if !a:0
        let &operatorfunc = g:opsave
    endif
endfunction

function! cutthroat#command#replaceToEOL() abort
    normal! v$p
endfunction

function! cutthroat#command#replaceLine() abort
    normal! Vp
endfunction

"""Substituting {{{1
"
"""
function! cutthroat#command#subtitute(type, ...) abort

    if !a:0
        call setpos('.', getpos("'["))

        if a:type ==# 'char'
            normal! v
        elseif a:type ==# 'line'
            normal! V
        else " a:type ==# 'block'
            execute "normal! \<c-v>"
        endif

        call setpos('.', getpos("']"))
    endif

    execute 'normal! p'
    let @"=@-

    if !a:0
        let &operatorfunc = g:opsave
    endif
endfunction

function! cutthroat#command#subtituteToEOL() abort
    normal! v$p
    let @"=@-
endfunction

function! cutthroat#command#subtituteLine() abort
    normal! Vp
    let @"=@-
endfunction
