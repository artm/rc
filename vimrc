" neobundle {{{
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#rc(expand('~/.vim/bundle/'))

let g:neobundle_default_git_protocol='git'

NeoBundleFetch 'Shougo/neobundle.vim'

" [+] vim/bundle/ack
" [ ] vim/bundle/coffee-script
" [+] vim/bundle/ctrlp
" [+] vim/bundle/endwise
" [+] vim/bundle/fugitive
" [+] vim/bundle/javascript
" [ ] vim/bundle/jsbeautify
" [+] vim/bundle/NERDtree
" [ ] vim/bundle/slim
" [+] vim/bundle/surround
" [-] vim/bundle/ultisnips

NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jelera/vim-javascript-syntax'
" NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}

filetype plugin indent on
" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
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
set wildignore+=*.o,*.obj,*.rbc,*.class,.git/*,vendor/*,node_modules/*,tmp/*,bower_components/*
set laststatus=2
set stl=%f%(\ \|\ %Y%)%(\ \|\ %M%R%)%=\|\ B:%n\ %p%%\ %3l/%L\ %c\ \|
set modeline modelines=10
set exrc " load local .vimrc
set mouse=a
" directories for backup and swpfiles
set backupdir=~/.vim/backup directory=~/.vim/backup backupcopy=yes
behave xterm " traditional visual mode
set cursorline cursorcolumn
set clipboard=unnamedplus
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
nmap <C-w>[ :tabN<CR>
nmap <C-w>] :tabn<CR>
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

    " disable slow syntax highlighting on large files
    au BufWinEnter *.md if line2byte(line("$") + 1) > 3000 | syntax clear | endif

    " solve slim plugin problem
    autocmd BufNewFile,BufRead *.slim set syntax=slim|set ft=slim

  augroup END
endif " }}}

" Plugin etc settings {{{
fu! HasPlugin(file)
  return globpath( &runtimepath, "**/" . a:file ) != ""
endfu

let g:tex_flavor = "latex"
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
let g:light_scheme='artm_light'
let g:dark_scheme='herald'
nmap <Leader>cc :ToggleScheme<CR>
syntax enable
" }}}
" neo complete {{{
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}
" neo snippet {{{
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" }}}
" javascript folds {{{
au FileType javascript call JavaScriptFold()
" }}}
" }}}

