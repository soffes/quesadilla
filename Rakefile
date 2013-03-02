require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end
task default: :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:doc) do |task|
    task.files   = ['Readme.markdown', 'LICENSE', 'lib/**/*.rb']
    task.options = [
      '--output-dir', 'doc',
      '--markup', 'markdown',
    ]
  end
rescue LoadError
end
