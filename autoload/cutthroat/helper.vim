" command to delete
function! cutthroat#helper#clear_registers() abort
  let l:regs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')

  for r in l:regs
    call setreg(r, '')
  endfor

  let g:saved_nine_register = ''
  let g:saved_yank_register = ''
endfunction

function! cutthroat#helper#getreg(...) abort
  if a:0 == 1
    return get(g:yankring, a:1, '')
  else

    let l:result = []
    for i in range(g:yankring_size)
      call add(l:result, g:yankring[i])
    endfor

    return l:result
  endif
endfunction
