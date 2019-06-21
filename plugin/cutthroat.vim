
function! s:ExamineYank() abort
  if v:event['operator'] ==# 'c' || v:event['operator'] ==# 'd'
    call setreg('-', v:event['regcontents'], v:event['regtype'])
    call cutthroat#helper#SyncRegistersToYankRing()

  elseif v:event['operator'] ==# 'y'
    call cutthroat#helper#InsertIntoYankRing(join(v:event['regcontents'], "\n"), v:event['regtype'])
    call cutthroat#helper#SyncRegistersToYankRing()

  else
    echom 'I should not happen'
    echom 'I should not happen'
    echom v:event
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
      let g:yankring[i] = {'regcontents': getreg(string(i)), 'regtype': getregtype(string(i))}
    else
      let g:yankring[i] = {'regcontents': getreg(l:letters[i - 10]), 'regtype': getregtype(l:letters[i - 10])}
    endif
  endfor
endfunction

augroup cutthroat
  autocmd!
  autocmd TextYankPost * call s:ExamineYank()
  autocmd CursorMoved * call cutthroat#helper#SyncRegistersToYankRing()
  autocmd VimEnter * call s:CreateYankRing(g:cutthroat#yankring#named_registers_count)
augroup END

nnoremap <silent> <plug>(CutthroatDelete)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#delete')<cr>g@
nnoremap <silent> <plug>(CutthroatDeleteLine)
      \ <cmd>call cutthroat#command#deleteLine()<cr>
nnoremap <silent> <plug>(CutthroatDeleteToEOL)
      \ <cmd>call cutthroat#command#deleteToEOL()<cr>
xnoremap <silent> <plug>(CutthroatDeleteVisual)
      \ <cmd>call cutthroat#command#delete(visualmode(), v:true)<cr>

nnoremap <silent> <plug>(CutthroatChange)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#change')<cr>g@
nnoremap <silent> <plug>(CutthroatChangeLine)
      \ <cmd>call cutthroat#command#changeLine()<cr>
nnoremap <silent> <plug>(CutthroatChangeToEOL)
      \ <cmd>call cutthroat#command#changeToEOL()<cr>
xnoremap <silent> <plug>(CutthroatChangeVisual)
      \ <cmd>call cutthroat#command#change(visualmode(), v:true)<cr>

nnoremap <silent> <plug>(CutthroatReplace)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#replace')<cr>g@
nnoremap <silent> <plug>(CutthroatReplaceLine)
      \ <cmd>call cutthroat#command#replaceLine()<cr>
nnoremap <silent> <plug>(CutthroatReplaceToEOL)
      \ <cmd>call cutthroat#command#replaceToEOL()<cr>
xnoremap <silent> <plug>(CutthroatReplaceVisual)
      \ <cmd>call cutthroat#command#replace(visualmode(), v:true)<cr>

nnoremap <silent> <plug>(CutthroatExchange)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#substitute')<cr>g@
nnoremap <silent> <plug>(CutthroatExchangeLine)
      \ <cmd>call cutthroat#command#substituteLine()<cr>
nnoremap <silent> <plug>(CutthroatExchangeToEOL)
      \ <cmd>call cutthroat#command#substituteToEOL()<cr>
xnoremap <silent> <plug>(CutthroatExchangeVisual)
      \ <cmd>call cutthroat#command#substitute(visualmode(), v:true)<cr>

nnoremap <plug>(CutthroatYankRing_p)
      \ <cmd>call cutthroat#yankring#enable('p')<cr>
nnoremap <plug>(CutthroatYankRing_P)
      \ <cmd>call cutthroat#yankring#enable('P')<cr>

nnoremap <plug>(CutthroatYankRing_gp)
      \ <cmd>call cutthroat#yankring#enable('gp')<cr>
nnoremap <plug>(CutthroatYankRing_gP)
      \ <cmd>call cutthroat#yankring#enable('gP')<cr>

xnoremap <plug>(CutthroatYankRing_v_p)
      \ <cmd>call cutthroat#yankring#enable('v_p')<cr>
xnoremap <plug>(CutthroatYankRing_v_P)
      \ <cmd>call cutthroat#yankring#enable('v_P')<cr>

command! ClearRegisters call cutthroat#helper#clear_registers()
command! ClearYankRing call cutthroat#helper#clear_yankring()
command! -nargs=? GetReg echo cutthroat#helper#getreg(<args>)
