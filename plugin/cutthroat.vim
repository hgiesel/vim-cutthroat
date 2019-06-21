
function! s:ExamineYank() abort

  if v:event['operator'] ==# 'c' ||
        \ v:event['operator'] ==# 'd'

    call setreg('-', v:event['regcontents'], v:event['regtype'])
    call s:SyncRegistersToYankRing()

  elseif v:event['operator'] ==# 'y'

    call s:InsertIntoYankRing(join(v:event['regcontents'], "\n"), v:event['regtype'])
    call s:SyncRegistersToYankRing()

  else
    echom 'I should not happen'
    echom 'I should not happen'
    echom v:event
  endif
endfunction

function! s:InsertIntoYankRing(regcontents, regtype) abort
  for i in reverse(range(g:yankring_size))

    if i == 0
      let g:yankring[i] = {'regcontents': a:regcontents, 'regtype': a:regtype}
    else
      let g:yankring[i] = g:yankring[i - 1]
    endif

  endfor
endfunction

function! s:RollbackYankRing(howmuch) abort

  for i in range(a:howmuch, g:yankring_size - 1)
    let g:yankring[i - a:howmuch] = g:yankring[i]
  endfor

  for i in range(g:yankring_size - a:howmuch, g:yankring_size - 1)
    let g:yankring[i]['regcontents'] = ''
  endfor
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

function! s:SyncRegistersToYankRing() abort
  call setreg('"', g:yankring[0]['regcontents'], g:yankring[0]['regtype'])

  for i in range(10)
    call setreg(i, g:yankring[i]['regcontents'], g:yankring[i]['regtype'])
  endfor

  let l:letters = 'abcdefghijklmnopqrstuvwxyz'

  for i in range(g:yankring_size - 10)
    call setreg(l:letters[i], g:yankring[i + 10]['regcontents'], g:yankring[i + 10]['regtype'])
  endfor
endfunction

augroup cutthroat
  autocmd!
  autocmd TextYankPost * call s:ExamineYank()
  autocmd CursorMoved * call s:SyncRegistersToYankRing()
  autocmd VimEnter * call s:CreateYankRing(5)
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

nnoremap <silent> <plug>(CutthroatSubstitute)
      \ <cmd>call cutthroat#command#prepare('cutthroat#command#substitute')<cr>g@
nnoremap <silent> <plug>(CutthroatSubstituteLine)
      \ <cmd>call cutthroat#command#substituteLine()<cr>
nnoremap <silent> <plug>(CutthroatSubstituteToEOL)
      \ <cmd>call cutthroat#command#substituteToEOL()<cr>
xnoremap <silent> <plug>(CutthroatSubstituteVisual)
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
command! -nargs=? GetReg echo cutthroat#helper#getreg(<args>)
