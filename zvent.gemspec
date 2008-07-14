require 'rake'

Gem::Specification.new do |s|
  s.name = 'zvent'
  s.author = "Austin Fonacier"
  s.version = '0.0.1'
  s.summary = 'An interface for zvents'
  
  s.files = FileList['lib/zvent.rb',
                     'lib/zvent/event.rb',
                     'lib/zvent/base.rb',
                     'lib/zvent/session.rb']
  
  s.description = <<-EOF
          Interface between zvents API without all the mess.
  EOF
  
  # s.executables = ['git-kablame', 'svn-kablame']
  
  s.homepage = 'http://www.yellowpages.com'
  # s.rubyforge_project = 'kablame'
  s.email = 'afonacier@yellowpages.com'  
  s.has_rdoc = false
  s.add_dependency('json', '>= 1.1.2')
end
