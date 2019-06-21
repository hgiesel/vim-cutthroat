
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
  if a:size >= 26
    let l:size = 25
  else
    let l:size = a:size
  end

  let l:letters       = 'abcdefghijklmnopqrstuvwxyz'
  let g:yankring_size = 10 + l:size
  let g:yankring      = {}

  for i in range(g:yankring_size)
    if i <=# 9
      let g:yankring[i] = getreg(string(i))
    else
      let g:yankring[i] = getreg(l:letters[i - 10])
    endif
  endfor
endfunction

augroup cutthroat
  autocmd!
  autocmd TextYankPost * call s:ExamineYank()
  autocmd BufEnter * call s:GetYankRegister()
  autocmd CursorMoved * call s:CreateYankRing(5)
augroup END

nmap <silent> <plug>(CutthroatDelete)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#delete')<cr>g@
nmap <silent> <plug>(CutthroatDeleteLine)
      \ <cmd>call cutthroat#command#deleteLine()<cr>
nmap <silent> <plug>(CutthroatDeleteToEOL)
      \ <cmd>call cutthroat#command#deleteToEOL()<cr>
xmap <silent> <plug>(CutthroatDeleteVisual)
      \ <cmd>call cutthroat#command#delete(visualmode(), v:true)<cr>

nmap <silent> <plug>(CutthroatChange)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#change')<cr>g@
nmap <silent> <plug>(CutthroatChangeLine)
      \ <cmd>call cutthroat#command#changeLine()<cr>
nmap <silent> <plug>(CutthroatChangeToEOL)
      \ <cmd>call cutthroat#command#changeToEOL()<cr>
xmap <silent> <plug>(CutthroatChangeVisual)
      \ <cmd>call cutthroat#command#change(visualmode(), v:true)<cr>

nmap <silent> <plug>(CutthroatReplace)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#replace')<cr>g@
nmap <silent> <plug>(CutthroatReplaceLine)
      \ <cmd>call cutthroat#command#replaceLine()<cr>
nmap <silent> <plug>(CutthroatReplaceToEOL)
      \ <cmd>call cutthroat#command#replaceToEOL()<cr>
xmap <silent> <plug>(CutthroatReplaceVisual)
      \ <cmd>call cutthroat#command#replace(visualmode(), v:true)<cr>

nmap <silent> <plug>(CutthroatSubstitute)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#substitute')<cr>g@
nmap <silent> <plug>(CutthroatSubstituteLine)
      \ <cmd>call cutthroat#command#substituteLine()<cr>
nmap <silent> <plug>(CutthroatSubstituteToEOL)
      \ <cmd>call cutthroat#command#substituteToEOL()<cr>
xmap <silent> <plug>(CutthroatSubstituteVisual)
      \ <cmd>call cutthroat#command#substitute(visualmode(), v:true)<cr>

nnoremap <plug>(CutthroatYankRing)
      \ <cmd>call cutthroat#yankring#enable()<cr>
nmap p <plug>(CutthroatYankRing)<cmd>normal! p<cr>

command! ClearRegisters call cutthroat#helper#clear_registers()
command! -nargs=? GetReg echo cutthroat#helper#getreg(<args>)
