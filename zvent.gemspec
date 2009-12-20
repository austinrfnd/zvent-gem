require 'rake'

Gem::Specification.new do |s|
  s.name = 'eostrom-zvent'
  s.author = "Austin Fonacier, Erik Ostrom"
  s.version = '0.0.6'
  s.summary = 'Interface for the zvents API without all the mess.'
  
  s.files = FileList['lib/zvent.rb',
                     'lib/zvent/event.rb',
                     'lib/zvent/venue.rb',                     
                     'lib/zvent/performer.rb',
                     'lib/zvent/base.rb',
                     'lib/zvent/category.rb',                     
                     'lib/zvent/session.rb',
                     'lib/core/ext.rb']
  
  s.description = <<-EOF
          Interface for the zvents API without all the mess.
  EOF

  s.homepage = 'http://github.com/austinrfnd/zvent-gem/'
  s.email = 'afonacier@yellowpages.com'  
  s.has_rdoc = true
  s.rubyforge_project = 'zvent'  
  s.extra_rdoc_files = ['README']
  s.add_dependency('json', '>= 1.1.2')
  s.add_dependency('tzinfo', '>= 0.3.9')  
end
