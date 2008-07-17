require 'rubygems'
gem 'rspec'
require 'spec'
require File.dirname(__FILE__) + '/../lib/zvent'
require File.dirname(__FILE__) + '/../lib/core/ext'

#mock data
SEARCH_RESULTS = File.read(File.dirname(__FILE__) + "/../test_data/event_search.json")
EMPTY_SEARCH_RESULTS = File.read(File.dirname(__FILE__) + "/../test_data/empty_event_search.json")
EVENT_RESULT = File.read(File.dirname(__FILE__) + "/../test_data/event.json")
INVALID_API_KEY = File.read(File.dirname(__FILE__) + "/../test_data/invalid_api_key.json")
 
GEM_ROOT = File.expand_path(File.dirname(__FILE__) + '/../') unless defined?(GEM_ROOT)
Dir.chdir(GEM_ROOT)