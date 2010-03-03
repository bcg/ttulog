
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'

NAME           = 'ttulog'
VERS           = '0.1'
GEM_NAME       = "#{NAME}-#{VERS}.gem"
TGZ_NAME       = "#{NAME}-#{VERS}.tgz"
RUBYFORGE_USER = "bcg"
WWW            = "#{RUBYFORGE_USER}@rubyforge.org:/var/www/gforge-projects/#{NAME}/"

RDOC_MAIN = "README"

spec = Gem::Specification.new do |s|
  s.name             = NAME
  s.version          = VERS
  s.author           = "Brenden Grace"
  s.email            = "brenden.grace@gmail.com"
  s.platform         = Gem::Platform::RUBY
  s.summary          = "Library for reading and writing TokyoTyrant Ulog files."
  s.files            = %w{README LICENSE Rakefile} +
                       Dir.glob("lib/**/*.{rb}") +
                       Dir.glob("test/**/*.rb")
  s.require_path     = "."
  #s.test_file        = ""
  s.has_rdoc         = true
  s.extra_rdoc_files = [ RDOC_MAIN, "LICENSE" ]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

Rake::RDocTask.new(:rdoc) do |rd|
  rd.main = RDOC_MAIN
  rd.rdoc_files.include(RDOC_MAIN, "LICENSE", "lib/**/*.rb")
  rd.options << "--all"
end

CLEAN.include FileList[
                       "pkg/*",
                       "html"
                      ]

task :test do
  Dir.chdir('test')
  sh('ruby bitpack_tests.rb')
  Dir.chdir('..')
end

task :gem do
  sh %{rake pkg/#{GEM_NAME}}
end

task :tgz do
  sh %{rake pkg/#{TGZ_NAME}}
end

task :package => [ :gem, :tgz ]

task :install => :gem do
  sh %{gem install pkg/#{GEM_NAME}}
end

task :uninstall do
  sh %{gem uninstall #{NAME}}
end

task :www => :rdoc do
  sh("scp -r html/* #{WWW}")
end

