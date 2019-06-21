"""Replacing {{{1
"
"""
function! cutthroat#command#replace#normal(type, ...) abort
  let l:register = get(s:, 'register', v:register)

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

  execute 'normal "' . l:register . 'p'

  if !a:0
    let &operatorfunc = g:opsave
  endif

  if exists('s:register')
    unlet s:register
  endif
endfunction

function! cutthroat#command#replace#toEOL() abort
  execute 'normal v$"' . v:register . 'p'
endfunction

function! cutthroat#command#replace#line() abort
  execute 'normal V"' . v:register . 'p'
endfunction
