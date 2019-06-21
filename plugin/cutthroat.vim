
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
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#delete#normal')<cr>g@
nnoremap <silent> <plug>(CutthroatDeleteLine)
      \ <cmd>call cutthroat#command#delete#line()<cr>
nnoremap <silent> <plug>(CutthroatDeleteToEOL)
      \ <cmd>call cutthroat#command#delete#toEOL()<cr>
xnoremap <silent> <plug>(CutthroatDeleteVisual)
      \ <cmd>call cutthroat#command#delete#normal(visualmode(), v:true)<cr>

nnoremap <silent> <plug>(CutthroatChange)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#change#normal')<cr>g@
nnoremap <silent> <plug>(CutthroatChangeLine)
      \ <cmd>call cutthroat#command#change#line()<cr>
nnoremap <silent> <plug>(CutthroatChangeToEOL)
      \ <cmd>call cutthroat#command#change#toEOL()<cr>
xnoremap <silent> <plug>(CutthroatChangeVisual)
      \ <cmd>call cutthroat#command#change#normal(visualmode(), v:true)<cr>

nnoremap <silent> <plug>(CutthroatReplace)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#replace#normal')<cr>g@
nnoremap <silent> <plug>(CutthroatReplaceLine)
      \ <cmd>call cutthroat#command#replace#line()<cr>
nnoremap <silent> <plug>(CutthroatReplaceToEOL)
      \ <cmd>call cutthroat#command#replace#toEOL()<cr>
xnoremap <silent> <plug>(CutthroatReplaceVisual)
      \ <cmd>call cutthroat#command#replace#normal(visualmode(), v:true)<cr>

nnoremap <silent> <plug>(CutthroatExchange)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#exchange#normal')<cr>g@
nnoremap <silent> <plug>(CutthroatExchangeLine)
      \ <cmd>call cutthroat#command#exchange#line()<cr>
nnoremap <silent> <plug>(CutthroatExchangeToEOL)
      \ <cmd>call cutthroat#command#exchange#toEOL()<cr>
xnoremap <silent> <plug>(CutthroatExchangeVisual)
      \ <cmd>call cutthroat#command#exchange#normal(visualmode(), v:true)<cr>

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
command! -nargs=? GetYank echo cutthroat#helper#getyank(<args>)
