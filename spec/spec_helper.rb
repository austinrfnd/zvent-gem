require 'rubygems'
gem 'rspec'
require 'spec'
require File.dirname(__FILE__) + '/../lib/zvent'
require File.dirname(__FILE__) + '/../lib/core/ext'

GEM_ROOT = File.expand_path(File.dirname(__FILE__) + '/../') unless defined?(GEM_ROOT)
Dir.chdir(GEM_ROOT)

def test_data(basename)
  File.read(GEM_ROOT + "/test_data/#{basename}.json")
end
