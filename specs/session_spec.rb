require File.dirname(__FILE__) + '/spec_helper'

describe Zvent::Session do
  describe "findEvents" do
    it "should be successful" do  
      mock_event_search      
      zvent_session = Zvent::Session.new('API_KEY')    
      events = zvent_session.find_events('93063')
      events.should be_kind_of(Hash)
      events[:event_count].should be_kind_of(Integer)
      events[:events].should be_kind_of(Array)
      events[:events].each{|event| event.should be_kind_of(Zvent::Event)}
    end
  
    it "should return the json only if options[:as_json] is true" do
      mock_event_search      
      zvent_session = Zvent::Session.new('API_KEY')    
      events = zvent_session.find_events('93063', {}, {:as_json => true})      
      events.should be_kind_of(Hash)
    end
  
    it "should throw an error if no location is given" do
      zvent_session = Zvent::Session.new('API_KEY')
      lambda {zvent_session.find_events('')}.should raise_error(Zvent::NoLocationError)      
    end
    
    it "should handle json read errors"
    
    it "should return empty array if no events found"
  end
  
  private  
  def mock_event_search
    @http_mock = mock('http')
    @http_mock.stub!(:get)
    @response_mock = mock(Net::HTTPResponse)
    @response_mock.stub!(:body).and_return(SEARCH_RESULTS)
    Net::HTTP.stub!(:start).and_yield(@http_mock).and_return(@response_mock)    
  end
end