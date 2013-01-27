function! s:strip()
  if exists("b:dont_strip")
    return
  endif
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction

if has("autocmd")
  au BufWritePre * call s:strip()
end
