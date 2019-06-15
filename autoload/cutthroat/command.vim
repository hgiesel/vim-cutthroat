"""Deleting {{{1
"
"""
function cutthroat#command#delete(type, ...)

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

  set operatorfunc=
endfunction

function cutthroat#command#deleteToEOL()
  normal! y$D
endfunction

function cutthroat#command#deleteLine()
  normal! yydd
endfunction

"""Changing {{{1
"
"""
function cutthroat#command#change(type, ...)

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

  set operatorfunc=
endfunction

function cutthroat#command#changeToEOL()
    normal! y$C
endfunction

function cutthroat#command#changeLine()
    normal! yycc
endfunction

"""Changing {{{1
"
"""
function cutthroat#command#replace(type, ...)

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

  set operatorfunc=
endfunction

function cutthroat#command#replaceToEOL()
    normal! v$p
endfunction

function cutthroat#command#replaceLine()
    normal! Vp
endfunction

"""Substituting {{{1
"
"""
function cutthroat#command#substitute(type, ...)

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

  execute 'normal! ygvp'

  set operatorfunc=
endfunction

function cutthroat#command#replaceToEOL()
    normal! y$v$p
endfunction

function cutthroat#command#replaceLine()
    normal! yyVp
endfunction
