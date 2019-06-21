function! cutthroat#yankring#DisableYankRing() abort
  echo s:yank_current

  nunmap <C-n>
  nunmap <C-p>

  " augroup! cutthroat-yankring
endfunction


function! s:ReselectSection() abort
  call setpos('.', s:startpos)
  execute 'normal! ' . s:regtype
  call setpos('.', s:endpos)
endfunction

function! s:ReinsertYank() abort
  noautocmd execute 'normal! c' . cutthroat#helper#getreg(s:yank_current)
  normal! 
  call setpos('.', s:startpos)

  let s:regtype  = getregtype('"')
  let s:startpos = getpos("'[")
  let s:endpos   = getpos("']")

endfunction


function! s:YankForwards() abort

  let s:yank_current += 1
  if s:yank_current >= g:yankring_size
    let s:yank_current = 0
  endif

  call s:ReselectSection()
  call s:ReinsertYank()

endfunction

function! s:YankBackwards() abort

  let s:yank_current -= 1
  if s:yank_current < 0
    let s:yank_current = g:yankring_size - 1
  endif

  call s:ReselectSection()
  call s:ReinsertYank()

endfunction

function! cutthroat#yankring#enable() abort
  let s:yank_current = 0

  if !exists('s:save_ctrl_n')
    let s:save_ctrl_n = maparg('<c-n>', 'n', v:false, v:true)
    let s:save_ctrl_p = maparg('<c-p>', 'n', v:false, v:true)
  endif

  nnoremap <c-n> <cmd>call <sid>YankForwards()<cr>
  nnoremap <c-p> <cmd>call <sid>YankBackwards()<cr>

  augroup cutthroat-yankring-checkifstillvalid
    autocmd!
  augroup END

  augroup cutthroat-yankring-getpos
    autocmd!
    autocmd TextChanged * call <sid>UpdatePos()
  augroup END
endfunction

function! s:UpdatePos() abort
  let s:startpos = getpos("'[")
  let s:endpos   = getpos("']")
  let s:regtype  = getregtype('"')

  augroup cutthroat-yankring-getpos
    autocmd!
  augroup END

  augroup cutthroat-yankring-checkifstillvalid
    autocmd!
    autocmd TextChanged  * call <sid>CheckIfStillValid()
    autocmd TextChangedI * call <sid>CheckIfStillValid()
    autocmd TextChangedP * call <sid>CheckIfStillValid()
  augroup END
endfunction


function! s:CheckIfStillValid() abort

  if s:startpos !=# getpos("'[") || s:endpos !=# getpos("']") || s:regtype !=# getregtype('"')

    if s:save_ctrl_n  == {}
      nunmap <c-n>
    else
      execute 'n' . (s:save_ctrl_n['noremap'] ? 'noremap' : 'map') . ' <C-n> ' . s:save_ctrl_n['rhs']
    endif

    if s:save_ctrl_p  == {}
      nunmap <c-p>
    else
      execute 'n' . (s:save_ctrl_p['noremap'] ? 'noremap' : 'map') . ' <C-p> ' . s:save_ctrl_p['rhs']
    endif

    augroup cutthroat-yankring-checkifstillvalid
      autocmd!
    augroup END
  endif

endfunction
