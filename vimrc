" prime the pathogen {{{
call pathogen#infect()
" }}}

" Some simple settings... {{{
set nocompatible
set backspace=indent,eol,start " sane backspacing
set hidden " don't complain when hiding modified buffers
set number " always linenumbers
set ts=2 sts=2 sw=2 expandtab " default indentation settings
set showcmd " Show (partial) command in the status line
set foldmethod=marker foldlevelstart=99
set swb=useopen,split " buffer switching behaviour
set autowrite autoread
set hlsearch incsearch ignorecase smartcase
noh " don't highlight search after sourcing this file
set wildmode=list:longest,list:full wildmenu
set wildignore+=*.o,*.obj,*.rbc,*.class,.git/*,vendor/*
set laststatus=2
set stl=%f%(\ \|\ %Y%)%(\ \|\ %M%R%)%=\|\ B:%n\ %p%%\ %3l/%L\ %c\ \|
set modeline modelines=10
set exrc " load local .vimrc
set mouse=a
" directories for backup and swpfiles
set backupdir=~/.vim/backup directory=~/.vim/backup backupcopy=yes
behave xterm " traditional visual mode
set cursorline cursorcolumn
" }}}

" fix ctrl+cursor keys in tmux {{{
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  exec "set <xUp>=\e[1;*A"
  exec "set <xDown>=\e[1;*B"
  exec "set <xRight>=\e[1;*C"
  exec "set <xLeft>=\e[1;*D"
  exec "set <PageUp>=\e[5;*~"
  exec "set <PageDown>=\e[6;*~"
  exec "set <xHome>=\e[1;*H"
  exec "set <xEnd>=\e[1;*F"
  " fix dragging inside tmux
  set ttymouse=xterm2
endif
" }}}

" global key mappings {{{
" change to the current file path
map <Leader>cd :lcd <C-R>=expand("%:p:h") . "/" <CR><CR>
" splitting like in my tmux
nmap <C-w>- :split<CR>
nmap <C-w>\| :vert split<CR>

nmap <C-PageUp> :tabN<CR>
nmap <C-PageDown> :tabn<CR>
" focus folding on current line
nmap zf zMzv
" }}}

" folding helpers {{{
fu! DisableFolding()
  if !exists('w:last_fdm')
    let w:last_fdm=&foldmethod
    setl foldmethod=manual
  endif
endfu

fu! RestoreFolding()
  if exists('w:last_fdm')
    let &l:foldmethod=w:last_fdm
    unlet w:last_fdm
  endif
endfu
" }}}

if has("autocmd") " {{{
  filetype plugin indent on
  augroup mine
    au!
    " Recall last location in file
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
          \| exe "normal g'\"" | endif
    au FileType qf setl nowrap
    au BufReadPost COMMIT_EDITMSG norm ggi

    " Don't screw up folds when inserting text that might affect them, until
    " leaving insert mode. Foldmethod is local to the window. Protect against
    " screwing up folding when switching between windows.
    au InsertEnter * call DisableFolding()
    au InsertLeave,WinLeave * call RestoreFolding()

    set viewoptions=folds
    au BufWinLeave * silent! mkview
    au BufWinEnter * silent! loadview

  augroup END
endif " }}}

" Plugin etc settings {{{
fu! HasPlugin(file)
  return globpath( &runtimepath, "**/" . a:file ) != ""
endfu

let g:tex_flavor = "latex"
" UltiSnips {{{
let g:UltiSnipsSnippetsDir = "~/.vim/snippets"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippets"]
" the less keys the better!
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:snips_author = "Artem Baguinski <femistofel@gmail.com>"
" }}}
" NERD tree {{{
if HasPlugin('NERD_tree.vim')
  let g:NERDTreeMapOpenSplit='h'
  let g:NERDTreeMapOpenVSplit='v'
  map <Leader>n :NERDTreeToggle<CR>
endif
" }}}
" Figitive {{{
if HasPlugin('fugitive.vim')
  nmap <Leader>g :Gstatus<CR>
endif
" }}}
" CtrlP {{{
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
let g:ctrlp_max_height = 20
let g:ctrlp_reuse_window = 'help\|quickfix'
let g:ctrlp_open_multiple_files = '2vjr'
let g:ctrlp_arg_map = 1
nmap <C-B> :CtrlPBuffer<CR>
nmap <Leader><C-P> :exec ":CtrlP " . expand('%:h')<CR>
" alternative key bindings
let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("h")': ['<c-h>'],
      \ }
" }}}
" color settings {{{
let g:light_scheme='summerfruit256'
let g:dark_scheme='herald'
nmap <Leader>cc :ToggleScheme<CR>
syntax enable
" }}}
" }}}

