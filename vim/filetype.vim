augroup filetypedetect
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Capfile,config.ru,Guardfile,*.rake,*.cap} setf ruby
  au BufRead,BufNewFile {SConstruct,SConscript} setf python
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} setf markdown
  au BufNewFile,BufRead *.hamlc setf haml
  au BufNewFile,BufRead *.hamlbars setf haml
  au BufNewFile,BufRead *.slimbars setf slim
  au BufNewFile,BufRead *.json setf javascript
  au BufNewFile,BufRead *.m setf octave
  au BufRead,BufNewFile */nginx/conf/* set ft=nginx
augroup END

