require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "tests"
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
end

task :rerun do
  require 'yaml'
  yaml = YAML.load_file('./config/config.yml')
  sh %(rerun rackup -d .,#{yaml["posts_path"]})
end
