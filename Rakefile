require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
  t.verbose = true
end

namespace :gish do
  namespace :specs do
    task :setup do
      gem_list = %w(fakefs mocha)

      gem_list.each { |g| %x(gem install #{g}) }
    end
  end
end
