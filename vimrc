" prime the pathogen {{{
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
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
set backupdir=~/.vim/backup directory=~/.vim/backup
behave xterm " traditional visual mode
set cursorline cursorcolumn
" }}}

" global key mappings {{{
" change to the current file path
map <Leader>cd :lcd <C-R>=expand("%:p:h") . "/" <CR><CR>
" splitting like in my tmux
nmap <C-w>- :split<CR>
nmap <C-w>\| :vert split<CR>
nmap <C-a>- :split<CR>
nmap <C-a>\| :vert split<CR>
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
  augroup END
endif " }}}

" color settings {{{
color herald
syntax enable
" }}}

" Plugin etc settings {{{
fu HasPlugin(file)
  return globpath( &runtimepath, "**/" . a:file )
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
" CtrlP {{{
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
let g:ctrlp_max_height = 20
let g:ctrlp_reuse_window = 'help\|quickfix'
"let g:ctrlp_open_new_file = 't'
let g:ctrlp_open_multiple_files = '2vjr'
let g:ctrlp_arg_map = 1
let g:ctrlp_default_input = 1
" }}}
" }}}
