namespace :gem do
  desc "Build the gem"
  task( :build => :clean ) { `gem build zvent.gemspec` }

  desc "Clean build artifacts"
  task( :clean ) { FileUtils.rm_rf Dir['*.gem'] }    
end