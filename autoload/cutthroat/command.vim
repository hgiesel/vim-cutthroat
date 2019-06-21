function! cutthroat#command#prepare(command) abort
  let g:opsave = &operatorfunc
  let s:register = v:register
  let &operatorfunc = a:command
endfunction

"""Deleting {{{1
"
"""
function! cutthroat#command#delete(type, ...) abort
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

function! cutthroat#command#deleteToEOL() abort
  execute 'normal! "'.v:register.'y$"_D'
endfunction

function! cutthroat#command#deleteLine() abort
  execute 'normal! "'.v:register.'yy"_dd'
endfunction

"""Changing {{{1
"
"""
function! cutthroat#command#change(type, ...) abort
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

function! cutthroat#command#changeToEOL() abort
  let [l:savedelreg, l:savedelregtype] = [getreg('-'), getregtype('-')]
  execute 'normal! v$"'. v:register .'ygv"_c'

  if 1 + col('.') ==# col('$')
    startinsert!
  else
    startinsert
  end

  call setreg('-', l:savedelreg, l:savedelregtype)
endfunction

function! cutthroat#command#changeLine() abort
  let [l:savedelreg, l:savedelregtype] = [getreg('-'), getregtype('-')]
  execute 'normal! V"'. v:register .'ygv"_c'

  if 1 + col('.') ==# col('$')
    startinsert!
  else
    startinsert
  end

  call setreg('-', l:savedelreg, l:savedelregtype)
endfunction

"""Changing {{{1
"
"""
function! cutthroat#command#replace(type, ...) abort
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

  execute 'normal! "' . l:register . 'p'

  if !a:0
    let &operatorfunc = g:opsave
  endif

  if exists('s:register')
    unlet s:register
  endif
endfunction

function! cutthroat#command#replaceToEOL() abort
  execute 'normal! v$"' . v:register . 'p'
endfunction

function! cutthroat#command#replaceLine() abort
  execute 'normal! V"' . v:register . 'p'
endfunction

"""Substituting {{{1
"
"""
function! cutthroat#command#substitute(type, ...) abort
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

  execute 'normal! "' . l:register . 'p'

  call cutthroat#helper#InsertIntoYankRing(getreg('-'), getregtype('-'))
  let @- = l:savedelreg

  if !a:0
    let &operatorfunc = g:opsave
  endif

  if exists('s:register')
    unlet s:register
  endif
endfunction

function! cutthroat#command#substituteToEOL() abort
  let l:savedelreg = @-
  execute 'normal! v$"'.v:register.'p'
  " call cutthroat#helper#InsertIntoYankRing(getreg('-'), getregtype('-'))
  " let @- = l:savedelreg
endfunction

function! cutthroat#command#substituteLine() abort
  let l:savedelreg = @-
  execute 'normal! V"'.v:register.'p'
  call cutthroat#helper#InsertIntoYankRing(getreg('-'), getregtype('-'))
  let @- = l:savedelreg
endfunction
