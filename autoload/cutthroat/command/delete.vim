"""Deleting {{{1
"
"""
function! cutthroat#command#delete#normal(type, ...) abort
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

  normal! ygv"_d

  if !a:0
    let &operatorfunc = g:opsave
  endif

  if exists('s:register')
    unlet s:register
  endif
endfunction

function! cutthroat#command#delete#toEOL() abort
  execute 'normal! "'.v:register.'y$"_D'
endfunction

function! cutthroat#command#delete#line() abort
  execute 'normal! "'.v:register.'yy"_dd'
endfunction
