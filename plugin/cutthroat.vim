" command to delete
command! ClearRegisters call <sid>ClearRegisters()
function! s:ClearRegisters() abort
  let l:regs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')

  for r in l:regs
    call setreg(r, '')
  endfor

  let g:saved_nine_register = ''
  let g:saved_yank_register = ''
endfunction

function! s:ExamineYank() abort

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
    " augroup cutthroat_oneshot
    "   autocmd CursorHold
    " augroup END
  endif

endfunction

function! s:GetYankRegister() abort
  let g:saved_yank_register = getreg('0')
endfunction

function! s:CreateYankRing(size) abort

  let g:yankring = {}
  for i in range(10 + a:size)
    if i <=# 9
      let g:yankring[i] = getreg(string(i))
    else
      let g:yankring[i] = ''
    endif
  endfor
endfunction

augroup cutthroat
  autocmd!
  autocmd TextYankPost * call s:ExamineYank()
  autocmd BufEnter * call s:GetYankRegister()
  autocmd CursorMoved * call s:CreateYankRing(5)
augroup END

nmap <silent> <plug>(CutthroatDelete) <cmd>call cutthroat#command#prepare('cutthroat#command#delete')<cr>g@
nmap <silent> <plug>(CutthroatDeleteLine) <cmd>call cutthroat#command#deleteLine()<cr>
nmap <silent> <plug>(CutthroatDeleteToEOL) <cmd>call cutthroat#command#deleteToEOL()<cr>
xmap <silent> <plug>(CutthroatDeleteVisual) <cmd>call cutthroat#command#delete(visualmode(), 1)<CR>

nmap <silent> <plug>(CutthroatChange) <cmd>call cutthroat#command#prepare('cutthroat#command#change')<cr>g@
nmap <silent> <plug>(CutthroatChangeLine) <cmd>call cutthroat#command#changeLine()<cr>
nmap <silent> <plug>(CutthroatChangeToEOL) <cmd>call cutthroat#command#changeToEOL()<cr>
xmap <silent> <plug>(CutthroatChangeVisual) <cmd>call cutthroat#command#change(visualmode(), 1)<CR>

nmap <silent> <plug>(CutthroatReplace) <cmd>call cutthroat#command#prepare('cutthroat#command#replace')<cr>g@
nmap <silent> <plug>(CutthroatReplaceLine) <cmd>call cutthroat#command#replaceLine()<cr>
nmap <silent> <plug>(CutthroatReplaceToEOL) <cmd>call cutthroat#command#replaceToEOL()<cr>
xmap <silent> <plug>(CutthroatReplaceVisual) <cmd>call cutthroat#command#replace(visualmode(), 1)<CR>

nmap <silent> <plug>(CutthroatSubstitute) <cmd>call cutthroat#command#prepare('cutthroat#command#substitute')<cr>g@
nmap <silent> <plug>(CutthroatSubstituteLine) <cmd>call cutthroat#command#substituteLine()<cr>
nmap <silent> <plug>(CutthroatSubstituteToEOL) <cmd>call cutthroat#command#substituteToEOL()<cr>
xmap <silent> <plug>(CutthroatSubstituteVisual) <cmd>call cutthroat#command#substitute(visualmode(), 1)<cr>

nmap <silent> <plug>(CutthroatYankring) <cmd>call cutthroat#yankring#enable()<cr>
