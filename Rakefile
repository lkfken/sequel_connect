require 'bundler/gem_tasks'
task :default => :spec

desc 'install to geminabox server'
task :install_to_a_box do |task|
  fl = FileList['./pkg/*.gem'].sort
  puts "upload #{fl.last} to geminabox server..."
  system "gem inabox #{fl.last}"
end

task :install_to_a_box => :install