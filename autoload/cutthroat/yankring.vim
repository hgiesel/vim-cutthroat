function! s:DisableYankRing() abort
  " nunmap <C-n>
  " nunmap <C-p>

  " augroup! cutthroat-yankring
endfunction

function! cutthroat#yankring#enable() abort
    echo 'hi world'
    nnoremap <C-n> <cmd>echo 'go forward'<cr>
    nnoremap <C-p> <cmd>echo 'go backwards'<cr>

    augroup cutthroat-yankring
        autocmd!
        autocmd CursorMoved * call s:DisableYankRing()
    augroup END

    normal! p
endfunction
