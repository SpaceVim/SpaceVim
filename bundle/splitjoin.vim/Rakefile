task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/splitjoin.zip autoload/ doc/splitjoin.txt ftplugin/ plugin/'
end
