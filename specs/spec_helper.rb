require 'rubygems'
gem 'rspec'
require 'spec'
require File.dirname(__FILE__) + '/../lib/zvent'

#mock data
SEARCH_RESULTS = File.read(File.dirname(__FILE__) + "/../test_data/event_search.json")
 
GEM_ROOT = File.expand_path(File.dirname(__FILE__) + '/../') unless defined?(GEM_ROOT)
Dir.chdir(GEM_ROOT)