"""Substituting {{{1
"
"""
function! cutthroat#command#exchange#normal(type, ...) abort
  let l:register = get(s:, 'register', v:register)
  let l:savedelreg = @-

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

  call cutthroat#helper#InsertIntoYankRing(getreg('-'), getregtype('-'))
  let @- = l:savedelreg

  if !a:0
    let &operatorfunc = g:opsave
  endif

  if exists('s:register')
    unlet s:register
  endif
endfunction

function! cutthroat#command#exchange#toEOL() abort
  let l:savedelreg = @-
  execute 'normal v$"' . v:register . 'p'
  " call cutthroat#helper#InsertIntoYankRing(getreg('-'), getregtype('-'))
  " let @- = l:savedelreg
endfunction

function! cutthroat#command#exchange#line() abort
  let l:savedelreg = @-
  execute 'normal V"' . v:register . 'p'
  call cutthroat#helper#InsertIntoYankRing(getreg('-'), getregtype('-'))
  let @- = l:savedelreg
endfunction
