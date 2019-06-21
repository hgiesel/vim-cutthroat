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
  let l:result = ''

  if a:0 ==# 1
    let l:result .= (a:1 < 10 ? '0'.string(a:1) : string(a:1))
    let l:result .= '(' . get(g:yankring, a:1, {'regtype': 'null'})['regtype'] . ')'
    let l:result .= ":\t"
    let l:result .= get(g:yankring, a:1, {'regcontents': 'null'})['regcontents']
  else
    for i in range(g:yankring_size)
      let l:result .= (i < 10 ? '0'.string(i) : string(i)).'('.get(g:yankring, i).')'. ":\t" . get(g:yankring, i)['regcontents'] . "\n"
    endfor
  endif

  return l:result
endfunction
