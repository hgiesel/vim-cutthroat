

function! s:ExamineYank()

  if v:event['operator'] ==# 'c' ||
        \ v:event['operator'] ==# 'd'

    call setreg('-', v:event['regcontents'])
    call setreg('"', getreg('0'))

    call setreg('1', getreg('2'))
    call setreg('2', getreg('3'))
    call setreg('3', getreg('4'))
    call setreg('4', getreg('5'))
    call setreg('5', getreg('6'))
    call setreg('6', getreg('7'))
    call setreg('7', getreg('8'))
    call setreg('8', getreg('9'))
    call setreg('9', get(g:, 'saved_nine_register', ''))

    let g:saved_nine_register = getreg('9')

  elseif v:event['operator'] ==# 'y'

    let g:saved_nine_register = getreg('9')
    call setreg('9', getreg('8'))
    call setreg('8', getreg('7'))
    call setreg('7', getreg('6'))
    call setreg('6', getreg('5'))
    call setreg('5', getreg('4'))
    call setreg('4', getreg('3'))
    call setreg('3', getreg('2'))
    call setreg('2', getreg('1'))
    call setreg('1', get(g:, 'saved_yank_register'))

    let g:saved_yank_register = getreg('"')
  else
    echom 'I should not happen'
    echom 'I should not happen'
    echom 'I should not happen'
    echom 'I should not happen'
    echom v:event
  endif
endfunction

function s:GetYankRegister()
  let g:saved_yank_register = getreg('0')
endfunction

augroup cutthroat
  autocmd!
  autocmd TextYankPost * call s:ExamineYank()
  autocmd BufEnter * call s:GetYankRegister()
augroup END

