"""Changing {{{1
"
"""
function! cutthroat#command#change#normal(type, ...) abort
  let l:register = get(s:, 'register', v:register)
  let [l:savedelreg, l:savedelregtype] = [getreg('-'), getregtype('-')]

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

  execute 'normal! "'.l:register.'ygv"_c'
  if 1 + col('.') ==# col('$')
    startinsert!
  else
    startinsert
  end

  call setreg('-', l:savedelreg, l:savedelregtype)

  if !a:0
    let &operatorfunc = g:opsave
  endif

  if exists('s:register')
    unlet s:register
  endif
endfunction

function! cutthroat#command#change#toEOL() abort
  let [l:savedelreg, l:savedelregtype] = [getreg('-'), getregtype('-')]
  execute 'normal! v$"'. v:register .'ygv"_c'

  if 1 + col('.') ==# col('$')
    startinsert!
  else
    startinsert
  end

  call setreg('-', l:savedelreg, l:savedelregtype)
endfunction

function! cutthroat#command#change#line() abort
  let [l:savedelreg, l:savedelregtype] = [getreg('-'), getregtype('-')]
  execute 'normal! V"'. v:register .'ygv"_c'

  if 1 + col('.') ==# col('$')
    startinsert!
  else
    startinsert
  end

  call setreg('-', l:savedelreg, l:savedelregtype)
endfunction
