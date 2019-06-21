" command to delete
function! cutthroat#helper#clear_registers() abort
  let l:regs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')

  for r in l:regs
    call setreg(r, '')
  endfor

  let g:saved_nine_register = ''
  let g:saved_yank_register = ''
endfunction

function! cutthroat#helper#clear_yankring() abort
  if exists('g:yankring')
    let l:yankring_replacement = {}

    for k in keys(g:yankring)
      let l:yankring_replacement[k] = {'regcontents': '', 'regtype': ''}
    endfor
  endif

  let g:yankring = l:yankring_replacement
endfunction

function! cutthroat#helper#getyank(...) abort
  let l:result = ''

  if a:0 ==# 1
    let l:result .= (a:1 < 10 ? '0'.string(a:1) : string(a:1))
    let l:result .= '(' . get(g:yankring, a:1, {'regtype': 'null'})['regtype'] . ')'
    let l:result .= ":\t"
    let l:result .= get(g:yankring, a:1, {'regcontents': 'null'})['regcontents']
  else
    for i in range(g:yankring_size)
      let l:result .= (i < 10 ? '0'.string(i) : string(i))
      let l:result .= '(' . get(g:yankring, i)['regtype'] . ')'
      let l:result .= ":\t"
      let l:result .= get(g:yankring, i)['regcontents'] . "\n"
    endfor
  endif

  return l:result
endfunction

function! cutthroat#helper#SyncRegistersToYankRing() abort
  call setreg('"', g:yankring[0]['regcontents'], g:yankring[0]['regtype'])

  for i in range(10)
    call setreg(i, g:yankring[i]['regcontents'], g:yankring[i]['regtype'])
  endfor

  let l:letters = 'abcdefghijklmnopqrstuvwxyz'

  for i in range(g:yankring_size - 10)
    call setreg(l:letters[i], g:yankring[i + 10]['regcontents'], g:yankring[i + 10]['regtype'])
  endfor
endfunction

function! cutthroat#helper#InsertIntoYankRing(regcontents, regtype) abort
  for i in reverse(range(g:yankring_size))

    if i == 0
      let g:yankring[i] = {'regcontents': a:regcontents, 'regtype': a:regtype}
    else
      let g:yankring[i] = g:yankring[i - 1]
    endif

  endfor
endfunction

function! cutthroat#helper#RollbackYankRing(howmuch) abort

  for i in range(a:howmuch, g:yankring_size - 1)
    let g:yankring[i - a:howmuch] = g:yankring[i]
  endfor

  for i in range(g:yankring_size - a:howmuch, g:yankring_size - 1)
    let g:yankring[i]['regcontents'] = ''
  endfor
endfunction
