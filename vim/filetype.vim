if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} setf ruby
  au BufRead,BufNewFile {SConstruct,SConscript} setf python
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} setf markdown
  au BufNewFile,BufRead *.hamlc setf haml
  au BufNewFile,BufRead *.json setf javascript
  au BufNewFile,BufRead *.m setf octave
augroup END

