require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Session do
  it "should search an event" do    
    a = Zvent::Session.new('API_KEY')    
    a.should_receive(:get_resources).with('http://www.zvents.com/rest/search?key=API_KEY&where=93063').and_return(SEARCH_RESULTS)    
    a.find_events('93063')
  end
end