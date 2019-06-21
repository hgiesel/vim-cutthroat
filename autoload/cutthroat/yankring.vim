
let g:cutthroat#yankring#named_registers_count  = get(g:, 'cutthroat#yankring#numbered_registers_count', 0)

let g:cutthroat#yankring#command_p   = get(g:, 'cutthroat#yankring#command_p', 'p')
let g:cutthroat#yankring#command_P   = get(g:, 'cutthroat#yankring#command_P', 'P')
let g:cutthroat#yankring#command_v_p = get(g:, 'cutthroat#yankring#command_v_p', 'p')
let g:cutthroat#yankring#command_v_P = get(g:, 'cutthroat#yankring#command_v_P', 'P')
let g:cutthroat#yankring#command_gp  = get(g:, 'cutthroat#yankring#command_gp', 'gp')
let g:cutthroat#yankring#command_gP  = get(g:, 'cutthroat#yankring#command_gP', 'gP')

let g:cutthroat#yankring#allow_recursive_maps = get(g:, 'cutthroat#yankring#allow_recursive_maps', v:false)

function! s:InsertRegister(mode, register, visualmode)
  let l:base = 'normal'.(g:cutthroat#yankring#allow_recursive_maps ? '' : '!').' "' . a:register

  if a:mode ==# 'p'
    execute l:base . g:cutthroat#yankring#command_p
  elseif a:mode ==# 'P'
    execute l:base . g:cutthroat#yankring#command_P
  elseif a:mode ==# 'v_p'
    execute 'normal! ' . (!empty(a:visualmode) ? a:visualmode : 'v')
    call setpos('.',  s:origpos_end)
    normal! o

    execute l:base . g:cutthroat#yankring#command_v_p
  elseif a:mode ==# 'v_P'
    execute 'normal! ' . (!empty(a:visualmode) ? a:visualmode : 'v')
    call setpos('.',  s:origpos_end)
    normal! o

    execute l:base . g:cutthroat#yankring#command_v_P
  elseif a:mode ==# 'gp'
    execute l:base . g:cutthroat#yankring#command_gp
  else " if a:mode ==# 'gP'
    execute l:base . g:cutthroat#yankring#command_gP
  endif
endfunction

function! s:ReinsertYank() abort
  silent normal! u
  call setpos('.', s:origpos)

  if s:yank_current <= 9
    let l:register = string(s:yank_current)
  else " s:yank_current >= 10
    let l:register = 'abcdefghijklmnopqrstuvwxyz'[s:yank_current - 10]
  endif

  call s:InsertRegister(s:mode, l:register, s:visualmode)

  let s:startpos = getpos("'[")
  let s:endpos   = getpos("']")
endfunction

function! s:PrintCurrentYankOnCmdline() abort
  if s:yank_current <= 9
    echo 'Current register is "''' . s:yank_current . '"'
  else
    let l:letters = 'abcdefghijklmnopqrstuvwxyz'
    echo 'Current register is "''' . l:letters[s:yank_current - 10] . '"'
  endif
endfunction

function! s:YankForwards() abort
  let s:yank_current += 1
  if s:yank_current >= g:yankring_size
    let s:yank_current = 0
  endif

  call s:PrintCurrentYankOnCmdline()
  call s:ReinsertYank()
endfunction

function! s:YankBackwards() abort
  let s:yank_current -= 1
  if s:yank_current < 0
    let s:yank_current = g:yankring_size - 1
  endif

  call s:PrintCurrentYankOnCmdline()
  call s:ReinsertYank()
endfunction

function! cutthroat#yankring#enable(mode) abort
  let l:register                   = v:register
  let l:paste_from_within_yankring = v:false
  let s:origpos                    = getpos('.')

  if a:mode ==# 'v_p' || a:mode ==# 'v_P'
    if index(['v', 'V', ''], mode())
      normal! gv
    endif

    let s:visualmode  = visualmode()
    let s:origpos_end = getpos('v')
  else " fake values, these should never be used
    let s:visualmode  = 'v'
    let s:origpos_end = s:origpos
  endif

  if index(split('"0123456789' . (g:yankring_size > 10 ? 'abcdefghijklmnopqrstuvwxyz'[0:g:yankring_size - 11]: ''), '\zs'), v:register) > -1
    let l:paste_from_within_yankring = v:true
    if match(l:register, '[0-9]') ==# 0
      let s:yank_current = str2nr(l:register)
    elseif match(l:register, '[a-z]') ==# 0
      let s:yank_current = 10 + index(split('abcdefghijklmnopqrstuvwxyz', '\zs'), l:register)
    else " l:register ==3 '"'
      let s:yank_current = 0
    endif

    if !exists('s:save_ctrl_n')
      let s:save_ctrl_n = maparg('<c-n>', 'n', v:false, v:true)
      let s:save_ctrl_p = maparg('<c-p>', 'n', v:false, v:true)
    endif

    nnoremap <c-n> <cmd>call <sid>YankForwards()<cr>
    nnoremap <c-p> <cmd>call <sid>YankBackwards()<cr>

    augroup cutthroat-yankring-checkifstillvalid
      autocmd!
    augroup END
  endif

  normal! 

  let s:mode = a:mode
  call s:InsertRegister(a:mode, l:register, s:visualmode)

  if l:paste_from_within_yankring
    call s:UpdatePos()
  endif
endfunction

""
" This is called right after the "p" command is executed
""
function! s:UpdatePos() abort
  let s:startpos = getpos("'[")
  let s:endpos   = getpos("']")
  let s:regtype  = getregtype('"')

  augroup cutthroat-yankring-checkifstillvalid
    autocmd!
    autocmd TextChanged  * call <sid>CheckIfStillValid(v:false)
    autocmd InsertEnter  * call <sid>CheckIfStillValid(v:true)
    autocmd InsertLeave  * call <sid>CheckIfStillValid(v:true)
  augroup END
endfunction

function! s:CheckIfStillValid(force) abort
  if a:force || s:startpos !=# getpos("'[") || s:endpos !=# getpos("']") || s:regtype !=# getregtype('"')

    execute "normal! \<c-l>"

    if !empty(maparg('<c-n>', 'n'))
      if s:save_ctrl_n ==# {}
        nunmap <c-n>
      else
        execute 'n' . (s:save_ctrl_n['noremap'] ? 'noremap' : 'map') . ' <C-n> ' . s:save_ctrl_n['rhs']
      endif

      unlet s:save_ctrl_n
    endif

    if !empty(maparg('<c-p>', 'n'))
      if s:save_ctrl_p ==# {}
        nunmap <c-p>
      else
        execute 'n' . (s:save_ctrl_p['noremap'] ? 'noremap' : 'map') . ' <C-p> ' . s:save_ctrl_p['rhs']
      endif

      unlet s:save_ctrl_p
    endif

    augroup cutthroat-yankring-checkifstillvalid
      autocmd!
    augroup END
  endif
endfunction
