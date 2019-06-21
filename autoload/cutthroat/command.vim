function! cutthroat#command#prepare(command) abort
  let g:opsave = &operatorfunc
  let s:register = v:register
  let &operatorfunc = a:command
endfunction
