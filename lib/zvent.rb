$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


require 'rubygems'
require 'json'
require 'tzinfo'
require 'cgi'
require 'net/http'

Dir[File.dirname(__FILE__) + "/zvent/*.rb"].each { |file| require(file) }