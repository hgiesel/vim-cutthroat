function! cutthroat#command#prepare(command)
    let g:opsave = &operatorfunc
    let &operatorfunc = a:command
endfunction

"""Deleting {{{1
"
"""
function! cutthroat#command#delete(type, ...)

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

  let &operatorfunc = g:opsave
endfunction

function! cutthroat#command#deleteToEOL()
  normal! y$D
endfunction

function! cutthroat#command#deleteLine()
  normal! yydd
endfunction

"""Changing {{{1
"
"""
function! cutthroat#command#change(type, ...)

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

  let &operatorfunc = g:opsave
endfunction

function! cutthroat#command#changeToEOL()
    normal! y$C
endfunction

function! cutthroat#command#changeLine()
    normal! yycc
endfunction

"""Changing {{{1
"
"""
function! cutthroat#command#replace(type, ...)

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

  let &operatorfunc = g:opsave
endfunction

function! cutthroat#command#replaceToEOL()
    normal! v$p
endfunction

function! cutthroat#command#replaceLine()
    normal! Vp
endfunction

"""Substituting {{{1
"
"""
function! cutthroat#command#subtitute(type, ...)

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

  let &operatorfunc = g:opsave
endfunction

function! cutthroat#command#subtituteToEOL()
    normal! v$p
    let @"=@-
endfunction

function! cutthroat#command#subtituteLine()
    normal! Vp
    let @"=@-
endfunction
