" command to delete
command ClearRegisters call <sid>ClearRegisters()
function! s:ClearRegisters()
  let l:regs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')

  for r in l:regs
    call setreg(r, '')
  endfor

  let g:saved_nine_register = ''
  let g:saved_yank_register = ''
endfunction

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

  if v:event['regname'] !=# ''
    echom 'You copied to a register'
    augroup cutthroat_oneshot
      autocmd CursorHold
    augroup END
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

nnoremap <silent> <plug>(CutthroatDelete) <cmd>set operatorfunc=cutthroat#command#delete<cr>g@
nnoremap <silent> <plug>(CutthroatDeleteLine) <cmd>call cutthroat#command#deleteLine()<cr>
nnoremap <silent> <plug>(CutthroatDeleteToEOL) <cmd>call cutthroat#command#deleteToEOL()<cr>
xnoremap <silent> <plug>(CutthroatDeleteVisual) <cmd>call cutthroat#command#delete(visualmode(), 1)<CR>

nnoremap <silent> <plug>(CutthroatChange) <cmd>set operatorfunc=cutthroat#command#change<cr>g@
nnoremap <silent> <plug>(CutthroatChangeLine) <cmd>call cutthroat#command#changeLine()<cr>
nnoremap <silent> <plug>(CutthroatChangeToEOL) <cmd>call cutthroat#command#changeToEOL()<cr>
xnoremap <silent> <plug>(CutthroatChangeVisual) <cmd>call cutthroat#command#change(visualmode(), 1)<CR>

nnoremap <silent> <plug>(CutthroatReplace) <cmd>set operatorfunc=cutthroat#command#replace<cr>g@
nnoremap <silent> <plug>(CutthroatReplaceLine) <cmd>call cutthroat#command#replaceLine()<cr>
nnoremap <silent> <plug>(CutthroatReplaceToEOL) <cmd>call cutthroat#command#replaceToEOL()<cr>
xnoremap <silent> <plug>(CutthroatReplaceVisual) <cmd>call cutthroat#command#replace(visualmode(), 1)<CR>

nnoremap <silent> <plug>(CutthroatSubstitute) <cmd>set operatorfunc=cutthroat#command#substitute<cr>g@
nnoremap <silent> <plug>(CutthroatSubstituteLine) <cmd>call cutthroat#command#substituteLine()<cr>
nnoremap <silent> <plug>(CutthroatSubstituteToEOL) <cmd>call cutthroat#command#substituteToEOL()<cr>
xnoremap <silent> <plug>(CutthroatSubstituteVisual) <cmd>call cutthroat#command#substitute(visualmode(), 1)<CR>
