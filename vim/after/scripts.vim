function! s:looks_like_sub()
  let basename = expand('%:t')
  let parent = expand('%:h:t')
  let sub_name = substitute(basename,'-.*','','')
  return parent == 'libexec' && glob( 'libexec/' . sub_name)!=''
endfunction

" append .sub or set to sub
if s:looks_like_sub()
  if !(&filetype =~ '\.sub')
    set ft+=.sub
  endif
endif
