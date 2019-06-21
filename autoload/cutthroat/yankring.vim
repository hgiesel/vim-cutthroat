function! cutthroat#yankring#DisableYankRing() abort
  echo s:yank_current

  nunmap <C-n>
  nunmap <C-p>
endfunction


function! s:ReselectSection() abort
  call setpos('.', s:startpos)
  execute 'normal! ' . s:regtype
  call setpos('.', s:endpos)
endfunction

function! s:ReinsertYank() abort
  undojoin | noautocmd execute 'normal! "_d'
  normal! 
  call setpos('.', s:origpos)

 . cutthroat#helper#getreg(s:yank_current)
  let s:regtype  = getregtype('"')
  let s:startpos = getpos("'[")
  let s:endpos   = getpos("']")
endfunction

function! s:RestoreInput() abort
  call inputrestore()
endfunction

function! s:PrintCurrentYankOnCmdline() abort
  call inputsave()

  if s:yank_current <= 9
    echo 'Current register is "''' . s:yank_current . '"'
  else
    let l:letters = 'abcdefghijklmnopqrstuvwxyz'
    echo 'Current register is "''' . l:letters[s:yank_current - 10] . '"'
  endif

  call jobstart('sleep 3', { 'on_exit': {a, b, c -> s:RestoreInput() }}) 
endfunction

function! s:YankForwards() abort

  let s:yank_current += 1
  if s:yank_current >= g:yankring_size
    let s:yank_current = 0
  endif

  call s:PrintCurrentYankOnCmdline()
  call s:ReselectSection()
  call s:ReinsertYank()

endfunction

function! s:YankBackwards() abort

  let s:yank_current -= 1
  if s:yank_current < 0
    let s:yank_current = g:yankring_size - 1
  endif

  call s:PrintCurrentYankOnCmdline()
  call s:ReselectSection()
  call s:ReinsertYank()

endfunction

function! cutthroat#yankring#enable(mode) abort

  if index(split('"0123456789' . (g:yankring_size > 10 ? 'abcdefghijklmnopqrstuvwxyz'[0:g:yankring_size - 11]: ''), '\zs'), v:register) > -1
    if match(v:register, '[0-9]') ==# 0
      let s:yank_current = str2nr(v:register)
    elseif match(v:register, '[a-z]') ==# 0
      let s:yank_current = 10 + index(split('abcdefghijklmnopqrstuvwxyz', '\zs'), v:register)
    else " v:register ==3 '"'
      let s:yank_current = 0
    endif

    let s:origpos = getpos('.')

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
  endif

  if a:mode ==# 'p'
    execute 'normal! "' . v:register . 'p'
  elseif a:mode ==# 'P'
    execute 'normal! "' . v:register . 'P'
  elseif a:mode ==# 'v_p'
    execute 'normal! "' . v:register . 'p'
  else " a:mode ==# 'v_P'
    execute 'normal! "' . v:register . 'P'
  endif
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
