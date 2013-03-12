" Show whitespace
set list
set listchars=tab:›\ ,eol:¬,trail:·

" Simpler gui...
set guioptions-=T
set guioptions-=r
set guioptions-=L
set guioptions-=m
set visualbell

if has('gui_macvim') " {{{
  set backupcopy=yes " this keeps finder file labels
  set noimdisable
  set guifont=Monaco:h9
  set fuoptions=maxvert,maxhorz
  macmenu Window.Toggle\ Full\ Screen\ Mode key=<D-CR>
  " cmd+option+arrows to switch tabs
  map <A-D-Right> :tabnext<CR>
  map <A-D-Left> :tabNext<CR>
  imap <A-D-Right> <ESC>:tabnext<CR>
  imap <A-D-Left> <ESC>:tabNext<CR>
  " custom full screen handling {{{
  function! s:HandleFullscreen()
    if &fullscreen == 0
      set guioptions+=e
    else
      set guioptions-=e
    endif
  endfunction

  if has("autocmd")
    augroup mygui
      au!
      au VimResized * call s:HandleFullscreen()
    augroup END
  endif
  " }}}
endif
" }}}

if has('gui_gtk2')
  set guioptions-=e
  set guifont=Monospace\ 7
  set linespace=-1
  set clipboard=unnamedplus
endif
