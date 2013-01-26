require 'pathname'
require 'fileutils'

BackupDir = 'bak'
Ignore = [ BackupDir, 'Rakefile', 'Readme.md' ]
Rc = File.basename Dir.pwd

task :default do
  exec 'rake -s -D'
end

desc 'install symlinks to the dotfiles, backup old ones'
task :install do |t|
  Dir['*'].each do |dotfile|
    target = "../.#{dotfile}"
    if File.exists? target
      if Pathname.new(target).realpath == Pathname.new(dotfile).realpath
        puts "#{dotfile} and #{target} are the same"
        next
      end
      puts "Need to backup #{target}"
      FileUtils.mkdir_p BackupDir
      FileUtils.mv target, "#{BackupDir}/#{dotfile}"
    end
    FileUtils.ln_s "#{Rc}/#{dotfile}", target
  end
end

